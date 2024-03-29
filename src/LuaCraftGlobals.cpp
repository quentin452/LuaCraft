#include <glew.h>

#include <string>

#include "LuaCraftGlobals.h"
#include "gamestatehandling/core/GameStatesUtils.h"
GameStateManager *LuaCraftGlobals::GameState_Manager = nullptr;
std::thread LuaCraftGlobals::LogThread;
int LuaCraftGlobals::WindowWidth = 0;
int LuaCraftGlobals::WindowHeight = 0;
LuaCraftLogger LuaCraftGlobals::LoggerInstance;
GameStatesUtils LuaCraftGlobals::GameStateUtilsInstance;
std::string LuaCraftGlobals::UsernameDirectory;