#include "OpenGLGameState.h"
#include <GLFW/glfw3.h>
//#include <TinyEngine.hpp>
#include <iostream>


OpenGLGameState::OpenGLGameState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), manager(manager) {
  // Initialiser TinyEngine
  // te::Engine::init();

  // Charger des modèles 3D, configurer des shaders, etc.
  // Exemple : Charger un modèle 3D
  // te::Model model("path/to/your/model.obj");

  // Configurer des shaders
  // te::Shader shader("path/to/your/vertex_shader.vert",
  //                  "path/to/your/fragment_shader.frag");

  // Configurer la caméra
  // te::Camera camera;
  // camera.setPosition(glm::vec3(0.0f, 0.0f, 3.0f));

  // Stocker les objets dans une structure de données appropriée
  // par exemple, std::vector<te::Model> models;
  // et std::vector<te::Shader> shaders;
  // ...

  // Dessiner les objets de la scène
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
  // Exemple : Utiliser la caméra de TinyEngine
  //  te::Engine::setViewMatrix(camera.getViewMatrix());
  // te::Engine::setProjectionMatrix(camera.getProjectionMatrix());

  // Dessiner les objets de la scène
  // Exemple : Boucle pour dessiner tous les modèles chargés
  // for (const auto &model : models) {
  //  model.draw(shader);
  //}

  // Échanger les tampons pour afficher la scène
  glfwSwapBuffers(window);
}
