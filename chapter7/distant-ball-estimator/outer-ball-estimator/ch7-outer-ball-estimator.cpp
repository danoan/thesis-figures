#include <DGtal/helpers/StdDefs.h>
#include <DGtal/shapes/parametric/AccFlower2D.h>
#include <DGtal/io/boards/Board2D.h>

#include <DIPaCUS/derivates/Misc.h>

#include <cmath>
#include <boost/filesystem/operations.hpp>

using namespace DGtal;
using namespace DGtal::Z2i;

double EPSILON=0;
double orderCoeffsE05R[8];
double orderCoeffsER[8];


void init()
{
    orderCoeffsE05R[0]=125.0/144.0;
    orderCoeffsE05R[1]=625.0/768.0;
    orderCoeffsE05R[2]=-125.0/1024.0;
    orderCoeffsE05R[3]=-3110125.0/4128768.0;
    orderCoeffsE05R[4]=6338875.0/22020096.0;
    orderCoeffsE05R[5]=5053378625.0/3875536896.0;
    orderCoeffsE05R[6]=-2112673672625.0/2116043145216.0;
    orderCoeffsE05R[7]=-3066286711375.0/1074815565824.0;

    orderCoeffsER[0]=12;
    orderCoeffsER[1]=6;
    orderCoeffsER[2]=-417.0/20.0;
    orderCoeffsER[3]=4923.0/280.0;
    orderCoeffsER[4]=318657.0/5600.0;
    orderCoeffsER[5]=-5952117.0/24640.0;
    orderCoeffsER[6]=8995546257.0/35875840.0;
    orderCoeffsER[7]=11960835753.0/10250240.0;
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

struct OuterEstimationPrecision
{
    typedef std::function<double(double)> OneVariableFunction;
    enum EpsilonType{EQUAL_R,HALF_R};

    OuterEstimationPrecision(double areaDiff,double simpleRadius,int order, EpsilonType et)
    {
        double R = simpleRadius;
        double orderCoeffs[8];

        if(et==EQUAL_R)
            for(int i=0;i<8;++i) orderCoeffs[i]=orderCoeffsER[i]*pow(R,6+2*i);
        else
            for(int i=0;i<8;++i) orderCoeffs[i]=orderCoeffsE05R[i]*pow(R,6+2*i);



        f=[areaDiff, orderCoeffs, order](double z)->double{
            double s=-pow(areaDiff,2);
            for(int i=0;i<order;++i)
            {
                s+= orderCoeffs[i]*pow(z,i+1);
            }
            return s;
        };

        f_prime=[orderCoeffs, order](double z)->double{
            double s=0;
            for(int i=0;i<order;++i)
            {
                s+= (i+1)*orderCoeffs[i]*pow(z,i);
            }
            return s;
        };
    }

    std::pair<double,double> operator()(const double z)
    {
        return std::make_pair(f(z),f_prime(z));
    }

    double find_root()
    {
        return boost::math::tools::newton_raphson_iterate(*this,1e-10,1e-10,10.0,4);
    }

    OneVariableFunction f;
    OneVariableFunction f_prime;
};

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

void drawEstimationBalls(const DigitalSet& shape,const RealPoint& centerInn, const RealPoint& centerOut, double ballRadius, double h, const std::string& outputFilepath)
{
    DigitalSet ballInn = DIPaCUS::Shapes::ball(h,centerInn[0]*h,centerInn[1]*h,ballRadius);
    DigitalSet ballOut = DIPaCUS::Shapes::ball(h,centerOut[0]*h,centerOut[1]*h,ballRadius);

    DigitalSet innerRegion(ballInn.domain());
    DIPaCUS::SetOperations::setDifference(innerRegion,ballInn,shape);

    DigitalSet outerRegion(ballInn.domain());
    DIPaCUS::SetOperations::setIntersection(outerRegion,ballOut,shape);

    DigitalSet intersection(ballInn.domain());
    DIPaCUS::SetOperations::setIntersection(intersection,innerRegion,outerRegion);

    Domain domain(shape.domain().lowerBound() - Point(2.0/h,2.0/h), shape.domain().upperBound() + Point(2.0/h,2.0/h) );


    DGtal::Board2D board;
    board << DGtal::SetMode(shape.className(),"Paving");
    board << domain;

    std::string specificStyle = shape.className() + "/Paving";
    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Black, DGtal::Color::Gray));
    board << shape;

    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Black, DGtal::Color::Blue));
    board << ballInn;

    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Black, DGtal::Color::Green));
    board << ballOut;

    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Black, DGtal::Color::Yellow));
    board << innerRegion;

    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Black, DGtal::Color::Navy));
    board << outerRegion;

    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Black, DGtal::Color::Cyan));
    board << intersection;

    board.saveSVG(outputFilepath.c_str());
}

Point round(const RealPoint& rp)
{
    return Point( (int) std::round(rp[0]), (int) std::round( rp[1] ) );
}

typedef std::pair<double,double> KPair;
typedef std::map<double,KPair> KMap;

template<class TShape>
KMap outerEstimation(const TShape& shape,double h,double r,int order,OuterEstimationPrecision::EpsilonType et)
{

    DigitalSet ds = DIPaCUS::Shapes::digitizeShape(shape,h);
    DigitalSet boundary(ds.domain());
    DIPaCUS::Misc::digitalBoundary<DIPaCUS::Neighborhood::EightNeighborhoodPredicate>(boundary,ds);

    KMap kMap;
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

        //double estK2 = outerEstimation(areaDiff,r);
        OuterEstimationPrecision oep(areaDiff,r,order,et);
        double estK2 = oep.find_root();


        kMap[angle] = KPair( pow(realK,2),estK2);
    }

    return kMap;
}

void writeGNUPlot(std::ostream& os, const KMap& kMap)
{
    os << "#Angle RealK2 EstK2\n";
    for(auto it=kMap.begin();it!=kMap.end();++it)
    {
        double angle = it->first;
        double realK2 = it->second.first;
        double estK2 = it->second.second;

        os << angle << " " << realK2 << " " << estK2 << "\n";
    }
}

int main(int argc, char* argv[])
{
    init();
    std::string shapeName=argv[1];
    double er=std::atof(argv[2]);
    double r=std::atof(argv[3]);
    double h=std::atof(argv[4]);
    int order=std::atoi(argv[5]);
    std::string epsilonType=argv[6];
    std::string outputFilepath = argv[7];

    OuterEstimationPrecision::EpsilonType  et;
    if(epsilonType=="equal_r")
    {
        EPSILON=r;
        et = OuterEstimationPrecision::EQUAL_R;
    }else
    {
        EPSILON=r/2.0;
        et = OuterEstimationPrecision::HALF_R;
    }

    boost::filesystem::path p(outputFilepath);
    boost::filesystem::create_directories(p.remove_filename());

    AccFlower2D<Space> flower(0,0,er,5,3,0);
    Ball2D<Space> ball(0,0,er);


    KMap kMap;

    if(shapeName=="ball")
        kMap = outerEstimation(ball,h,r,order,et);
    else if(shapeName=="flower")
        kMap = outerEstimation(flower,h,r,order,et);
    else
        throw std::runtime_error("Unrecognized shape!");

    std::ofstream ofs(outputFilepath);
    writeGNUPlot(ofs,kMap);
    ofs.flush();
    ofs.close();

    return 0;
}