///
/// @file      app.d
/// @brief     メインエントリ。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

import std.conv:
    to;

import std.stdio:
    readln, writefln;

import desktopdial.app:
    App;

import sdl = derelict.sdl2.sdl;

public:

void main(string[] args)
{
    try
    {
        sdl.DerelictSDL2.load;

        if(sdl.SDL_Init(sdl.SDL_INIT_EVERYTHING) < 0) throw new Exception(sdl.SDL_GetError().to!string);

        scope(exit) sdl.SDL_Quit();

        configureSDL;

        (args.length > 1 ? new App(args[1]) : new App).run;
    }
    catch(Exception e)
    {
        debug
        {
            throw e;
        }
        else
        {
            error.writefln(e.file, e.line, e.msg);
            readln;
        }
    }
}

private:

/// @brief SDLの設定を行う。
void configureSDL() nothrow @nogc
{
    sdl.SDL_SetHint(sdl.SDL_HINT_RENDER_SCALE_QUALITY, "liner");
    sdl.SDL_SetHint(sdl.SDL_HINT_VIDEO_ALLOW_SCREENSAVER, "1");
    sdl.SDL_SetHint(sdl.SDL_HINT_NO_SIGNAL_HANDLERS, "0");
}

immutable error = "An error occurred.\n%s(%d):\n\t%s\nPress any key..."; ///< エラーメッセージのフォーマット。
