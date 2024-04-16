#ifndef LOGGER_THREAD_HPP
#define LOGGER_THREAD_HPP

#include <ThreadedLoggerForCPP/LoggerFileSystem.hpp>
#include <ThreadedLoggerForCPP/LoggerGlobals.hpp>
#include <condition_variable>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <filesystem>
#include <fstream>
#include <functional>
#include <iomanip>
#include <iostream>
#include <mutex>
#include <queue>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

enum class LogLevel { INFO, WARNING, ERROR, LOGICERROR };

class LoggerThread {
public:
  LoggerThread() : Done_Logger_Thread(false) {
    std::thread workerThread(&LoggerThread::logWorker, this);
    workerThread.detach();
  }

  ~LoggerThread() {
    {
      std::unique_lock<std::mutex> lock(mtx);
      Done_Logger_Thread = true;
    }
    Unlock_Logger_Thread.notify_one(); // Notify worker thread to stop
  }

  void logMessageAsync(LogLevel level, const std::string &sourceFile, int line,
                       const std::string &message) {
    std::unique_lock<std::mutex> lock(mtx);
    tasks.emplace([=] { logMessage(level, sourceFile, line, message); });
    Unlock_Logger_Thread.notify_one();
  }

  void ExitLoggerThread() {
    TimeStamp = getTimestamp();
    std::string src = LogFilePathForTheThread;
    std::string dst = LogFileBackupPathForTheThread + TimeStamp + ".log";
    this->copyFile(src, dst);
    Done_Logger_Thread = true;
    Unlock_Logger_Thread.notify_one();
  }

  void StartLoggerThread(const std::string &LogFolderPath,
                         const std::string &LogFilePath,
                         const std::string &LogFolderBackupPath,
                         const std::string &LogFileBackupPath) {
    this->LogFolderPathForTheThread = LogFolderPath;
    this->LogFilePathForTheThread = LogFilePath;
    this->logFilePath_ = LogFilePath;
    this->LogFolderBackupPathForTheThread = LogFolderBackupPath;
    this->LogFileBackupPathForTheThread = LogFileBackupPath;
    std::remove(LogFilePathForTheThread.c_str());
    LoggerFileSystem::createDirectories(LogFolderBackupPathForTheThread);
    LoggerFileSystem::createDirectories(LogFolderPathForTheThread);
    LoggerFileSystem::createFile(LogFilePathForTheThread);
    LogThread = std::thread(&LoggerThread::logWorker, this);
  }

  std::thread &getGlobalLogThread() { return LogThread; }
  std::thread LogThread;

private:
  std::queue<std::function<void()>> tasks;
  std::mutex mtx;
  std::condition_variable Unlock_Logger_Thread;
  bool Done_Logger_Thread;
  std::ofstream logFile;
  std::string logFilePath_;
  std::string LogFolderPathForTheThread;
  std::string LogFilePathForTheThread;
  std::string LogFolderBackupPathForTheThread;
  std::string LogFileBackupPathForTheThread;
  std::string TimeStamp;

  void logWorker() {
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
  void logMessage(LogLevel level, const std::string &sourceFile, int line,
                  const Args &...args) {
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
    oss << getTimestamp() << " [" << extractRelativePath(sourceFile) << ":"
        << line << "] ";
    append(oss, args...);
    std::string message = oss.str();
    std::cout << message << std::endl;
    std::ofstream logFile(logFilePath_, std::ios::app);
    logFile << message << std::endl; // Write to file
  }

  std::string extractRelativePath(const std::string &filePath) {
    std::string relativePath;
    size_t found = filePath.find_last_of("/\\");
    if (found != std::string::npos) {
      std::string folder = filePath.substr(0, found);
      size_t srcIndex = folder.rfind(LoggerGlobals::SrcProjectDirectory);
      if (srcIndex != std::string::npos) {
        relativePath = folder.substr(srcIndex) + filePath.substr(found);
      } else {
        relativePath = filePath.substr(found);
      }
    } else {
      relativePath = filePath;
    }
    return relativePath;
  }

  template <typename T> void append(std::ostringstream &oss, const T &arg) {
    oss << arg;
  }

  template <typename T, typename... Args>
  void append(std::ostringstream &oss, const T &first, const Args &...args) {
    oss << first;
    append(oss, args...);
  }

  void copyFile(const std::string &source, const std::string &dest) {
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
    };
    dst << src.rdbuf(); // Efficiently copy file
    src.close();
    dst.close();
  }

  std::string getTimestamp() {
    auto now = std::chrono::system_clock::now();
    auto in_time_t = std::chrono::system_clock::to_time_t(now);

    std::stringstream ss;
    ss << std::put_time(std::localtime(&in_time_t), "%Y-%m-%d-%H-%M-%S");
    return ss.str();
  }
};

#endif // LOGGER_THREAD_HPP
