/**
 * メインエントリ。
 *
 * Date: 2017/7/10
 * Authors: masaniwa
 */

import std.conv : to;
import std.stdio : readln, writeln;

import desktopdial.app : App;

import sdl = derelict.sdl2.sdl;

public:

void main(string[] args)
{
    try
    {
        sdl.DerelictSDL2.load;

        if (sdl.SDL_Init(sdl.SDL_INIT_EVERYTHING) < 0) throw new Exception(sdl.SDL_GetError().to!string);

        scope(exit) sdl.SDL_Quit();

        configureSDL;

        (args.length > 1 ? new App(args[1]) : new App).run;
    }
    catch (Exception e)
    {
        handle(e);
    }
}

private:

/** SDLの設定を行う。 */
void configureSDL() nothrow @nogc
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
 *     Exception = 例外を再送出すべきな場合。
 */
void handle(in Exception e)
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
            e.error.writeln;
            readln;
        }
    }
}

/**
 * 例外発生時のエラーメッセージ。
 *
 * Params:
 *     e = 例外。
 *
 * Returns: 生成したメッセージ。
 */
string error(in Exception e) nothrow pure @safe
{
    return "An error occurred.\n" ~ e.file ~ "(" ~ e.line.to!string ~ "):\n\t" ~ e.msg ~ "\nPress any key...";
}
