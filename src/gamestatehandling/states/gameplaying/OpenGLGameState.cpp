#include "OpenGLGameState.h"
#include <GLFW/glfw3.h>
#include <iostream>

OpenGLGameState::OpenGLGameState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), manager(manager) {
  // Initialiser OpenGL et d'autres choses spécifiques à OpenGLGameState
  // Charger des modèles 3D, configurer des shaders, etc.
}

void OpenGLGameState::handleInput(GLFWwindow *window) {
  // Gérer les entrées utilisateur pour OpenGLGameState
}

void OpenGLGameState::update() {
  // Mettre à jour l'état de OpenGLGameState
}

void OpenGLGameState::draw(GLFWwindow *window) {
  // Effacer l'écran
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

  // Mettre en place la vue de la caméra

  // Dessiner les objets de la scène

  // Échanger les tampons pour afficher la scène
  glfwSwapBuffers(window);
}
