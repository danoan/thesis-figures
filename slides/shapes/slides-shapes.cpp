#include <boost/filesystem.hpp>

#include <DGtal/helpers/StdDefs.h>

#include <DIPaCUS/base/Shapes.h>
#include <DGtal/io/boards/Board2D.h>

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

int main(int argc, char* argv[]){
  std::string shapeName = argv[1];
  double h = std::atof(argv[2]);
  std::string outputFilepath = argv[3];

  boost::filesystem::path p(outputFilepath);
  boost::filesystem::create_directories(p.remove_filename());

  DigitalSet shape = resolveShape(shapeName,20,h);
  DGtal::Board2D board;
  board << DGtal::SetMode(shape.className(),"Paving");
  board << DGtal::CustomStyle(shape.className() + "/Paving", new DGtal::CustomColors(DGtal::Color::Gray, DGtal::Color::Gray));
  board << shape;

  board.saveEPS(outputFilepath.c_str());

  return 0;
}