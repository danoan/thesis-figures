#include <DGtal/helpers/StdDefs.h>
#include <DGtal/geometry/volumes/distance/DistanceTransformation.h>
#include <DGtal/io/boards/Board2D.h>
#include <DGtal/io/readers/GenericReader.h>
#include <DGtal/io/colormaps/GradientColorMap.h>
#include <DGtal/io/colormaps/HueShadeColorMap.h>
#include <DGtal/base/Common.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/base/Representation.h>

#include <DIPaCUS/components/SetOperations.h>

#include <DIPaCUS/derivates/Misc.h>
#include <random>
#include <boost/filesystem/operations.hpp>

using namespace DGtal::Z2i;

typedef DGtal::DistanceTransformation<DGtal::Z2i::Space, DigitalSet, DGtal::Z2i::L2Metric> DTL2;
typedef DIPaCUS::Representation::Image2D Image2D;

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

DigitalSet resolveShape(const std::string& shapeName,double gridStep)
{
    DigitalSet _shape = resolveShape(Shape(ShapeType::Flower),gridStep);
    return DIPaCUS::Transform::bottomLeftBoundingBoxAtOrigin(_shape);
}

DTL2 interiorDistanceTransform(const Domain& domain, const DigitalSet& original)
{
    return DTL2(domain, original, DGtal::Z2i::l2Metric);
}

DTL2 exteriorDistanceTransform(const Domain& domain, const DigitalSet& original)
{
    DigitalSet d(domain);
    d.assignFromComplement(original);

    return DTL2(domain, d, DGtal::Z2i::l2Metric);
}

DigitalSet level(const DTL2& dtL2, int lessThan, int greaterThan)
{
    DigitalSet d(dtL2.domain());
    for(auto it=dtL2.domain().begin();it!=dtL2.domain().end();++it)
    {
        if(dtL2(*it)<=lessThan && dtL2(*it)>greaterThan) d.insert(*it);
    }

    return d;
}


struct LevelsDS
{
    LevelsDS(const DigitalSet& baseDS,const DigitalSet& innDS, const DigitalSet& outDS):baseDS(baseDS),innDS(innDS),outDS(outDS){}

    DigitalSet baseDS;
    DigitalSet innDS;
    DigitalSet outDS;
};

void drawDTs(DGtal::Board2D& board, const LevelsDS& levels, const std::string& outputFilepath)
{
    const DigitalSet& ds = levels.baseDS;
    board << DGtal::SetMode(ds.className(),"Paving");
    board /*<< DGtal::CustomStyle( ds.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::Silver, DGtal::Color::Blue))
          << ds*/
            << DGtal::CustomStyle( ds.className() + "/Paving",new DGtal::CustomColors(DGtal::Color::None, DGtal::Color::Navy))
            << levels.innDS << levels.outDS;

    board.saveEPS(outputFilepath.c_str());
}

LevelsDS getLevels(double LEVEL, const DigitalSet& base)
{
    DigitalSet ds = base;

    DTL2 innDT = interiorDistanceTransform(base.domain(),ds);
    DTL2 outDT = exteriorDistanceTransform(base.domain(),ds);

    DigitalSet innLevel = level(innDT,LEVEL,LEVEL-1);
    DigitalSet outLevel = level(outDT,LEVEL,LEVEL-1);

    return LevelsDS(ds,innLevel,outLevel);
}

//typedef DGtal::HueShadeColorMap<DTL2::Value, 2> HueTwice;
typedef DGtal::GradientColorMap<DTL2::Value, 8> ColorMap;

struct Wrapper
{
    typedef double Value;
    typedef DGtal::Z2i::Domain Domain;

    Wrapper(const DigitalSet& ds, const DTL2& outDT, const DTL2& innDT):ds(ds),
                                                                        outDT(outDT),
                                                                        innDT(innDT){}

    double operator()(const Point& p) const
    {
        if(ds(p)) return -innDT(p);
        else return outDT(p);
    }

    const Domain& domain() const{ return ds.domain(); }

    const DigitalSet& ds;
    const DTL2& outDT;
    const DTL2& innDT;
};

int main(int argc, char* argv[])
{
    double LEVEL = std::atof(argv[1]);
    double h = std::atof(argv[2]);
    std::string outputFolder = argv[3];
    std::string shape = argv[4];

    boost::filesystem::create_directories(outputFolder);

    DigitalSet ds = resolveShape(shape,h);
    const Domain& domain = ds.domain();

    DTL2 innDT = interiorDistanceTransform(domain,ds);
    DTL2 outDT = exteriorDistanceTransform(domain,ds);


    DGtal::Board2D board;
    Wrapper W(ds,outDT,innDT);

    double min=0;
    double max=0;
    for(auto p:domain)if(min>W(p)) min = W(p);
    for(auto p:domain)if(max<W(p)) max = W(p);

    LevelsDS LDS = getLevels(LEVEL,ds);

//    DGtal::Display2DFactory::drawImage<ColorMap>(board, W, min, max);
//    drawDTs(board,L1,(outputFolder + "/L1.eps").c_str());
//    board.clear();

    board << DGtal::SetMode(ds.className(),"Grid") << ds;
    drawDTs(board,LDS,(outputFolder + "/L4-nodt.eps").c_str());
    board.clear();


    return 0;
}