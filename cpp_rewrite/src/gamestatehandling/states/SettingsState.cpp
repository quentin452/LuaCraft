#include "SettingsState.h"
#include "MainMenuState.h"
#include <GLFW/glfw3.h>
#include <ft2build.h>
#include <iostream>

#include FT_FREETYPE_H

SettingsState::SettingsState(FT_Face face, GLFWwindow *window,
                             GameStateManager &manager)
    : fontFace(face), m_window(window), m_manager(manager) {
  titleText = "Paramètres";
  option1Text = "Option 1";

  titlePositionX = 250;
  titlePositionY = 50;
  option1PositionX = 300;
  option1PositionY = 200;

  titleFontSize = 50;
  optionFontSize = 30;
}

void SettingsState::handleInput(GLFWwindow *window) {
  int width, height;
  glfwGetWindowSize(window, &width, &height);
  double xpos, ypos;
  glfwGetCursorPos(window, &xpos, &ypos);
  int mouseState = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  if (mouseState == GLFW_PRESS && !mouseButtonPressed) {
    std::cout << "Transition vers le menu des paramètres..." << std::endl;

    mouseButtonPressed = true;
    if (isInsideForSettings(xpos, ypos, option1PositionX, option1PositionY,
                            optionWidth, optionHeight)) {
      std::cout << "Transition vers le menu principal..." << std::endl;
      m_manager.set(std::make_unique<MainMenuState>(font, window, m_manager));
    }
  } else if (mouseState == GLFW_RELEASE) {
    mouseButtonPressed = false;
  }
}
void SettingsState::update() {
  // Mettre à jour l'état des paramètres si nécessaire
}

void SettingsState::draw(GLFWwindow *window) {
  // Dessiner le titre
  drawTextSettings(fontFace, titleText, titlePositionX, titlePositionY,
                   titleFontSize);
  // Dessiner l'option 1
  drawTextSettings(fontFace, option1Text, option1PositionX, option1PositionY,
                   optionFontSize);

  // Dessiner d'autres éléments des paramètres si nécessaire
}

// Fonction utilitaire pour vérifier si un point est à l'intérieur d'un
// rectangle
bool SettingsState::isInsideForSettings(double x, double y, double rectX,
                                        double rectY, double rectWidth,
                                        double rectHeight) {
  return x >= rectX && x <= rectX + rectWidth && y >= rectY &&
         y <= rectY + rectHeight;
}

// Fonction utilitaire pour dessiner du texte
void SettingsState::drawTextSettings(FT_Face face, const std::string &text,
                                     float x, float y, int fontSize) {
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