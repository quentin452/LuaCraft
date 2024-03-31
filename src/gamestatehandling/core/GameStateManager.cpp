#include <GL/glew.h>

#include "../../LuaCraftGlobals.h"
#include "../../utils/luacraft_logger.h"
#include "GameStateManager.h"
#include <GLFW/glfw3.h>

std::unique_ptr<GameState> GameStateManager::currentState = nullptr;

void GameStateManager::SetGameState(std::unique_ptr<GameState> state,
                                    GLFWwindow *window) {
  if (currentState) {
    currentState->cleanup();
  }
  currentState = std::move(state);
  if (window) {
    currentState->calculateButtonPositionsAndSizes(window);
    lastStateChangeTime = glfwGetTime();
  } else {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Trying to change GameState with no window");
  }
}

GameState &GameStateManager::GetGameState() { return *currentState; }

double GameStateManager::getLastStateChangeTime() const {
  return lastStateChangeTime;
}