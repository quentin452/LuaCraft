
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
  if (!titlescreen) {
    titlescreen = gltCreateText();
    if (!titlescreen) {
      std::cerr << "Erreur lors de la création du texte titlescreen."
                << std::endl;
      return;
    }
    gltSetText(titlescreen, "Main Menu");
  }
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
  int screenWidth, screenHeight;
  glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

  textWidth1 = gltGetTextWidth(text1, buttonScale);
  textHeight1 = gltGetTextHeight(text1, buttonScale);
  textPosX1 = (screenWidth - textWidth1) / 2;
  textPosY1 = (screenHeight - textHeight1) / 2;

  GLfloat textWidth2 = gltGetTextWidth(text2, buttonScale);
  GLfloat textHeight2 = gltGetTextHeight(text2, buttonScale);
  textPosX2 = (screenWidth - textWidth2) / 2;
  textPosY2 = textPosY1 - textHeight2 - 10.0f;

  textWidthForTitle = gltGetTextWidth(titlescreen, buttonScale);
  textHeighForTitle = gltGetTextHeight(titlescreen, buttonScale);
  textPosXForTitle = (screenWidth - textWidthForTitle) / 2;
  textPosYForTitle = (screenHeight - textHeighForTitle) / 4;
}
void MainMenuState::handleInput(GLFWwindow *window) {
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

    // Conversion des positions et dimensions de texte en coordonnées de fenêtre
    int option1PositionX = textPosX1;
    int option1PositionY = textPosY1;
    int optionWidth = textWidth1;
    int optionHeight = textHeight1;

    int option2PositionX = textPosX2;
    int option2PositionY = textPosY2;

    if (isInsideForMainMenu(windowX, windowY, option1PositionX,
                            option1PositionY, optionWidth, optionHeight)) {
      std::cout << "Transition vers le menu des paramètres..." << std::endl;
      m_manager.set(std::make_unique<SettingsState>(window, m_manager));
    } else if (isInsideForMainMenu(windowX, windowY, option2PositionX,
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