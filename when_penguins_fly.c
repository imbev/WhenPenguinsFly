#include <assert.h>
#include <SDL3/SDL.h>
#include "assets.h"

int main(void) {
    assert(SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_EVENTS));

    SDL_Renderer *renderer;
    SDL_Window *window;

    SDL_CreateWindowAndRenderer("When Penguins Fly", 1150, 650, 0, &window, 
        &renderer);
    
    assert(renderer);
    assert(window);

    SDL_Texture *background = assets_images_cloud_mountains_background(renderer);

    SDL_Event e;
    bool running = true;

    while (running) {
        while (SDL_PollEvent(&e)) {
            switch (e.type) {
                case SDL_EVENT_QUIT:
                    running = false;
                    break;
            }
        }

        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);
        SDL_RenderClear(renderer);

        SDL_FRect background_src_rect = { .w = 500, .h = 500, .y = 250 };
        SDL_RenderTexture(renderer, background, &background_src_rect, NULL);

        SDL_RenderPresent(renderer);
    }

    SDL_Quit();
    return 0;
}
