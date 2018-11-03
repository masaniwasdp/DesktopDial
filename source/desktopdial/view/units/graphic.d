/**
  Provizas grafika kunteksto.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.units.graphic;

import desktopdial.view.units.property : Color, Size;
import sdlraii;

/**
  Grafika kunteksto.

  Uzi tiojn postulas la SDL bibliotekon.
 */
struct Graphic
{
    /**
      Konstruas kunteksto.

      Params:
        size  = La grandeco de fenestro.
        color = La koloro de fenestro.

      Throws:
        SDL_Exception Kiam konstruado malsukcesas.
     */
    this(in Size size, in Color color)
    {
        color_ = color;

        window_ = SDL_RAII_Window(SDL_CreateWindow(null, windowInitX, windowInitY, size.w, size.h, windowFlags));

        renderer_ = SDL_RAII_Renderer(SDL_CreateRenderer(window_.ptr, rendererIndex, rendererFlags));
    }

    this(this) @disable;

    /** La rendisto de fenestro. */
    ref SDL_RAII_Renderer context() @nogc nothrow @property pure @safe
    {
        return renderer_;
    }

    /**
      Rendas la fenestron.

      Params:
        expression = Esprimo, kiun ekzekutas antaŭ prezentas fenestron.

      Throws:
        SDL_Exception Kiam malsukcesas rendi.
     */
    void render(lazy void expression)
    {
        SDL_Try(SDL_SetRenderDrawColor(renderer_.ptr, color_.r, color_.g, color_.b, SDL_ALPHA_OPAQUE));

        SDL_Try(SDL_RenderClear(renderer_.ptr));

        expression;

        SDL_RenderPresent(renderer_.ptr);
    }

    /** La koloro de la fenestro. */
    private immutable Color color_;

    /** Fenestro por prezentas grafikon. */
    private SDL_RAII_Window window_;

    /** Rendisto de la fenestro. */
    private SDL_RAII_Renderer renderer_;
}

private enum windowInitX = SDL_WINDOWPOS_UNDEFINED;  /// La komenca X pozicio de fenestro.
private enum windowInitY = SDL_WINDOWPOS_UNDEFINED;  /// La komenca Y pozicio de fenestro.
private enum windowFlags = SDL_WINDOW_ALWAYS_ON_TOP; /// La flagoj por krei fenestron.

private enum rendererIndex = -1;                                                   /// La indekso de rendistoj.
private enum rendererFlags = SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED; /// La flagoj por krei rendiston.
