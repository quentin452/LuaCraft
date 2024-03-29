#include "LuaCraftGlobals.h"

GameStateManager *LuaCraftGlobals::GameState_Manager = nullptr;
std::thread LuaCraftGlobals::LogThread;
int LuaCraftGlobals::WindowWidth = 0;
int LuaCraftGlobals::WindowHeight = 0;
LuaCraftLogger LuaCraftGlobals::LoggerInstance;