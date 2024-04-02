#pragma once
#include "../../core/GameStateManager.h"
#include <string>
class OpenGLGameState : public GameState {
public:
  OpenGLGameState(SDL_Window *window, GameStateManager &manager);

  void handleInput(SDL_Window *window) override;
  void update() override;
  void draw(SDL_Window *window) override;

  void cleanup() override {
    glDeleteBuffers(1, &m_VBO);
    glDeleteVertexArrays(1, &m_VAO);
    glDeleteProgram(m_shaderProgram);
    m_shaderProgram = 0;
  }

private:
  SDL_Window *m_window;
  GameStateManager &manager;
  GLuint m_shaderProgram;
  const char *vertexShaderSource =
      "#version 330 core\n"
      "layout (location = 0) in vec3 aPos;\n"
      "void main() {\n"
      "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
      "}\0";
  const char *fragmentShaderSource =
      "#version 330 core\n"
      "out vec4 FragColor;\n"
      "void main() {\n"
      "   FragColor = vec4(1.0, 0.5, 0.2, 1.0);\n"
      "}\0";
  GLuint m_VAO;
  GLuint m_VBO;
  GLuint compileAndLinkShaders();
  GLuint compileShader(GLenum shaderType, const char *shaderSource);
};