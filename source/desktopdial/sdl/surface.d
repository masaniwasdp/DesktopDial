/**
  Modulo, kiu provizas strukturon de surfaco.

  Copyright: 2017 masaniwa
  License: MIT
 */

module desktopdial.sdl.surface;

import derelict.sdl2.sdl : SDL_CreateRGBSurface, SDL_FreeSurface, SDL_GetError, SDL_Surface;
import desktopdial.sdl.exception : SDLException;
import std.conv : to;

/** Strukturo, kiu administras surfacon rimedon. Uzi tion postulas la SDL-bibliotekon. */
struct Surface
{
    alias get this;

    /**
      Konstruas la strukturon kaj surfacon.

      Params:
        width = La larĝo de la surfaco.
        height = La alceto de la surfaco.

      Throws:
        SDLException Kiam konstruado malsukcesas.
     */
    this(in int width, in int height)
    {
        data = SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0);

        if (!data) throw new SDLException(SDL_GetError().to!string);
    }

    this(this) @disable;

    ~this()
    {
        data.SDL_FreeSurface;
    }

    /**
      Akiras la surfacon rimedon, kiu estas administrata.

      Returns: La surfaco rimedo.
     */
    SDL_Surface* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Surface* data; /// Surfaco rimedo, kiu estas administrata.

    invariant
    {
        assert(data);
    }
}
