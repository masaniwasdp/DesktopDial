///
/// @file      app.d
/// @brief     メインエントリ。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

import std.conv;

import derelict.sdl2.sdl;

import DesktopDial.App;

/// @brief メインエントリ。
void main()
{
    DerelictSDL2.load;

    if(SDL_Init(SDL_INIT_EVERYTHING) < 0)
    {
        throw new Exception(SDL_GetError().to!string);
    }

    scope(exit) SDL_Quit();

    configureSDL;

    (new App).Run;
}

/// @brief SDLの設定を行う。
private void configureSDL() nothrow
{
    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "liner");
    SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, "1");
    SDL_SetHint(SDL_HINT_NO_SIGNAL_HANDLERS, "0");
}
