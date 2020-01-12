#include "energy.h"

namespace Energy
{
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

    BooleanConfigurations& BooleanConfigurations::operator+(const BooleanConfigurations& other)
    {
        this->e00 += other.e00;
        this->e01 += other.e01;
        this->e10 += other.e10;
        this->e11 += other.e11;

        return *this;
    }

    Term::Term(const ODRModel& ODR):vm(ODR)
    {
        numVars = vm.numVars;
        UTM = UnaryTermsMatrix(2,numVars);
        UTM.setZero();
    }



}