/**
  Modulo, kiu provizas strukturon de teksturo.

  Copyright: 2017 masaniwa
  License: MIT
 */

module desktopdial.sdl.texture;

import derelict.sdl2.sdl : SDL_CreateTextureFromSurface, SDL_DestroyTexture, SDL_GetError, SDL_Texture;
import desktopdial.sdl.exception : SDLException;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.surface : Surface;
import std.conv : to;

/** Strukturo, kiu administras teksturon rimedon. Uzi tion postulas la SDL-bibliotekon. */
struct Texture
{
    alias get this;

    /**
      Konstruas la strukturon kaj teksturon.

      Params:
        renderer = Rendisto uzota por konstrui teksturon.
        surface = Surfaco uzota por konstrui teksturon.

      Throws:
        SDLException Kiam konstruado malsukcesas.
     */
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

    /**
      Akiras la teksturon rimedon, kiu estas administrata.

      Returns: La teksturo rimedo.
     */
    SDL_Texture* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Texture* data; /// Teksturo rimedo, kiu estas administrata.

    invariant
    {
        assert(data);
    }
}
