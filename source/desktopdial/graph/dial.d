module desktopdial.graph.dial;

import derelict.sdl2.sdl;
import desktopdial.graph.hands : Hands, HandsVisual;
import desktopdial.graph.symbols : Symbols, SymbolsVisual;
import desktopdial.graph.sdl.renderer : Renderer, get;
import desktopdial.graph.sdl.window : Window;
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
        SDL_SetRenderDrawColor(renderer.get, background.r, background.g, background.b, SDL_ALPHA_OPAQUE);

        SDL_RenderClear(renderer.get);

        symbols.draw(renderer);

        hands.draw(renderer, time);

        SDL_RenderPresent(renderer.get);
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
