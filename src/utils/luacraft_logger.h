#ifndef LUACRAFT_LOGGER_H
#define LUACRAFT_LOGGER_H

#include <condition_variable>
#include <fstream>
#include <functional>
#include <iostream>
#include <mutex>
#include <queue>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

enum class LogLevel { INFO, WARNING, ERROR, LOGICERROR };

class LuaCraftLogger {
public:
  LuaCraftLogger();
  ~LuaCraftLogger();

  void logMessageAsync(LogLevel level, const std::string &message);
  void ExitLoggerThread();
  void StartLoggerThread();
  void flushToFile();

  template <typename... Args>
  void logMessage(LogLevel level, const Args &...args);
  void logWorker();
  void copyAndCompressLogFile();
  void copyFile(const std::string &source, const std::string &dest);
  std::string getTimestamp();

private:
  std::queue<std::function<void()>> tasks;
  std::mutex mtx;
  std::condition_variable Unlock_Logger_Thread;
  bool Done_Logger_Thread;
  std::ofstream logFile;
  std::string logFilePath_;
  std::ofstream logFilePath;
  template <typename T> void append(std::ostringstream &oss, const T &arg);
  template <typename T, typename... Args>
  void append(std::ostringstream &oss, const T &first, const Args &...args);
};

#endif // LUACRAFT_LOGGER_H
