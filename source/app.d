///
/// @file      app.d
/// @brief     メインエントリ。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

import std.conv,
       std.stdio;

import derelict.sdl2.sdl;

import DesktopDial.App;

public:

void main(string[] args)
{
    try
    {
        DerelictSDL2.load;

        if(SDL_Init(SDL_INIT_EVERYTHING) < 0) throw new Exception(SDL_GetError().to!string);

        scope(exit) SDL_Quit();

        configureSDL;

        (args.length > 1 ? new App(args[1]) : new App).Run;
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
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "liner");
    SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, "1");
    SDL_SetHint(SDL_HINT_NO_SIGNAL_HANDLERS, "0");
}

immutable error = "An error occurred.\n%s(%d):\n\t%s\nPress any key..."; ///< エラーメッセージのフォーマット。
