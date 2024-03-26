#include "src/gamestatehandling/states/VulkanGameState.h"
#include <GLFW/glfw3.h>
#include <ft2build.h>
#include <iostream>

#include FT_FREETYPE_H
VulkanGameState::VulkanGameState(FT_Face face, GLFWwindow *window,
                                 GameStateManager &manager)
    : fontFace(face), m_window(window), manager(manager) {
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