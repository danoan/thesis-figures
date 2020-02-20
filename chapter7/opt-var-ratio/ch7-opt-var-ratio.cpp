#include <cmath>
#include <boost/filesystem.hpp>
#include <DGtal/helpers/StdDefs.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/components/SetOperations.h>

#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>
#include <SCaBOliC/Core/model/ODRModel.h>


using namespace DGtal::Z2i;
typedef SCaBOliC::Core::ODRModel ODRModel;

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

    double cFgOut = pow(h,2)*intersectionCount(ballOut,ODR.trustFRG);
    double cFgInn = pow(h,2)*intersectionCount(ballInn,ODR.trustFRG);

    double cOptOut = pow(h,2)*intersectionCount(ballOut,ODR.optRegion);
    double cOptInn = pow(h,2)*intersectionCount(ballInn,ODR.optRegion);

    double den = ballOut.size() - cFgInn - cFgOut;

    double numConcave = cOptInn;
    double numConvex = cOptOut;

    return std::make_pair(numConvex/den,numConcave/den);
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
    double optBand=1;

    ODRPixels odrPixels(radius,
            h,
            levels,
            ODRPixels::LevelDefinition::LD_CloserFromCenter,
            ODRPixels::NeighborhoodType::FourNeighborhood,
            optBand);

    return odrPixels.createODR(ODRPixels::ApplicationMode::AM_AroundBoundary,ds);
}

int main(int argc,char* argv[])
{
    int COL_LENGTH=20;

    if(argc<4)
    {
        std::cerr << "Usage: " << argv[0] << " GridStep Radius OutputFilepath \n";
        exit(1);
    }

    double h=std::atof(argv[1]);
    double radius=std::atof(argv[2]);
    std::string outputFolder = argv[3];

    boost::filesystem::create_directories(outputFolder);
    std::ofstream ofsRatio(outputFolder+"/ratio.txt");

    ofsRatio << fixedStrLength(COL_LENGTH,"#Distance")
           << fixedStrLength(COL_LENGTH,"convex ratio")
            << fixedStrLength(COL_LENGTH,"concave ratio") << "\n";

    DigitalSet shape = DIPaCUS::Shapes::square(h);
    Point lp,up;
    shape.computeBoundingBox(lp,up);

    SCaBOliC::Core::ODRModel ODR = buildModel(shape);

    Arange arange(0,radius/h,100);
    RealPoint center = up;
    double d;
    while(arange(d))
    {
        RealPoint pOut(d,d);
        RealPoint pInn(-d,-d);

        RealPoint centerOut = center + pOut;
        RealPoint centerInn = center + pInn;


        auto ratios = optVarRatio(shape,ODR,centerOut,centerInn,radius,h);
        double convexRatio=ratios.first;
        double concaveRatio=ratios.second;

        ofsRatio << fixedStrLength(COL_LENGTH,h*d*sqrt(2))
               << fixedStrLength(COL_LENGTH,convexRatio)
                << fixedStrLength(COL_LENGTH,concaveRatio) << "\n";
    }

    ofsRatio.flush();
    ofsRatio.close();

    return 0;
}