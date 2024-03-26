#include "gamestatehandling/SettingsState.h"
#include "gamestatehandling/MainMenuState.h"
#include <SFML/Graphics.hpp>
#include <iostream>

SettingsState::SettingsState(sf::Font &font, GameStateManager &manager)
    : font(font), manager(manager) {
  title.setString("Paramètres");
  title.setFont(font);
  title.setCharacterSize(50);
  title.setPosition(250, 50);

  option1.setString("Option 1");
  option1.setFont(font);
  option1.setCharacterSize(30);
  option1.setPosition(300, 200);
}

void SettingsState::handleInput(sf::RenderWindow &window) {
  sf::Event event;
  while (window.pollEvent(event)) {
    if (event.type == sf::Event::Closed)
      window.close();
    if (event.type == sf::Event::MouseButtonPressed) {
      if (event.mouseButton.button == sf::Mouse::Left) {
        if (option1.getGlobalBounds().contains(
                static_cast<float>(event.mouseButton.x),
                static_cast<float>(event.mouseButton.y))) {
          std::cout << "Transition vers le main menu..." << std::endl;
          manager.set(std::make_unique<MainMenuState>(font, manager));
        }
      }
    }
  }
}

void SettingsState::update() {
  // Mettre à jour l'état des paramètres
}

void SettingsState::draw(sf::RenderWindow &window) {
  window.draw(title);
  window.draw(option1);
  // Dessiner d'autres éléments des paramètres si nécessaire
}
