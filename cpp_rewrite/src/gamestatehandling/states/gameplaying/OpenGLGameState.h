#pragma once
#include "../../core/GameStateManager.h"
#include <string>
class OpenGLGameState : public GameState {
public:
  OpenGLGameState(GLFWwindow *window, GameStateManager &manager);

  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;

private:
  GLFWwindow *m_window;
  GameStateManager &manager;
};