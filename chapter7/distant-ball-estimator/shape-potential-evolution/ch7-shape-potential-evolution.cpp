#include <boost/filesystem.hpp>
#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/boards/Board2D.h>
#include <DGtal/io/writers/GenericWriter.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/components/SetOperations.h>

#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>
#include <SCaBOliC/Core/model/ODRModel.h>

#include <geoc/api/gridCurve/Curvature.hpp>
#include <geoc/api/gridCurve/Tangent.hpp>

#include "Flow.h"
#include "InputData.h"

using namespace DGtal::Z2i;

enum ShapeType{Triangle,Square,Pentagon,Heptagon,Ball,Ellipse,Flower,Wave,Bean,UserDefined,NoType};

struct Shape
{
    Shape():type(NoType),imagePath(""),name(""){}

    Shape(ShapeType type, const std::string& imagePath=""):type(type),
                                                           imagePath(imagePath)
    {
        if(type==ShapeType::Triangle) name = "triangle";
        else if(type==ShapeType::Square) name = "square";
        else if(type==ShapeType::Pentagon) name =  "pentagon";
        else if(type==ShapeType::Heptagon) name = "heptagon";
        else if(type==ShapeType::Ball) name = "ball";
        else if(type==ShapeType::Ellipse) name = "ellipse";
        else if(type==ShapeType::Flower) name = "flower";
        else if(type==ShapeType::Wave) name = "wave";
        else if(type==ShapeType::Bean) name = "bean";
        else name = "user-defined";
    }

    ShapeType type;
    std::string imagePath;
    std::string name;
};

DigitalSet resolveShape(Shape shape,double gridStep)
{
    int radius=20;
    if(shape.type==ShapeType::Triangle) return DIPaCUS::Shapes::triangle(gridStep,0,0,radius);
    else if(shape.type==ShapeType::Square) return DIPaCUS::Shapes::square(gridStep,0,0,radius);
    else if(shape.type==ShapeType::Pentagon) return DIPaCUS::Shapes::NGon(gridStep,0,0,radius,5);
    else if(shape.type==ShapeType::Heptagon) return DIPaCUS::Shapes::NGon(gridStep,0,0,radius,7);
    else if(shape.type==ShapeType::Ball) return DIPaCUS::Shapes::ball(gridStep,0,0,radius);
    else if(shape.type==ShapeType::Flower) return DIPaCUS::Shapes::flower(gridStep,0,0,radius,radius/2.0,2);
    else if(shape.type==ShapeType::Ellipse) return DIPaCUS::Shapes::ellipse(gridStep,0,0,radius,radius/2);
    else if(shape.type==ShapeType::Wave) return DIPaCUS::Shapes::wave(gridStep,1200,radius*3,radius*6,0.01);
    else if(shape.type==ShapeType::Bean) return DIPaCUS::Shapes::bean(gridStep,0,0,0.1);
    else
    {
        cv::Mat img = cv::imread(shape.imagePath,CV_8UC1);
        Domain domain( DGtal::Z2i::Point(0,0), DGtal::Z2i::Point(img.cols-1,img.rows-1) );
        DigitalSet ds(domain);
        DIPaCUS::Representation::CVMatToDigitalSet(ds,img,1);
        return ds;
    }
}
DigitalSet resolveShape(const std::string& shape,double gridStep)
{
    if(shape=="triangle") return resolveShape(Shape(ShapeType::Triangle),gridStep);
    else if(shape=="square") return resolveShape(Shape(ShapeType::Square),gridStep);
    else if(shape=="pentagon") return resolveShape(Shape(ShapeType::Pentagon),gridStep);
    else if(shape=="heptagon") return resolveShape(Shape(ShapeType::Heptagon),gridStep);
    else if(shape=="ball") return resolveShape(Shape(ShapeType::Ball),gridStep);
    else if(shape=="flower") return resolveShape(Shape(ShapeType::Flower),gridStep);
    else if(shape=="ellipse") return resolveShape(Shape(ShapeType::Ellipse),gridStep);
    else if(shape=="wave") return resolveShape(Shape(ShapeType::Wave),gridStep);
    else if(shape=="bean") return resolveShape(Shape(ShapeType::Bean),gridStep);
    else return resolveShape(Shape(ShapeType::UserDefined,shape),gridStep);

}


uint intersectionCount(const DigitalSet& A, const DigitalSet& B)
{
    uint c=0;
    for(Point p: A)
    {
        if(B(p)) ++c;
    }

    return c;
}

double balanceCoefficient(const DigitalSet& shape, const RealPoint& ballCenter, double ballRadius, double h)
{
    DigitalSet ball = DIPaCUS::Shapes::ball(h,ballCenter[0]*h,ballCenter[1]*h,ballRadius);
    double cInt = pow(h,2)*intersectionCount(ball,shape);
    double halfBallArea = pow(h,2)*ball.size()/2.0;


    return pow( halfBallArea - cInt, 2);
}

std::string fixedStrLength(int l,double v)
{
    std::string out = std::to_string(v);
    while(out.length()<l) out += " ";

    return out;
}

std::string fixedStrLength(int l,std::string str)
{
    std::string out = str;
    while(out.length()<l) out += " ";

    return out;
}

struct PotentialData
{
    typedef GEOC::API::GridCurve::Curvature::EstimationsVector CurvatureVector;
    typedef GEOC::API::GridCurve::Tangent::EstimationsVector TangentVector;
    typedef GEOC::API::GridCurve::Length::EstimationsVector LengthVector;

    PotentialData(const DigitalSet& shape, double h)
    {
        using namespace GEOC::API::GridCurve;

        const Domain& domain = shape.domain();
        kspace.init(domain.lowerBound(),domain.upperBound(),true);

        DIPaCUS::Misc::computeBoundaryCurve(curve,shape);

        GEOC::Estimator::Standard::IICurvatureExtraData data(true,5);
        Curvature::identityOpen<Curvature::EstimationAlgorithms::ALG_II>(kspace,curve.begin(),curve.end(),kv,h,&data);

        Tangent::symmetricClosed<Tangent::EstimationAlgorithms::ALG_MDSS>(kspace,curve.begin(),curve.end(),tv,h,NULL);

        LengthVector lv;
        Length::mdssClosed<Length::EstimationAlgorithms::ALG_PROJECTED>(kspace,curve.begin(),curve.end(),lv,h,NULL);
        length=0;
        for(auto el:lv)length+=el;
    }

    KSpace kspace;
    Curve curve;
    CurvatureVector kv;
    TangentVector tv;
    double length;
};

struct Potential
{
    std::vector<double> outBalances;
    std::vector<double> innBalances;
    std::vector<double> diffBalances;
};

Potential computePotential(const DigitalSet& shape,double h,double radius, double level)
{
    PotentialData pd(shape,h);
    Potential potential;

    int i=0;
    for(auto kp:pd.curve)
    {
        RealPoint center = pd.kspace.sCoords(kp);
        auto tangent = pd.tv[i];
        RealPoint dir( -tangent[1],tangent[0] );
        double norm=pow( pow(dir[0],2)+pow(dir[1],2),0.5 );
        dir/=norm;

        RealPoint pOut = -level*dir;
        RealPoint pInn = level*dir;

        RealPoint centerOut = center + pOut;
        RealPoint centerInn = center + pInn;

        double uOut = balanceCoefficient(shape,centerOut,radius,h);
        double uInn = balanceCoefficient(shape,centerInn,radius,h);

        potential.outBalances.push_back(uOut);
        potential.innBalances.push_back(uInn);

        potential.diffBalances.push_back( fabs(uOut-uInn)/pd.length );

        ++i;
    }

    return potential;
}

int main(int argc,char* argv[])
{
    int COL_LENGTH=20;

    if(argc<4)
    {
        std::cerr << "Usage: " << argv[0] << " Shape GridStep Radius MaxIt OutputFilepath \n";
        exit(1);
    }

    std::string shapeName=argv[1];
    double h=std::atof(argv[2]);
    double radius=std::atof(argv[3]);
    uint maxIt=std::atoi(argv[4]);
    std::string outputFolder = argv[5];

    boost::filesystem::create_directories(outputFolder);
    std::ofstream ofsDiff(outputFolder+"/diff.txt");

    DigitalSet _shape = resolveShape(shapeName,h);
    DigitalSet shape = DIPaCUS::Transform::bottomLeftBoundingBoxAtOrigin(_shape,Point(100,100));


    ofsDiff << fixedStrLength(COL_LENGTH,"#Iteration")
           << fixedStrLength(COL_LENGTH,"Diff Potential") << "\n";


    SCaBOliC::Input::Data inputFlow;
    inputFlow.radius = radius/h;
    inputFlow.levels = (radius/h)-1;
    inputFlow.gridStep = h;
    inputFlow.optBand=1;
    inputFlow.iterations=1;
    inputFlow.uniformPerimeter=true;
    inputFlow.outputFolder = outputFolder;

    Point size = shape.domain().upperBound() - shape.domain().lowerBound() + Point(1,1);
    int it=0;
    while(it<maxIt)
    {
        SCaBOliC::Core::ODRPixels odrPixels(inputFlow.radius,
                                            inputFlow.gridStep,
                                            inputFlow.levels,
                                            inputFlow.ld,
                                            inputFlow.nt,
                                            inputFlow.optBand);

        SCaBOliC::Core::ODRModel ODR = odrPixels.createODR(SCaBOliC::Core::ODRModel::ApplicationMode::AM_AroundBoundary,
                                                           shape,
                                                           false);

        auto potential = computePotential(shape,h,radius,inputFlow.levels);

        double diffPotential=0;
        for(auto diff:potential.diffBalances) diffPotential+=diff;

        ofsDiff << fixedStrLength(COL_LENGTH,it)
                << fixedStrLength(COL_LENGTH,diffPotential) << "\n";


        cv::Mat imgOut = cv::Mat::zeros(size[1],size[0],CV_8UC1);;
        DIPaCUS::Representation::digitalSetToCVMat(imgOut,shape);
        cv::imwrite(outputFolder + "/" + std::to_string(it) +  ".png",imgOut);

        ++it;
        shape = SCaBOliC::Flow::flow(shape,inputFlow,shape.domain());


        if(shape.size()==0) break;

    }

    ofsDiff.flush(); ofsDiff.flush();

    return 0;
}