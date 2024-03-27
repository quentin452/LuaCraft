#pragma once
#include "../core/GameStateManager.h"
#include <ft2build.h>
#include FT_FREETYPE_H
#include <string>
class SettingsState : public GameState {
public:
  SettingsState(FT_Face face, GLFWwindow *window, GameStateManager &manager);

  bool isInsideForSettings(double x, double y, double rectX, double rectY,
                           double rectWidth, double rectHeight);
  void drawTextSettings(FT_Face face, const std::string &text, float x, float y,
                        int fontSize);

  void handleInput(GLFWwindow *window) override;
  void update() override;
  void draw(GLFWwindow *window) override;

private:
  FT_Face font;
  FT_Face fontFace;
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

  // Déclaration de vos autres variables membres
};