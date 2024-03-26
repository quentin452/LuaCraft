#include "gamestatehandling/GameStateManager.h"
#include "gamestatehandling/MainMenuState.h"
#include "gamestatehandling/SettingsState.h"
#include <SFML/Graphics.hpp>
#include <iostream>

int main() {
  sf::RenderWindow window(sf::VideoMode(1280, 720), "Menu Principal");

  sf::Font font;
  if (!font.loadFromFile("arial.ttf")) {
    std::cerr << "Erreur lors du chargement de la police de caractères."
              << std::endl;
    return 1;
  }

  GameStateManager manager;
  manager.set(std::make_unique<MainMenuState>(font, manager));

  while (window.isOpen()) {
    window.clear();
    manager.get().handleInput(window);
    manager.get().update();
    manager.get().draw(window);
    window.display();
  }

  return 0;
}