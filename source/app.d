/**
 * メインエントリ。
 *
 * Date: 2017/8/7
 * Authors: masaniwa
 */

import std.conv : to;
import std.stdio : writeln;

import desktopdial.app : App;

import derelict.sdl2.sdl;

void main(string[] args)
{
    try
    {
        DerelictSDL2.load;

        if (SDL_Init(SDL_INIT_EVERYTHING) < 0) throw new Exception(SDL_GetError().to!string);

        scope (exit) SDL_Quit();

        configureSDL;

        auto app = args.length > 1 ? new App(args[1]) : new App;

        scope (exit) app.destroy;

        app.run;
    }
    catch (Exception e)
    {
        handle(e);
    }
}

/** SDLの設定を行う。 */
private void configureSDL() nothrow @nogc
{
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "liner");
    SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, "1");
    SDL_SetHint(SDL_HINT_NO_SIGNAL_HANDLERS, "0");
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
        (e.file ~ "(" ~ e.line.to!string ~ "): " ~ e.msg ~ "\n").writeln;
    }
}
