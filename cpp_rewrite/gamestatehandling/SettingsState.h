#pragma once
#include "gamestatehandling/GameState.h"
#include "gamestatehandling/GameStateManager.h"

class SettingsState : public GameState {
public:
  SettingsState(sf::Font &font, GameStateManager &manager);

  void handleInput(sf::RenderWindow &window) override;
  void update() override;
  void draw(sf::RenderWindow &window) override;

private:
  sf::Font &font;
  sf::Text title;
  sf::Text option1;
  GameStateManager &manager;
};
