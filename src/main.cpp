#include "LuaCraftGlobals.h"
#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/gameplaying/VulkanGameState.h"
#include "gltext.h"
#include "utils/TinyEngine-master/TinyEngine/include/imgui-backend/backends/imgui_impl_opengl3.h"
#include "utils/TinyEngine-master/TinyEngine/include/imgui-backend/backends/imgui_impl_sdl2.h"
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>
#include <ThreadedLoggerForCPP/LoggerFileSystem.hpp>
#include <ThreadedLoggerForCPP/LoggerGlobals.hpp>
#include <ThreadedLoggerForCPP/LoggerThread.hpp>
#include <cstdlib>
#include <fstream>
#include <imgui/imgui.h>
#include <iostream>
#include <string>
#include <sys/stat.h>
#include <thread>


#include "utils/TinyEngine-master/TinyEngine.hpp"
#include "utils/TinyEngine-master/TinyEngine/include/audio.hpp"
int WINDOW_WIDTH = 1280;
int WINDOW_HEIGHT = 720;
void framebufferSizeCallback(SDL_Window *window, int width, int height) {
  SDL_GL_GetDrawableSize(window, &LuaCraftGlobals::WindowWidth,
                         &LuaCraftGlobals::WindowHeight);
  glViewport(0, 0, LuaCraftGlobals::WindowWidth, LuaCraftGlobals::WindowHeight);
  if (LuaCraftGlobals::GameState_Manager) {
    LuaCraftGlobals::GameState_Manager->GetGameState()
        .framebufferSizeCallbackGameState(window, LuaCraftGlobals::WindowWidth,
                                          LuaCraftGlobals::WindowHeight);
  }
}

int main(int argc, char *args[]) {
  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  LoggerGlobals::UsernameDirectory = std::getenv("USERNAME");

  // Create Log File and folder
  LoggerGlobals::LogFolderPath = "C:\\Users\\" +
                                 LoggerGlobals::UsernameDirectory +
                                 "\\.LuaCraft\\cpp_rewrite\\logging\\";
  LoggerGlobals::LogFilePath =
      "C:\\Users\\" + LoggerGlobals::UsernameDirectory +
      "\\.LuaCraft\\cpp_rewrite\\logging\\LuaCraftCPP.log";
  LoggerGlobals::LogFolderBackupPath =
      "C:\\Users\\" + LoggerGlobals::UsernameDirectory +
      "\\.LuaCraft\\cpp_rewrite\\logging\\LogBackup";
  LoggerGlobals::LogFileBackupPath =
      "C:\\Users\\" + LoggerGlobals::UsernameDirectory +
      "\\.LuaCraft\\cpp_rewrite\\logging\\LogBackup\\LuaCraftCPP-";

  LuaCraftGlobals::LoggerInstance.StartLoggerThread(
      LoggerGlobals::LogFolderPath, LoggerGlobals::LogFilePath,
      LoggerGlobals::LogFolderBackupPath, LoggerGlobals::LogFileBackupPath);

  // Initialize Settings
  Tiny::view.vsync = false;
  // Initialize a Window
  Tiny::window("LuaCraft", WINDOW_WIDTH, WINDOW_HEIGHT);
  SDL_Window *window = Tiny::view.getSDLWindow();

  // Initialize GameStateManager and set the initial game state
  GameStateManager manager;
  LuaCraftGlobals::setGlobalGameStateManager(&manager);
  manager.SetGameState(std::make_unique<MainMenuState>(window, manager),
                       window);
  LuaCraftGlobals::GameState_Manager = &manager;

  // Add the Event Handler
  Tiny::event.handler = [&]() {
    if (Tiny::event.click[SDL_BUTTON_LEFT]) {
      manager.GetGameState().handleInput(window);
    }
  };

  // Set up an ImGUI Interface here
  Tiny::view.interface = [&]() {};

  // Define the rendering pipeline
  Tiny::view.pipeline = []() { Tiny::view.targetNoClear(glm::vec3(1)); };

  SDL_Event event;
  // Execute the render loop
  Tiny::loop([&]() {
    SDL_GetWindowSize(window, &WINDOW_WIDTH, &WINDOW_HEIGHT);
    if (WINDOW_WIDTH != LuaCraftGlobals::WindowWidth ||
        WINDOW_HEIGHT != LuaCraftGlobals::WindowHeight) {
      framebufferSizeCallback(window, WINDOW_WIDTH, WINDOW_HEIGHT);
      LuaCraftGlobals::WindowWidth = WINDOW_WIDTH;
      LuaCraftGlobals::WindowHeight = WINDOW_HEIGHT;
    }
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    manager.GetGameState().update();
    manager.GetGameState().draw(window);
    SDL_GL_SwapWindow(window);
  });
  // Clean up resources
  LuaCraftGlobals::LoggerInstance.ExitLoggerThread();
  SDL_DestroyWindow(window);
  window = nullptr;
  Tiny::quit();
  Mix_CloseAudio();
  TTF_Quit();
  IMG_Quit();
  SDL_Quit();

  return 0;
}