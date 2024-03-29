#include <glew.h>

#include "Globals.h"
#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/VulkanGameState.h"
#include "gltext.h"
#include "utils/luacraft_logger.h"
#include <GLFW/glfw3.h>
#include <iostream>
#include <thread>
constexpr int WINDOW_WIDTH = 1280;
constexpr int WINDOW_HEIGHT = 720;

void framebufferSizeCallback(GLFWwindow *window, int width, int height) {
  glViewport(0, 0, width, height);
  if (Globals::_Global_GameState_Manager) {
    Globals::_Global_GameState_Manager->get().framebufferSizeCallbackGameState(
        window, width, height);
    Globals::_Global_GameState_Manager->get().calculateButtonPositionsAndSizes(
        window);
  }
}

int main() {
  Globals::_Global_LoggerInstance.StartLoggerThread();
  double elapsedTime = 0.0;
  const double inputDelay = 0.1;
  if (!glfwInit()) {
    Globals::_Global_LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during GLFW Initializations");
    return 1;
  }
  GLFWwindow *window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LuaCraft",
                                        nullptr, nullptr);
  if (!window) {
    Globals::_Global_LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during creating GLFW Windows");
    glfwTerminate();
    return 1;
  }
  int api = glfwGetWindowAttrib(window, GLFW_CLIENT_API);
  std::string apiNameString = (api == GLFW_OPENGL_API) ? "OpenGL" : "Vulkan";
  Globals::_Global_LoggerInstance.logMessageAsync(
      LogLevel::INFO, "Graphical API Used : " + apiNameString);
  glfwMakeContextCurrent(window);
  glewExperimental = GL_TRUE;
  if (glewInit() != GLEW_OK) {
    Globals::_Global_LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during GLEW Initializations");
    glfwTerminate();
    return 1;
  }
  GameStateManager manager;
  manager.set(std::make_unique<MainMenuState>(window, manager));
  Globals::_Global_GameState_Manager = &manager;
  glfwSwapInterval(0); // disable Vsync

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
  Globals::_Global_LoggerInstance.ExitLoggerThread();
  glfwDestroyWindow(window);
  glfwTerminate();
  return 0;
}