#include <glew.h>
#include "gamestatehandling/core/GameStateManager.h"
#include <thread>

#ifndef GLOBALS_H
#define GLOBALS_H

static GameStateManager *_Global_GameState_Manager;
static std::thread Global_LogThread;
extern int _Global_WindowWidth;
extern int _Global_WindowHeight;

#endif // GLOBALS_H