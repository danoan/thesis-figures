#include "Flow.h"

namespace SCaBOliC
{
    namespace Flow
    {
        void dummyCBF(const ISQEnergy& isqEnergy, const ISQEnergy::Solution& Solution, const ODRModel& odr){};

        DigitalSet flow(const DigitalSet& ds, const InputData& id,const Domain& domain,CallbackFlow cbf)
        {
            Point size = domain.upperBound() - domain.lowerBound() + Point(1,1);

            typedef DIPaCUS::Representation::Image2D Image2D;
            DigitalSet* pixelMaskDS;
            if(id.pixelMaskFilepath=="")
            {
                pixelMaskDS = new DigitalSet(Domain(Point(0,0),Point(1,1)));
            }else
            {
                Image2D img = DGtal::GenericReader<Image2D>::import(id.pixelMaskFilepath);
                pixelMaskDS = new DigitalSet(img.domain());
                DIPaCUS::Representation::imageAsDigitalSet(*pixelMaskDS,img);
            }

            ODRPixels odrFactory(id.radius,id.gridStep,id.levels,id.ld,id.nt,id.optBand);
            ODRModel odr = odrFactory.createODR(id.appMode,ds,id.optRegionInApplication,*pixelMaskDS);

            SCaBOliC::Core::Display::DisplayODR(odr,"odr.eps");

            cv::Mat colorImage = cv::Mat::zeros(size[1],size[0],CV_8UC3);
            MockDistribution fgDistr,bgDistr;

            ISQEnergy::InputData isqInput(odr,
                                          colorImage,
                                          fgDistr,
                                          bgDistr,
                                          id.excludeOptPointsFromAreaComputation,
                                          id.uniformPerimeter,
                                          id.dataTerm,
                                          id.sqTerm,
                                          id.lengthTerm,
                                          id.innerBallCoef,id.outerBallCoef,
                                          Point(0,0));

            ISQEnergy energy(isqInput,odrFactory.handle());


            ISQEnergy::Solution solution(domain);
            solution.init(energy.numVars());
            solution.labelsVector.setZero();
            energy.template solve<QPBOImproveSolver>(solution);

            DigitalSet dsOut(domain);
            DigitalSet dsIn = odr.trustFRG;

            odrFactory.handle()->solutionSet(dsOut,dsIn,odr,solution.labelsVector.data(),energy.vm().pim);
            cbf( energy, solution, odr);

            delete pixelMaskDS;

            return dsOut;
        }

        void shapeFlow(InputData& id,CallbackFlow cbf)
        {
            DigitalSet square = DIPaCUS::Shapes::square(id.gridStep,0,0,20);

            Domain domain( square.domain().lowerBound() - Point(20,20), square.domain().upperBound() + Point(20,20) );
            DigitalSet workSet(domain);
            workSet.insert(square.begin(),square.end());

            Point size = domain.upperBound() - domain.lowerBound() + Point(1,1);

            boost::filesystem::create_directories(id.outputFolder);
            int it=0;
            while(it<id.iterations)
            {
                cv::Mat imgOut = cv::Mat::zeros(size[1],size[0],CV_8UC1);;
                DIPaCUS::Representation::digitalSetToCVMat(imgOut,workSet);
                cv::imwrite(id.outputFolder + "/" + std::to_string(it) +  ".png",imgOut);


                workSet = flow(workSet,id,domain,cbf);

                ++it;
            }




        }

        void imageFlow(InputData& id,CallbackFlow cbf)
        {

            cv::Mat img = cv::imread(id.imageFilepath,CV_8UC1);
            Domain domain( Point(0,0), Point(img.cols-1,img.rows-1) );
            DigitalSet imgDS(domain);
            DIPaCUS::Representation::CVMatToDigitalSet(imgDS,img,1);
            Point size = domain.upperBound() - domain.lowerBound() + Point(1,1);


            boost::filesystem::create_directories(id.outputFolder);
            int it=0;
            while(it<id.iterations)
            {

                cv::Mat imgOut = cv::Mat::zeros(size[1],size[0],CV_8UC1);
                DIPaCUS::Representation::digitalSetToCVMat(imgOut,imgDS);
                cv::imwrite(id.outputFolder + "/" + std::to_string(it) +  ".png",imgOut);

                imgDS = flow(imgDS,id,domain,cbf);
                ++it;
            }


        }
    }
}
