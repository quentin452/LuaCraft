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

class SettingsState : public GameState {
public:
  SettingsState(GLFWwindow *window, GameStateManager &manager);

  bool isInsideForSettings(double x, double y, double rectX, double rectY,
                           double rectWidth, double rectHeight);

  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;
  void initializeGLText();

private:
  GLfloat textPosX1, textPosY1, textPosX2, textPosY2, textWidth1, textHeight1;
  GLTtext *titleText = nullptr;
  GLTtext *option1Text = nullptr;
  GLFWwindow *m_window;

  GameStateManager &m_manager;
  float buttonScale = 1.0f;
  float titlePositionX;
  float titlePositionY;
  float option1PositionX;
  float option1PositionY;
  float option2PositionX;
  float option2PositionY;

  float optionWidth;
  float optionHeight;
  bool mouseButtonPressed = false;

  // Déclaration de vos autres variables membres
};