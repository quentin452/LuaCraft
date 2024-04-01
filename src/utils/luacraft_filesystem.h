#ifndef LUACRAFT_FILESYSTEM_H
#define LUACRAFT_FILESYSTEM_H

#include <string>

class luacraft_filesystem {
public:
  static bool fileExists(const std::string &filename);
  static bool createFile(const std::string &filename);
  static bool directoryExists(const std::string &path);
  static bool createDirectories(const std::string &path);
};

#endif // LUACRAFT_FILESYSTEM_H
