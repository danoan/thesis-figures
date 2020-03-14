#include <boost/filesystem.hpp>

#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/colormaps/GradientColorMap.h>
#include <DGtal/io/colormaps/TickedColorMap.h>
#include <DGtal/io/boards/Board2D.h>
#include <DGtal/shapes/parametric/AccFlower2D.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/derivates/Misc.h>

using namespace DGtal::Z2i;

enum ShapeType{Triangle,Square,Pentagon,Heptagon,Ball,Ellipse,Flower,Wave,Bean,UserDefined,NoType};

struct Shape
{
    Shape():type(NoType),imagePath(""),name(""){}

    Shape(ShapeType type, const std::string& imagePath=""):type(type),
                                                           imagePath(imagePath)
    {
        if(type==ShapeType::Triangle) name = "triangle";
        else if(type==ShapeType::Square) name = "square";
        else if(type==ShapeType::Pentagon) name =  "pentagon";
        else if(type==ShapeType::Heptagon) name = "heptagon";
        else if(type==ShapeType::Ball) name = "ball";
        else if(type==ShapeType::Ellipse) name = "ellipse";
        else if(type==ShapeType::Flower) name = "flower";
        else if(type==ShapeType::Wave) name = "wave";
        else if(type==ShapeType::Bean) name = "bean";
        else name = "user-defined";
    }

    ShapeType type;
    std::string imagePath;
    std::string name;
};

DigitalSet resolveShape(Shape shape,double gridStep)
{
    int radius=20;
    if(shape.type==ShapeType::Triangle) return DIPaCUS::Shapes::triangle(gridStep,0,0,radius);
    else if(shape.type==ShapeType::Square) return DIPaCUS::Shapes::square(gridStep,0,0,radius);
    else if(shape.type==ShapeType::Pentagon) return DIPaCUS::Shapes::NGon(gridStep,0,0,radius,5);
    else if(shape.type==ShapeType::Heptagon) return DIPaCUS::Shapes::NGon(gridStep,0,0,radius,7);
    else if(shape.type==ShapeType::Ball) return DIPaCUS::Shapes::ball(gridStep,0,0,radius);
    else if(shape.type==ShapeType::Flower) return DIPaCUS::Shapes::flower(gridStep,0,0,radius,radius/2.0,2);
    else if(shape.type==ShapeType::Ellipse) return DIPaCUS::Shapes::ellipse(gridStep,0,0,radius,radius/2);
    else if(shape.type==ShapeType::Wave) return DIPaCUS::Shapes::wave(gridStep,1200,radius*3,radius*6,0.01);
    else if(shape.type==ShapeType::Bean) return DIPaCUS::Shapes::bean(gridStep,0,0,0.1);
    else
    {
        cv::Mat img = cv::imread(shape.imagePath,CV_8UC1);
        Domain domain( DGtal::Z2i::Point(0,0), DGtal::Z2i::Point(img.cols-1,img.rows-1) );
        DigitalSet ds(domain);
        DIPaCUS::Representation::CVMatToDigitalSet(ds,img,1);
        return ds;
    }
}
DigitalSet resolveShape(const std::string& shape,double gridStep)
{
    if(shape=="triangle") return resolveShape(Shape(ShapeType::Triangle),gridStep);
    else if(shape=="square") return resolveShape(Shape(ShapeType::Square),gridStep);
    else if(shape=="pentagon") return resolveShape(Shape(ShapeType::Pentagon),gridStep);
    else if(shape=="heptagon") return resolveShape(Shape(ShapeType::Heptagon),gridStep);
    else if(shape=="ball") return resolveShape(Shape(ShapeType::Ball),gridStep);
    else if(shape=="flower") return resolveShape(Shape(ShapeType::Flower),gridStep);
    else if(shape=="ellipse") return resolveShape(Shape(ShapeType::Ellipse),gridStep);
    else if(shape=="wave") return resolveShape(Shape(ShapeType::Wave),gridStep);
    else if(shape=="bean") return resolveShape(Shape(ShapeType::Bean),gridStep);
    else return resolveShape(Shape(ShapeType::UserDefined,shape),gridStep);

}

struct UComputer
{
    UComputer(const DigitalSet& shape, double radius,double thickness):
    shape(shape),
    minLevel(shape.domain()),
    DBI(radius,shape),
    thickness(thickness),
    ballArea(DBI.digitalBall().size())
    {
        M=pow(ballArea/2.0,2);
    }

    void compute()
    {
        DigitalSet temp(shape.domain());
        for(auto p: shape.domain())
        {
            temp.clear();
            DBI.operator()(temp,p);
            uMap[p] = pow(ballArea/2.0 - temp.size(),2);

            if(uMap[p]<thickness) minLevel.insert(p);
        }

    }



    const DigitalSet& shape;
    DIPaCUS::Misc::DigitalBallIntersection DBI;
    double ballArea;
    double M;
    double thickness;

    std::map<Point,double> uMap;
    DigitalSet minLevel;
};

void drawLevelSet(const DigitalSet& shape, double radius, double thickness,const std::string& outputFilepath)
{
    UComputer uc(shape,radius,thickness);
    uc.compute();

    typedef DGtal::GradientColorMap<double,DGtal::ColorGradientPreset::CMAP_JET> MyColorMap;

    DGtal::TickedColorMap<double,MyColorMap> hmap(0,uc.M,DGtal::Color::Magenta);
    hmap.addTick(0,thickness);

    DGtal::Board2D board;

    board << DGtal::SetMode(shape.domain().className(),"Paving");
    board << shape.domain();
    board << DGtal::SetMode(shape.begin()->className(),"Paving");


    std::string specificStyle =  shape.begin()->className() + "/Paving";

    DigitalSet contour(shape.domain());
    DIPaCUS::Misc::digitalBoundary<DIPaCUS::Neighborhood::FourNeighborhoodPredicate>(contour,shape);

    for(auto p:shape.domain())
    {
        board << DGtal::CustomStyle( specificStyle,
                                     new DGtal::CustomColors( hmap(uc.uMap[p]),hmap(uc.uMap[p]) ) )
              << p;

    }

    for(auto p:contour)
    {
        board << DGtal::CustomStyle( specificStyle,
                                     new DGtal::CustomColors( DGtal::Color::White,DGtal::Color::White ) )
              << p;
    }

    DigitalSet intersection(contour.domain());
    DIPaCUS::SetOperations::setIntersection(intersection,contour,uc.minLevel);

    for(auto p:intersection)
    {
        board << DGtal::CustomStyle( specificStyle,
                                     new DGtal::CustomColors( DGtal::Color::Magenta,DGtal::Color::Magenta ) )
              << p;
    }


    board.saveEPS(outputFilepath.c_str());

}



int main(int argc, char* argv[])
{
    std::string shapeName=argv[1];
    double h=std::atof(argv[2]);
    double radius=std::atof(argv[3]);
    double thickness=std::atof(argv[4]);

    std::string outputFilepath=argv[5];

    boost::filesystem::path p(outputFilepath);
    boost::filesystem::create_directories(p.remove_filename());

    DigitalSet _shape = resolveShape(shapeName,h);
    DigitalSet shape = DIPaCUS::Transform::bottomLeftBoundingBoxAtOrigin(_shape,Point(2*radius,2*radius));

    drawLevelSet(shape,radius,thickness,outputFilepath);


    return 0;
}