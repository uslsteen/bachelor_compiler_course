#include "lib.hh"
#include <SFML/Graphics.hpp>

//! NOTE: imagine here SfmlImpl class realziation
static sf::RenderWindow window;
static sf::Image buffer;
static sf::Texture texture;
static sf::Sprite sprite;
//

#ifdef __cplusplus
extern "C" {
#endif

void __glang_print(int num) { std::cout << num << std::endl; }

int __glang_read() {
  int num;
  std::cin >> num;
  if (!std::cin) {
    std::cerr << "Error : bad input " << num << std::endl;
    exit(1);
  }
  return num;
}

void graph_init() {
  uint32_t h = AppParams::APP_HEIGHT, w = AppParams::APP_WIDTH;
  //
  window.create(sf::VideoMode(w, h), "Game of Life");
  buffer.create(w, h, sf::Color(BLACK));
  //
  //! NOTE: maybe it not useful
  window.setVerticalSyncEnabled(true);
}

void window_clear(uint8_t r, uint8_t g, uint8_t b) {
  window.clear(sf::Color{r, g, b});
}

void flush() { window.display(); }

bool is_open_window() { return window.isOpen(); }

void set_pixel(int x, int y, uint8_t r, uint8_t g, uint8_t b) {
  sf::RectangleShape pixel{sf::Vector2f(RECT_SIZE)};
  pixel.setFillColor(sf::Color{r, g, b});
  pixel.setPosition(sf::Vector2f(x, y));

  window.draw(pixel);
}

int get_random_val() {
  double radius = (double)rand() / RAND_MAX;
  return radius < EPS;
}
#ifdef __cplusplus
}
#endif
