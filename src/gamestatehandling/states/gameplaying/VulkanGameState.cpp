#include "VulkanGameState.h"
#include <GLFW/glfw3.h>
#include <iostream>

VulkanGameState::VulkanGameState(SDL_Window *window, GameStateManager &manager)
    : m_window(window), manager(manager) {
  // Initialiser Vulkan et d'autres choses spécifiques à VulkanGameState
}

void VulkanGameState::handleInput(SDL_Window *window) {
  // Gérer les entrées utilisateur pour VulkanGameState
}

void VulkanGameState::update() {
  // Mettre à jour l'état de VulkanGameState
}

void VulkanGameState::draw(SDL_Window *window) {
  glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
}