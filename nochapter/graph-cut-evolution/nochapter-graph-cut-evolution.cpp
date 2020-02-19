#include <boost/filesystem/operations.hpp>

#include <DGtal/helpers/StdDefs.h>
#include <DGtal/geometry/volumes/distance/DistanceTransformation.h>
#include <DGtal/io/boards/Board2D.h>
#include <DGtal/io/readers/GenericReader.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/base/Representation.h>
#include <DIPaCUS/components/SetOperations.h>
#include <DIPaCUS/derivates/Misc.h>

#include <SCaBOliC/Core/ODRPixels/ODRPixels.h>
#include <SCaBOliC/Core/model/ODRModel.h>

using namespace DGtal::Z2i;
using namespace SCaBOliC::Core;


std::pair<ODRPixels,ODRModel> createODRPair(const DigitalSet& shape)
{
    double radius=7;
    double gridStep=1.0;
    double levels=0;

    ODRPixels odrPixels(radius,gridStep,levels,ODRModel::LD_CloserFromCenter,ODRPixels::NeighborhoodType::FourNeighborhood,2);
    ODRModel odr = odrPixels.createODR(ODRPixels::ApplicationMode::AM_OptimizationBoundary,
                                       shape);

    return std::make_pair(odrPixels,odr);
}


void shapeAndBands(const DigitalSet& shape, const std::string& outputFolder)
{
    auto odrPair = createODRPair(shape);
    const ODRPixels& odrPixels = odrPair.first;
    const ODRModel& odr = odrPair.second;

    const DigitalSet& frgRegion = odr.trustFRG;
    const DigitalSet& optRegion = odr.optRegion;

    Point lb,ub;
    shape.computeBoundingBox(lb,ub);

    DigitalSet ball = DIPaCUS::Shapes::ball(1.0,ub[0],ub[1],10);

    DigitalSet frgIntersection(shape.domain());
    DIPaCUS::SetOperations::setIntersection(frgIntersection,frgRegion,ball);

    DigitalSet optIntersection(shape.domain());
    DIPaCUS::SetOperations::setIntersection(optIntersection,optRegion,ball);

    DGtal::Board2D board;
    board << shape.domain();
    board << DGtal::SetMode(shape.className(),"Paving");

    board << DGtal::CustomStyle( shape.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color::Blue))
          << shape;

    board
            << DGtal::CustomStyle( frgRegion.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color::Blue))
            << frgRegion
            << DGtal::CustomStyle( optRegion.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color::Yellow) )
            << optRegion;

    board.saveSVG( (outputFolder+"/shape-and-band.svg").c_str());

    board
            << DGtal::CustomStyle( ball.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color::Gray) )
            << ball
            << DGtal::CustomStyle( frgIntersection.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color::Navy) )
            << frgIntersection
            << DGtal::CustomStyle( optIntersection.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color(255,128,0)) )
            << optIntersection;

    board.saveSVG( (outputFolder+"/shape-and-ball.svg").c_str() );
}


int main(int argc, char* argv[])
{
    DigitalSet _shape = DIPaCUS::Shapes::square(1.0,0,0,20);
    DigitalSet shape = DIPaCUS::Transform::bottomLeftBoundingBoxAtOrigin(_shape);

    std::string outputFolder = argv[1];

    boost::filesystem::create_directories(outputFolder);

    DGtal::Board2D board;
    board << shape.domain();
    board << DGtal::SetMode(shape.className(),"Paving");

    board << DGtal::CustomStyle( shape.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color::Blue))
          << shape;
    board.saveSVG( (outputFolder+"/single-shape.svg").c_str() );

    shapeAndBands(shape,outputFolder);

    return 0;
}