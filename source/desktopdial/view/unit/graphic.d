/**
  Provizas grafika kunteksto por rendi.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.unit.graphic;

import derelict.sdl2.sdl;
import desktopdial.view.unit.prop : Color, Size;
import sdlraii;

/**
  Grafika kunteksto.

  Uzi tiojn postulas la SDL bibliotekon.
 */
struct Graphic
{
    /**
      Konstruas kunteksto.

      Params: size = La grandeco de fenestro.
              back = La koloro de fenestro.

      Throws: SDL_Exception Kiam konstruado malsukcesas.
     */
    this(in Size size, in Color back)
    {
        this.back = back;

        this.window = SDL_RAII!(SDL_Window*)(SDL_CreateWindow(null, wInitX, wInitY, size.w, size.h, wFlags));

        this.renderer = SDL_RAII!(SDL_Renderer*)(SDL_CreateRenderer(window.ptr, -1, rFlags));
    }

    this(this) @disable;

    /** La rendisto de fenestro. */
    SDL_Renderer* context() @nogc nothrow @property pure @safe
    {
        return renderer.ptr;
    }

    /**
      Rendas la fenestron.

      Params: expression = Esprimo, kiun ekzekutas antaŭ prezentas fenestron.

      Throws: SDL_Exception Kiam malsukcesas rendi.
     */
    void render(lazy void expression)
    {
        SDL_Try(SDL_SetRenderDrawColor(renderer.ptr, back.r, back.g, back.b, SDL_ALPHA_OPAQUE));

        SDL_Try(SDL_RenderClear(renderer.ptr));

        expression;

        SDL_RenderPresent(renderer.ptr);
    }

    /** La koloro de la fenestro. */
    private immutable Color back;

    /** Fenestro por prezentas grafikon. */
    private SDL_RAII!(SDL_Window*) window;

    /** Rendisto de la fenestro. */
    private SDL_RAII!(SDL_Renderer*) renderer;
}

private enum wInitX = SDL_WINDOWPOS_UNDEFINED;  /// La komenca X pozicio de fenestro.
private enum wInitY = SDL_WINDOWPOS_UNDEFINED;  /// La komenca Y pozicio de fenestro.
private enum wFlags = SDL_WINDOW_ALWAYS_ON_TOP; /// La flagoj por krei fenestron.

private enum rFlags = SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED; /// La flagoj por krei rendiston.
