#ifndef LUACRAFT_LOGGER_H
#define LUACRAFT_LOGGER_H

#include <condition_variable>
#include <functional>
#include <iostream>
#include <mutex>
#include <queue>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

enum class LogLevel { INFO, WARNING, ERROR };

extern std::queue<std::function<void()>> tasks;
extern std::mutex mtx;
extern std::condition_variable cv;
extern bool done;

void logWorker();

void logMessageAsync(LogLevel level, const std::string &message);

template <typename... Args>
void logMessage(LogLevel level, const Args &...args);

template <typename T> void append(std::ostringstream &oss, const T &arg);

template <typename T, typename... Args>
void append(std::ostringstream &oss, const T &first, const Args &...args);

#endif // LUACRAFT_LOGGER_H
