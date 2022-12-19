#ifndef LIB_HH
#define LIB_HH

#include <iostream>
//
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

enum AppParams { APP_WIDTH = 400, APP_HEIGHT = 400 };

#define EPS 0.1

#define GREEN 0, 255, 0
#define BLACK 0, 0, 0

#define RECT_SIZE 1.0, 1.0

#ifdef __cplusplus
extern "C" {
#endif

void __glang_print(int num);
int __glang_read();


/**
 * @brief
 *
 * @param argc
 * @param argv
 */
void graph_init();

//! NOTE: sf::Color color;
/**
 * @brief
 *
 * @param r
 * @param g
 * @param b
 */
void window_clear(uint8_t r, uint8_t g, uint8_t b);

/**
 * @brief
 *
 * @return true
 * @return false
 */
bool is_open_window();
/**
 * @brief
 *
 */
void flush();

/**
 * @brief Set the pixel object
 *
 * @param x
 * @param y
 * @param r
 * @param g
 * @param b
 */
void set_pixel(int x, int y, uint8_t r, uint8_t g, uint8_t b);

int get_random_val();

#ifdef __cplusplus
}
#endif

#endif //!  LIB_HH