#include <boost/filesystem.hpp>

#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/boards/Board2D.h>
#include <DIPaCUS/base/Shapes.h>


using namespace DGtal::Z2i;


void drawDomain(DGtal::Board2D& board,const Domain& domain)
{
    board << DGtal::SetMode(domain.className(),"");
    std::string specificStyle = domain.className() + "/Paving";
    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::Gray, DGtal::Color::Silver));
    board << domain;

}

void drawSingle(DGtal::Board2D board, const std::string& outputFilepath)
{
    board.setPenColorRGBi(255,114,39);
    board.setLineStyle( DGtal::Board2D::Shape::SolidStyle );
    board.setFillColorRGBi(247,146,86,128);
    board.setLineWidth(2);
    board.drawLine(-5,-1,5,5);

    board.saveSVG(outputFilepath.c_str());
}

void draw4Connected(DGtal::Board2D board, const std::string& outputFilepath)
{
    board.setPenColorRGBi(255,114,39);
    board.setLineStyle( DGtal::Board2D::Shape::SolidStyle );
    board.setFillColorRGBi(247,146,86,128);
    board.setLineWidth(2);
    board.drawLine(-5,-1,5,5);

    board.setPenColorRGBi(255,0,0);
    board.drawLine(-5,-2.4,5,3.6);

    board.saveSVG(outputFilepath.c_str());
}

void draw8Connected(DGtal::Board2D board, const std::string& outputFilepath)
{
    board.setPenColorRGBi(255,114,39);
    board.setLineStyle( DGtal::Board2D::Shape::SolidStyle );
    board.setFillColorRGBi(247,146,86,128);
    board.setLineWidth(2);
    board.drawLine(-5,-1,5,5);

    board.setPenColorRGBi(255,0,0);
    board.drawLine(-5,-1.8,5,4.2);

    board.saveSVG(outputFilepath.c_str());
}

int main(int argc, char* argv[])
{
    std::string outputFolder = argv[1];
    boost::filesystem::create_directories(outputFolder);

    DGtal::Board2D board;

    Domain domain( Point(-5,-2),Point(7,7) );
    drawDomain(board,domain);


    drawSingle(board,outputFolder+"/single.svg");
    draw4Connected(board,outputFolder+"/four-connected.svg");
    draw8Connected(board,outputFolder+"/eight-connected.svg");



    return 0;
}

