module desktopdial.sdl.renderer;

import std.conv : to;

import derelict.sdl2.sdl :
    SDL_CreateRenderer,
    SDL_DestroyRenderer,
    SDL_GetError,
    SDL_RENDERER_ACCELERATED,
    SDL_RENDERER_PRESENTVSYNC,
    SDL_Renderer;

import desktopdial.sdl.exception : SDLException;
import desktopdial.sdl.window : Window;

struct Renderer
{
    alias get this;

    this(ref Window window)
    {
        data = window.SDL_CreateRenderer(-1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);

        if (!data) throw new SDLException(SDL_GetError().to!string);
    }

    this(this) @disable;

    ~this()
    {
        data.SDL_DestroyRenderer;
    }

    SDL_Renderer* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Renderer* data;

    invariant
    {
        assert(data);
    }
}

unittest
{
    import std.exception : assertNotThrown;

    import derelict.sdl2.sdl : DerelictSDL2, SDL_INIT_EVERYTHING, SDL_Init, SDL_Quit;

    DerelictSDL2.load;

    assert(SDL_Init(SDL_INIT_EVERYTHING) == 0);

    scope(exit) SDL_Quit();

    auto window = Window(`Alice`, 77, 16);

    assertNotThrown(Renderer(window));
}
