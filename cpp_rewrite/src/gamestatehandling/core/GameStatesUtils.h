#pragma once
#include <glew.h>
#define GLT_IMPLEMENTATION
#include <gltext.h>
class GameStatesUtils {
public:
  bool isMouseInsideButton(double x, double y, double rectX, double rectY,
                           double rectWidth, double rectHeight) const;
};
