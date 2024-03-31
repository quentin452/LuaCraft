#include "view.hpp"
#include "imgui-backend/backends/imgui_impl_opengl3.h"
#include "imgui-backend/backends/imgui_impl_sdl2.h"
#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <imgui/imgui.h>
#include <iostream>

bool View::init(std::string _name, int W, int H) {
  enabled = windowed;
  WIDTH = W;
  HEIGHT = H;

#ifndef TINYENGINE_COMPATIBILITY
  if (antialias)
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, antialias);
#endif

  // Initialize the Window and Context
  Uint32 windowflags = SDL_WINDOW_OPENGL;
  if (!windowed)
    windowflags = windowflags | SDL_WINDOW_HIDDEN;

  gWindow =
      SDL_CreateWindow(_name.c_str(), SDL_WINDOWPOS_UNDEFINED,
                       SDL_WINDOWPOS_UNDEFINED, WIDTH, HEIGHT, windowflags);
  if (gWindow == NULL) {
    printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
    return false;
  }
  SDL_SetWindowResizable(gWindow, SDL_TRUE);

  gContext = SDL_GL_CreateContext(gWindow);
  if (gContext == NULL) {
    printf("Context could not be created! SDL_Error: %s\n", SDL_GetError());
    return false;
  }

  SDL_GL_SetSwapInterval(vsync);
  glewExperimental = GL_TRUE; // Launch GLEW
  glewInit();

  IMGUI_CHECKVERSION(); // Setup ImGUI
  ImGui::CreateContext();
  io = ImGui::GetIO();
  (void)io;
  ImGui_ImplSDL2_InitForOpenGL(gWindow, gContext);
#ifndef TINYENGINE_COMPATIBILITY
  ImGui_ImplOpenGL3_Init("#version 330 core");
#else
  ImGui_ImplOpenGL3_Init("#version 130");
#endif
  ImGui::StyleColorsClassic();

#ifndef TINYENGINE_COMPATIBILITY
  if (antialias)
    glEnable(GL_MULTISAMPLE);
#endif

  glEnable(GL_DEPTH_TEST); // Setup Global OpenGL State!
  glDepthFunc(GL_LEQUAL);

  if (blend) {
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  }

  glEnable(GL_CULL_FACE);
  if (ccw)
    glFrontFace(GL_CCW);
  else
    glFrontFace(GL_CW);
  glLineWidth(lineWidth);
  glPointSize(pointSize);
  glBindFramebuffer(GL_FRAMEBUFFER, 0);

  std::cout << glGetString(GL_VERSION) << std::endl;

  return true;
}

void View::quit() {
  ImGui_ImplOpenGL3_Shutdown(); // Shutdown ImGUI
  ImGui_ImplSDL2_Shutdown();
  ImGui::DestroyContext();

  SDL_GL_DeleteContext(gContext);
  SDL_DestroyWindow(gWindow);
}

void View::render() {
  (pipeline)(); // User-Defined Pipeline call

  if (showInterface) // Draw the interface on top
    drawInterface();

  SDL_GL_SwapWindow(gWindow); // Update Window
}

void View::drawInterface() {
  ImGui_ImplOpenGL3_NewFrame();
  ImGui_ImplSDL2_NewFrame();
  ImGui::NewFrame();

  (interface)(); // Draw user-defined interface
  // ImGui::ShowDemoWindow();  //Demo-Window (if you want)

  ImGui::Render();
  glViewport(0, 0, (int)io.DisplaySize.x, (int)io.DisplaySize.y);
  ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
}

void View::target(glm::vec3 clearcolor, bool clearc, bool cleard) {
  glBindFramebuffer(GL_FRAMEBUFFER, 0);
  glViewport(0, 0, WIDTH, HEIGHT);
  glClearColor(clearcolor.x, clearcolor.y, clearcolor.z, 1.0f);
  if (clearc)
    glClear(GL_COLOR_BUFFER_BIT);
  if (cleard)
    glClear(GL_DEPTH_BUFFER_BIT);
}
