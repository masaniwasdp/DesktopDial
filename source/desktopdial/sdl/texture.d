module desktopdial.sdl.texture;

import derelict.sdl2.sdl : SDL_CreateTextureFromSurface, SDL_DestroyTexture, SDL_GetError, SDL_Texture;
import desktopdial.sdl.exception : SDLException;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.surface : Surface;
import std.conv : to;

struct Texture
{
    alias get this;

    this(ref Renderer renderer, ref Surface surface)
    {
        data = renderer.SDL_CreateTextureFromSurface(surface);

        if (!data) throw new SDLException(SDL_GetError().to!string);
    }

    this(this) @disable;

    ~this()
    {
        data.SDL_DestroyTexture;
    }

    SDL_Texture* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Texture* data;

    invariant
    {
        assert(data);
    }
}
