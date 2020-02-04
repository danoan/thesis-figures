#ifndef THESIS_FIGURES_DGCIENERGY_H
#define THESIS_FIGURES_DGCIENERGY_H

#include <DGtal/helpers/StdDefs.h>

#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>
#include <SCaBOliC/Core/model/ODRModel.h>
#include <SCaBOliC/Optimization/solver/improve/QPBOImproveSolver.h>
#include <SCaBOliC/Energy/model/Solution.h>
#include <SCaBOliC/Energy/model/OptimizationData.h>
#include <SCaBOliC/Energy/ISQ/VariableMap.h>

#include <geoc/api/gridCurve/Tangent.hpp>

namespace DGCIEnergy
{
    using namespace DGtal::Z2i;
    using namespace SCaBOliC::Core;
    using namespace SCaBOliC::Optimization;
    using namespace SCaBOliC::Energy;

    using namespace GEOC::API::GridCurve;

    typedef Tangent::EstimationsVector VectorTangent;


    struct EnergyInput
    {
        EnergyInput(const DigitalSet& ds, double radius, double epsilon, double gridStep, double levels, int optBand) : ds(
                ds), radius(radius), epsilon(epsilon), gridStep(gridStep), levels(levels), optBand(optBand) {}

        DigitalSet ds;
        double radius;
        double epsilon;
        double gridStep;
        double levels;
        int optBand;
    };

    struct EnergyOutput
    {
        EnergyOutput(const DigitalSet& initial, const DigitalSet& outputDS,const Solution& solution):initial(initial),outputDS(outputDS),solution(solution){}
        DigitalSet outputDS;
        DigitalSet initial;
        Solution solution;
    };

    DigitalSet ballIntersection(const RealPoint& center, double radius, double h, const DigitalSet& intersectWith);
    VectorTangent estimateTangent(const Domain& domain,const Curve& curve,double h);
    Point round(const RealPoint& rp);
    EnergyOutput dgciEnergy(const EnergyInput& ei);
    EnergyOutput rSepEnergy(const EnergyInput& ei);

}

#endif //THESIS_FIGURES_DGCIENERGY_H
