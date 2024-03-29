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
  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;
  void initializeGLText();
  void calculateButtonPositionsAndSizes(GLFWwindow *window) override;
  void framebufferSizeCallbackGameState(GLFWwindow *window, int width,
                                        int height) override;
  void cleanup() override {
    gltDeleteText(titleText), gltDeleteText(option1Text);
  }
  static void framebufferSizeCallbackWrapper(GLFWwindow *window, int width,
                                             int height);

private:
  GLfloat textPosX1;
  GLfloat textPosY1;
  GLfloat textPosX2;
  GLfloat textPosY2;
  GLfloat textWidth1;
  GLfloat textHeight1;
  GLfloat textWidth2;
  GLfloat textHeight2;
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
  double xpos;
  double ypos;
  float optionWidth;
  float optionHeight;
  bool mouseButtonPressed = false;
  int screenWidth;
  int screenHeight;
};