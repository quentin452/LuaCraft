#pragma once
#include <GLFW/glfw3.h>

class GameState {
public:
  virtual void handleInput(GLFWwindow *window) = 0;
  virtual void update() = 0;
  virtual void draw(GLFWwindow *window) = 0;
  virtual ~GameState() {}
  virtual void cleanup() {}
  virtual void framebufferSizeCallbackGameState(GLFWwindow *window, int width,
                                                int height) {}
  virtual void calculateButtonPositionsAndSizes(GLFWwindow *window) {}
};
