/**
  Desegnas teksturojn de rektanguloj.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.unit.texture;

import desktopdial.view.unit.prop : Color, Size;
import sdlraii;

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
package SDL_RAII_Texture draw(ref SDL_RAII_Renderer renderer, in TextureDesign design)
{
    immutable size = renderer.size;

    auto surface = SDL_RAII_Surface(SDL_CreateRGBSurface(0, size.w, size.h, 32, 0, 0, 0, 0));

    surface.drawBack(design);
    surface.drawFore(design);

    return SDL_RAII_Texture(SDL_CreateTextureFromSurface(renderer.ptr, surface.ptr));
}

/** Formo de rektanguloj. */
private struct Shape
{
    int d; /// La distanco de centro.
    int w; /// Larĝo.
    int h; /// Alteco.
}

/**
  Akiras la eligon grandecon de rendisto.

  Params: renderer = Rendisto de intereso.

  Returns: La eligo grandeco de rendisto.

  Throws: SDL_Exception Kiam malsukcesas akiri la grandecon.
 */
private Size size(ref SDL_RAII_Renderer renderer)
{
    Size size = void;

    SDL_Try(SDL_GetRendererOutputSize(renderer.ptr, &size.w, &size.h));

    return size;
}

/**
  Desegnas rektangulon.

  Params: surface = Surfaco por desegni.
          design  = Dezajno de rektangulo, kiun desegnos.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
private void drawFore(ref SDL_RAII_Surface surface, in TextureDesign design)
{
    immutable SDL_Rect rect = {
        surface.ptr.w / 2 - design.shape.w / 2,
        surface.ptr.h / 2 - design.shape.h - design.shape.d,
        design.shape.w,
        design.shape.h
    };

    immutable pixel = SDL_MapRGB(surface.ptr.format, design.fore.r, design.fore.g, design.fore.b);

    SDL_Try(SDL_FillRect(surface.ptr, &rect, pixel));
}

/**
  Desegnas fonon de rektangulo.

  Params: surface = Surfaco por desegni.
          design  = Dezajno de rektangulo, kiun desegnos.

  Throws: SDL_Exception Kiam desegno malsukcesas.
 */
private void drawBack(ref SDL_RAII_Surface surface, in TextureDesign design)
{
    immutable pixel = SDL_MapRGB(surface.ptr.format, design.back.r, design.back.g, design.back.b);

    SDL_Try(SDL_SetColorKey(surface.ptr, true, pixel));

    SDL_Try(SDL_FillRect(surface.ptr, null, pixel));
}
