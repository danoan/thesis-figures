#include <boost/filesystem.hpp>
#include <opencv/core.hpp>
#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/boards/Board2D.h>
#include <DIPaCUS/base/Shapes.h>


using namespace DGtal::Z2i;


void drawDomain(DGtal::Board2D& board,const Domain& domain,double h)
{
    board << domain;
}

int main(int argc, char* argv[])
{
    double radius=5.0;
    double h = std::atof(argv[1]);
    double cx =  std::atof(argv[2]);
    double cy =  std::atof(argv[3]);
    std::string outputFilepath = argv[4];

    boost::filesystem::path p(outputFilepath);
    boost::filesystem::create_directories(p.remove_filename());
    DGtal::Board2D board;

    Domain domain( 1.2*RealPoint(-radius/h,-radius/h), 1.2*RealPoint(radius/h,radius/h) );
    drawDomain(board,domain,h);

    DigitalSet digBall = DIPaCUS::Shapes::ball(h,cx,cy,radius);

    board << DGtal::SetMode(digBall.className(),"Paving");
    std::string specificStyle = digBall.className() + "/Paving";

    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Black, DGtal::Color(29,78,137,100)));
    board << digBall;


    board.setPenColorRGBi(244,114,39);
    board.setLineStyle( DGtal::Board2D::Shape::SolidStyle );
    board.setFillColorRGBi(247,146,86,128);
    board.setLineWidth(2);

    board.drawCircle(cx/h,cy/h,radius/h);
    board.saveSVG(outputFilepath.c_str());


    return 0;
}

