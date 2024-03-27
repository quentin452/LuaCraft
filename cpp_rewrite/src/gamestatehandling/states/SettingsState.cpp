
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
  if (!titleText)
    titleText = gltCreateText();
  if (!option1Text)
    option1Text = gltCreateText();

  gltSetText(titleText, "Paramètres");
  gltSetText(option1Text, "Go To Main Menu");
}

SettingsState::SettingsState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), m_manager(manager) {
  initializeGLText();

  int screenWidth, screenHeight;
  glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

  textWidth1 = gltGetTextWidth(titleText, buttonScale);
  textHeight1 = gltGetTextHeight(titleText, buttonScale);
  titlePositionX = (screenWidth - textWidth1) / 2;
  titlePositionY = (screenHeight - textHeight1) / 4;

  GLfloat textWidth2 = gltGetTextWidth(option1Text, buttonScale);
  GLfloat textHeight2 = gltGetTextHeight(option1Text, buttonScale);
  option1PositionX = (screenWidth - textWidth2) / 2;
  option1PositionY = (screenHeight - textHeight2) / 2+ 50.0f;
}
void SettingsState::handleInput(GLFWwindow *window) {
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
    mouseButtonPressed = true;
    int screenWidth, screenHeight;
    glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

    // Coordonnées normalisées du curseur
    double normalizedX = 2.0 * xpos / screenWidth - 1.0;
    double normalizedY = 1.0 - 2.0 * ypos / screenHeight;

    // Convertir les coordonnées normalisées en coordonnées de fenêtre
    int windowX = (int)((normalizedX + 1.0) * screenWidth / 2.0);
    int windowY = (int)((1.0 - normalizedY) * screenHeight / 2.0);

    int option1Width = textWidth1;
    int option1Height = textHeight1;

    if (isInsideForSettings(windowX, windowY, option1PositionX,
                            option1PositionY, option1Width, option1Height)) {
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
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);
  gltBeginDraw();
  gltColor(1.0f, 1.0f, 1.0f, 1.0f);

  gltDrawText2D(titleText, titlePositionX, titlePositionY, buttonScale);
  gltDrawText2D(option1Text, option1PositionX, option1PositionY, buttonScale);

  gltEndDraw();
  glfwSwapBuffers(window);
}

// Fonction utilitaire pour vérifier si un point est à l'intérieur d'un
// rectangle
bool SettingsState::isInsideForSettings(double x, double y, double rectX,
                                        double rectY, double rectWidth,
                                        double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}