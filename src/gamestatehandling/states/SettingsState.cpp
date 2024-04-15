
#include "../../LuaCraftGlobals.h"
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <SDL.h>

#define GLT_IMPLEMENTATION

#include <gltext.h>
#include <iostream>
#include <vector>

#include "../core/GameStatesUtils.h"
#include "MainMenuState.h"
#include "SettingsState.h"
#include "gameplaying/VulkanGameState.h"
#include <ThreadedLoggerForCPP/LoggerGlobals.hpp>

SettingsState::SettingsState(SDL_Window *window, GameStateManager &manager)
    : m_window(window), m_manager(manager) {
  initializeGLText();
  SDL_SetWindowData(window, "userPointer", this);
}

void SettingsState::initializeGLText() {
  gltInit();
  titleText = gltCreateText();
  gltSetText(titleText, "Paramètres");
  option1Text = gltCreateText();
  gltSetText(option1Text, "Go To Main Menu");

  textWidth1 = gltGetTextWidth(titleText, buttonScale);
  textHeight1 = gltGetTextHeight(titleText, buttonScale);

  textWidth2 = gltGetTextWidth(option1Text, buttonScale);
  textHeight2 = gltGetTextHeight(option1Text, buttonScale);
}

void SettingsState::framebufferSizeCallbackGameState(SDL_Window *window,
                                                     int width, int height) {
  calculateButtonPositionsAndSizes(window);
}

void SettingsState::calculateButtonPositionsAndSizes(SDL_Window *window) {
  titlePositionX = (float(LuaCraftGlobals::WindowWidth) - textWidth1) / 2.0f;
  titlePositionY = (float(LuaCraftGlobals::WindowHeight) - textHeight1) / 4.0f;

  option1PositionX = (float(LuaCraftGlobals::WindowWidth) - textWidth2) / 2.0f;
  option1PositionY =
      (float(LuaCraftGlobals::WindowHeight) - textHeight2) / 2.0f + 50.0f;
}
void SettingsState::handleInput(SDL_Window *window) {
  int xpos, ypos;
  SDL_GetMouseState(&xpos, &ypos);
  const Uint32 mouseState = SDL_GetMouseState(nullptr, nullptr);
  if (mouseState & SDL_BUTTON(SDL_BUTTON_LEFT)) {
    double normalizedX = 2.0 * xpos / LuaCraftGlobals::WindowWidth - 1.0;
    double normalizedY = 1.0 - 2.0 * ypos / LuaCraftGlobals::WindowHeight;
    auto windowX =
        (int)((normalizedX + 1.0) * LuaCraftGlobals::WindowWidth / 2.0);
    auto windowY =
        (int)((1.0 - normalizedY) * LuaCraftGlobals::WindowHeight / 2.0);
    if (LuaCraftGlobals::GameStateUtilsInstance.isMouseInsideButton(
            windowX, windowY, option1PositionX, option1PositionY, textWidth1,
            textHeight1)) {
      LuaCraftGlobals::LoggerInstance.logMessageAsync(LogLevel::INFO,
                                                      "Go To MainMenuState...");
      m_manager.SetGameState(std::make_unique<MainMenuState>(window, m_manager),
                             window);
    }
  }
}
void SettingsState::update() {}

void SettingsState::draw(SDL_Window *window) {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  gltBeginDraw();
  gltColor(1.0f, 1.0f, 1.0f, 1.0f);

  gltDrawText2D(titleText, titlePositionX, titlePositionY, buttonScale);
  gltDrawText2D(option1Text, option1PositionX, option1PositionY, buttonScale);

  gltEndDraw();
}