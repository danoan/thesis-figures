#ifndef SCABOLIC_FLOW_H
#define SCABOLIC_FLOW_H

#include <boost/filesystem.hpp>

#include <DGtal/helpers/StdDefs.h>
#include <DIPaCUS/components/Morphology.h>

#include "SCaBOliC/Core/display.h"
#include "SCaBOliC/Core/model/ODRModel.h"
#include "SCaBOliC/Core/ODRPixels/ODRPixels.h"
#include "SCaBOliC/Energy/ISQ/ISQEnergy.h"

#include "MockDistribution.h"
#include "InputData.h"

namespace SCaBOliC
{
    namespace Flow
    {
        typedef DGtal::Z2i::DigitalSet DigitalSet;
        typedef DGtal::Z2i::Domain Domain;
        typedef DGtal::Z2i::Point Point;

        typedef SCaBOliC::Input::Data InputData;
        typedef SCaBOliC::Core::ODRModel ODRModel;
        typedef SCaBOliC::Core::ODRPixels ODRPixels;
        typedef SCaBOliC::Energy::ISQEnergy ISQEnergy;

        typedef std::function<void(const ISQEnergy& isqEnergy, const ISQEnergy::Solution& Solution, const ODRModel& odr)> CallbackFlow;

        void dummyCBF(const ISQEnergy& isqEnergy, const ISQEnergy::Solution& Solution, const ODRModel& odr);

        DigitalSet flow(const DigitalSet& ds, const InputData& id,const Domain& domain,CallbackFlow cbf=dummyCBF);
        void shapeFlow(InputData& id,CallbackFlow cbf=dummyCBF);
        void imageFlow(InputData& id,CallbackFlow cbf=dummyCBF);
    }
}

#endif //SCABOLIC_FLOW_H

