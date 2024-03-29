#include <glew.h>

#include <GLFW/glfw3.h>

#define GLT_IMPLEMENTATION
#include <gltext.h>
#include <iostream>
#include <vector>

#include "../../LuaCraftGlobals.h"
#include "../../utils/luacraft_logger.h"
#include "MainMenuState.h"
#include "SettingsState.h"
#include "VulkanGameState.h"

void MainMenuState::initializeGLText() {
  gltInit();
  titlescreen = gltCreateText();
  gltSetText(titlescreen, "Main Menu");
  text1 = gltCreateText();
  gltSetText(text1, "Option 1");
  text2 = gltCreateText();
  gltSetText(text2, "Play Game!");

  textWidth1 = gltGetTextWidth(text1, buttonScale);
  textHeight1 = gltGetTextHeight(text1, buttonScale);
  textWidth2 = gltGetTextWidth(text2, buttonScale);
  textHeight2 = gltGetTextHeight(text2, buttonScale);
  textWidthForTitle = gltGetTextWidth(titlescreen, buttonScale);
  textHeightForTitle = gltGetTextHeight(titlescreen, buttonScale);
}
void MainMenuState::framebufferSizeCallbackGameState(GLFWwindow *window,
                                                     int width, int height) {
  calculateButtonPositionsAndSizes(window);
}

void MainMenuState::framebufferSizeCallbackWrapper(GLFWwindow *window,
                                                   int width, int height) {
  MainMenuState *state =
      reinterpret_cast<MainMenuState *>(glfwGetWindowUserPointer(window));
  if (state != nullptr) {
    state->framebufferSizeCallbackGameState(window, width, height);
  }
}

void MainMenuState::calculateButtonPositionsAndSizes(GLFWwindow *window) {
  glfwGetFramebufferSize(window, &LuaCraftGlobals::WindowWidth,
                         &LuaCraftGlobals::WindowHeight);
  textPosX1 = (LuaCraftGlobals::WindowWidth - textWidth1) / 2;
  textPosY1 = (LuaCraftGlobals::WindowHeight - textHeight1) / 2;
  textPosX2 = (LuaCraftGlobals::WindowWidth - textWidth2) / 2;
  textPosY2 = textPosY1 - textHeight2 - 10.0f;
  textPosXForTitle = (LuaCraftGlobals::WindowWidth - textWidthForTitle) / 2;
  textPosYForTitle = (LuaCraftGlobals::WindowHeight - textHeightForTitle) / 4;
}

MainMenuState::MainMenuState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), m_manager(manager) {
  initializeGLText();
  glfwGetFramebufferSize(window, &LuaCraftGlobals::WindowWidth,
                         &LuaCraftGlobals::WindowHeight);
  calculateButtonPositionsAndSizes(window);
  glfwSetWindowUserPointer(window, this);
  glfwSetFramebufferSizeCallback(
      window, &MainMenuState::framebufferSizeCallbackWrapper);
}

void MainMenuState::handleInput(GLFWwindow *window) {
  double xpos, ypos;
  //  LuaCraftGlobals::LoggerInstance.logMessageAsync(LogLevel::INFO,
  //  "textHeight1: "+ textHeight1);

  glfwGetCursorPos(window, &xpos, &ypos);
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
    mouseButtonPressed = true;
    auto windowX = static_cast<int>(xpos);
    auto windowY = static_cast<int>(ypos);
    if (isInsideForMainMenu(windowX, windowY, textPosX1, textPosY1, textWidth1,
                            textHeight1)) {
      m_manager.set(std::make_unique<SettingsState>(window, m_manager));
      LuaCraftGlobals::LoggerInstance.logMessageAsync(LogLevel::INFO,
                                                      "Go To SettingsState...");
    } else if (isInsideForMainMenu(windowX, windowY, textPosX2, textPosY2,
                                   textWidth2, textHeight2)) {
      m_manager.set(std::make_unique<VulkanGameState>(window, m_manager));
      LuaCraftGlobals::LoggerInstance.logMessageAsync(
          LogLevel::INFO, "Go To 3D Scene USing Vulkan...");
    }
  } else if (mouseState == GLFW_RELEASE) {
    mouseButtonPressed = false;
  }
}

void MainMenuState::update() {}

void MainMenuState::draw(GLFWwindow *window) {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);
  gltBeginDraw();
  gltColor(1.0f, 1.0f, 1.0f, 1.0f);
  gltDrawText2D(titlescreen, textPosXForTitle, textPosYForTitle, buttonScale);
  gltDrawText2D(text1, textPosX1, textPosY1, buttonScale);
  gltDrawText2D(text2, textPosX2, textPosY2, buttonScale);
  gltEndDraw();
  glfwSwapBuffers(window);
}

bool MainMenuState::isInsideForMainMenu(double x, double y, double rectX,
                                        double rectY, double rectWidth,
                                        double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}
