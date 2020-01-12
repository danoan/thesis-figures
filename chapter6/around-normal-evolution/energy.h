#include <SCaBOliC/Energy/model/OptimizationData.h>
#include <SCaBOliC/Energy/model/Solution.h>
#include <SCaBOliC/Energy/ISQ/VariableMap.h>
#include <SCaBOliC/Optimization/solver/improve/QPBOImproveSolver.h>

namespace Energy
{
    typedef SCaBOliC::Energy::OptimizationData::UnaryTermsMatrix UnaryTermsMatrix;
    typedef SCaBOliC::Energy::OptimizationData::PairwiseTermsMatrix PairwiseTermsMatrix;
    typedef SCaBOliC::Energy::OptimizationData::EnergyTable EnergyTable;

    typedef SCaBOliC::Energy::Solution Solution;
    typedef Solution::LabelsVector LabelsVector;

    typedef SCaBOliC::Optimization::QPBOImproveSolver<UnaryTermsMatrix,EnergyTable,LabelsVector> MySolver;

    void solve(Solution& solution, UnaryTermsMatrix& UTM, EnergyTable& ET );

    struct BooleanConfigurations
    {
        BooleanConfigurations(){}
        BooleanConfigurations(double e00, double e01, double e10, double e11):e00(e00),
                                                                              e01(e01),e10(e10),e11(e11){}

        BooleanConfigurations& operator+(const BooleanConfigurations& other);

        double e00,e01,e10,e11;
    };

    struct Term
    {
        typedef SCaBOliC::Core::ODRModel ODRModel;
        typedef SCaBOliC::Energy::ISQ::VariableMap VariableMap;

        Term(const ODRModel& ODR);

        template<class TIterator>
        void add(double uOut,double uInn,TIterator begin, TIterator end);

        VariableMap vm;
        UnaryTermsMatrix UTM;
        EnergyTable ET;
        unsigned int numVars;
    };


}

#include "energy.hpp"

