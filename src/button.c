#include "button.h"

bool button_is_hovered(struct Button *button, float mouse_x, float mouse_y) {
  return mouse_x > button->rect.x &&
         mouse_x < button->rect.x + button->rect.w &&
         mouse_y > button->rect.y && mouse_y < button->rect.y + button->rect.h;
}
