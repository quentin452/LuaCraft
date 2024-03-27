#include "SettingsState.h"
#include "MainMenuState.h"
#include <GLFW/glfw3.h>
#include <glew.h>
#include <iostream>

SettingsState::SettingsState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), m_manager(manager), titleFontSize(24),
      optionFontSize(18) {
  titleText = "Paramètres";
  option1Text = "Option 1";

  titlePositionX = 250;
  titlePositionY = 50;
  option1PositionX = 300;
  option1PositionY = 200;

  titleFontSize = 50;
  optionFontSize = 30;
}

void SettingsState::handleInput(GLFWwindow *window) {
  int width, height;
  glfwGetWindowSize(window, &width, &height);
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
    std::cout << "Transition vers le menu des paramètres..." << std::endl;

    mouseButtonPressed = true;
    if (isInsideForSettings(xpos, ypos, option1PositionX, option1PositionY,
                            optionWidth, optionHeight)) {
      std::cout << "Transition vers le menu principal..." << std::endl;
      m_manager.set(std::make_unique<MainMenuState>(window, m_manager));
    }
  } else if (mouseState == GLFW_RELEASE) {
    mouseButtonPressed = false;
  }
}
void SettingsState::update() {
  // Mettre à jour l'état des paramètres si nécessaire
}

void SettingsState::draw(GLFWwindow *window) {
  // Dessiner d'autres éléments des paramètres si nécessaire
}

// Fonction utilitaire pour vérifier si un point est à l'intérieur d'un
// rectangle
bool SettingsState::isInsideForSettings(double x, double y, double rectX,
                                        double rectY, double rectWidth,
                                        double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}