
#include <glew.h>

#include <GLFW/glfw3.h>
#define GLT_IMPLEMENTATION

#include <gltext.h>
#include <iostream>
#include <vector>

#include "MainMenuState.h"
#include "SettingsState.h"
#include "VulkanGameState.h"

void MainMenuState::initializeGLText() {
  gltInit();
  if (!text1) {
    text1 = gltCreateText();
    if (!text1) {
      std::cerr << "Erreur lors de la création du texte text1." << std::endl;
      return;
    }
    gltSetText(text1, "Option 1");
  }
  if (!text2) {
    text2 = gltCreateText();
    if (!text2) {
      std::cerr << "Erreur lors de la création du texte text2." << std::endl;
      return;
    }
    gltSetText(text2, "Play Game!");
  }
}

MainMenuState::MainMenuState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), m_manager(manager) {
  initializeGLText();
  titleText = "Menu Principal";
}
void MainMenuState::handleInput(GLFWwindow *window) {
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
    mouseButtonPressed = true;
    int width, height;
    glfwGetWindowSize(window, &width, &height);
    double normalizedX = 2.0f * xpos / width - 1.0f;
    double normalizedY = 1.0f - 2.0f * ypos / height;
    if (isInsideForMainMenu(normalizedX, normalizedY, option1PositionX,
                            option1PositionY, optionWidth, optionHeight)) {
      std::cout << "Transition vers le menu des paramètres..." << std::endl;
      m_manager.set(std::make_unique<SettingsState>(window, m_manager));
    } else if (isInsideForMainMenu(normalizedX, normalizedY, option2PositionX,
                                   option2PositionY, optionWidth,
                                   optionHeight)) {
      std::cout << "Transition vers la scène 3D avec Vulkan..." << std::endl;
      m_manager.set(std::make_unique<VulkanGameState>(window, m_manager));
    }
  } else if (mouseState == GLFW_RELEASE) {
    mouseButtonPressed = false;
  }
}

void MainMenuState::update() {}

void MainMenuState::draw(GLFWwindow *window) {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);

  gltBeginDraw(); // Début du rendu de texte

  gltColor(1.0f, 1.0f, 1.0f, 1.0f);

  int screenWidth, screenHeight;
  glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

  GLfloat textWidth1 = gltGetTextWidth(text1, buttonScale);
  GLfloat textHeight1 = gltGetTextHeight(text1, buttonScale);
  GLfloat textPosX1 = (screenWidth - textWidth1) / 2;
  GLfloat textPosY1 = (screenHeight - textHeight1) / 2;

  GLfloat textWidth2 = gltGetTextWidth(text2, buttonScale);
  GLfloat textHeight2 = gltGetTextHeight(text2, buttonScale);
  GLfloat textPosX2 = (screenWidth - textWidth2) / 2;
  GLfloat textPosY2 = textPosY1 - textHeight2 - 10.0f; // Espace entre les textes

  gltDrawText2D(text1, textPosX1, textPosY1, buttonScale);
  gltDrawText2D(text2, textPosX2, textPosY2, buttonScale);

  gltEndDraw(); // Fin du rendu de texte

  glfwSwapBuffers(window);
}


bool MainMenuState::isInsideForMainMenu(double x, double y, double rectX,
                                        double rectY, double rectWidth,
                                        double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}