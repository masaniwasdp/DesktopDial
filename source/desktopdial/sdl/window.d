/**
  Modulo, kiu provizas strukturon de fenestro.

  Copyright: 2017 masaniwa
  License: MIT
 */

module desktopdial.sdl.window;

import derelict.sdl2.sdl :
        SDL_CreateWindow, SDL_DestroyWindow, SDL_GetError, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOW_ALWAYS_ON_TOP,
        SDL_Window;

import desktopdial.sdl.exception : SDLException;
import std.conv : to;
import std.string : toStringz;

/** Strukturo, kiu administras fenestron rimedon. Uzi tion postulas la SDL-bibliotekon. */
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
                name.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height,
                SDL_WINDOW_ALWAYS_ON_TOP);

        if (!data) throw new SDLException(SDL_GetError().to!string);
    }

    this(this) @disable;

    ~this()
    {
        data.SDL_DestroyWindow;
    }

    /**
      Akiras la fenestron rimedon, kiu estas administrata.

      Returns: La fenestro rimedo.
     */
    SDL_Window* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Window* data; /// Fenestro rimedo, kiu estas administrata.

    invariant
    {
        assert(data);
    }
}
