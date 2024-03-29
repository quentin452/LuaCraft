#include "OpenGLGameState.h"
#include <GLFW/glfw3.h>
#include <iostream>

OpenGLGameState::OpenGLGameState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), manager(manager) {
  // Initialiser Vulkan et d'autres choses spécifiques à OpenGLGameState
}

void OpenGLGameState::handleInput(GLFWwindow *window) {
  // Gérer les entrées utilisateur pour OpenGLGameState
}

void OpenGLGameState::update() {
  // Mettre à jour l'état de OpenGLGameState
}

void OpenGLGameState::draw(GLFWwindow *window) {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT);

  glfwSwapBuffers(window);
}