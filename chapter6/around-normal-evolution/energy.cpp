#include "energy.h"

namespace Energy
{
    IndexPair makePair(Index i1, Index i2)
    {
        Index temp = i1;
        if (i2 < i1)
        {
            i1 = i2;
            i2 = temp;
        }

        return IndexPair(i1,i2);
    }

    void solve(Solution& solution, UnaryTermsMatrix& UTM, EnergyTable& ET )
    {
        MySolver (solution.energyValue,
                  solution.energyValuePriorInversion,
                  solution.unlabeled,
                  UTM,
                  ET,
                  solution.labelsVector,
                  10);
    }


    Term::Term(const ODRModel& ODR):vm(ODR)
    {
        numVars = vm.numVars;
        UTM = UnaryTermsMatrix(2,numVars);
        UTM.setZero();
    }



}