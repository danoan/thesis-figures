#include <DGtal/helpers/StdDefs.h>
#include <DGtal/shapes/parametric/AccFlower2D.h>

#include <DIPaCUS/derivates/Misc.h>
#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>

#include <cmath>
#include <boost/filesystem/operations.hpp>

using namespace DGtal;
using namespace DGtal::Z2i;

double EPSILON=0;
enum EpsilonType{EQUAL_R,HALF_R};

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

double outerEstimation(double areaDiff,double simpleRadius)
{
    double R = simpleRadius;
    double A = 625.0/768.0*pow(R,8);
    double B = 125.0/144.0*pow(R,6);

    double C = -pow(areaDiff,2);

    double d = pow(B,2) - 4*A*C;
    double k2 = (-B+sqrt(d))/(2*A);

    return k2;

}


typedef std::pair<double,double> KPair;
typedef std::map<double,KPair> KMap;

template<class TShape>
double dgciEnergy(const TShape& shape,double h,double r)
{
    DigitalSet ds = DIPaCUS::Shapes::digitizeShape(shape,h);

    DigitalSet boundary(ds.domain());
    DIPaCUS::Misc::digitalBoundary<DIPaCUS::Neighborhood::EightNeighborhoodPredicate>(boundary,ds);

    KMap kMap;
    double energyValue=0;
    for(auto p:boundary)
    {
        double angle = shape.parameter(p);
        RealVector realNormal = shape.normal(angle);
        double realK = shape.curvature(angle);

        if(fabs(realK)>2) continue;

        RealPoint centerOut = p -(r/h+h/2.0)*realNormal;
        RealPoint centerInn = p + (r/h-h/2.0)*realNormal;


        double innCoeff = innerCoefficient(ds,centerInn,r+EPSILON,h);
        double outCoeff = outerCoefficient(ds,centerOut,r+EPSILON,h);

        double estK2 = outerEstimation(innCoeff,r);
        estK2 += outerEstimation(outCoeff,r);

        kMap[angle] = KPair( pow(realK,2),estK2);
        energyValue+=estK2*h;
    }

    return energyValue;
}

template<class TShape>
double rsepEnergy(const TShape& shape,double h,double r)
{
    DigitalSet ds = DIPaCUS::Shapes::digitizeShape(shape,h);

    DigitalSet boundary(ds.domain());
    DIPaCUS::Misc::digitalBoundary<DIPaCUS::Neighborhood::EightNeighborhoodPredicate>(boundary,ds);

    KMap kMap;
    double energyValue=0;
    for(auto p:boundary)
    {
        double angle = shape.parameter(p);
        RealVector realNormal = shape.normal(angle);
        double realK = shape.curvature(angle);

        if(fabs(realK)>2) continue;

        RealPoint centerOut = p -(r/h+h/2.0)*realNormal;
        RealPoint centerInn = p + (r/h-h/2.0)*realNormal;


        double innCoeff = innerCoefficient(ds,centerInn,r+EPSILON,h);
        double outCoeff = outerCoefficient(ds,centerOut,r+EPSILON,h);

        double areaDiff = (innCoeff-outCoeff);
        double estK2 = outerEstimation(areaDiff,r);

        kMap[angle] = KPair( pow(realK,2),estK2);
        energyValue+=estK2*h;
    }

    return energyValue;

}


int main(int argc, char* argv[])
{
    std::string shapeName=argv[1];
    double shapeRadius=std::atof(argv[2]);
    double r=std::atof(argv[3]);
    double h=std::atof(argv[4]);
    std::string epsilonType=argv[5];
//    std::string outputFilepath = argv[6];

    EpsilonType  et;
    if(epsilonType=="equal_r")
    {
        EPSILON=r;
        et = EpsilonType::EQUAL_R;
    }else
    {
        EPSILON=r/2.0;
        et = EpsilonType::HALF_R;
    }

//    boost::filesystem::path p(outputFilepath);
//    boost::filesystem::create_directories(p.remove_filename());

    AccFlower2D<Space> flower(0,0,shapeRadius,5,3,0);
    Ball2D<Space> ball(0,0,shapeRadius);


    double dgciEnergyValue,rsepEnergyValue;
    if(shapeName=="ball")
    {
        dgciEnergyValue=dgciEnergy(ball,h,r);
        rsepEnergyValue=rsepEnergy(ball,h,r);
    }else if(shapeName=="flower")
    {
        dgciEnergyValue=dgciEnergy(flower,h,r);
        rsepEnergyValue=rsepEnergy(flower,h,r);
    }else
        throw std::runtime_error("Unrecognized shape!");

    std::cout << "DGCI energy value:" << dgciEnergyValue << std::endl;
    std::cout << "R-Sep energy value:" << rsepEnergyValue << std::endl;

    return 0;
}