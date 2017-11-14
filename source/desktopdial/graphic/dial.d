module desktopdial.graphic.dial;

import derelict.sdl2.sdl : SDL_ALPHA_OPAQUE, SDL_Color, SDL_RenderClear, SDL_RenderPresent, SDL_SetRenderDrawColor;
import desktopdial.graphic.hands : Hands, HandsVisual;
import desktopdial.graphic.symbols : Symbols, SymbolsVisual;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.window : Window;
import std.datetime : SysTime;

struct Dial
{
    this(in DialVisual visual)
    {
        background = visual.window.background;

        window = Window(visual.window.name, visual.window.width, visual.window.height);

        renderer = Renderer(window);

        hands = Hands(renderer, visual.hands);

        symbols = Symbols(renderer, visual.symbols);
    }

    this(this) @disable;

    void draw(in SysTime time) nothrow
    {
        renderer.SDL_SetRenderDrawColor(background.r, background.g, background.b, SDL_ALPHA_OPAQUE);

        renderer.SDL_RenderClear;

        symbols.draw(renderer);

        hands.draw(renderer, time);

        renderer.SDL_RenderPresent;
    }

    private immutable SDL_Color background;

    private Window window;

    private Renderer renderer;

    private Hands hands;

    private Symbols symbols;
}

struct DialVisual
{
    WindowVisual window;

    HandsVisual hands;

    SymbolsVisual symbols;
}

struct WindowVisual
{
    string name;

    ushort width;
    ushort height;

    SDL_Color background;
}
