#pragma once
#include "GameState.h"
#include <iostream>
#include <memory>


class GameStateManager {
public:
  void set(std::unique_ptr<GameState> state) {
    if (currentState) {
      currentState->cleanup();
    }
    // Définir le nouvel état
    currentState = std::move(state);
  }

  GameState &get() { return *currentState; }

private:
  std::unique_ptr<GameState> currentState;
};