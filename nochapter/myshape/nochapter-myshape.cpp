#include <boost/filesystem.hpp>

#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/boards/Board2D.h>

#include <DIPaCUS/base/Shapes.h>

using namespace DGtal::Z2i;

struct MyShape
{
    typedef DGtal::Z2i::RealPoint RealPoint;

    MyShape(double a, double b, double c, double r):a(a),b(b),c(c),r(r)
    {
        double minX = -r;
        double maxX = r;
        double minY = -r<c?-r:c;
        double maxY = c>r?c:r;

        lb=RealPoint(minX,minY);
        ub=RealPoint(maxX,maxY);
    }

    DGtal::Orientation orientation(const RealPoint& aPoint) const
    {
        double x = aPoint[0];
        double y = aPoint[1];

        double down = a*pow(x,2) + b*x +c;
        bool notInDisk = pow(x,2)+pow(y,2)>pow(r,2);
        bool onDisk = pow(x,2)+pow(y,2)==pow(r,2);

        if(notInDisk) return DGtal::Orientation::OUTSIDE;
        else
        if(y == down )
            return DGtal::Orientation::ON;
        else if(y < down )
            if(onDisk) return DGtal::Orientation::ON;
            else return DGtal::Orientation::INSIDE;
        else return DGtal::Orientation::OUTSIDE;
    }

    RealPoint getLowerBound() const { return lb; }
    RealPoint getUpperBound() const { return ub; }

    RealPoint lb,ub;
    double a,b,c,r;
};

void setStyle(DGtal::Board2D& board, const DigitalSet& digSet, unsigned int alpha=255)
{
    board << DGtal::SetMode(digSet.className(),"Paving");
    std::string specificStyle = digSet.className() + "/Paving";
    board << DGtal::CustomStyle(specificStyle, new DGtal::CustomColors(DGtal::Color(247,146,86,alpha), DGtal::Color(247,146,86,alpha)));
}

void setStyle(DGtal::Board2D& board)
{
    board.setPenColorRGBi(247,146,86);
    board.setLineStyle( DGtal::Board2D::Shape::SolidStyle );
    board.setFillColorRGBi(247,146,86);
    board.setLineWidth(40);
}

void createMyShape(const std::string& outputFilepath,double h)
{
    MyShape myShape(1,0,0,3);
    DigitalSet digMyShape = DIPaCUS::Shapes::digitizeShape(myShape,h);
    DGtal::Board2D board;

    setStyle(board,digMyShape,128);

    board << digMyShape.domain();
    board << digMyShape;
    board.saveSVG(outputFilepath.c_str());
}

void createMyShapeAndDisk(const std::string& outputFilepath,double h, double r)
{
    MyShape myShape(1,0,0,3);
    DigitalSet digMyShape = DIPaCUS::Shapes::digitizeShape(myShape,h);
    DigitalSet disk = DIPaCUS::Shapes::ball(h,0,0,r);
    
    DGtal::Board2D board;

    board << digMyShape.domain();
    board << digMyShape;
    
    setStyle(board,disk,128);
    board << disk;
    
    board.saveSVG(outputFilepath.c_str());
}

void createFlowerAndDisk(const std::string& outputFilepath,double h, double r)
{
    MyShape myShape(1,0,0,3);
    DigitalSet flower = DIPaCUS::Shapes::flower(h,0,0,10,8,3);
    DigitalSet disk = DIPaCUS::Shapes::ball(h,0,0,r);
    
    DGtal::Board2D board;

    board << flower.domain();
    board << flower;
    
    setStyle(board,disk,128);
    board << disk;
    
    board.saveSVG(outputFilepath.c_str());
}

void createLine(const std::string& outputFilepath)
{
    DGtal::Board2D board;
    setStyle(board);
    board.drawLine(0,0,5,5);
    board.saveSVG(outputFilepath.c_str(),200,200);
}

void createDisk(const std::string& outputFilepath)
{
    DGtal::Board2D board;
    setStyle(board);
    board.drawCircle(0,0,5);
    board.saveSVG(outputFilepath.c_str(),200,200);
}

int main(int argc, char* argv[])
{
    double h=std::atof(argv[1]);
    std::string outputFolder = argv[2];
    double radius = 3;
    if(argc>3){
        radius = std::atof(argv[3]);
    }
    boost::filesystem::create_directories(outputFolder);

    createMyShapeAndDisk(outputFolder+"/myShapeAndDisk.svg",h,radius);
    createFlowerAndDisk(outputFolder+"/flowerAndDisk.svg",h,radius);
    createMyShape(outputFolder+"/myShape.svg",h);
    createLine(outputFolder+"/line.svg");
    createDisk(outputFolder+"/circle.svg");

    return 0;
}
