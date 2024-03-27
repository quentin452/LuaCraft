#pragma once
#include <glew.h>
#include "../core/GameStateManager.h"
#include <string>
class SettingsState : public GameState {
public:
  SettingsState(GLFWwindow *window, GameStateManager &manager);

  bool isInsideForSettings(double x, double y, double rectX, double rectY,
                           double rectWidth, double rectHeight);

  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;

private:
  GLFWwindow *m_window;
  GameStateManager &m_manager;

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