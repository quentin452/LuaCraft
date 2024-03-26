#pragma once
#include "src/gamestatehandling/core/GameStateManager.h"
#include <ft2build.h>
#include <string>
#include FT_FREETYPE_H
class VulkanGameState : public GameState {
public:
  VulkanGameState(FT_Face face,GLFWwindow *window, GameStateManager &manager);

  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;

private:
  FT_Face font;
    FT_Face fontFace;
  GLFWwindow *m_window;
  GameStateManager &manager;
  // Autres attributs et méthodes spécifiques à VulkanGameState
};