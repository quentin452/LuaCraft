#include <GL/glew.h>

#include "LuaCraftGlobals.h"
#include "gamestatehandling/core/GameStatesUtils.h"
#include <ThreadedLoggerForCPP/LoggerThread.hpp>
#include <string>

GameStateManager *LuaCraftGlobals::GameState_Manager = nullptr;
int LuaCraftGlobals::WindowWidth = 0;
int LuaCraftGlobals::WindowHeight = 0;
GameStatesUtils LuaCraftGlobals::GameStateUtilsInstance;
std::string LuaCraftGlobals::UsernameDirectory;
LoggerThread LuaCraftGlobals::LoggerInstance;
