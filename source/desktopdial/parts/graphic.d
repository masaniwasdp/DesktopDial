module desktopdial.parts.graphic;

import desktopdial.parts.types : Color, Size;
import sdlraii;

struct Graphic
{
    this(in Size size, in Color color)
    {
        color_ = color;

        window_ = SDL_RAII_Window(SDL_CreateWindow(null, windowInitX, windowInitY, size.w, size.h, windowFlags));

        renderer_ = SDL_RAII_Renderer(SDL_CreateRenderer(window_.ptr, rendererIndex, rendererFlags));
    }

    this(this) @disable;

    ref SDL_RAII_Renderer context() @nogc nothrow @property pure @safe
    {
        return renderer_;
    }

    void render(lazy void expression)
    {
        SDL_Try(SDL_SetRenderDrawColor(renderer_.ptr, color_.r, color_.g, color_.b, SDL_ALPHA_OPAQUE));

        SDL_Try(SDL_RenderClear(renderer_.ptr));

        expression;

        SDL_RenderPresent(renderer_.ptr);
    }

    private immutable Color color_;

    private SDL_RAII_Window window_;

    private SDL_RAII_Renderer renderer_;
}

private enum windowInitX = SDL_WINDOWPOS_UNDEFINED;

private enum windowInitY = SDL_WINDOWPOS_UNDEFINED;

private enum windowFlags = SDL_WINDOW_ALWAYS_ON_TOP;

private enum rendererIndex = -1;

private enum rendererFlags = SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED;
