module desktopdial.sdl.surface;

import std.conv : to;

import derelict.sdl2.sdl : SDL_CreateRGBSurface, SDL_FreeSurface, SDL_GetError, SDL_Surface;

import desktopdial.sdl.exception : SDLException;

struct Surface
{
    alias get this;

    this(in int width, in int height)
    in
    {
        assert(width > 0, `The width must be more than 0.`);
        assert(height > 0, `The height must be more than 0.`);
    }
    body
    {
        data = SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0);

        if (!data) throw new SDLException(SDL_GetError().to!string);
    }

    this(this) @disable;

    ~this()
    {
        data.SDL_FreeSurface;
    }

    SDL_Surface* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Surface* data;

    invariant
    {
        assert(data);
    }
}
