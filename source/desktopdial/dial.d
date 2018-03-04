module desktopdial.dial;

import desktopdial.parts.hands : HandDesigns, Hands;
import desktopdial.parts.symbols : SymbolDesigns, Symbols;
import desktopdial.parts.types : Color, Size;
import sdlraii;
import std.datetime : SysTime;

package struct Dial
{
    this(in DialDesign design)
    {
        color_ = design.color;

        window_ = design.size.createWindow;

        renderer_ = window_.createRenderer;

        hands_ = Hands(renderer_, design.hands);

        symbols_ = Symbols(renderer_, design.symbols);
    }

    this(this) @disable;

    void draw(in SysTime time)
    {
        SDL_Try(SDL_SetRenderDrawColor(renderer_.ptr, color_.r, color_.g, color_.b, SDL_ALPHA_OPAQUE));

        SDL_Try(SDL_RenderClear(renderer_.ptr));

        symbols_.draw(renderer_);

        hands_.draw(renderer_, time);

        SDL_RenderPresent(renderer_.ptr);
    }

    private immutable Color color_;

    private SDL_RAII_Window window_;

    private SDL_RAII_Renderer renderer_;

    private Hands hands_;

    private Symbols symbols_;
}

package struct DialDesign
{
    Size size;

    Color color;

    HandDesigns hands;

    SymbolDesigns symbols;
}

private SDL_RAII_Window createWindow(in Size size)
{
    auto window = SDL_CreateWindow(
        null, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, size.w, size.h, SDL_WINDOW_ALWAYS_ON_TOP);

    return SDL_RAII_Window(window);
}

private SDL_RAII_Renderer createRenderer(ref SDL_RAII_Window window)
{
    auto renderer = SDL_CreateRenderer(window.ptr, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);

    return SDL_RAII_Renderer(renderer);
}
