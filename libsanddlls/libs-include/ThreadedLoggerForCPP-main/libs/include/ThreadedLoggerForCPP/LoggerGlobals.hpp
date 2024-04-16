#ifndef LOGGERGLOBALS_HPP
#define LOGGERGLOBALS_HPP

#include <atomic>
#include <mutex>
#include <string>
#include <thread>

class LoggerGlobals {
public:
  static inline std::string UsernameDirectory;
  static inline std::string LogFilePath;
  static inline std::string LogFolderPath;
  static inline std::string LogFolderBackupPath;
  static inline std::string LogFileBackupPath;
  static inline std::string SrcProjectDirectory;
};

#endif
