#include <iostream>
#include <sstream>
#include <string>

enum class LogLevel {
    INFO,
    WARNING,
    ERROR
};

// Fonction récursive pour concaténer les arguments
template <typename T>
void append(std::ostringstream &oss, const T &arg) {
    oss << arg;
}

template <typename T, typename... Args>
void append(std::ostringstream &oss, const T &first, const Args &...args) {
    oss << first;
    append(oss, args...);
}

// Fonction template variadique pour accepter un nombre variable d'arguments
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