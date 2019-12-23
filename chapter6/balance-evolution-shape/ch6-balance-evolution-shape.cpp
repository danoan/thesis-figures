#include <boost/filesystem.hpp>
#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/boards/Board2D.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/components/SetOperations.h>

#include <geoc/api/gridCurve/Curvature.hpp>
#include <geoc/api/gridCurve/Tangent.hpp>

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



class Arange
{
public:
    Arange(double start, double end, uint n):start(start),end(end),n(n),h((end-start)/n),curr(start),i(0){}

    bool operator()(double& v)
    {
        if(i==n) return false;

        v = curr;
        curr+=h;
        ++i;

        return true;
    }

private:
    double start,end;
    uint n;
    uint i;
    double curr;
    double h;
};

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

struct CurveData
{
    CurveData(Point kPoint,double k,RealPoint tangent):kPoint(kPoint),k(k),tangent(tangent){}

    Point kPoint;
    double k;
    RealPoint tangent;
};

CurveData findKPoint(const DigitalSet& shape, double h, double k1, double k2)
{
    using namespace GEOC::API::GridCurve;

    const Domain& domain = shape.domain();
    KSpace kspace;
    kspace.init(domain.lowerBound(),domain.upperBound(),true);
    Curve curve;
    DIPaCUS::Misc::computeBoundaryCurve(curve,shape);

    Curvature::EstimationsVector evK;
    GEOC::Estimator::Standard::IICurvatureExtraData data(true,5);
    Curvature::identityOpen<Curvature::EstimationAlgorithms::ALG_II>(kspace,curve.begin(),curve.end(),evK,h,&data);

    Tangent::EstimationsVector evT;
    Tangent::symmetricClosed<Tangent::EstimationAlgorithms::ALG_MDSS>(kspace,curve.begin(),curve.end(),evT,h,NULL);

    int i=0;
    for(auto c:curve)
    {
        if( evK[i] >= k1 && evK[i] <= k2 )
        {
            for(auto p: kspace.sUpperIncident(c) )
            {
                if( shape(kspace.sCoords(p)) ) return CurveData(kspace.sCoords(p),evK[i],evT[i]);
            }
        }
        ++i;
    }

    exit(2);
}

int main(int argc,char* argv[])
{
    int COL_LENGTH=20;

    if(argc<4)
    {
        std::cerr << "Usage: " << argv[0] << " Shape GridStep Radius k1 k2 OutputFilepath \n";
        exit(1);
    }

    std::string shapeName=argv[1];
    double h=std::atof(argv[2]);
    double radius=std::atof(argv[3]);
    double k1=std::atof(argv[4]);
    double k2=std::atof(argv[5]);
    std::string outputFolder = argv[6];

    boost::filesystem::create_directories(outputFolder);
    std::ofstream ofsInn(outputFolder+"/inner.txt");
    std::ofstream ofsOut(outputFolder+"/outer.txt");

    DigitalSet shape = resolveShape(shapeName,h);
    CurveData cd = findKPoint(shape,h,k1,k2);


    Arange arange(0,radius/h,100);
    RealPoint center = cd.kPoint;
    RealPoint dir( -cd.tangent[1],cd.tangent[0] );
    double norm=pow( pow(dir[0],2)+pow(dir[1],2),0.5 );
    dir/=norm;


    ofsInn << fixedStrLength(COL_LENGTH,"#Distance")
           << fixedStrLength(COL_LENGTH,"uInn")
           << fixedStrLength(COL_LENGTH,"k=" + std::to_string(cd.k)) << "\n";

    ofsOut << fixedStrLength(COL_LENGTH,"#Distance")
           << fixedStrLength(COL_LENGTH,"uOut")
            << fixedStrLength(COL_LENGTH,"k=" + std::to_string(cd.k)) << "\n";

//    DGtal::Board2D board;
//    board.clear();
//    board << DGtal::SetMode(shape.className(),"Paving");
//    board << shape;
//    board << DGtal::CustomStyle(center.className() + "/Paving", new DGtal::CustomColors(DGtal::Color::Red, DGtal::Color::Red));
//    board << center;
//    board.saveSVG("alo.svg");

    double d;
    while(arange(d))
    {
        RealPoint pOut = -d*dir;
        RealPoint pInn = d*dir;

        RealPoint centerOut = center + pOut;
        RealPoint centerInn = center + pInn;


        double uOut = balanceCoefficient(shape,centerOut,radius,h);
        double uInn = balanceCoefficient(shape,centerInn,radius,h);

        ofsInn << fixedStrLength(COL_LENGTH,h*d*sqrt(2))
               << fixedStrLength(COL_LENGTH,uInn) << "\n";

        ofsOut << fixedStrLength(COL_LENGTH,h*d*sqrt(2))
               << fixedStrLength(COL_LENGTH,uOut) << "\n";
    }

    ofsInn.flush(); ofsOut.flush();
    ofsInn.close(); ofsOut.close();

    return 0;
}