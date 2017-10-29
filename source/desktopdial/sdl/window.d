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

struct Window
{
    alias get this;

    this(in string name, in int width, in int height)
    in
    {
        assert(width > 0, `The width must be more than 0.`);
        assert(height > 0, `The height must be more than 0.`);
    }
    body
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

    SDL_Window* get() pure nothrow @nogc @safe
    {
        return data;
    }

    private SDL_Window* data;

    invariant
    {
        assert(data);
    }
}

unittest
{
    import std.exception : assertNotThrown;

    import derelict.sdl2.sdl : DerelictSDL2, SDL_INIT_EVERYTHING, SDL_Init, SDL_Quit;

    DerelictSDL2.load;

    if (SDL_Init(SDL_INIT_EVERYTHING) == 0)
    {
        scope(exit) SDL_Quit();

        assertNotThrown(Window(`Alice`, 77, 16));
        assertNotThrown(Window(``, 7, 7));
        assertNotThrown(Window(null, 1, 6));
    }
    else
    {
        import std.stdio : writeln;

        writeln(__FILE__ ~ `: The test of class Window was disable.`);
    }
}
