#pragma once
#include "../core/GameStateManager.h"

#include <glew.h>

#include <GLFW/glfw3.h>
#define GLT_IMPLEMENTATION

#include "MainMenuState.h"
#include "SettingsState.h"
#include "VulkanGameState.h"
#include <gltext.h>
#include <iostream>
#include <vector>

class MainMenuState : public GameState {
public:
  MainMenuState(GLFWwindow *window, GameStateManager &manager);

  bool isInsideForMainMenu(double x, double y, double rectX, double rectY,
                           double rectWidth, double rectHeight);

  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;

  void cleanup() override { gltDeleteText(glText); }
  void initializeGLText();

private:
  GLTtext *text1 = nullptr;
  GLTtext *text2 = nullptr;

  GLFWwindow *m_window;
  GameStateManager &m_manager;
  GLTtext *glText = nullptr;
  std::string titleText;
  std::string option1Text;
  std::string option2Text;
  float buttonScale = 1.0f;

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