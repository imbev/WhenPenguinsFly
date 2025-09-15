#include "assets.h"

SDL_Texture *assets_images_cloud_mountains_background(SDL_Renderer *renderer) {
    const char data[] = {
        #embed "../assets/images/cloud-mountains-background.png"
    };
    return IMG_LoadTexture_IO(renderer, SDL_IOFromConstMem(data, sizeof(data)), true);
}
