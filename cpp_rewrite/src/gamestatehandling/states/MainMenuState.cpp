#include "src/gamestatehandling/states/MainMenuState.h"
#include "src/gamestatehandling/states/SettingsState.h"
#include <SFML/Graphics.hpp>
#include <iostream>

MainMenuState::MainMenuState(sf::Font &font, GameStateManager &manager)
    : font(font), manager(manager) {
  title.setString("Menu Principal");
  title.setFont(font);
  title.setCharacterSize(50);
  title.setPosition(250, 50);

  option1.setString("Option 1");
  option1.setFont(font);
  option1.setCharacterSize(30);
  option1.setPosition(300, 200);
}

void MainMenuState::handleInput(sf::RenderWindow &window) {
  sf::Event event;
  while (window.pollEvent(event)) {
    if (event.type == sf::Event::Closed)
      window.close();
    if (event.type == sf::Event::MouseButtonPressed) {
      if (event.mouseButton.button == sf::Mouse::Left) {
        if (option1.getGlobalBounds().contains(
                static_cast<float>(event.mouseButton.x),
                static_cast<float>(event.mouseButton.y))) {
          std::cout << "Transition vers le menu des paramètres..." << std::endl;
          manager.set(std::make_unique<SettingsState>(font, manager));
        }
      }
    }
  }
}

void MainMenuState::update() {
  // Mettre à jour l'état du menu principal
}

void MainMenuState::draw(sf::RenderWindow &window) {
  window.draw(title);
  window.draw(option1);
  // Dessiner d'autres éléments du menu principal si nécessaire
}
