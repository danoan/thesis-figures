#include <DGtal/helpers/StdDefs.h>
#include <DGtal/shapes/parametric/AccFlower2D.h>

#include <DIPaCUS/derivates/Misc.h>
#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>

#include <cmath>
#include <boost/filesystem/operations.hpp>

using namespace DGtal;
using namespace DGtal::Z2i;

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

double outerCoefficient(const DigitalSet& shape, const RealPoint& ballCenter, double estimationBallRadius, double h)
{
    DigitalSet ball = DIPaCUS::Shapes::ball(h,ballCenter[0]*h,ballCenter[1]*h,estimationBallRadius);
    double foreground = pow(h,2)*intersectionCount(ball,shape);

    return foreground;
}

double innerCoefficient(const DigitalSet& shape, const RealPoint& ballCenter, double estimationBallRadius, double h)
{
    DigitalSet ball = DIPaCUS::Shapes::ball(h,ballCenter[0]*h,ballCenter[1]*h,estimationBallRadius);
    double foreground = pow(h,2)*intersectionCount(ball,shape);
    double ballArea = pow(h,2)*ball.size();


    return ballArea - foreground;
}


typedef std::pair<double,double> KPair;
typedef std::map<double,KPair> KMap;
typedef std::map<Point,double> KPMap;


template<class TShape>
double elasticaEstimation(const TShape& shape,double h,double r)
{
    using namespace SCaBOliC::Core;

    DigitalSet ds = DIPaCUS::Shapes::digitizeShape(shape,h);
    ODRPixels odrPixels((r+r/2.0)/h,h,r/h,ODRPixels::LevelDefinition::LD_CloserFromCenter,ODRPixels::NeighborhoodType::FourNeighborhood,1);
    ODRModel ODR=odrPixels.createODR(ODRPixels::ApplicationMode::AM_AroundBoundary,ds);



    double inner=0;
    double outer=0;
    for(auto p:ODR.applicationRegionInn) inner+=innerCoefficient(ds,p,r+r/2.0,h)*ODR.innerCoef*h;
    for(auto p:ODR.applicationRegionOut) outer+=outerCoefficient(ds,p,r+r/2.0,h)*ODR.outerCoef*h;

    //2pi/r
    double areaDiff = inner-outer;
    double A = 125.0/144.0*pow(r,2);
    return pow(areaDiff,2)/A;
}


int main(int argc, char* argv[])
{
    double r=std::atof(argv[1]);
    double h=std::atof(argv[2]);

//    AccFlower2D<Space> flower(0,0,20,5,3,0);
    Ball2D<Space> flower(0,0,10);
    double elastica = 2*M_PI/10.0;
    double ee=elasticaEstimation(flower,h,r);

    std::cout << "Real elastica:" << elastica << std::endl;
    std::cout << "Estimated elastica:" << ee << std::endl;
    std::cout << "Factor:" << elastica/ee << std::endl;

    return 0;
}