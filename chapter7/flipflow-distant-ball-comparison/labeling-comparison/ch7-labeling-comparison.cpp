#include <DGtal/helpers/StdDefs.h>
#include <DGtal/shapes/parametric/AccFlower2D.h>
#include <DGtal/io/writers/GenericWriter.h>

#include <DIPaCUS/derivates/Misc.h>
#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>

#include <cmath>
#include <boost/filesystem/operations.hpp>

#include <DGCIEnergy.h>

using namespace DGtal;
using namespace DGtal::Z2i;

DigitalSet resolveShape(const std::string& shape,double radius,double gridStep)
{
    if(shape=="triangle") return DIPaCUS::Shapes::triangle(gridStep,0,0,radius);
    else if(shape=="square") return DIPaCUS::Shapes::square(gridStep,0,0,radius);
    else if(shape=="pentagon") return DIPaCUS::Shapes::NGon(gridStep,0,0,radius,5);
    else if(shape=="heptagon") return DIPaCUS::Shapes::NGon(gridStep,0,0,radius,7);
    else if(shape=="ball") return DIPaCUS::Shapes::ball(gridStep,0,0,radius);
    else if(shape=="flower") return DIPaCUS::Shapes::flower(gridStep,0,0,radius,radius/2.0,2);
    else if(shape=="ellipse") return DIPaCUS::Shapes::ellipse(gridStep,0,0,radius,radius/2);
    else if(shape=="wave") return DIPaCUS::Shapes::wave(gridStep,1200,radius*3,radius*6,0.01);
    else if(shape=="bean") return DIPaCUS::Shapes::bean(gridStep,0,0,0.1);
    else return DIPaCUS::Shapes::triangle(gridStep,0,0,radius);

}

void saveDigitalSetAsImage(const DigitalSet& ds,const std::string& outputFilepath)
{
    typedef DIPaCUS::Representation::Image2D Image2D;
    Image2D image(ds.domain());


    DIPaCUS::Representation::digitalSetToImage(image,ds);
    DGtal::GenericWriter<Image2D>::exportFile(outputFilepath,image);
}

void flow(const std::string& energyName, const DigitalSet& ds,double radius, double epsilon, double h, int iterations, const std::string& outputFolder)
{
    DGCIEnergy::EnergyInput ei(ds,radius,epsilon,h,1,1);


    saveDigitalSetAsImage(ds,outputFolder+"/0.pgm");
    for(int i=1;i<=iterations;++i)
    {
        DGCIEnergy::EnergyOutput energyOutput = energyName=="dgci-energy"? DGCIEnergy::dgciEnergy(ei): DGCIEnergy::rSepEnergy(ei);
        ei.ds=energyOutput.outputDS;

        saveDigitalSetAsImage(energyOutput.outputDS,outputFolder+"/" + std::to_string(i) + ".pgm");
    }
}



int main(int argc, char* argv[])
{
    std::string shapeName=argv[1];
    double shapeRadius=std::atof(argv[2]);
    double r=std::atof(argv[3]);
    double epsilon=std::atof(argv[4]);
    double h=std::atof(argv[5]);
    std::string energyName=argv[6];
    std::string outputFolder = argv[7];

    boost::filesystem::create_directories(outputFolder);

    DigitalSet* ptDS;
    DigitalSet _ds = resolveShape(shapeName,shapeRadius,h);
    ptDS = new DigitalSet( DIPaCUS::Transform::bottomLeftBoundingBoxAtOrigin(_ds,Point(40.0,40.0)) );

    flow(energyName,*ptDS,r,epsilon,h,100,outputFolder);
    delete ptDS;

    return 0;
}