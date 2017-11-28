/**
  Modulo, kiu provizas strukturon de fenestro.

  Copyright: 2017 masaniwa
  License: MIT
 */

module desktopdial.sdl.window;

import derelict.sdl2.sdl;
import desktopdial.sdl.exception : SDLException;
import std.conv : to;
import std.string : toStringz;

/** Strukturo, kiu administras fenestron rimedon. Uzi tion postulas la SDL-bibliotekon. */
struct Window
{
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
        immutable namez = name.toStringz;

        data = SDL_CreateWindow(
                namez, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_ALWAYS_ON_TOP);

        if (!data) throw new SDLException(SDL_GetError().to!string);
    }

    this(this) @disable;

    ~this()
    {
        SDL_DestroyWindow(data);
    }

    private SDL_Window* data; /// Fenestro rimedo, kiu estas administrata.

    invariant
    {
        assert(data);
    }
}

/**
  Akiras fenestron rimedon, kiu estas administrata.

  Params:
    window = Strukturo, kiu administras fenestron rimedon.

  Returns: Fenestro rimedo.
 */
SDL_Window* get(ref Window window) @nogc nothrow pure @safe
{
    return window.data;
}
