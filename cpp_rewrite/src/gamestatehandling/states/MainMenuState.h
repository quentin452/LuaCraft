#pragma once
#include "../core/GameStateManager.h"
#include <GLFW/glfw3.h>
#include <glew.h>

#define GLT_IMPLEMENTATION
#include "MainMenuState.h"
#include "SettingsState.h"
#include "gameplaying/VulkanGameState.h"
#include <gltext.h>
#include <iostream>
#include <vector>

class MainMenuState : public GameState {
public:
  MainMenuState(GLFWwindow *window, GameStateManager &manager);
  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;
  void calculateButtonPositionsAndSizes(GLFWwindow *window) override;
  void framebufferSizeCallbackGameState(GLFWwindow *window, int width,
                                        int height) override;
  void cleanup() override {
    gltDeleteText(titlescreen), gltDeleteText(text1), gltDeleteText(text2);
  }
  void initializeGLText();
  static void framebufferSizeCallbackWrapper(GLFWwindow *window, int width,
                                             int height);
  bool handleMouseInput(GLFWwindow *window, double xpos, double ypos,
                        int button, bool &mouseButtonPressed) const;
  GLTtext *CreateTextUsingGLText(const char *text, float buttonScale,
                                 float &textWidth, float &textHeight);

private:
  GLfloat textPosX1;
  GLfloat textPosY1;
  GLfloat textPosX2;
  GLfloat textPosY2;
  GLfloat textWidth1;
  GLfloat textHeight1;
  GLfloat textWidth2;
  GLfloat textHeight2;
  GLfloat textHeightForTitle;
  GLfloat textWidthForTitle;
  GLfloat textPosXForTitle;
  GLfloat textPosYForTitle;
  GLTtext *text1 = nullptr;
  GLTtext *text2 = nullptr;
  GLTtext *titlescreen = nullptr;
  GLFWwindow *m_window;
  GameStateManager &m_manager;
  GLTtext *glText = nullptr;
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
  int screenWidth;
  int screenHeight;
  double textInteractionWidth1;
  double textInteractionHeight1;
  double textInteractionWidth2;
  double textInteractionHeight2;
  double xpos;
  double ypos;
};