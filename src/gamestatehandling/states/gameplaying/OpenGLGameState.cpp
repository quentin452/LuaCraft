#include "OpenGLGameState.h"
#include <GLFW/glfw3.h>
#include <iostream>
// Définir les données de vertex
GLfloat vertices[] = {
    // Position
    -1.0f, -1.0f, 0.0f, // Vertex 1
    1.0f,  -1.0f, 0.0f, // Vertex 2
    0.0f,  1.0f,  0.0f  // Vertex 3
};

OpenGLGameState::OpenGLGameState(GLFWwindow *window, GameStateManager &manager)
    : m_window(window), manager(manager) {
  // Initialisation OpenGL
  glEnable(GL_DEPTH_TEST); // Activer le test de profondeur

  // Compiler et lier les shaders
  m_shaderProgram = compileAndLinkShaders();

  // Générer un VAO et lier
  glGenVertexArrays(1, &m_VAO);
  glBindVertexArray(m_VAO);

  // Générer un VBO et lier pour stocker les données de vertex
  glGenBuffers(1, &m_VBO);
  glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

  // Spécifier comment les données de vertex sont organisées
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat),
                        (GLvoid *)0);
  glEnableVertexAttribArray(0);

  // Délier VAO et VBO
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);
}

void OpenGLGameState::handleInput(GLFWwindow *window) {
  // Gérer les entrées utilisateur pour OpenGLGameState
}

void OpenGLGameState::update() {
  // Mettre à jour l'état de OpenGLGameState
}

void OpenGLGameState::draw(GLFWwindow *window) {
  // Effacer l'écran
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  // Utiliser le programme de shader
  glUseProgram(m_shaderProgram);

  // Lier le VAO
  glBindVertexArray(m_VAO);

  // Dessiner le triangle à partir des données de vertex
  glDrawArrays(GL_TRIANGLES, 0, 3);

  // Délier le VAO
  glBindVertexArray(0);

  // Échanger les tampons avant et arrière
  glfwSwapBuffers(window);
}

GLuint OpenGLGameState::compileAndLinkShaders() {
  // Compiler les shaders
  GLuint vertexShader = compileShader(GL_VERTEX_SHADER, vertexShaderSource);
  GLuint fragmentShader =
      compileShader(GL_FRAGMENT_SHADER, fragmentShaderSource);

  // Créer un programme de shader et le lier
  GLuint shaderProgram = glCreateProgram();
  glAttachShader(shaderProgram, vertexShader);
  glAttachShader(shaderProgram, fragmentShader);
  glLinkProgram(shaderProgram);

  // Vérifier les erreurs de liaison
  GLint success;
  glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
  if (!success) {
    // Afficher les erreurs
    GLchar infoLog[512];
    glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
    std::cerr << "Erreur lors de la liaison du programme de shader : "
              << infoLog << std::endl;
  }

  // Supprimer les shaders une fois qu'ils sont liés
  glDeleteShader(vertexShader);
  glDeleteShader(fragmentShader);

  return shaderProgram;
}

GLuint OpenGLGameState::compileShader(GLenum shaderType,
                                      const char *shaderSource) {
  // Compiler le shader
  GLuint shader = glCreateShader(shaderType);
  glShaderSource(shader, 1, &shaderSource, NULL);
  glCompileShader(shader);

  // Vérifier les erreurs de compilation
  GLint success;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
  if (!success) {
    // Afficher les erreurs
    GLchar infoLog[512];
    glGetShaderInfoLog(shader, 512, NULL, infoLog);
    std::cerr << "Erreur lors de la compilation du shader : " << infoLog
              << std::endl;
  }

  return shader;
}