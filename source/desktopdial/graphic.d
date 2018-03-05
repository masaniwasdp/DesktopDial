module desktopdial.graphic;

import desktopdial.parts.types : Size;
import sdlraii;

package struct Graphic
{
    this(in Size size)
    {
        window_ = SDL_RAII_Window(
            SDL_CreateWindow(
                null, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, size.w, size.h, SDL_WINDOW_ALWAYS_ON_TOP));

        renderer_ = SDL_RAII_Renderer(
            SDL_CreateRenderer(
                window_.ptr, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED));
    }

    this(this) @disable;

    ref SDL_RAII_Renderer obj() @nogc nothrow @property pure @safe
    {
        return renderer_;
    }

    private SDL_RAII_Window window_;

    private SDL_RAII_Renderer renderer_;
}
