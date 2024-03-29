#include "luacraft_logger.h"

std::queue<std::function<void()>> tasks;
std::mutex mtx;
std::condition_variable cv;
bool done = false;

void logWorker() {
  while (true) {
    std::function<void()> task;
    {
      std::unique_lock<std::mutex> lock(mtx);
      cv.wait(lock, [] { return !tasks.empty() || done; });
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
void logMessage(LogLevel level, const Args &...args) {
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
  }
  append(oss, args...); // Concaténer tous les arguments à oss
  std::cout << oss.str() << std::endl;
}

void logMessageAsync(LogLevel level, const std::string &message) {
  std::unique_lock<std::mutex> lock(mtx);
  tasks.push([=] { logMessage(level, message); });
  cv.notify_one();
}
template <typename T> void append(std::ostringstream &oss, const T &arg) {
  oss << arg;
}

template <typename T, typename... Args>
void append(std::ostringstream &oss, const T &first, const Args &...args) {
  oss << first;
  append(oss, args...);
}