// TODO MADE FILESYSTEM / SETTINGS SYSTEM / LOGGER WRITTER SYSTEM

#include "luacraft_logger.h"
#include "../LuaCraftGlobals.h"
LuaCraftLogger::LuaCraftLogger() : Done_Logger_Thread(false) {
  std::thread workerThread(&LuaCraftLogger::logWorker, this);
  workerThread.detach();
}

LuaCraftLogger::~LuaCraftLogger() {
  {
    std::unique_lock<std::mutex> lock(mtx);
    Done_Logger_Thread = true;
  }
  Unlock_Logger_Thread.notify_one(); // Notify worker thread to stop
}

void LuaCraftLogger::logWorker() {
  while (true) {
    std::function<void()> task;
    {
      std::unique_lock<std::mutex> lock(mtx);
      Unlock_Logger_Thread.wait(
          lock, [this] { return !tasks.empty() || Done_Logger_Thread; });
      if (tasks.empty()) {
        return;
      }
      task = std::move(tasks.front());
      tasks.pop();
    }
    task();
  }
}

template <typename... Args>
void LuaCraftLogger::logMessage(LogLevel level, const Args &...args) {
  std::ostringstream oss;
  switch (level) {
  case LogLevel::INFO:
    oss << "[INFO] ";
    append(oss, args...);
    std::cout << oss.str() << std::endl;
    break;
  case LogLevel::WARNING:
    oss << "[WARNING] ";
    append(oss, args...);
    std::cout << oss.str() << std::endl;
    break;
  case LogLevel::ERROR:
    oss << "[ERROR] ";
    append(oss, args...);
    std::cerr << oss.str() << std::endl;
  case LogLevel::LOGICERROR:
    oss << "[LOGIC ERROR] ";
    append(oss, args...);
    throw std::logic_error(oss.str());
    break;
  }
}

void LuaCraftLogger::logMessageAsync(LogLevel level,
                                     const std::string &message) {
  std::unique_lock<std::mutex> lock(mtx);
  tasks.emplace([=] { logMessage(level, message); });
  Unlock_Logger_Thread.notify_one();
}

template <typename T>
void LuaCraftLogger::append(std::ostringstream &oss, const T &arg) {
  oss << arg;
}

template <typename T, typename... Args>
void LuaCraftLogger::append(std::ostringstream &oss, const T &first,
                            const Args &...args) {
  oss << first;
  append(oss, args...);
}

void LuaCraftLogger::ExitLoggerThread() {
  Done_Logger_Thread = true;
  Unlock_Logger_Thread.notify_one();
}

void LuaCraftLogger::StartLoggerThread() {
  LuaCraftGlobals::LogThread = std::thread(&LuaCraftLogger::logWorker, this);
}
