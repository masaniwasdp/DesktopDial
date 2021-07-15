/**
  Desegnas teksturojn de rektanguloj.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.texture;

import derelict.sdl2.sdl;
import desktopdial.view.data : Color, Size;
import sdlraii.except;
import sdlraii.raii;

/** Proprieto de teksturoj. */
struct TextureProperty
{
    TextureShape shape; /// Formo.

    Color foreground; /// Antaŭa koloro.
    Color background; /// Fona koloro.
}

/** Formo de teksturoj. */
struct TextureShape
{
    int d; /// La distanco de centro.
    int w; /// Larĝo.
    int h; /// Alteco.
}

/**
  Kreas teksturon kun rektangulo desegnita.

  Params: renderer = Rendisto por desegni.
          property = Proprieto de rektangulo, kiun desegnos.

  Returns: Teksturo kun rektangulo desegnita.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
SDL_Texture* create(SDL_Renderer* renderer, in TextureProperty property)
{
    Size size = void;

    SDL_Try(SDL_GetRendererOutputSize(renderer, &size.w, &size.h));

    auto surface = SDL_RAII!(SDL_Surface*)(SDL_CreateRGBSurface(0, size.w, size.h, 32, 0, 0, 0, 0));

    surface.ptr.drawBackground(property);
    surface.ptr.drawForeground(property);

    return SDL_CreateTextureFromSurface(renderer, surface.ptr);
}

/**
  Desegnas rektangulon.

  Params: surface  = Surfaco por desegni.
          property = Proprieto de rektangulo, kiun desegnos.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
private void drawForeground(SDL_Surface* surface, in TextureProperty property)
{
    immutable SDL_Rect rect = {
        surface.w / 2 - property.shape.w / 2,
        surface.h / 2 - property.shape.h - property.shape.d,
        property.shape.w,
        property.shape.h
    };

    immutable pixel = SDL_MapRGB(surface.format, property.foreground.r, property.foreground.g, property.foreground.b);

    SDL_Try(SDL_FillRect(surface, &rect, pixel));
}

/**
  Desegnas fonon de rektangulo.

  Params: surface  = Surfaco por desegni.
          property = Proprieto de rektangulo, kiun desegnos.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
private void drawBackground(SDL_Surface* surface, in TextureProperty property)
{
    immutable pixel = SDL_MapRGB(surface.format, property.background.r, property.background.g, property.background.b);

    SDL_Try(SDL_SetColorKey(surface, true, pixel));

    SDL_Try(SDL_FillRect(surface, null, pixel));
}
