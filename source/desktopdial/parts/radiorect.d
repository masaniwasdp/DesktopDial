/**
  Desegnas teksturojn de radiaj rektanguloj.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.parts.radiorect;

import desktopdial.parts.types : Color, Size;
import sdlraii;

/** Dezajno de radiaj rektanguloj. */
package struct RadioRectTextureDesign
{
    /** La distanco de centro. */
    int distance;

    /** Grandeco. */
    Size size;

    /** Antaŭa koloro. */
    Color front;

    /** Fona koloro. */
    Color back;
}

/**
  Desegnas radian rektangulon sur teksturo.

  Params:
    renderer = Rendisto por desegni.
    design   = Dezajno de rektangulo, kiun desegnos.

  Returns:
    Teksturo kun rektangulo desegnita.

  Throws:
    SDL_Exception Kiam desegno malsukcesas.
 */
package SDL_RAII_Texture draw(ref SDL_RAII_Renderer renderer, in RadioRectTextureDesign design)
{
    immutable size = renderer.size;

    auto surface = SDL_RAII_Surface(SDL_CreateRGBSurface(0, size.w, size.h, 32, 0, 0, 0, 0));

    surface.drawBack(design.back);

    surface.drawFront(design.front, design.size, design.distance);

    return SDL_RAII_Texture(SDL_CreateTextureFromSurface(renderer.ptr, surface.ptr));
}

/**
  Akiras la eligo grandeco de rendisto.

  Params:
    renderer = Rendisto de intereso.

  Returns:
    La eligo grandeco de rendisto.

  Throws:
    SDL_Exception Kiam malsukcesas akiri.
 */
private Size size(ref SDL_RAII_Renderer renderer)
{
    Size size = void;

    SDL_Try(SDL_GetRendererOutputSize(renderer.ptr, &size.w, &size.h));

    return size;
}

/**
  Desegnas radian rektangulon.

  Params:
    surface  = Surfaco por desegni.
    color    = La koloro de rektangulo, kiun desegnos.
    size     = La grandeco de rektangulo, kiun desegnos.
    distance = La distanco de centro.

  Throws:
    SDL_Exception Kiam desegno malsukcesas.
 */
private void drawFront(ref SDL_RAII_Surface surface, in Color color, in Size size, in int distance)
{
    immutable SDL_Rect rect = {
        surface.ptr.w / 2 - size.w / 2,
        surface.ptr.h / 2 - distance - size.h,
        size.w,
        size.h
    };

    immutable pixel = SDL_MapRGB(surface.ptr.format, color.r, color.g, color.b);

    SDL_Try(SDL_FillRect(surface.ptr, &rect, pixel));
}

/**
  Desegnas fonon de radia rektangulo.

  Params:
    surface = Surfaco por desegni.
    color   = La koloro de rektangulo, kiun desegnos.

  Throws:
    SDL_Exception Kiam desegno malsukcesas.
 */
private void drawBack(ref SDL_RAII_Surface surface, in Color color)
{
    immutable pixel = SDL_MapRGB(surface.ptr.format, color.r, color.g, color.b);

    SDL_Try(SDL_SetColorKey(surface.ptr, true, pixel));

    SDL_Try(SDL_FillRect(surface.ptr, null, pixel));
}
