#include <boost/filesystem.hpp>
#include <DGtal/helpers/StdDefs.h>
#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/components/SetOperations.h>

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
    std::ofstream ofsInn(outputFolder+"/inner.txt");
    std::ofstream ofsOut(outputFolder+"/outer.txt");

    ofsInn << fixedStrLength(COL_LENGTH,"#Distance")
           << fixedStrLength(COL_LENGTH,"uInn") << "\n";

    ofsOut << fixedStrLength(COL_LENGTH,"#Distance")
           << fixedStrLength(COL_LENGTH,"uOut") << "\n";

    DigitalSet shape = DIPaCUS::Shapes::square(h);
    Point lp,up;
    shape.computeBoundingBox(lp,up);

    Arange arange(0,radius/h,100);
    RealPoint center = up;
    double d;
    while(arange(d))
    {
        RealPoint pOut(d,d);
        RealPoint pInn(-d,-d);

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