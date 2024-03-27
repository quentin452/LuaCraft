#pragma once
#include "../core/GameStateManager.h"

#include <glew.h>

#include <GLFW/glfw3.h>
#include <ft2build.h>
#define GLT_IMPLEMENTATION

#include <gltext.h>
#include <iostream>
#include <vector>
#include FT_FREETYPE_H
#define GL_CLAMP_TO_EDGE 0x812F
#include "MainMenuState.h"
#include "SettingsState.h"
#include "VulkanGameState.h"

class MainMenuState : public GameState {
public:
  MainMenuState(FT_Face face, GLFWwindow *window, GameStateManager &manager);

  bool isInsideForMainMenu(double x, double y, double rectX, double rectY,
                           double rectWidth, double rectHeight);
  void drawTextMainMenu(FT_Face face, const std::string &text, float x, float y,
                        int fontSize);

  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;

  void cleanup() override { gltDeleteText(glText); }
  void initializeGLText();

private:
  FT_Face font;

  GLTtext *text1 = nullptr;
  FT_Face fontFace;
  GLFWwindow *m_window;
  GameStateManager &m_manager;
  GLTtext *glText = nullptr;
  std::string titleText;
  std::string option1Text;
  std::string option2Text;

  float titlePositionX;
  float titlePositionY;
  float option1PositionX;
  float option1PositionY;
  float option2PositionX;
  float option2PositionY;

  float optionWidth;
  float optionHeight;

  int titleFontSize;
  int optionFontSize;

  bool mouseButtonPressed = false;

  // Déclaration de vos autres variables membres
};