/**
  Modulo, kiu provizas strukturon de rendisto.

  Date: 2017/11/2
  Author: masaniwa
 */

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

/** Strukturo, kiu administras rendistan rimedon. Uzi tion postulas la SDL-bibliotekon. */
struct Renderer
{
    alias get this;

    /**
      Konstruas la strukturon kaj rendiston.

      Params:
        window = Fenestro uzota por konstrui rendiston.

      Throws:
        SDLException Kiam konstruado malsukcesas.
     */
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

    /**
      Akiras la rendistan rimedon, kiu estas administrata.

      Returns: La rendista rimedo.
     */
    SDL_Renderer* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Renderer* data; /// Rendista rimedo, kiu estas administrata.

    invariant
    {
        assert(data);
    }
}
