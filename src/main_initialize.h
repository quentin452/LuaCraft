#include <GL/glew.h>
#include <GLFW/glfw3.h>
#ifndef MainInitialize_H
#define MainInitialize_H

class MainInitialize {
public:
  static void InitializeContexts(GLFWwindow *window);

private:
  static void initializeSDL();
  static void initializeSDLImage();
  static void initializeSDLTTF();

  static void initializeSDLMixer();

  static void initializeGLFW();
  static void initializeGLEW(GLFWwindow *window);
  static void initializeGLEWWindows(GLFWwindow *window);
};
#endif // MainInitialize_H