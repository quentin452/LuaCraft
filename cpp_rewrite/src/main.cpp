#include <ft2build.h>
#include <glew.h>

#include FT_FREETYPE_H
#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/VulkanGameState.h"
#define GLT_IMPLEMENTATION

#include "gltext.h"
#include <GLFW/glfw3.h>

#include <iostream>

int main() {
  // Initialiser GLFW
  if (!glfwInit()) {
    std::cerr << "Erreur lors de l'initialisation de GLFW." << std::endl;
    return 1;
  }

  // Créer une fenêtre GLFW
  GLFWwindow *window = glfwCreateWindow(1280, 720, "LuaCraft", NULL, NULL);
  if (!window) {
    std::cerr << "Erreur lors de la création de la fenêtre GLFW." << std::endl;
    glfwTerminate();
    return 1;
  }
  int api = glfwGetWindowAttrib(window, GLFW_CLIENT_API);
  const char *apiName = (api == GLFW_OPENGL_API) ? "OpenGL" : "Vulkan";
  std::cout << "API graphique utilisée : " << apiName << std::endl;

  // Initialiser FreeType
  FT_Library ft;
  if (FT_Init_FreeType(&ft)) {
    std::cerr << "Erreur lors de l'initialisation de FreeType." << std::endl;
    glfwDestroyWindow(window);
    glfwTerminate();
    return 1;
  }

  // Charger la police de caractères
  FT_Face face;
  if (FT_New_Face(ft, "Arial.ttf", 0, &face)) {
    std::cerr << "Impossible de charger la police de caractères." << std::endl;
    glfwDestroyWindow(window);
    glfwTerminate();
    return 1;
  }
  glfwMakeContextCurrent(window);
  // GLTtext *text = gltCreateText2D(face, 512, 512);
  // Initialiser le texte glText


  // Initialiser le gestionnaire d'état du jeu
  GameStateManager manager;
  // Passer la police chargée à MainMenuState
  manager.set(std::make_unique<MainMenuState>(face, window, manager));
  // Activer la Vsync (limiter le taux de rafraîchissement au taux de
  // rafraîchissement de l'écran)
  // glfwSwapInterval(1);

  // Désactiver la Vsync (permettre le taux de rafraîchissement maximum)
  glfwSwapInterval(0);
  // Boucle principale du jeu
  while (!glfwWindowShouldClose(window)) {
    // Effacer la fenêtre
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Gérer les événements et mettre à jour l'état du jeu
    manager.get().handleInput(window);
    manager.get().update();

    // Dessiner l'état du jeu
    manager.get().draw(window);

    // Mettre à jour le contenu de la fenêtre
    glfwSwapBuffers(window);

    // Vérifier les événements
    glfwPollEvents();
  }

  // Nettoyer et fermer GLFW
  glfwDestroyWindow(window);
  glfwTerminate();

  // Nettoyer les ressources de FreeType
  FT_Done_Face(face);
  FT_Done_FreeType(ft);

  return 0;
}