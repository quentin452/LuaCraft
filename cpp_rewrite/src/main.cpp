#include <glew.h>

#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/VulkanGameState.h"
#include "gltext.h"
#include "utils/luacraft_logger.h"
#include <GLFW/glfw3.h>
#include <iostream>
#include <thread> 
#include "Globals.h"
#define WINDOW_WIDTH 1280
#define WINDOW_HEIGHT 720

void framebufferSizeCallback(GLFWwindow *window, int width, int height) {
  glViewport(0, 0, width, height);
  if (_Global_GameState_Manager) {
    _Global_GameState_Manager->get().framebufferSizeCallbackGameState(window, width, height);
    _Global_GameState_Manager->get().calculateButtonPositionsAndSizes(window);
  }
}

int main() {
  double elapsedTime = 0.0;
  const double inputDelay = 0.1;
  if (!glfwInit()) {
    logMessageAsync(LogLevel::ERROR, "Error during GLFW Initializations");
    return 1;
  }
  GLFWwindow *window =
      glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LuaCraft", NULL, NULL);
  if (!window) {
    logMessageAsync(LogLevel::ERROR, "Error during creating GLFW Windows");
    glfwTerminate();
    return 1;
  }
  int api = glfwGetWindowAttrib(window, GLFW_CLIENT_API);
  std::string apiNameString = (api == GLFW_OPENGL_API) ? "OpenGL" : "Vulkan";
  logMessageAsync(LogLevel::INFO, "Graphical API Used : " + apiNameString);
  glfwMakeContextCurrent(window);
  glewExperimental = GL_TRUE;
  if (glewInit() != GLEW_OK) {
    logMessageAsync(LogLevel::ERROR, "Error during GLEW Initializations");
    glfwTerminate();
    return 1;
  }
  GameStateManager manager;
  manager.set(std::make_unique<MainMenuState>(window, manager));
  _Global_GameState_Manager = &manager;
  glfwSwapInterval(0); // disable Vsync

  // Démarrer le thread de journalisation
  Global_LogThread = std::thread(logWorker);

  while (!glfwWindowShouldClose(window)) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);
    elapsedTime = glfwGetTime() - manager.getLastStateChangeTime();
    if (elapsedTime >= inputDelay) {
      manager.get().handleInput(window);
    }
    manager.get().update();
    manager.get().draw(window);
    glfwPollEvents();
  }

  // Arrêter le thread de journalisation
  done = true;     // Indiquer au thread de journalisation qu'il doit s'arrêter
  cv.notify_one(); // Débloquer le thread de journalisation pour qu'il puisse
                   // s'arrêter
  Global_LogThread.join(); // Attendre que le thread de journalisation se termine
  glfwDestroyWindow(window);
  glfwTerminate();
  return 0;
}