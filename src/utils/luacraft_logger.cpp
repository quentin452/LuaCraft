#include "luacraft_logger.h"
#include "../LuaCraftGlobals.h"
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <mutex>
#include <sstream>

LuaCraftLogger::LuaCraftLogger() : Done_Logger_Thread(false) {
  LuaCraftGlobals::UsernameDirectory = std::getenv("USERNAME");
  std::string logFilePath = "C:\\Users\\" + LuaCraftGlobals::UsernameDirectory +
                            "\\.LuaCraft\\cpp_rewrite\\LuaCraftCPP.log";

  logFile.open(logFilePath, std::ios::trunc);
  logFile.close();
  logFilePath_ = logFilePath;
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
      if (Done_Logger_Thread && tasks.empty()) {
        break;
      }
      if (tasks.empty()) {
        continue;
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
    break;
  case LogLevel::WARNING:
    oss << "[WARNING] ";
    break;
  case LogLevel::ERROR:
    oss << "[ERROR] ";
    break;
  case LogLevel::LOGICERROR:
    oss << "[LOGIC ERROR] ";
    break;
  }
  append(oss, args...);
  std::string message = oss.str();
  std::cout << message << std::endl;
  std::ofstream logFile(logFilePath_, std::ios::app);
  logFile << message << std::endl;
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

void LuaCraftLogger::copyFile(const std::string &source,
                              const std::string &dest) {
  std::ifstream src(source, std::ios::binary);
  if (!src.is_open()) {
    std::cerr << "Error: Unable to open source file " << source << ".\n";
    return;
  }

  std::ofstream dst(dest, std::ios::binary);
  if (!dst.is_open()) {
    std::cerr << "Error: Unable to create or open destination file " << dest
              << ".\n";
    src.close();
    return;
  }
  std::string line;
  while (std::getline(src, line)) {
    dst << line << std::endl;
  }
  src.close();
  dst.close();
}

std::string LuaCraftLogger::getTimestamp() {
  auto now = std::chrono::system_clock::now();
  auto in_time_t = std::chrono::system_clock::to_time_t(now);

  std::stringstream ss;
  ss << std::put_time(std::localtime(&in_time_t), "%Y-%m-%d-%H-%M-%S");
  return ss.str();
}

void LuaCraftLogger::ExitLoggerThread() {
  std::string timestamp = getTimestamp();
  std::string src = "C:\\Users\\" + LuaCraftGlobals::UsernameDirectory +
                    "\\.LuaCraft\\cpp_rewrite\\LuaCraftCPP.log";

  std::string dst = "C:\\Users\\" + LuaCraftGlobals::UsernameDirectory +
                    "\\.LuaCraft\\cpp_rewrite\\LogBackup\\LuaCraftCPP-" +
                    timestamp + ".log";
  this->copyFile(src, dst);
  Done_Logger_Thread = true;
  Unlock_Logger_Thread.notify_one();
}

void LuaCraftLogger::StartLoggerThread() {
  LuaCraftGlobals::LogThread = std::thread(&LuaCraftLogger::logWorker, this);
}