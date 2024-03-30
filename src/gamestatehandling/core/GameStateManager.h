#pragma once
#include <GL/glew.h>

#include <GLFW/glfw3.h>

#include "GameState.h"
#include <iostream>
#include <memory>

class GameStateManager {
private:
  static std::unique_ptr<GameState> currentState;
  double lastStateChangeTime = 0.0;

public:
  void SetGameState(std::unique_ptr<GameState> state, GLFWwindow *window);
  GameState &GetGameState();

  double getLastStateChangeTime() const;
};