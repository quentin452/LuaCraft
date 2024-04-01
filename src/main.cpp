#include "LuaCraftGlobals.h"
#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/gameplaying/VulkanGameState.h"
#include "gltext.h"
#include "main_initialize.h"
#include "utils/TinyEngine-master/TinyEngine/include/imgui-backend/backends/imgui_impl_opengl3.h"
#include "utils/TinyEngine-master/TinyEngine/include/imgui-backend/backends/imgui_impl_sdl2.h"
#include "utils/luacraft_filesystem.h"
#include "utils/luacraft_logger.h"
#include "utils/threads_starter.h"
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <cstdlib>
#include <fstream>
#include <imgui/imgui.h>
#include <iostream>
#include <string>
#include <sys/stat.h>
#include <thread>


#define SDL_MAIN_HANDLED
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>

#include "utils/TinyEngine-master/TinyEngine.hpp"
#include "utils/TinyEngine-master/TinyEngine/include/audio.hpp"

constexpr int WINDOW_WIDTH = 1280;
constexpr int WINDOW_HEIGHT = 720;

void framebufferSizeCallback(GLFWwindow *window, int width, int height) {
  glViewport(0, 0, width, height);
  if (LuaCraftGlobals::GameState_Manager) {
    LuaCraftGlobals::GameState_Manager->GetGameState()
        .framebufferSizeCallbackGameState(window, width, height);
  }
}

int main() {
  // Initialize GLFW
  if (!glfwInit()) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during GLFW Initializations");
    exit(1);
  }

  // Create GLFW window
  GLFWwindow *window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LuaCraft",
                                        nullptr, nullptr);
  if (!window) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during creating GLFW Windows");
    glfwTerminate();
    exit(1);
  }

  // Initialize other contexts
  MainInitialize::InitializeContexts(window);

  // Start LuaCraft threads
  threads_starter::LuaCraftStartAllThreads();

  // Create necessary directories and files
  luacraft_filesystem::createDirectories("C:\\Users\\" +
                                         LuaCraftGlobals::UsernameDirectory +
                                         "\\.LuaCraft\\cpp_rewrite\\");
  luacraft_filesystem::createDirectories("C:\\Users\\" +
                                         LuaCraftGlobals::UsernameDirectory +
                                         "\\.LuaCraft\\cpp_rewrite\\LogBackup");
  luacraft_filesystem::createFile("C:\\Users\\" +
                                  LuaCraftGlobals::UsernameDirectory +
                                  "\\.LuaCraft\\cpp_rewrite\\LuaCraftCPP.log");

  double elapsedTime = 0.0;
  const double inputDelay = 0.1;

  // Log graphical API used
  int api = glfwGetWindowAttrib(window, GLFW_CLIENT_API);
  std::string apiNameString = (api == GLFW_OPENGL_API) ? "OpenGL" : "Vulkan";
  LuaCraftGlobals::LoggerInstance.logMessageAsync(
      LogLevel::INFO, "Graphical API Used : " + apiNameString);

  // Initialize GameStateManager and set the initial game state
  GameStateManager manager;
  LuaCraftGlobals::setGlobalGameStateManager(&manager);
  manager.SetGameState(std::make_unique<MainMenuState>(window, manager),
                       window);
  LuaCraftGlobals::GameState_Manager = &manager;
  glfwSwapInterval(0); // Disable Vsync

  // Main loop
  while (!glfwWindowShouldClose(window)) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);
    elapsedTime = glfwGetTime() - manager.getLastStateChangeTime();
    if (elapsedTime >= inputDelay) {
      manager.GetGameState().handleInput(window);
    }
    manager.GetGameState().update();
    manager.GetGameState().draw(window);
    glfwPollEvents();
  }

  // Clean up resources
  LuaCraftGlobals::LoggerInstance.ExitLoggerThread();
  glfwDestroyWindow(window);
  glfwTerminate();
  Tiny::quit();
  Mix_CloseAudio();
  TTF_Quit();
  IMG_Quit();
  SDL_Quit();

  return 0;
}
