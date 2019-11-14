#include <iostream>
#include <utility>

#include <opencv2/highgui.hpp>
#include <boost/filesystem.hpp>

#include <DIPaCUS/base/Representation.h>
#include <DIPaCUS/derivates/Misc.h>

#include <gcurve/utils/displayUtils.h>

using namespace DGtal::Z2i;

typedef DGtal::Circulator<Curve::ConstIterator> CurveCirculator;
typedef std::pair<CurveCirculator,CurveCirculator> CirculatorPair;

DigitalSet toDigitalSet(const cv::Mat& img)
{
    Domain domain( Point(0,0), Point(img.cols-1,img.rows-1) );
    DigitalSet ds(domain);
    DIPaCUS::Representation::CVMatToDigitalSet(ds,img);
    return ds;
}

void alignIterators(CurveCirculator& it1, CurveCirculator& it2)
{
    while(it1->preCell().coordinates!=it2->preCell().coordinates) ++it2;
}

CirculatorPair findForkPoint(CurveCirculator it1, CurveCirculator it2, bool posOrientation)
{
    while(it1->preCell().coordinates==it2->preCell().coordinates)
    {
        if(posOrientation)
        {
            ++it1;
            ++it2;
        }else
        {
            --it1;
            --it2;
        }
    }

    return CirculatorPair(it1,it2);
}


int main(int argc, char* argv[])
{
    if(argc<2)
    {
        std::cout << "Usage: ImageFolderPath OutputFolder" << std::endl;
        exit(1);
    }
    std::string imageFolderPath = argv[1];
    std::string outputFolder = argv[2];

    boost::filesystem::create_directories(outputFolder);

    cv::Mat img1 = cv::imread(imageFolderPath + "/chapter5/mdca-sensitivity/0017-a.pgm",cv::IMREAD_GRAYSCALE);
    cv::Mat img2 = cv::imread(imageFolderPath + "/chapter5/mdca-sensitivity/0017.pgm",cv::IMREAD_GRAYSCALE);

    DigitalSet ds1 = toDigitalSet(img1);
    DigitalSet ds2 = toDigitalSet(img2);

    std::cout << "DS size: " << ds1.size() << std::endl;


    Curve c1,c2;
    DIPaCUS::Misc::computeBoundaryCurve(c1,ds1);
    DIPaCUS::Misc::computeBoundaryCurve(c2,ds2);


    CurveCirculator it1(c1.begin(),c1.begin(),c1.end() );
    CurveCirculator it2(c2.begin(),c2.begin(),c2.end() );

    alignIterators(it1,it2);
    auto leftFork = findForkPoint(it1,it2,true);
    auto rightFork = findForkPoint(it1,it2,false);

    DGtal::Board2D board;

    auto t1 = leftFork.first;
    auto t2 = rightFork.first;
    for(int i=0;i<15;++i) --t1;
    for(int i=0;i<15;++i) ++t2;

    ++rightFork.second;
    ++rightFork.first;


    GCurve::Utils::drawCurve(board,DGtal::Color::Black,DGtal::Color::Black,it1,it1);
    GCurve::Utils::drawCurve(board,DGtal::Color::Red,DGtal::Color::Red,leftFork.first,rightFork.first);
    GCurve::Utils::drawCurve(board,DGtal::Color::Blue,DGtal::Color::Blue,leftFork.second,rightFork.second);
    board.saveEPS( (outputFolder + "/big-picture.eps").c_str() );
    board.clear();

    GCurve::Utils::drawCurve(board,DGtal::Color::Black,DGtal::Color::Black,t1,t2);
    GCurve::Utils::drawCurve(board,DGtal::Color::Red,DGtal::Color::Red,leftFork.first,rightFork.first);
    GCurve::Utils::drawCurve(board,DGtal::Color::Blue,DGtal::Color::Blue,leftFork.second,rightFork.second);
    board.saveEPS( (outputFolder +"/closer-picture.eps").c_str());
    board.clear();

    return 0;
}