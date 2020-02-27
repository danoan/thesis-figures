#include "DGCIEnergy.h"

namespace DGCIEnergy
{
    DigitalSet ballIntersection(const RealPoint& center, double radius, double h, const DigitalSet& intersectWith)
    {
        DigitalSet ball = DIPaCUS::Shapes::ball(h,center[0]*h,center[1]*h,radius);
        DigitalSet intersectionSet(ball.domain());
        DIPaCUS::SetOperations::setIntersection(intersectionSet,ball,intersectWith);

        return intersectionSet;
    }

    VectorTangent estimateTangent(const Domain& domain, const Curve& curve, double h)
    {
        KSpace kspace;
        kspace.init(domain.lowerBound(),domain.upperBound(),true);

        VectorTangent ev;
        Tangent::symmetricClosed<Tangent::EstimationAlgorithms::ALG_MDSS>(kspace,curve.begin(),curve.end(),ev,h,NULL);

        return ev;
    }

    Point round(const RealPoint& rp)
    {
        return Point( (int) std::round(rp[0]), (int) std::round( rp[1] ) );
    }

    EnergyOutput dgciEnergy(const EnergyInput& ei)
    {
        const DigitalSet& ds = ei.ds;
        ODRPixels odrPixels(ei.radius+ei.epsilon,ei.gridStep,ei.levels,ODRPixels::LevelDefinition::LD_CloserFromCenter,ODRPixels::NeighborhoodType::FourNeighborhood,ei.optBand);
        ODRModel ODR=odrPixels.createODR(ODRPixels::ApplicationMode::AM_AroundBoundary,ds);

        typedef QPBOImproveSolver<OptimizationData::UnaryTermsMatrix,OptimizationData::EnergyTable,Solution::LabelsVector> MySolver;

        double energyValue;
        double energyValuePriorInversion;
        int unlabeled;

        ISQ::VariableMap vm(ODR);
        OptimizationData od;


        od.numVars = ODR.optRegion.size();
        od.localUTM=OptimizationData::UnaryTermsMatrix(2,od.numVars);
        od.localUTM.setZero();


        double ballArea = odrPixels.handle()->pixelArea()/(ei.gridStep*ei.gridStep);
        Curve boundary;
        KSpace kspace;
        kspace.init(ds.domain().lowerBound(),ds.domain().upperBound(),true);
        DIPaCUS::Misc::computeBoundaryCurve(boundary,ds);
        VectorTangent tangents = estimateTangent(ds.domain(),boundary,ei.gridStep);

        int i=0;
        for(auto c:boundary)
        {
            auto pixels=kspace.sUpperIncident(c);
            Point p;
            for(auto _p:pixels)
            {
                if( ds( kspace.sCoords(_p) ) )
                {
                    p=kspace.sCoords(_p);
                    break;
                }
            }


            RealVector tangent = tangents[i];
            RealVector realNormal( -tangent[1], tangent[0]);


            RealPoint centerInn = round( p -(ei.radius/ei.gridStep)*realNormal );
            RealPoint centerOut = round( p + (ei.radius/ei.gridStep)*realNormal );


            DigitalSet Fi= ballIntersection(centerInn,ei.radius+ei.epsilon,ei.gridStep,ODR.trustFRG);
            DigitalSet Xi = ballIntersection(centerInn,ei.radius+ei.epsilon,ei.gridStep,ODR.optRegion);
            double Ai = (ballArea/2.0 - Fi.size())*pow(ei.gridStep,2);

            DigitalSet Fo= ballIntersection(centerOut,ei.radius+ei.epsilon,ei.gridStep,ODR.trustFRG);
            DigitalSet Xo = ballIntersection(centerOut,ei.radius+ei.epsilon,ei.gridStep,ODR.optRegion);
            double Ao = (ballArea/2.0-Fo.size())*pow(ei.gridStep,2);

            for(auto x:Xi)
            {
                OptimizationData::Index xj = vm.pim.at(x);
                od.localUTM(1,xj)+=-2*Ai+1;
                for(auto y:Xi)
                {
                    if(y==x) continue;
                    OptimizationData::Index yj = vm.pim.at(y);
                    OptimizationData::IndexPair ip = od.makePair(xj,yj);
                    if( od.localTable.find(ip)==od.localTable.end()) od.localTable[ip] = OptimizationData::BooleanConfigurations(0,0,0,0);
                    od.localTable[ip].e11 +=2;
                }
            }

            for(auto x:Xo)
            {
                OptimizationData::Index xj = vm.pim.at(x);
                od.localUTM(1,xj)+=-2*Ao+1;
                for(auto y:Xo)
                {
                    if(y==x) continue;
                    OptimizationData::Index yj = vm.pim.at(y);
                    OptimizationData::IndexPair ip = od.makePair(xj,yj);
                    if( od.localTable.find(ip)==od.localTable.end()) od.localTable[ip] = OptimizationData::BooleanConfigurations(0,0,0,0);
                    od.localTable[ip].e11 +=2;
                }
            }

            ++i;
        }


        Solution solution(ODR.domain,od.numVars);
        MySolver solver(energyValue,energyValuePriorInversion,unlabeled,od.localUTM,od.localTable,solution.labelsVector,10);

        for (int i = 0; i < solution.labelsVector.rows(); ++i)
        {
            solution.labelsVector.coeffRef(i) = 1-solution.labelsVector.coeff(i);
        }

        DigitalSet outputDS(ds.domain());
        odrPixels.handle()->solutionSet(outputDS,ODR.trustFRG,ODR,solution.labelsVector.data(),vm.pim);

        return EnergyOutput(ds,outputDS,solution);
    }


    EnergyOutput rSepEnergy(const EnergyInput& ei)
    {
        const DigitalSet& ds = ei.ds;
        ODRPixels odrPixels(ei.radius+ei.epsilon,ei.gridStep,ei.levels,ODRPixels::LevelDefinition::LD_CloserFromCenter,ODRPixels::NeighborhoodType::FourNeighborhood,ei.optBand);
        ODRModel ODR=odrPixels.createODR(ODRPixels::ApplicationMode::AM_AroundBoundary,ds);

        typedef QPBOImproveSolver<OptimizationData::UnaryTermsMatrix,OptimizationData::EnergyTable,Solution::LabelsVector> MySolver;

        double energyValue;
        double energyValuePriorInversion;
        int unlabeled;

        ISQ::VariableMap vm(ODR);
        OptimizationData od;


        od.numVars = ODR.optRegion.size();
        od.localUTM=OptimizationData::UnaryTermsMatrix(2,od.numVars);
        od.localUTM.setZero();


        double ballArea = odrPixels.handle()->pixelArea()/(ei.gridStep*ei.gridStep);
        Curve boundary;
        KSpace kspace;
        kspace.init(ds.domain().lowerBound(),ds.domain().upperBound(),true);
        DIPaCUS::Misc::computeBoundaryCurve(boundary,ds);
        VectorTangent tangents = estimateTangent(ds.domain(),boundary,ei.gridStep);

        int i=0;
        for(auto c:boundary)
        {
            auto pixels=kspace.sUpperIncident(c);
            Point p;
            for(auto _p:pixels)
            {
                if( ds( kspace.sCoords(_p) ) )
                {
                    p=kspace.sCoords(_p);
                    break;
                }
            }


            RealVector tangent = tangents[i];
            RealVector realNormal( -tangent[1], tangent[0]);


            RealPoint centerOut = round( p -(ei.radius/ei.gridStep)*realNormal );
            RealPoint centerInn = round( p + (ei.radius/ei.gridStep)*realNormal );


            DigitalSet Fi= ballIntersection(centerInn,ei.radius+ei.epsilon,ei.gridStep,ODR.trustFRG);
            DigitalSet Xi = ballIntersection(centerInn,ei.radius+ei.epsilon,ei.gridStep,ODR.optRegion);
            double Ai = (ballArea/2.0 - Fi.size())*pow(ei.gridStep,2);

            DigitalSet Fo= ballIntersection(centerOut,ei.radius+ei.epsilon,ei.gridStep,ODR.trustFRG);
            DigitalSet Xo = ballIntersection(centerOut,ei.radius+ei.epsilon,ei.gridStep,ODR.optRegion);
            double Ao = (ballArea/2.0-Fo.size())*pow(ei.gridStep,2);

            double AiAo=Ai+Ao;

            for(auto x:Xi)
            {
                OptimizationData::Index xj = vm.pim.at(x);
                od.localUTM(1,xj)+=-2*AiAo+1;
                for(auto y:Xi)
                {
                    if(y==x) continue;
                    OptimizationData::Index yj = vm.pim.at(y);
                    OptimizationData::IndexPair ip = od.makePair(xj,yj);
                    if( od.localTable.find(ip)==od.localTable.end()) od.localTable[ip] = OptimizationData::BooleanConfigurations(0,0,0,0);
                    od.localTable[ip].e11 +=2;
                }
            }

            for(auto x:Xo)
            {
                OptimizationData::Index xj = vm.pim.at(x);
                od.localUTM(1,xj)+=-2*AiAo+1;
                for(auto y:Xo)
                {
                    if(y==x) continue;
                    OptimizationData::Index yj = vm.pim.at(y);
                    OptimizationData::IndexPair ip = od.makePair(xj,yj);
                    if( od.localTable.find(ip)==od.localTable.end()) od.localTable[ip] = OptimizationData::BooleanConfigurations(0,0,0,0);
                    od.localTable[ip].e11 +=2;
                }
            }

            for(auto x:Xi)
            {
                OptimizationData::Index xj = vm.pim.at(x);
                for(auto y:Xo)
                {
                    if(x==y)
                    {
                        od.localUTM(1,xj)+=1;
                    }
                    else
                    {
                        OptimizationData::Index yj = vm.pim.at(y);
                        OptimizationData::IndexPair ip = od.makePair(xj,yj);
                        if( od.localTable.find(ip)==od.localTable.end()) od.localTable[ip] = OptimizationData::BooleanConfigurations(0,0,0,0);
                        od.localTable[ip].e11 +=1;
                    }

                }
            }

            ++i;
        }


        Solution solution(ODR.domain,od.numVars);
        MySolver solver(energyValue,energyValuePriorInversion,unlabeled,od.localUTM,od.localTable,solution.labelsVector,100);

        for (int i = 0; i < solution.labelsVector.rows(); ++i)
        {
            solution.labelsVector.coeffRef(i) = 1-solution.labelsVector.coeff(i);
        }

        DigitalSet outputDS(ds.domain());
        odrPixels.handle()->solutionSet(outputDS,ODR.trustFRG,ODR,solution.labelsVector.data(),vm.pim);

        return EnergyOutput(ds,outputDS,solution);
    }


}
