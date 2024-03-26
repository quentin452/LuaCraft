#pragma once
#include <SFML/Graphics.hpp>

class GameState {
public:
  virtual void handleInput(sf::RenderWindow &window) = 0;
  virtual void update() = 0;
  virtual void draw(sf::RenderWindow &window) = 0;
  virtual ~GameState() {}
};