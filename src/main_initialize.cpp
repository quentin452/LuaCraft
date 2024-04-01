#include "main_initialize.h"
#include "LuaCraftGlobals.h"
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>

void MainInitialize::initializeSDL() {
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) < 0) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR,
        "SDL could not initialize! Error: %s\n" + std::string(SDL_GetError()));
    exit(1);
  }
}

void MainInitialize::initializeSDLImage() {
  if (!(IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG)) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "SDL_Image could not initialize! Error: %s\n" +
                             std::string(IMG_GetError()));
    exit(1);
  }
}

void MainInitialize::initializeSDLTTF() {
  if (TTF_Init() == -1) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "SDL_ttf could not initialize! Error: %s\n" +
                             std::string(IMG_GetError()));
    exit(1);
  }
}

void MainInitialize::initializeSDLMixer() {
  if (Mix_OpenAudio(22050, MIX_DEFAULT_FORMAT, 2, 4096) < 0) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "SDL_mixer could not initialize! Error: %s\n" +
                             std::string(IMG_GetError()));
    exit(1);
  }
}

void MainInitialize::initializeGLEW(GLFWwindow *window) {
  glfwMakeContextCurrent(window);
  glewExperimental = GL_TRUE;
  if (glewInit() != GLEW_OK) {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Error during GLEW Initializations");
    exit(1);
  }
}

void MainInitialize::InitializeContexts(GLFWwindow *window) {
  initializeSDL();
  initializeSDLImage();
  initializeSDLTTF();
  initializeSDLMixer();
  initializeGLEW(window);
}