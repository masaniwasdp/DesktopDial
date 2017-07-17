/**
 * メインエントリ。
 *
 * Date: 2017/7/18
 * Authors: masaniwa
 */

import std.conv : to;
import std.stdio : writeln;

import desktopdial.app : App;

import sdl = derelict.sdl2.sdl;

void main(string[] args)
{
    try
    {
        sdl.DerelictSDL2.load;

        if (sdl.SDL_Init(sdl.SDL_INIT_EVERYTHING) < 0) throw new Exception(sdl.SDL_GetError().to!string);

        scope (exit) sdl.SDL_Quit();

        configureSDL;

        (args.length > 1 ? new App(args[1]) : new App).run;
    }
    catch (Exception e)
    {
        handle(e);
    }
}

/** SDLの設定を行う。 */
private void configureSDL() nothrow @nogc
{
    sdl.SDL_SetHint(sdl.SDL_HINT_RENDER_SCALE_QUALITY, "liner");
    sdl.SDL_SetHint(sdl.SDL_HINT_VIDEO_ALLOW_SCREENSAVER, "1");
    sdl.SDL_SetHint(sdl.SDL_HINT_NO_SIGNAL_HANDLERS, "0");
}

/**
 * 例外に対応する。
 *
 * Params:
 *     e = 例外。
 *
 * Throws:
 *     Exception 例外を再送出すべきな場合。
 */
private void handle(in Exception e)
in
{
    assert(e);
}
body
{
    debug
    {
        throw e;
    }
    else
    {
        version (Windows)
        {
            throw e;
        }
        else
        {
            immutable error = e.file ~ "[" ~ e.line.to!string ~ "]: " ~ e.msg ~ "\n";

            error.writeln;
        }
    }
}
