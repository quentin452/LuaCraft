
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
  if (glewInit() != GLEW_OK) {
    std::cerr << "GLEW is not initialized" << std::endl;
    return;
  }
  // Créer l'objet glText une seule fois lors de l'initialisation
  if (!text1) {
    text1 = gltCreateText();
    if (!text1) {
      std::cerr << "Erreur lors de la création du texte text1." << std::endl;
      return;
    }
    // Définir le texte à afficher
    gltSetText(text1, "Hello World!");
  }
}

MainMenuState::MainMenuState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), m_manager(manager){
  // Initialiser glText
  initializeGLText();

  titlePositionX = 100.0f;
  titlePositionY = 100.0f;
  option1PositionX = 150.0f;
  option1PositionY = 200.0f;
  option2PositionX = 150.0f;
  option2PositionY = 250.0f;
  titleText = "Menu Principal";
  option1Text = "Option 1";
  option2Text = "Play Game";
}
void MainMenuState::handleInput(GLFWwindow *window) {
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);

  // Gestion des événements de la souris
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
          std::cout << "Transition vers le menu des paramètres..." << std::endl;
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

void MainMenuState::update() {
  // Mettre à jour l'état du menu principal si nécessaire
}
void MainMenuState::draw(GLFWwindow *window) {
  // Définir la couleur de fond
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f); // Couleur grise (par exemple)
  // Effacer l'écran avec la couleur de fond définie
  glClear(GL_COLOR_BUFFER_BIT);

  // Dessiner le texte à l'aide de glText
  // Définir la couleur du texte en blanc
  gltColor(1.0f, 1.0f, 1.0f, 1.0f);

  // Dessiner le texte
  gltDrawText2D(text1, 0.0f, 0.0f, 1.0f); // x=0.0, y=0.0, scale=1.0

  // Mettre à jour l'affichage
  glfwSwapBuffers(window);
}
// Fonction utilitaire pour vérifier si un point est à l'intérieur d'un
// rectangle
bool MainMenuState::isInsideForMainMenu(double x, double y, double rectX,
                                        double rectY, double rectWidth,
                                        double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}