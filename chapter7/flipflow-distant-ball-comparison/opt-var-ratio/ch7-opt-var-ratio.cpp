#include <cmath>
#include <boost/filesystem.hpp>

#include <DGtal/helpers/StdDefs.h>
#include <DGtal/shapes/parametric/AccFlower2D.h>
#include <DGtal/shapes/parametric/NGon2D.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/components/SetOperations.h>

#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>
#include <SCaBOliC/Core/model/ODRModel.h>

#include <geoc/api/api.h>


using namespace DGtal::Z2i;
typedef SCaBOliC::Core::ODRModel ODRModel;

#define COL_LENGTH 20

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

std::pair<double,double> optVarRatio(const DigitalSet& shape, const ODRModel& ODR, const RealPoint& ballCenterOut, const RealPoint& ballCenterInn, double ballRadius, double h)
{
    DigitalSet ballOut = DIPaCUS::Shapes::ball(h,ballCenterOut[0]*h,ballCenterOut[1]*h,ballRadius);
    DigitalSet ballInn = DIPaCUS::Shapes::ball(h,ballCenterInn[0]*h,ballCenterInn[1]*h,ballRadius);

    double cFgOut = intersectionCount(ballOut,ODR.trustFRG);
    double cFgInn = intersectionCount(ballInn,ODR.trustFRG);

    double cOptOut = intersectionCount(ballOut,ODR.optRegion);
    double cOptInn = intersectionCount(ballInn,ODR.optRegion);

    double numConcave = ballOut.size() - cFgInn - cFgOut;
    double numConvex = ballOut.size() - cFgInn - cFgOut - 2*cOptOut;

    double denConcave = cOptOut-cOptInn;
    double denConvex = cOptInn-cOptOut;

    double ratioConvex;
    if(denConvex==0) ratioConvex=-1;
    else ratioConvex=numConvex/denConvex;

    double ratioConcave;
    if(denConcave==0) ratioConcave=-1;
    else ratioConcave=numConcave/denConcave;


    if(numConvex>denConvex)ratioConvex=1;
    if(numConcave>denConcave)ratioConcave=1;

    if(numConvex<0) ratioConvex=0;
    if(numConcave<0) ratioConcave=0;

    return std::make_pair(ratioConvex,ratioConcave);
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


ODRModel buildModel(const DigitalSet& ds)
{
    using namespace SCaBOliC::Core;
    double radius=3;
    double h=1.0;
    double levels=1;
    double optBand=2;

    ODRPixels odrPixels(radius,
            h,
            levels,
            ODRPixels::LevelDefinition::LD_CloserFromCenter,
            ODRPixels::NeighborhoodType::FourNeighborhood,
            optBand);

    return odrPixels.createODR(ODRPixels::ApplicationMode::AM_AroundBoundary,ds);
}

typedef GEOC::API::GridCurve::Tangent::TangentVector TangentVector;
typedef std::map<Point,TangentVector> TangentMap;

TangentMap computeTangentMap(const DigitalSet& ds,double h)
{
    using namespace GEOC::API::GridCurve::Tangent;

    const Domain& domain = ds.domain();
    KSpace kspace;
    kspace.init(domain.lowerBound(),domain.upperBound(),true);

    Curve curve;
    DIPaCUS::Misc::computeBoundaryCurve(curve,ds);
    EstimationsVector ev;
    symmetricClosed<EstimationAlgorithms::ALG_MDSS>(kspace,curve.begin(),curve.end(),ev,h,NULL);

    std::map<Point,TangentVector> tangentMap;
    int i=0;
    for(auto c:curve)
    {
        auto pixels = kspace.sUpperIncident(c);
        for(auto p:pixels)
        {
            Point pCoords = kspace.sCoords(p);
            if(ds(pCoords))
            {
                tangentMap[pCoords] = ev[i++];
            }
        }
    }

    return tangentMap;
}

template<class TShape>
void computeShapeOptRatio(std::ostream& osConvex,std::ostream& osConcave, const TShape& shape,const DigitalSet& ds, const ODRModel& ODR, double h,double radius, double d)
{
    DigitalSet boundary(ds.domain());
    DIPaCUS::Misc::digitalBoundary<DIPaCUS::Neighborhood::EightNeighborhoodPredicate>(boundary,ds);

    auto tangentMap = computeTangentMap(ds,h);
    for(auto p:boundary)
    {
        RealVector realNormal( -tangentMap[p][1],tangentMap[p][0]);

        double angle = shape.parameter(p);
        double realK = shape.curvature(angle);

        RealPoint centerOut = p -(d+h/2.0)*realNormal;
        RealPoint centerInn = p + (d-h/2.0)*realNormal;

        auto ratios = optVarRatio(ds,ODR,centerOut,centerInn,radius,h);
        double convexRatio=ratios.first;
        double concaveRatio=ratios.second;

        if(realK<0)
        {
            osConcave << fixedStrLength(COL_LENGTH,h*d*sqrt(2))
                      << fixedStrLength(COL_LENGTH,realK)
                      << fixedStrLength(COL_LENGTH,centerInn[0])
                      << fixedStrLength(COL_LENGTH,centerInn[1])
                      << fixedStrLength(COL_LENGTH,concaveRatio) << "\n";
        }else
        {
            osConvex << fixedStrLength(COL_LENGTH,h*d*sqrt(2))
                     << fixedStrLength(COL_LENGTH,realK)
                     << fixedStrLength(COL_LENGTH,centerOut[0])
                     << fixedStrLength(COL_LENGTH,centerOut[1])
                     << fixedStrLength(COL_LENGTH,convexRatio)  << "\n";
        }

    }


}

int main(int argc,char* argv[])
{
    if(argc<4)
    {
        std::cerr << "Usage: " << argv[0] << " GridStep ShapeRadius EstimationRadius OutputFilepath \n";
        exit(1);
    }

    double h=std::atof(argv[1]);
    double shapeRadius=std::atof(argv[2]);
    double estimationRadius=std::atof(argv[3]);
    std::string outputFolder = argv[4];

    boost::filesystem::create_directories(outputFolder);
    std::ofstream ofsConcave(outputFolder+"/concave.txt");
    std::ofstream ofsConvex(outputFolder+"/convex.txt");

    ofsConvex << fixedStrLength(COL_LENGTH,"#Distance")
               << fixedStrLength(COL_LENGTH,"k")
               << fixedStrLength(COL_LENGTH,"x-out")
               << fixedStrLength(COL_LENGTH,"y-out")
               << fixedStrLength(COL_LENGTH,"convex ratio") << "\n";

    ofsConcave << fixedStrLength(COL_LENGTH,"#Distance")
               << fixedStrLength(COL_LENGTH,"k")
               << fixedStrLength(COL_LENGTH,"x-inn")
               << fixedStrLength(COL_LENGTH,"y-inn")
               << fixedStrLength(COL_LENGTH,"concave ratio") << "\n";


//    DGtal::AccFlower2D<Space> shape(0,0,10,5,2,0);
//    DigitalSet ds = DIPaCUS::Shapes::flower(h,0,0,10,5,2,0);

    DGtal::NGon2D<Space> shape(0,0,shapeRadius,4,M_PI/4.0);
    DigitalSet ds = DIPaCUS::Shapes::square(h,0,0,shapeRadius);

    Point lp,up;
    ds.computeBoundingBox(lp,up);

    SCaBOliC::Core::ODRModel ODR = buildModel(ds);

    Arange arange(0,estimationRadius/h,10);
    RealPoint center = up;
    double d;
    while(arange(d))
    {
        computeShapeOptRatio(ofsConvex,ofsConcave,shape,ds,ODR,h,estimationRadius,d);

    }

    ofsConvex.flush();ofsConvex.close();
    ofsConcave.flush();ofsConcave.close();

    return 0;
}