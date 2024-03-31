#include "GameStatesUtils.h"
#include <GL/glew.h>
#define GLT_IMPLEMENTATION
#include <gltext.h>
bool GameStatesUtils::isMouseInsideButton(double x, double y, double rectX,
                                          double rectY, double rectWidth,
                                          double rectHeight) const {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}
