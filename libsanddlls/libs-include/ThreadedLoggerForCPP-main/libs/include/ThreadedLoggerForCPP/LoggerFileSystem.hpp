#ifndef LOGGERFILESYSTEM_HPP
#define LOGGERFILESYSTEM_HPP

#include <ThreadedLoggerForCPP/LoggerThread.hpp>
#include <string>
#include <sys/stat.h>
#include <fstream>
#include <iostream>

class LoggerFileSystem {
public:
  static bool fileExists(const std::string &filename) {
    struct stat buffer;
    return (stat(filename.c_str(), &buffer) == 0);
  }

  static bool createFile(const std::string &filename) {
    if (fileExists(filename)) {
      return false;
    }

    std::ofstream file(filename);
    if (!file.is_open()) {
      std::cerr << "Error: Unable to create file " << filename << ".\n";
      return false;
    }

    file.close();
    return true;
  }

  static bool directoryExists(const std::string &path) {
    struct stat info;
    if (stat(path.c_str(), &info) != 0)
      return false;
    else if (info.st_mode & S_IFDIR)
      return true;
    else
      return false;
  }

  static bool createDirectories(const std::string &path) {
    if (!directoryExists(path)) {
      std::string command = "mkdir " + path;
      if (system(command.c_str()) != 0) {
        std::cerr << "Error: Unable to create directory " << path << ".\n";
        return false;
      }
    }
    return true;
  }
};

#endif // LOGGERFILESYSTEM_HPP
