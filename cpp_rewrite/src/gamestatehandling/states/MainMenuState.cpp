#include "src/gamestatehandling/states/MainMenuState.h"
#include "src/gamestatehandling/states/SettingsState.h"
#include "src/gamestatehandling/states/VulkanGameState.h"
#include <GLFW/glfw3.h>
#include <ft2build.h>
#include <iostream>
#include <vector>

#include FT_FREETYPE_H

MainMenuState::MainMenuState(FT_Face face, GLFWwindow *window,
                             GameStateManager &manager)
    : fontFace(face), m_window(window), m_manager(manager) {
  titlePositionX = 100.0f;
  titlePositionY = 100.0f;
  option1PositionX = 150.0f;
  option1PositionY = 200.0f;
  option2PositionX = 150.0f;
  option2PositionY = 250.0f;

  titleText = "Menu Principal";
  option1Text = "Option 1";
  option2Text = "Play Game";
}

void MainMenuState::handleInput(GLFWwindow *window) {
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);

  // Gestion des événements de la souris
  if (glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT) == GLFW_PRESS) {
    int width, height;
    glfwGetWindowSize(window, &width, &height);
    double normalizedX = 2.0f * xpos / width - 1.0f;
    double normalizedY = 1.0f - 2.0f * ypos / height;

    // Vérifier si les coordonnées du clic se trouvent dans la zone de l'option
    // 1
    if (isInsideForMainMenu(normalizedX, normalizedY, option1PositionX,
                            option1PositionY, optionWidth, optionHeight)) {
      std::cout << "Transition vers le menu des paramètres..." << std::endl;
      m_manager.set(std::make_unique<SettingsState>(font, window, m_manager));
    }
    // Vérifier si les coordonnées du clic se trouvent dans la zone de l'option
    // 2
    else if (isInsideForMainMenu(normalizedX, normalizedY, option2PositionX,
                                 option2PositionY, optionWidth, optionHeight)) {
      std::cout << "Transition vers la scène 3D avec Vulkan..." << std::endl;
      m_manager.set(std::make_unique<VulkanGameState>(font, window, m_manager));
    }
  }
}

void MainMenuState::update() {
  // Mettre à jour l'état du menu principal si nécessaire
}

void MainMenuState::draw(GLFWwindow *window) {
  // Effacer l'écran
  glClear(GL_COLOR_BUFFER_BIT);

  // Dessiner le titre
  drawTextMainMenu(fontFace, titleText, titlePositionX, titlePositionY,
                   titleFontSize);

  // Dessiner l'option 1
  drawTextMainMenu(fontFace, option1Text, option1PositionX, option1PositionY,
                   optionFontSize);

  // Dessiner l'option 2
  drawTextMainMenu(fontFace, option2Text, option2PositionX, option2PositionY,
                   optionFontSize);

  // Mettre à jour l'affichage
  glfwSwapBuffers(window);
}

// Fonction utilitaire pour vérifier si un point est à l'intérieur d'un
// rectangle
bool MainMenuState::isInsideForMainMenu(double x, double y, double rectX, double rectY,
                         double rectWidth, double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}

// Fonction utilitaire pour dessiner du texte
void MainMenuState::drawTextMainMenu(FT_Face face, const std::string &text, float x, float y,
                      int fontSize) {
  // Configuration de la taille de police
  FT_Set_Pixel_Sizes(face, 0, fontSize);

  // Positionner le texte
  glLoadIdentity();
  glTranslatef(x, y, 0.0f);

  // Dessiner chaque caractère du texte
  for (const char &c : text) {
    // Charger le glyphe correspondant
    if (FT_Load_Char(face, c, FT_LOAD_RENDER))
      continue; // Ignorer les caractères non chargés

    // Récupérer la métrique du glyphe
    FT_GlyphSlot glyph = face->glyph;

    // Dessiner le glyphe
    glRasterPos2i(glyph->bitmap_left, -glyph->bitmap_top);
    glDrawPixels(glyph->bitmap.width, glyph->bitmap.rows, GL_RED,
                 GL_UNSIGNED_BYTE, glyph->bitmap.buffer);

    // Déplacer le curseur de dessin pour le prochain glyphe
    glBitmap(0, 0, 0, 0, glyph->advance.x >> 6, 0, nullptr);
  }
}