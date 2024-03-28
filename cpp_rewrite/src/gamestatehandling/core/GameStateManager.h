#pragma once
#include "GameState.h"
#include <iostream>
#include <memory>

class GameStateManager {
private:
  double lastStateChangeTime = 0.0;

public:
  void set(std::unique_ptr<GameState> state) {
    if (currentState) {
      currentState->cleanup();
    }
    currentState = std::move(state);
    lastStateChangeTime =
        glfwGetTime();
  }

  GameState &get() { return *currentState; }
  std::unique_ptr<GameState> currentState;
  double getLastStateChangeTime() const { return lastStateChangeTime; }
};