#include <GL/glew.h>

#include "LuaCraftGlobals.h"
#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/gameplaying/VulkanGameState.h"
#include "gltext.h"
#include "utils/luacraft_filesystem.h"
#include "utils/luacraft_logger.h"
#include "utils/threads_starter.h"
#include <GLFW/glfw3.h>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <sys/stat.h>
#include <thread>

//#include <SDL.h>
//#include <SDL_image.h>
//#include <SDL_mixer.h>
//#include <SDL_ttf.h>

//#include "utils/TinyEngine-master/TinyEngine/include/audio.hpp"
//#include "utils/TinyEngine-master/TinyEngine/include/view.hpp"

//#include "utils/TinyEngine-master/TinyEngine.hpp"

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
  threads_starter::LuaCraftStartAllThreads();
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

  LuaCraftGlobals::LoggerInstance.logMessageAsync(
      LogLevel::INFO, "LuaCraftGlobals::UsernameDirectory:" +
                          LuaCraftGlobals::UsernameDirectory);
  if (!glfwInit()) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during GLFW Initializations");
    return 1;
  }
  GLFWwindow *window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LuaCraft",
                                        nullptr, nullptr);
  if (!window) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during creating GLFW Windows");
    glfwTerminate();
    return 1;
  }
  int api = glfwGetWindowAttrib(window, GLFW_CLIENT_API);
  std::string apiNameString = (api == GLFW_OPENGL_API) ? "OpenGL" : "Vulkan";
  LuaCraftGlobals::LoggerInstance.logMessageAsync(
      LogLevel::INFO, "Graphical API Used : " + apiNameString);
  glfwMakeContextCurrent(window);
  glewExperimental = GL_TRUE;
  if (glewInit() != GLEW_OK) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during GLEW Initializations");
    glfwTerminate();
    return 1;
  }
  /*
  // Initialize SDL
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) < 0) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::INFO,
        "SDL could not initialize! Error: %s\n" + std::string(SDL_GetError()));
    return 1;
  }

  // Initialize SDL_image
  if (!(IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG)) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::INFO, "SDL_Image could not initialize! Error: %s\n" +
                            std::string(IMG_GetError()));
    SDL_Quit();
    return 1;
  }

  // Initialize SDL_ttf
  if (TTF_Init() == -1) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::INFO, "SDL_ttf could not initialize! Error: %s\n" +
                            std::string(IMG_GetError()));
    IMG_Quit();
    SDL_Quit();
    return 1;
  }

  // Initialize SDL_mixer
  if (Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 2, 4096) < 0) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::INFO, "SDL_mixer could not initialize! Error: %s\n" +
                            std::string(IMG_GetError()));
    TTF_Quit();
    IMG_Quit();
    SDL_Quit();
    return 1;
  }

  // Initialize TinyEngine
  if (!Tiny::window("TinyEngine Window", WINDOW_WIDTH, WINDOW_HEIGHT)) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::INFO, "Failed to initialize TinyEngine!\n");
    Mix_CloseAudio();
    TTF_Quit();
    IMG_Quit();
    SDL_Quit();
    return 1;
  }
 */
  GameStateManager manager;
  LuaCraftGlobals::setGlobalGameStateManager(&manager);
  manager.SetGameState(std::make_unique<MainMenuState>(window, manager),
                       window);
  LuaCraftGlobals::GameState_Manager = &manager;
  glfwSwapInterval(0); // disable Vsync

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
  LuaCraftGlobals::LoggerInstance.ExitLoggerThread();
  glfwDestroyWindow(window);
  glfwTerminate();
   /*
  Tiny::quit();
  Mix_CloseAudio();
  TTF_Quit();
  IMG_Quit();
  SDL_Quit();
   */
  return 0;
}