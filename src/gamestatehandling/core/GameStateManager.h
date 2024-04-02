#pragma once
#include <GL/glew.h>

#include <GLFW/glfw3.h>

#include "GameStateBase.h"
#include <iostream>
#include <memory>

class GameStateManager {
private:
  static std::unique_ptr<GameState> currentState;
  double lastStateChangeTime = 0.0;

public:
  void SetGameState(std::unique_ptr<GameState> state, SDL_Window *window);
  GameState &GetGameState();

  double getLastStateChangeTime() const;
};