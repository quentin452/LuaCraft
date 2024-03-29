#include "../LuaCraftGlobals.h"
#include "luacraft_logger.h"
#include "threads_starter.h"

void threads_starter::LuaCraftStartAllThreads() {
  LuaCraftGlobals::LoggerInstance.StartLoggerThread();
}