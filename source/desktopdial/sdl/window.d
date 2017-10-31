/**
  Modulo, kiu provizas strukturon de fenestro.

  Date: 2017/11/1
  Author: masaniwa
 */

module desktopdial.sdl.window;

import std.conv : to;
import std.string : toStringz;

import derelict.sdl2.sdl :
    SDL_CreateWindow,
    SDL_DestroyWindow,
    SDL_GetError,
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOW_ALWAYS_ON_TOP,
    SDL_Window;

import desktopdial.sdl.exception : SDLException;

/** Strukturo, kiu administras fenestran rimedon. */
struct Window
{
    alias get this;

    /**
      Konstruas la strukturon kaj fenestron.

      Params:
        name = La nomo por doni la fenestron.
        width = La larĝo de la fenestro.
        height = La alceto de la fenestro.

      Throws:
        SDLException Kiam konstruado malsukcesas.
     */
    this(in string name, in int width, in int height)
    {
        data = SDL_CreateWindow(
                name.toStringz,
                SDL_WINDOWPOS_UNDEFINED,
                SDL_WINDOWPOS_UNDEFINED,
                width,
                height,
                SDL_WINDOW_ALWAYS_ON_TOP);

        if (!data) throw new SDLException(SDL_GetError().to!string);
    }

    this(this) @disable;

    ~this()
    {
        data.SDL_DestroyWindow;
    }

    /**
      Akiras la fenestran rimedon, kiu estas administrata.

      Returns: La fenestra rimedo.
     */
    SDL_Window* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Window* data; /// Fenestra rimedo, kiu estas administrata.

    invariant
    {
        assert(data);
    }
}
