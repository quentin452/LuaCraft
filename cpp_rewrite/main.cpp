#include <libs/SFML-2.6.1/include/SFML/Graphics.hpp>

int main() {
    sf::RenderWindow window(sf::VideoMode(1280, 720), "Ma première fenêtre SFML");
    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        // Effacer l'écran avec une couleur de fond
        window.clear(sf::Color::White);
        window.display();
    }
    return 0;
}