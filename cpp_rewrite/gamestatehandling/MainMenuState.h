#pragma once
#include "gamestatehandling/GameState.h"
#include "gamestatehandling/GameStateManager.h"

class MainMenuState : public GameState {
public:
  MainMenuState(sf::Font &font, GameStateManager &manager);

  void handleInput(sf::RenderWindow &window) override;
  void update() override;
  void draw(sf::RenderWindow &window) override;

private:
  sf::Font &font;
  sf::Text title;
  sf::Text option1;
  GameStateManager &manager;
};
