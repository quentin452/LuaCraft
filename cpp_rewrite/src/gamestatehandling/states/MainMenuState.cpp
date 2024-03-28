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
  titlescreen = gltCreateText();
  gltSetText(titlescreen, "Main Menu");
  text1 = gltCreateText();
  gltSetText(text1, "Option 1");
  text2 = gltCreateText();
  gltSetText(text2, "Play Game!");
}
void MainMenuState::framebufferSizeCallbackGameState(GLFWwindow *window,
                                                     int width, int height) {
  // Recalculate button positions and sizes
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
  int windowWidth, windowHeight;
  glfwGetFramebufferSize(window, &windowWidth, &windowHeight);

  // Utiliser les dimensions de la framebuffer pour les calculs
  textWidth1 = gltGetTextWidth(text1, buttonScale);
  textHeight1 = gltGetTextHeight(text1, buttonScale);
  textPosX1 = (windowWidth - textWidth1) / 2;
  textPosY1 = (windowHeight - textHeight1) / 2;

  textWidth2 = gltGetTextWidth(text2, buttonScale);
  textHeight2 = gltGetTextHeight(text2, buttonScale);
  textPosX2 = (windowWidth - textWidth2) / 2;
  textPosY2 = textPosY1 - textHeight2 - 10.0f;

  // Calculer les dimensions et positions du titre
  textWidthForTitle = gltGetTextWidth(titlescreen, buttonScale);
  textHeightForTitle = gltGetTextHeight(titlescreen, buttonScale);
  textPosXForTitle = (windowWidth - textWidthForTitle) / 2;
  textPosYForTitle = (windowHeight - textHeightForTitle) / 4;
}

MainMenuState::MainMenuState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), m_manager(manager) {
  initializeGLText();
  glfwGetFramebufferSize(window, &screenWidth, &screenHeight);
  calculateButtonPositionsAndSizes(window);
  glfwSetWindowUserPointer(window, this);
  glfwSetFramebufferSizeCallback(
      window, &MainMenuState::framebufferSizeCallbackWrapper);
}

void MainMenuState::handleInput(GLFWwindow *window) {
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
    mouseButtonPressed = true;
    // Convertir les coordonnées de la souris en coordonnées de la framebuffer
    int windowX = static_cast<int>(xpos);
    int windowY = static_cast<int>(ypos);
    // Vérifier si les coordonnées de la souris se trouvent à l'intérieur des
    // boutons
    if (isInsideForMainMenu(windowX, windowY, textPosX1, textPosY1, textWidth1,
                            textHeight1)) {
      m_manager.set(std::make_unique<SettingsState>(window, m_manager));
      std::cout << "Transition vers la scène SettingsState..." << std::endl;
    } else if (isInsideForMainMenu(windowX, windowY, textPosX2, textPosY2,
                                   textWidth2, textHeight2)) {
      m_manager.set(std::make_unique<VulkanGameState>(window, m_manager));
      std::cout << "Transition vers la scène 3D avec Vulkan..." << std::endl;
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
  // Vérifier si les coordonnées de la souris se trouvent à l'intérieur du
  // rectangle défini
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}
