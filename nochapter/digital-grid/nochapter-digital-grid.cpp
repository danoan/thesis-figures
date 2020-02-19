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

void drawSCell(DGtal::Board2D& board, const DGtal::Z2i::SCell scell, DGtal::Color color, const std::string& outputFilepath)
{
    board << DGtal::SetMode(scell.className(),"Grid");
    std::string specificStyle = scell.className() + "/Grid";

    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color::None, color));
    board << scell;

    board.saveSVG(outputFilepath.c_str());
}

int main(int argc, char* argv[])
{
    std::string outputFolder = argv[1];
    boost::filesystem::create_directories(outputFolder);

    DGtal::Board2D board;

    Domain domain( Point(0,0),Point(10,10) );
    drawDomain(board,domain);
    board.saveSVG( (outputFolder + "/domain.svg").c_str() );

    KSpace kspace;
    kspace.init(domain.lowerBound(),domain.upperBound(),true);

    KSpace::SCell pixel = kspace.sCell( Point(5,5) );
    KSpace::SCell linel = kspace.sCell( Point(5,4) );
    KSpace::SCell vertex = kspace.sCell( Point(4,4) );

    drawSCell(board,pixel,DGtal::Color::Blue, outputFolder + "/pixel.svg");
    drawSCell(board,linel,DGtal::Color::Red, outputFolder + "/linel.svg");
    drawSCell(board,vertex,DGtal::Color::Green, outputFolder + "/vertex.svg");


    return 0;
}

