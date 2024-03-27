#include <glew.h>

#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/VulkanGameState.h"
#include <GLFW/glfw3.h>
#include <iostream>

#define GLT_IMPLEMENTATION
#include "gltext.h"

#define WINDOW_WIDTH 1280
#define WINDOW_HEIGHT 720

// Fonction de rappel pour le redimensionnement de la fenêtre
void framebufferSizeCallback(GLFWwindow *window, int width, int height) {
  glViewport(0, 0, width, height);
}

int main() {
  // Initialiser GLFW
  if (!glfwInit()) {
    std::cerr << "Erreur lors de l'initialisation de GLFW." << std::endl;
    return 1;
  }

  // Créer une fenêtre GLFW
  GLFWwindow *window =
      glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LuaCraft", NULL, NULL);
  if (!window) {
    std::cerr << "Erreur lors de la création de la fenêtre GLFW." << std::endl;
    glfwTerminate();
    return 1;
  }
  int api = glfwGetWindowAttrib(window, GLFW_CLIENT_API);
  const char *apiName = (api == GLFW_OPENGL_API) ? "OpenGL" : "Vulkan";
  std::cout << "API graphique utilisée : " << apiName << std::endl;

  glfwMakeContextCurrent(window);
  // Définir la fonction de rappel de redimensionnement de la fenêtre
  glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);

  // Obtenir les dimensions initiales de la fenêtre
  int prevWidth = WINDOW_WIDTH, prevHeight = WINDOW_HEIGHT;

  // Initialiser le gestionnaire d'état du jeu
  GameStateManager manager;
  manager.set(std::make_unique<MainMenuState>(window, manager));

  // Activer / Désactiver la Vsync
  glfwSwapInterval(0);

  // Boucle principale du jeu
  while (!glfwWindowShouldClose(window)) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Gérer les événements et mettre à jour l'état du jeu
    manager.get().handleInput(window);
    manager.get().update();
    manager.get().draw(window);
    glfwSwapBuffers(window);
    glfwPollEvents();
  }

  // Nettoyer et fermer GLFW
  glfwDestroyWindow(window);
  glfwTerminate();

  return 0;
}