#ifndef LuaCraftGlobals_H
#define LuaCraftGlobals_H
#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/core/GameStatesUtils.h"
#include <GL/glew.h>
#include <ThreadedLoggerForCPP/LoggerThread.hpp>
#include <thread>


#include <string>
class LuaCraftGlobals {
public:
  static GameStateManager *getGlobalGameStateManager() {
    return GameState_Manager;
  }

  static void setGlobalGameStateManager(GameStateManager *manager) {
    GameState_Manager = manager;
  }

  static std::thread &getGlobalLogThread() { return LogThread; }

  static int &getGlobalWindowWidth() { return WindowWidth; }

  static int &getGlobalWindowHeight() { return WindowHeight; }

  static GameStateManager *GameState_Manager;
  static std::thread LogThread;
  static int WindowWidth;
  static int WindowHeight;
  static GameStatesUtils GameStateUtilsInstance;
  static std::string UsernameDirectory;
  static LoggerThread LoggerInstance;
};
#endif // LuaCraftGlobals_H