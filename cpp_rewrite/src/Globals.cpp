#include "Globals.h"

GameStateManager *Globals::_Global_GameState_Manager = nullptr;
std::thread Globals::_Global_LogThread;
int Globals::_Global_WindowWidth = 0;
int Globals::_Global_WindowHeight = 0;
LuaCraftLogger Globals::_Global_LoggerInstance;