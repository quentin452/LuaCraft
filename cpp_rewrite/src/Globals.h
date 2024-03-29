#include <glew.h>
#ifndef GLOBALS_H
#define GLOBALS_H
#include "gamestatehandling/core/GameStateManager.h"
#include "utils/luacraft_logger.h"
#include <thread>

class Globals {
public:
  static GameStateManager *getGlobalGameStateManager() {
    return _Global_GameState_Manager;
  }

  static void setGlobalGameStateManager(GameStateManager *manager) {
    _Global_GameState_Manager = manager;
  }

  static std::thread &getGlobalLogThread() { return _Global_LogThread; }

  static int &getGlobalWindowWidth() { return _Global_WindowWidth; }

  static int &getGlobalWindowHeight() { return _Global_WindowHeight; }

  static GameStateManager *_Global_GameState_Manager;
  static std::thread _Global_LogThread;
  static LuaCraftLogger _Global_LoggerInstance;
  static int _Global_WindowWidth;
  static int _Global_WindowHeight;
};
#endif // GLOBALS_H