#include <GL/glew.h>

#include <GLFW/glfw3.h>
#include <SDL.h>

#define GLT_IMPLEMENTATION
#include "../../LuaCraftGlobals.h"
#include "../../utils/luacraft_logger.h"
#include "../core/GameStatesUtils.h"
#include "MainMenuState.h"
#include "SettingsState.h"
#include "gameplaying/OpenGLGameState.h"
#include "gameplaying/VulkanGameState.h"
#include <gltext.h>
#include <iostream>
#include <vector>

MainMenuState::MainMenuState(SDL_Window *window, GameStateManager &manager)
    : m_window(window), m_manager(manager) {
  initializeGLText();
  SDL_SetWindowData(window, "userPointer", this);
}

void MainMenuState::initializeGLText() {
  gltInit();
  titlescreen = CreateTextUsingGLText("Main Menu", buttonScale,
                                      textWidthForTitle, textHeightForTitle);
  text1 =
      CreateTextUsingGLText("Option 1", buttonScale, textWidth1, textHeight1);
  text2 =
      CreateTextUsingGLText("Play Game!", buttonScale, textWidth2, textHeight2);
}

GLTtext *MainMenuState::CreateTextUsingGLText(const char *text,
                                              float buttonScale,
                                              float &textWidth,
                                              float &textHeight) {
  GLTtext *newText = gltCreateText();
  gltSetText(newText, text);
  textWidth = gltGetTextWidth(newText, buttonScale);
  textHeight = gltGetTextHeight(newText, buttonScale);
  return newText;
}

void MainMenuState::framebufferSizeCallbackGameState(SDL_Window *window,
                                                     int width, int height) {
  calculateButtonPositionsAndSizes(window);
}
void MainMenuState::calculateButtonPositionsAndSizes(SDL_Window *window) {
  textPosX1 = (float(LuaCraftGlobals::WindowWidth) - textWidth1) / 2.0f;
  textPosY1 = (float(LuaCraftGlobals::WindowHeight) - textHeight1) / 2.0f;
  textPosX2 = (float(LuaCraftGlobals::WindowWidth) - textWidth2) / 2.0f;
  textPosY2 = textPosY1 - textHeight2 - 10.0f;
  textPosXForTitle =
      (float(LuaCraftGlobals::WindowWidth) - textWidthForTitle) / 2.0f;
  textPosYForTitle =
      (float(LuaCraftGlobals::WindowHeight) - textHeightForTitle) / 4.0f;
}

void MainMenuState::handleInput(SDL_Window *window) {
  int xpos, ypos;
  SDL_GetMouseState(&xpos, &ypos);
  bool mouseClicked = handleMouseInput(window, xpos, ypos, SDL_BUTTON_LEFT);
  if (mouseClicked) {
    auto windowX = static_cast<int>(xpos);
    auto windowY = static_cast<int>(ypos);
    if (LuaCraftGlobals::GameStateUtilsInstance.isMouseInsideButton(
            windowX, windowY, textPosX1, textPosY1, textWidth1, textHeight1)) {
      m_manager.SetGameState(std::make_unique<SettingsState>(window, m_manager),
                             window);
      LuaCraftGlobals::LoggerInstance.logMessageAsync(LogLevel::INFO,
                                                      "Go To SettingsState...");
    } else if (LuaCraftGlobals::GameStateUtilsInstance.isMouseInsideButton(
                   windowX, windowY, textPosX2, textPosY2, textWidth2,
                   textHeight2)) {
      m_manager.SetGameState(
          std::make_unique<OpenGLGameState>(window, m_manager), window);
      LuaCraftGlobals::LoggerInstance.logMessageAsync(
          LogLevel::INFO, "Go To 3D Scene Using OpenGL...");
    }
  }
}

bool MainMenuState::handleMouseInput(SDL_Window *window, double xpos,
                                     double ypos, int button) const {
  int x, y;
  Uint32 mouseState = SDL_GetMouseState(&x, &y);
  if (mouseState & SDL_BUTTON(button)) {
    return true;
  }
  return false;
}
void MainMenuState::update() {}

void MainMenuState::draw(SDL_Window *window) {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  gltBeginDraw();
  gltColor(1.0f, 1.0f, 1.0f, 1.0f);
  gltDrawText2D(titlescreen, textPosXForTitle, textPosYForTitle, buttonScale);
  gltDrawText2D(text1, textPosX1, textPosY1, buttonScale);
  gltDrawText2D(text2, textPosX2, textPosY2, buttonScale);
  gltEndDraw();
}