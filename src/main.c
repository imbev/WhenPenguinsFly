#include "button.h"
#include <SDL3/SDL_events.h>
#include <SDL3/SDL_init.h>
#include <SDL3/SDL_mouse.h>
#include <SDL3/SDL_oldnames.h>
#include <SDL3/SDL_pixels.h>
#include <SDL3/SDL_rect.h>
#include <SDL3/SDL_render.h>
#include <SDL3/SDL_surface.h>
#include <SDL3/SDL_video.h>
#include <SDL3_image/SDL_image.h>
#include <SDL3_ttf/SDL_ttf.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#define TITLE "When Penguins Fly"
#define WIDTH 1152
#define HEIGHT 650

#define BASE_PATH "./assets/"

#define COLOR_BLACK 0, 0, 0, 0
#define COLOR_WHITE 255, 255, 255, 255

enum MainMenuButton {
  MAIN_MENU_BUTTON_PLAY,
  MAIN_MENU_BUTTON_QUIT,
  MAIN_MENU_BUTTON_COUNT
};

void game_quit(bool *running) { *running = false; }

int main(void) {
  SDL_Window *window;
  SDL_Renderer *renderer;

  if (!SDL_Init(SDL_INIT_VIDEO)) {
    printf("Failed to init SDL: %s\n", SDL_GetError());
    return EXIT_FAILURE;
  }

  if (!TTF_Init()) {
    printf("Failed to init SDL TTF: %s\n", SDL_GetError());
    return EXIT_FAILURE;
  }

  SDL_CreateWindowAndRenderer(TITLE, WIDTH, HEIGHT, 0, &window, &renderer);

  if (window == NULL || renderer == NULL) {
    printf("Failed to create window or renderer: %s\n", SDL_GetError());
  }

  SDL_Cursor *cursor_default =
      SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_DEFAULT);
  SDL_Cursor *cursor_pointer =
      SDL_CreateSystemCursor(SDL_SYSTEM_CURSOR_POINTER);

  TTF_Font *font_small = TTF_OpenFont(BASE_PATH "fonts/Roboto-Regular.ttf", 24);
  TTF_Font *font_large = TTF_OpenFont(BASE_PATH "fonts/Roboto-Regular.ttf", 64);

  SDL_FRect window_rect = {.w = WIDTH, .h = HEIGHT, .x = 0, .y = 0};

  float mouse_x;
  float mouse_y;

  SDL_Surface *background_main_menu_surface =
      IMG_Load(BASE_PATH "images/cloud-mountains-background.png");
  SDL_Texture *background_main_menu_texture =
      SDL_CreateTextureFromSurface(renderer, background_main_menu_surface);
  SDL_FRect background_main_menu_rect = {
      .w = WIDTH, .h = 150, .x = 0, .y = 250};

  SDL_Surface *main_menu_title_surface = TTF_RenderText_Blended(
      font_large, "When Penguins Fly", 0, (SDL_Color){COLOR_WHITE});
  SDL_Texture *main_menu_title_texture =
      SDL_CreateTextureFromSurface(renderer, main_menu_title_surface);
  SDL_FRect main_menu_title_rect = {.w = main_menu_title_texture->w,
                                    .h = main_menu_title_texture->h,
                                    .x = (float)WIDTH / 2 -
                                         (float)main_menu_title_texture->w / 2,
                                    .y = 200};

  struct Button main_menu_buttons[MAIN_MENU_BUTTON_COUNT];
  {
    main_menu_buttons[MAIN_MENU_BUTTON_PLAY] = (struct Button){
        .label = "Play",
        .rect = {.w = 200, .h = 36, .x = ((float)WIDTH / 2) - 100, .y = 360},
        .label_color = {.r = 255, .g = 255, .b = 255, .a = 255},
        .background_color = {.r = 75, .g = 86, .b = 86, .a = 255},
        .background_hovered_color = {.r = 95, .g = 106, .b = 106, .a = 255}};

    main_menu_buttons[MAIN_MENU_BUTTON_QUIT] = (struct Button){
        .label = "Quit",
        .rect = {.w = 200, .h = 36, .x = ((float)WIDTH / 2) - 100, .y = 460},
        .label_color = {.r = 255, .g = 255, .b = 255, .a = 255},
        .background_color = {.r = 75, .g = 86, .b = 86, .a = 255},
        .background_hovered_color = {.r = 95, .g = 106, .b = 106, .a = 255}};
  }

  SDL_Surface *main_menu_button_label_surfaces[MAIN_MENU_BUTTON_COUNT];
  {
    main_menu_button_label_surfaces[MAIN_MENU_BUTTON_QUIT] =
        TTF_RenderText_Blended(
            font_small, main_menu_buttons[MAIN_MENU_BUTTON_QUIT].label, 0,
            main_menu_buttons[MAIN_MENU_BUTTON_QUIT].label_color);

    main_menu_button_label_surfaces[MAIN_MENU_BUTTON_PLAY] =
        TTF_RenderText_Blended(
            font_small, main_menu_buttons[MAIN_MENU_BUTTON_PLAY].label, 0,
            main_menu_buttons[MAIN_MENU_BUTTON_PLAY].label_color);
  }

  SDL_Texture *main_menu_button_label_textures[MAIN_MENU_BUTTON_COUNT];
  {
    main_menu_button_label_textures[MAIN_MENU_BUTTON_QUIT] =
        SDL_CreateTextureFromSurface(
            renderer, main_menu_button_label_surfaces[MAIN_MENU_BUTTON_QUIT]);

    main_menu_button_label_textures[MAIN_MENU_BUTTON_PLAY] =
        SDL_CreateTextureFromSurface(
            renderer, main_menu_button_label_surfaces[MAIN_MENU_BUTTON_PLAY]);
  }

  SDL_FRect main_menu_button_label_rects[MAIN_MENU_BUTTON_COUNT];
  {
    main_menu_button_label_rects[MAIN_MENU_BUTTON_QUIT] = (SDL_FRect){
        .w = main_menu_button_label_textures[MAIN_MENU_BUTTON_QUIT]->w,
        .h = main_menu_button_label_textures[MAIN_MENU_BUTTON_QUIT]->h,
        .x = main_menu_buttons[MAIN_MENU_BUTTON_QUIT].rect.x +
             main_menu_buttons[MAIN_MENU_BUTTON_QUIT].rect.w / 2 -
             (float)main_menu_button_label_textures[MAIN_MENU_BUTTON_QUIT]->w /
                 2,
        .y = main_menu_buttons[MAIN_MENU_BUTTON_QUIT].rect.y +
             main_menu_buttons[MAIN_MENU_BUTTON_QUIT].rect.h / 2 -
             (float)main_menu_button_label_textures[MAIN_MENU_BUTTON_QUIT]->h /
                 2};

    main_menu_button_label_rects[MAIN_MENU_BUTTON_PLAY] = (SDL_FRect){
        .w = main_menu_button_label_textures[MAIN_MENU_BUTTON_PLAY]->w,
        .h = main_menu_button_label_textures[MAIN_MENU_BUTTON_PLAY]->h,
        .x = main_menu_buttons[MAIN_MENU_BUTTON_PLAY].rect.x +
             main_menu_buttons[MAIN_MENU_BUTTON_PLAY].rect.w / 2 -
             (float)main_menu_button_label_textures[MAIN_MENU_BUTTON_PLAY]->w /
                 2,
        .y = main_menu_buttons[MAIN_MENU_BUTTON_PLAY].rect.y +
             main_menu_buttons[MAIN_MENU_BUTTON_PLAY].rect.h / 2 -
             (float)main_menu_button_label_textures[MAIN_MENU_BUTTON_PLAY]->h /
                 2};
  }

  bool running = true;
  SDL_Event event;

  bool mouse_button_down;
  bool button_hovered = false;

  while (running) {
    mouse_button_down = false;
    button_hovered = false;

    while (SDL_PollEvent(&event)) {
      switch (event.type) {
      case SDL_EVENT_QUIT:
        game_quit(&running);
        break;
      case SDL_EVENT_MOUSE_BUTTON_DOWN:
        mouse_button_down = true;
        break;
      }
    }

    SDL_GetMouseState(&mouse_x, &mouse_y);

    SDL_Color button_color[MAIN_MENU_BUTTON_COUNT];

    for (size_t i = 0; i < MAIN_MENU_BUTTON_COUNT; i++) {
      if (button_is_hovered(&main_menu_buttons[i], mouse_x, mouse_y)) {
        button_hovered = true;
        button_color[i] = main_menu_buttons[i].background_hovered_color;

        if (mouse_button_down) {
          switch (i) {
          case MAIN_MENU_BUTTON_PLAY:
            printf("Play\n");
            break;
          case MAIN_MENU_BUTTON_QUIT:
            game_quit(&running);
            break;
          }
        }
      } else {
        button_color[i] = main_menu_buttons[i].background_color;
      }
    }

    if (button_hovered) {
      SDL_SetCursor(cursor_pointer);
    } else {
      SDL_SetCursor(cursor_default);
    }

    SDL_SetRenderDrawColor(renderer, COLOR_BLACK);
    SDL_RenderClear(renderer);

    SDL_RenderTexture(renderer, background_main_menu_texture,
                      &background_main_menu_rect, &window_rect);

    SDL_SetRenderDrawColor(renderer, COLOR_WHITE);
    SDL_RenderTexture(renderer, main_menu_title_texture, NULL,
                      &main_menu_title_rect);

    for (size_t i = 0; i < MAIN_MENU_BUTTON_COUNT; i++) {
      SDL_SetRenderDrawColor(renderer, button_color[i].r, button_color[i].g,
                             button_color[i].b, button_color[i].a);
      SDL_RenderFillRect(renderer, &main_menu_buttons[i].rect);

      SDL_SetRenderDrawColor(renderer, COLOR_WHITE);
      SDL_RenderTexture(renderer, main_menu_button_label_textures[i], NULL,
                        &main_menu_button_label_rects[i]);
    }

    SDL_RenderPresent(renderer);
  }

  for (size_t i = 0; i < MAIN_MENU_BUTTON_COUNT; i++) {
    SDL_DestroySurface(main_menu_button_label_surfaces[i]);
    SDL_DestroyTexture(main_menu_button_label_textures[i]);
  }

  SDL_DestroySurface(background_main_menu_surface);
  SDL_DestroyTexture(background_main_menu_texture);

  SDL_DestroySurface(main_menu_title_surface);
  SDL_DestroyTexture(main_menu_title_texture);

  TTF_CloseFont(font_small);
  TTF_CloseFont(font_large);

  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);

  return EXIT_SUCCESS;
}