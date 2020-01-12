#include <cmath>
#include <iostream>

#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/writers/GenericWriter.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/base/Representation.h>
#include <DIPaCUS/components/Transform.h>
#include <DIPaCUS/derivates/Misc.h>

#include <geoc/api/api.h>

#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>

#include "energy.h"

using namespace DGtal::Z2i;
using namespace SCaBOliC::Core;

#define PI 3.14159265359

typedef std::pair<Point,double> PointWeight;

struct PointWeightComparator
{
    bool operator()(const PointWeight& pw1, const PointWeight& pw2) const
    {
        if( pw1.first[0] == pw2.first[0] ) return pw1.first[1] < pw2.first[1];
        else return pw1.first[0] < pw2.first[0];
    }
};


struct NormalInterval
{
    typedef DGtal::Circulator<Curve::ConstIterator> CurveCirculator;
    typedef std::pair<CurveCirculator,CurveCirculator> IntervalCirculator;
    typedef std::unordered_map<Point,IntervalCirculator> PointIntervalMap;

    typedef std::set<PointWeight,PointWeightComparator> NormalNeighbors;

    NormalInterval(const DigitalSet& shape, int interval):shape(shape),interval(interval)
    {
        DIPaCUS::Misc::computeBoundaryCurve(boundary,shape);

        CurveCirculator boundaryCirc(boundary.begin(),boundary.begin(),boundary.end());
        CurveCirculator minusInt=boundaryCirc;
        CurveCirculator plusInt=boundaryCirc;
        for(int i=0;i<interval;++i){ --minusInt; ++plusInt; }

        const Domain& domain = shape.domain();
        kspace.init(domain.lowerBound(),domain.upperBound(),true);

        auto it=boundaryCirc;
        do{
            auto pixels = kspace.sUpperIncident(*it);
            for(auto kp:pixels)
            {
                auto p = kspace.sCoords(kp);
                if(shape( p))
                {
                    pim[p] = IntervalCirculator(minusInt,plusInt);
                }
            }

            ++plusInt;
            ++minusInt;
            ++it;
        }while(it!=boundaryCirc);

    }

    double weight(int n)
    {
//        double x = -interval+n;
//        double s=interval/2.5;
//        return 1.0/(s*sqrt(PI))*exp(-(x*x/(2*s)));
        return 1;
    }

    NormalNeighbors get(const Point& p)
    {
        NormalNeighbors nn;
        IntervalCirculator ic = pim.at(p);

        int i=0;
        for(auto it=ic.first;it!=ic.second;++it)
        {
            auto pixels = kspace.sUpperIncident(*it);
            for(auto kp:pixels)
            {
                auto _p = kspace.sCoords(kp);
                if (shape(_p)) nn.insert(std::make_pair(_p, weight(i)));

            }
            ++i;
        }

        return nn;
    }


    KSpace kspace;
    Curve boundary;
    PointIntervalMap pim;

    const DigitalSet& shape;
    int interval;
};

struct TangentMap
{
    typedef GEOC::API::GridCurve::Tangent::EstimationsVector TangentVector;
    typedef std::map<Point,TangentVector::value_type> PointTangentMap;

    TangentMap(const DigitalSet& shape, double h)
    {
        using namespace GEOC::API::GridCurve;

        const Domain& domain = shape.domain();
        KSpace kspace;
        kspace.init(domain.lowerBound(),domain.upperBound(),true);
        Curve curve;

        DIPaCUS::Misc::computeBoundaryCurve(curve,shape);

        TangentVector tv;
        Tangent::symmetricClosed<Tangent::EstimationAlgorithms::ALG_MDSS>(kspace,curve.begin(),curve.end(),tv,h,NULL);

        int i=0;
        for(auto c:curve)
        {
            auto pixels = kspace.sUpperIncident(c);
            for(auto kp:pixels)
            {
                auto p = kspace.sCoords(kp);
                if(shape(p)){
                    ptm[p] = tv[i];
                }
            }
            ++i;
        }
    }

    PointTangentMap ptm;

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

double foregroundInters(const DigitalSet& shape, const RealPoint& ballCenter, double ballRadius, double h)
{
    DigitalSet ball = DIPaCUS::Shapes::ball(h,ballCenter[0]*h,ballCenter[1]*h,ballRadius);
    double cInt = intersectionCount(ball,shape);

    return fabs(ball.size()/2-cInt);
}

int main(int argc, char* argv[])
{
    typedef DIPaCUS::Representation::Image2D Image2D;

    double radius=3;
    double h=0.25;
    double level=2;
    int optBand=0;
    std::string outputFolder=argv[1];

    DigitalSet _shape = DIPaCUS::Shapes::flower(h,0,0,20,5,2);
    DigitalSet shape = DIPaCUS::Transform::bottomLeftBoundingBoxAtOrigin(_shape);
    const Domain& domain=shape.domain();


    for(int i=0;i<10;++i)
    {
        NormalInterval ni(shape,5);

        ODRPixels odrPixels(radius,h,level,ODRPixels::LevelDefinition::LD_CloserFromCenter,ODRPixels::NeighborhoodType::FourNeighborhood,optBand);
        ODRModel ODR = odrPixels.createODR(ODRPixels::ApplicationMode::AM_OptimizationBoundary,shape);

    //    for(auto p:ODR.applicationRegionInn)
    //    {
    //        std::cout << "Neighbors of:" << p << std::endl;
    //        for(auto npair:ni.get(p))
    //        {
    //            std::cout << "\t" << npair.first << ":" << npair.second << std::endl;
    //        }
    //    }

        TangentMap tm(shape,h);
        Energy::Term term(ODR);
        for(auto p:ODR.applicationRegion)
        {
            RealPoint center = p;
            if(tm.ptm.find(p)==tm.ptm.end()) continue;

            RealPoint dir( -tm.ptm.at(p)[1],tm.ptm.at(p)[0] );
            double norm=pow( pow(dir[0],2)+pow(dir[1],2),0.5 );
            dir/=norm;

            RealPoint pOut = -level*dir/h;
            RealPoint pInn = level*dir/h;

            RealPoint centerOut = center + pOut;
            RealPoint centerInn = center + pInn;

            auto neighbors = ni.get(p);
            double s=neighbors.size();

            double uOut = foregroundInters(shape,centerOut,radius,h)-s;
            double uInn = foregroundInters(shape,centerInn,radius,h)-s;

            if(uOut > uInn)
            {
                std::cout << "Giripoca" << std::endl;
            }

            term.add(uOut,uInn,neighbors.begin(),neighbors.end());

        }

        Energy::Solution solution(ODR.domain);
        solution.init(term.numVars);
        solution.labelsVector.setZero();

        Energy::solve(solution,term.UTM,term.ET);

        DigitalSet dsOut(domain);
        DigitalSet dsIn = ODR.trustFRG;
        odrPixels.handle()->solutionSet(dsOut,dsIn,ODR,solution.labelsVector.data(),term.vm.pim);

        shape = dsOut;


        Image2D image(domain);
        DIPaCUS::Representation::digitalSetToImage(image,shape);
        DGtal::GenericWriter<Image2D>::exportFile( outputFolder + "/00" + std::to_string(i) + ".pgm",image);
    }


    return 0;
}