module desktopdial.sdl.texture;

import std.conv : to;

import derelict.sdl2.sdl : SDL_CreateTextureFromSurface, SDL_DestroyTexture, SDL_GetError, SDL_Texture;

import desktopdial.sdl.exception : SDLException;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.surface : Surface;

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

unittest
{
    import std.exception : assertNotThrown;

    import derelict.sdl2.sdl : DerelictSDL2, SDL_INIT_EVERYTHING, SDL_Init, SDL_Quit;

    import desktopdial.sdl.window : Window;

    DerelictSDL2.load;

    assert(SDL_Init(SDL_INIT_EVERYTHING) == 0);

    scope(exit) SDL_Quit();

    auto window = Window(`Alice`, 77, 16);

    auto renderer = Renderer(window);

    {
        auto surface = Surface(77, 16);

        assertNotThrown(Texture(renderer, surface));
    }

    {
        auto surface = Surface(16, 77);

        assertNotThrown(Texture(renderer, surface));
    }
}
