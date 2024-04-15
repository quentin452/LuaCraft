#include <GL/glew.h>

#include "../../LuaCraftGlobals.h"
#include <ThreadedLoggerForCPP/LoggerGlobals.hpp>
#include <ThreadedLoggerForCPP/LoggerThread.hpp>
#include "GameStateManager.h"
#include <GLFW/glfw3.h>
#include <SDL.h>
std::unique_ptr<GameState> GameStateManager::currentState = nullptr;

void GameStateManager::SetGameState(std::unique_ptr<GameState> state,
                                    SDL_Window *window) const{
  if (currentState) {
    currentState->cleanup();
  }
  currentState = std::move(state);
  if (window) {
    currentState->calculateButtonPositionsAndSizes(window);
  } else {
    LuaCraftGlobals::LoggerInstance.logMessageAsync(
        LogLevel::ERROR, "Trying to change GameState with no window");
  }
}

GameState &GameStateManager::GetGameState() { return *currentState; }