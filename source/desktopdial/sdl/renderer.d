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
        data = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);

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
