#include "glued-curve.h"

namespace Fig2
{
    namespace GluedCurve
    {
        void gluedCurve(const std::string& outputFolder)
        {
            typedef GenerateSeedPairs::SeedPair SeedPair;
            typedef ExhaustiveGC::CheckableSeedPair CheckableSeedPair;
            typedef ExhaustiveGC::CurveFromJoints CurveFromJoints;

            typedef std::vector< CheckableSeedPair > CheckableSeedPairVector;

            DigitalSet ds = DIPaCUS::Shapes::square();
            EnergyInput::LinelSet ls;
            EnergyInput energyInput(EnergyType::Elastica,EnergyInput::MDCA,1.0,5,0.001,ls);
            SearchParameters sp(SearchParameters::Strategy::Best, 1, 11, 12,false,1,0,0,energyInput,2,0);

            const DGtal::Z2i::Domain& domain = ds.domain();
            KSpace kspace;
            kspace.init(domain.lowerBound(),domain.upperBound(),true);

            GCurve::Range gcRange(ds,11);
            GenerateSeedPairs::SeedPairsList spl;
            GenerateSeedPairs(spl,gcRange);

            std::cout << spl.size() << " qualified seeds\n";


            CheckableSeedPairVector cspv;
            std::for_each(spl.begin(),spl.end(),[&cspv](SeedPair sp) mutable {cspv.push_back( CheckableSeedPair(sp) );});



            auto range = magLac::Core::addRange(cspv.begin(),cspv.end(),sp.jointPairs);
            auto combinator = magLac::Core::Single::createCombinator(range);
            auto resolver = combinator.resolver();

            typedef decltype(combinator) MyCombinator;
            typedef MyCombinator::MyResolver MyResolver;

            GCurve::Seed mainInnerSeed;
            GCurve::Seed mainOuterSeed;
            for(auto it=gcRange.begin();it!=gcRange.end();++it)
            {
                if(it->seed.type==GCurve::Seed::SeedType::MainInner)
                {
                    mainInnerSeed = it->seed;
                    break;
                }
            }

            for(auto it=gcRange.begin();it!=gcRange.end();++it)
            {
                if(it->seed.type==GCurve::Seed::SeedType::MainOuter)
                {
                    mainOuterSeed = it->seed;
                    break;
                }
            }


            DGtal::Board2D board;
            std::vector<CheckableSeedPair> seedCombination(sp.jointPairs);
            int i=1;
            while( combinator.next(resolver) )
            {
                board.clear();
                board << ds;

                auto mainC = mainInnerSeed.inCirculatorBegin;
                auto innC = mainInnerSeed.outCirculatorBegin;
                auto outC = mainOuterSeed.inCirculatorBegin;

                GCurve::Utils::drawCurve(board,DGtal::Color::Silver,DGtal::Color::Silver,mainC,mainC);
                GCurve::Utils::drawCurve(board,DGtal::Color::Silver,DGtal::Color::Silver,innC,innC);
                GCurve::Utils::drawCurve(board,DGtal::Color::Silver,DGtal::Color::Silver,outC,outC);


                resolver >> seedCombination;

                Curve curve;
                CurveFromJoints(curve, seedCombination.data(), sp.jointPairs);

                GCurve::Utils::drawCurve(board,DGtal::Color::Red,DGtal::Color::Red,curve.begin(),curve.end());

                GCurve::Utils::drawCurve(board,DGtal::Color::Green,DGtal::Color::Green,
                                         seedCombination[0].data().first.inCirculatorBegin,
                                         seedCombination[0].data().first.inCirculatorEnd);

                GCurve::Utils::drawCurve(board,DGtal::Color::Green,DGtal::Color::Green,
                                         seedCombination[0].data().first.inCirculatorEnd,
                                         seedCombination[0].data().second.outCirculatorBegin+1);

                board << DGtal::CustomStyle(curve.begin()->className() + "/Paving", new DGtal::CustomColors(DGtal::Color::Blue, DGtal::Color::Blue));
                board << seedCombination[0].data().first.linkLinels[0]
                      << seedCombination[0].data().second.linkLinels[0];

                std::string currOutputPath = outputFolder + "/" + std::to_string(i++) + ".eps";
                board.saveEPS(currOutputPath.c_str());

            }


        };
    }
}