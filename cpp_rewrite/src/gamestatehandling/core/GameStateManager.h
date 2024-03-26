#pragma once
#include "src/gamestatehandling/core/GameState.h"
#include <memory>

class GameStateManager {
public:
  void set(std::unique_ptr<GameState> state) {
    currentState = std::move(state);
  }
  GameState &get() { return *currentState; }

private:
  std::unique_ptr<GameState> currentState;
};
