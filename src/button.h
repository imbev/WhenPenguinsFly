#ifndef BUTTON_H
#define BUTTON_H

#include <SDL3/SDL_pixels.h>
#include <SDL3/SDL_rect.h>

struct Button {
    const char *label;
    SDL_FRect rect;
    SDL_Color label_color;
    SDL_Color background_color;
    SDL_Color background_hovered_color;
};

bool button_is_hovered(struct Button *button, float mouse_x, float mouse_y);

#endif
