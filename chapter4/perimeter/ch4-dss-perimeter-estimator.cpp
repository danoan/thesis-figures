#include <boost/filesystem.hpp>

#include <DGtal/helpers/StdDefs.h>
#include <DGtal/io/boards/Board2D.h>
#include <DGtal/shapes/parametric/Flower2D.h>
#include <DGtal/geometry/curves/ArithmeticalDSSComputer.h>

#include <DIPaCUS/base/Shapes.h>
#include <DIPaCUS/derivates/Misc.h>

using namespace DGtal::Z2i;

class InnerKToGridCoordinates{
public:
    typedef DGtal::Z2i::Domain Domain;
    typedef DGtal::Z2i::Curve::InnerPointsRange::ConstIterator InnerPointIterator;

public:
    InnerKToGridCoordinates(const Domain& domain)
    {
        kspace.init(domain.lowerBound(),domain.upperBound(),true);

    }

    Point operator()(const InnerPointIterator& it)
    {
        auto scell = kspace.sCell(*it,true);
        return kspace.sCoords(scell);
    }

private:
    KSpace kspace;
};

int main(int argc, char* argv[])
{
    double h=std::atof(argv[1]);
    std::string outputFolder = argv[2];

    boost::filesystem::create_directories(outputFolder);

    DGtal::Flower2D<Space> flower(0,0,10,2,5,1);
    DigitalSet flowerShape = DIPaCUS::Shapes::digitizeShape(flower,h);

    Curve flowerCurve;
    DIPaCUS::Misc::computeBoundaryCurve(flowerCurve,flowerShape);


    auto pointsRange = flowerCurve.getPointsRange();

    typedef Curve::PointsRange::ConstIterator ConstIterator;
    typedef DGtal::StandardDSS4Computer< ConstIterator > DSSComputer;


    DGtal::Board2D board;
    board << DGtal::SetMode( flowerShape.domain().className(), "Grid")
          << flowerShape.domain();

    board << DGtal::SetMode( flowerCurve.className(), "Points")
          << flowerCurve;

    DSSComputer theDSSComputer;


    auto currIt= pointsRange.begin();
    int i=0;
    do
    {
        theDSSComputer.init( currIt );
        while( (theDSSComputer.end() != pointsRange.end() ) &&
               ( theDSSComputer.extendFront() )  ) {}

        // Draw the bounding box
        auto _it = theDSSComputer.primitive();

        if( _it.isValid() )
        {
            std::cout << "Valid\n";

            board << DGtal::SetMode(_it.className(), "BoundingBox")
                  << _it;
        }


        currIt = theDSSComputer.end();
        currIt--;
        theDSSComputer.init( currIt );

        i++;
        if(i==100)
            break;

    }while(theDSSComputer.end() != pointsRange.end());
    std::cout << i << std::endl;
    board.saveEPS( (outputFolder + "/dss-estimator.eps").c_str() );


    return 0;
}