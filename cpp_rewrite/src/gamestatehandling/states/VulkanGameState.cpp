#include "VulkanGameState.h"
#include <GLFW/glfw3.h>
#include <iostream>

VulkanGameState::VulkanGameState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), manager(manager) {
  // Initialiser Vulkan et d'autres choses spécifiques à VulkanGameState
}

void VulkanGameState::handleInput(GLFWwindow *window) {
  // Gérer les entrées utilisateur pour VulkanGameState
}

void VulkanGameState::update() {
  // Mettre à jour l'état de VulkanGameState
}

void VulkanGameState::draw(GLFWwindow *window) {
  // Dessiner VulkanGameState
}