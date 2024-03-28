
#include <glew.h>

#include <GLFW/glfw3.h>
#define GLT_IMPLEMENTATION

#include <gltext.h>
#include <iostream>
#include <vector>

#include "MainMenuState.h"
#include "SettingsState.h"
#include "VulkanGameState.h"

void SettingsState::initializeGLText() {
  gltInit();
  titleText = gltCreateText();
  gltSetText(titleText, "Paramètres");
  option1Text = gltCreateText();
  gltSetText(option1Text, "Go To Main Menu");
}

void SettingsState::framebufferSizeCallbackGameState(GLFWwindow *window,
                                                     int width, int height) {
  // Recalculate button positions and sizes
  calculateButtonPositionsAndSizes(window);
}

void SettingsState::framebufferSizeCallbackWrapper(GLFWwindow *window,
                                                   int width, int height) {
  SettingsState *state =
      reinterpret_cast<SettingsState *>(glfwGetWindowUserPointer(window));
  if (state != nullptr) {
    state->framebufferSizeCallbackGameState(window, width, height);
  }
}

void SettingsState::calculateButtonPositionsAndSizes(GLFWwindow *window) {

  int screenWidth, screenHeight;
  glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

  textWidth1 = gltGetTextWidth(titleText, buttonScale);
  textHeight1 = gltGetTextHeight(titleText, buttonScale);
  titlePositionX = (screenWidth - textWidth1) / 2;
  titlePositionY = (screenHeight - textHeight1) / 4;

  GLfloat textWidth2 = gltGetTextWidth(option1Text, buttonScale);
  GLfloat textHeight2 = gltGetTextHeight(option1Text, buttonScale);
  option1PositionX = (screenWidth - textWidth2) / 2;
  option1PositionY = (screenHeight - textHeight2) / 2 + 50.0f;
}

SettingsState::SettingsState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), m_manager(manager) {
  initializeGLText();
  glfwGetFramebufferSize(window, &screenWidth, &screenHeight);
  calculateButtonPositionsAndSizes(window);
  glfwSetWindowUserPointer(window, this);
  glfwSetFramebufferSizeCallback(
      window, &SettingsState::framebufferSizeCallbackWrapper);
}
void SettingsState::handleInput(GLFWwindow *window) {
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
    mouseButtonPressed = true;
    int screenWidth, screenHeight;
    glfwGetFramebufferSize(window, &screenWidth, &screenHeight);
    double normalizedX = 2.0 * xpos / screenWidth - 1.0;
    double normalizedY = 1.0 - 2.0 * ypos / screenHeight;
    int windowX = (int)((normalizedX + 1.0) * screenWidth / 2.0);
    int windowY = (int)((1.0 - normalizedY) * screenHeight / 2.0);
    if (isInsideForSettings(windowX, windowY, option1PositionX,
                            option1PositionY, textWidth1, textHeight1)) {
      std::cout << "Transition vers le menu principal..." << std::endl;
      m_manager.set(std::make_unique<MainMenuState>(window, m_manager));
    }
  } else if (mouseState == GLFW_RELEASE) {
    mouseButtonPressed = false;
  }
}

void SettingsState::update() {}

void SettingsState::draw(GLFWwindow *window) {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);
  gltBeginDraw();
  gltColor(1.0f, 1.0f, 1.0f, 1.0f);

  gltDrawText2D(titleText, titlePositionX, titlePositionY, buttonScale);
  gltDrawText2D(option1Text, option1PositionX, option1PositionY, buttonScale);

  gltEndDraw();
  glfwSwapBuffers(window);
}

bool SettingsState::isInsideForSettings(double x, double y, double rectX,
                                        double rectY, double rectWidth,
                                        double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}