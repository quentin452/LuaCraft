#pragma once
#include <GLFW/glfw3.h>
#include <SDL.h>

class GameState {
public:
  virtual void handleInput(SDL_Window *window) = 0;
  virtual void update() = 0;
  virtual void draw(SDL_Window *window) = 0;
  virtual ~GameState() {}
  virtual void cleanup() {}
  virtual void framebufferSizeCallbackGameState(SDL_Window *window, int width,
                                                int height) {}
  virtual void calculateButtonPositionsAndSizes(SDL_Window *window) {}
};
