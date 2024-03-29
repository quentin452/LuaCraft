#include <glew.h>

#include "LuaCraftGlobals.h"
#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/VulkanGameState.h"
#include "gltext.h"
#include "utils/luacraft_logger.h"
#include <GLFW/glfw3.h>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>
#include <sys/stat.h>
#include <thread>

constexpr int WINDOW_WIDTH = 1280;
constexpr int WINDOW_HEIGHT = 720;

void framebufferSizeCallback(GLFWwindow *window, int width, int height) {
  glViewport(0, 0, width, height);
  if (LuaCraftGlobals::GameState_Manager) {
    LuaCraftGlobals::GameState_Manager->GetGameState()
        .framebufferSizeCallbackGameState(window, width, height);
    LuaCraftGlobals::GameState_Manager->GetGameState()
        .calculateButtonPositionsAndSizes(window);
  }
}
bool directoryExists(const std::string &path) {
  struct stat info;
  if (stat(path.c_str(), &info) != 0)
    return false;
  else if (info.st_mode & S_IFDIR)
    return true;
  else
    return false;
}

void createDirectories(const std::string &path) {
  if (!directoryExists(path)) {
    std::string command = "mkdir " + path;
    std::system(command.c_str());
  }
}
bool fileExists(const std::string &filename) {
  struct stat buffer;
  return (stat(filename.c_str(), &buffer) == 0);
}

bool createFile(const std::string &filename) {
  if (fileExists(filename)) {
    std::cerr << "Error: File " << filename << " already exists.\n";
    return false;
  }

  std::ofstream file(filename);
  if (!file.is_open()) {
    std::cerr << "Error: Unable to create file " << filename << ".\n";
    return false;
  }

  file.close();
  return true;
}
int main() {
    LuaCraftGlobals::LoggerInstance.StartLoggerThread(); 
  const char *username = std::getenv("USERNAME");
  createDirectories("C:\\Users\\" + std::string(username) +
                    "\\.LuaCraft\\cpp_rewrite\\");
  createDirectories("C:\\Users\\" + std::string(username) +
                    "\\.LuaCraft\\cpp_rewrite\\LogBackup");
  createFile("C:\\Users\\" + std::string(username) +
             "\\.LuaCraft\\cpp_rewrite\\LuaCraftCPP.log");
  double elapsedTime = 0.0;
  const double inputDelay = 0.1;
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
  return 0;
}