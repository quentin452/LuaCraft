#include <glew.h>

#include "gamestatehandling/core/GameStateManager.h"
#include "gamestatehandling/states/MainMenuState.h"
#include "gamestatehandling/states/SettingsState.h"
#include "gamestatehandling/states/VulkanGameState.h"
#include "gltext.h"
#include "utils/luacraft_logger.h"
#include <GLFW/glfw3.h>
#include <iostream>

#define WINDOW_WIDTH 1280
#define WINDOW_HEIGHT 720

static GameStateManager *g_Manager;

void framebufferSizeCallback(GLFWwindow *window, int width, int height) {
    glViewport(0, 0, width, height);
    if (g_Manager) {
        g_Manager->get().framebufferSizeCallbackGameState(window, width, height);
        g_Manager->get().calculateButtonPositionsAndSizes(window);
    }
}

int main() {
    double elapsedTime = 0.0;
    const double inputDelay = 0.1;
    if (!glfwInit()) {
        logMessage(LogLevel::ERROR, "Error during GLFW Initializations");
        return 1;
    }
    GLFWwindow *window =
        glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LuaCraft", NULL, NULL);
    if (!window) {
        logMessage(LogLevel::ERROR, "Error during creating GLFW Windows");
        glfwTerminate();
        return 1;
    }
    int api = glfwGetWindowAttrib(window, GLFW_CLIENT_API);
    const char *apiName = (api == GLFW_OPENGL_API) ? "OpenGL" : "Vulkan";
    logMessage(LogLevel::INFO, "Graphical API Used : ",apiName);
    glfwMakeContextCurrent(window);
    glewExperimental = GL_TRUE;
    if (glewInit() != GLEW_OK) {
        logMessage(LogLevel::ERROR, "Erorr during GLEW Initializations");
        glfwTerminate();
        return 1;
    }
    GameStateManager manager;
    manager.set(std::make_unique<MainMenuState>(window, manager));
    g_Manager = &manager;
    glfwSwapInterval(0); // disable Vsync
    while (!glfwWindowShouldClose(window)) {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glfwSetFramebufferSizeCallback(window, framebufferSizeCallback);
        elapsedTime = glfwGetTime() - manager.getLastStateChangeTime();
        if (elapsedTime >= inputDelay) {
            manager.get().handleInput(window);
        }
        manager.get().update();
        manager.get().draw(window);
        // TODO FIX glfwPollEvents causing lags when moving mouse
        glfwPollEvents();
    }
    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}