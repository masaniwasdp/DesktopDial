/**
  Desegnas teksturojn de rektanguloj.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.unit.texture;

import derelict.sdl2.sdl;
import desktopdial.view.unit.prop : Color, Size;
import sdlraii.except;
import sdlraii.raii;

/** Dezajno de rektanguloj. */
package struct TextureDesign
{
    Shape shape; /// Koloro.

    Color fore; /// Antaŭa koloro.
    Color back; /// Fona koloro.
}

/**
  Desegnas rektangulon sur teksturo.

  Params: renderer = Rendisto por desegni.
          design   = Dezajno de rektangulo, kiun desegnos.

  Returns: Teksturo kun rektangulo desegnita.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
package SDL_RAII!(SDL_Texture*) draw(SDL_Renderer* renderer, in TextureDesign design)
{
    Size size = void;

    SDL_Try(SDL_GetRendererOutputSize(renderer, &size.w, &size.h));

    auto surface = SDL_RAII!(SDL_Surface*)(SDL_CreateRGBSurface(0, size.w, size.h, 32, 0, 0, 0, 0));

    surface.ptr.drawBack(design);
    surface.ptr.drawFore(design);

    return SDL_RAII!(SDL_Texture*)(SDL_CreateTextureFromSurface(renderer, surface.ptr));
}

/** Formo de rektanguloj. */
private struct Shape
{
    int d; /// La distanco de centro.
    int w; /// Larĝo.
    int h; /// Alteco.
}

/**
  Desegnas rektangulon.

  Params: surface = Surfaco por desegni.
          design  = Dezajno de rektangulo, kiun desegnos.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
private void drawFore(SDL_Surface* surface, in TextureDesign design)
{
    immutable SDL_Rect rect = {
        surface.w / 2 - design.shape.w / 2,
        surface.h / 2 - design.shape.h - design.shape.d,
        design.shape.w,
        design.shape.h
    };

    immutable pixel = SDL_MapRGB(surface.format, design.fore.r, design.fore.g, design.fore.b);

    SDL_Try(SDL_FillRect(surface, &rect, pixel));
}

/**
  Desegnas fonon de rektangulo.

  Params: surface = Surfaco por desegni.
          design  = Dezajno de rektangulo, kiun desegnos.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
private void drawBack(SDL_Surface* surface, in TextureDesign design)
{
    immutable pixel = SDL_MapRGB(surface.format, design.back.r, design.back.g, design.back.b);

    SDL_Try(SDL_SetColorKey(surface, true, pixel));

    SDL_Try(SDL_FillRect(surface, null, pixel));
}
