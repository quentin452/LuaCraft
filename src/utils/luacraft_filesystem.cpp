#include "luacraft_filesystem.h"
#include "luacraft_logger.h"
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <string>
#include <sys/stat.h>

bool luacraft_filesystem::directoryExists(const std::string &path) {
  struct stat info;
  if (stat(path.c_str(), &info) != 0)
    return false;
  else if (info.st_mode & S_IFDIR)
    return true;
  else
    return false;
}

bool luacraft_filesystem::fileExists(const std::string &filename) {
  struct stat buffer;
  return (stat(filename.c_str(), &buffer) == 0);
}

bool luacraft_filesystem::createDirectories(const std::string &path) {
  if (!directoryExists(path)) {
    std::string command = "mkdir " + path;
    if (system(command.c_str()) != 0) {
      std::cerr << "Error: Unable to create directory " << path << ".\n";
      return false;
    }
  }
  return true;
}

bool luacraft_filesystem::createFile(const std::string &filename) {
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