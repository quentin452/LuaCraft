#pragma once
#include "../../core/GameStateManager.h"
#include <string>
class VulkanGameState : public GameState {
public:
  VulkanGameState(SDL_Window *window, GameStateManager &manager);

  void handleInput(SDL_Window *window) override;
  void update() override;
  void draw(SDL_Window *window) override;

private:
  SDL_Window *m_window;
  GameStateManager &manager;
};