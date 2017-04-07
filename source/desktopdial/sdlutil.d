///
/// @file      sdlutil.d
/// @brief     SDLユーティリティモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module desktopdial.sdlutil;

import std.conv:
    to;

import std.exception:
    enforceEx;

import std.string:
    toStringz;

import desktopdial.exception:
    CreationException;

import sdl = derelict.sdl2.sdl;

public:

/// @brief   ウィンドウを生成する。
/// @param   name   名前。
/// @param   width  幅。
/// @param   height 高さ。
/// @return  生成したウィンドウ。
/// @throws  CreationException   ウィンドウ生成に失敗した場合。
/// @details ウィンドウ使用後はDestroy()で破棄する必要がある。
sdl.SDL_Window *createWindow(in string name, in ushort width, in ushort height)
{
    auto window = sdl.SDL_CreateWindow(name.toStringz, sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, width, height, sdl.SDL_WINDOW_ALWAYS_ON_TOP);

    return window.enforceEx!CreationException(sdl.SDL_GetError().to!string);
}

/// @brief ウィンドウを破棄する。
/// @param window 破棄するウィンドウ。
void destroy(sdl.SDL_Window *window) nothrow @nogc
{
    if(window)
    {
        sdl.SDL_DestroyWindow(window);
    }
}

/// @brief   レンダラを生成する。
/// @param   window ウィンドウ。
/// @return  生成したレンダラ。
/// @throws  CreationException レンダラ生成に失敗した場合。
/// @details レンダラ使用後はDestroy()で破棄する必要がある。
sdl.SDL_Renderer *createRenderer(sdl.SDL_Window *window)
{
    auto renderer = sdl.SDL_CreateRenderer(window, -1, sdl.SDL_RENDERER_PRESENTVSYNC | sdl.SDL_RENDERER_ACCELERATED);

    return renderer.enforceEx!CreationException(sdl.SDL_GetError().to!string);
}

/// @brief レンダラを破棄する。
/// @param renderer 破棄するレンダラ。
void destroy(sdl.SDL_Renderer *renderer) nothrow @nogc
{
    if(renderer)
    {
        sdl.SDL_DestroyRenderer(renderer);
    }
}

/// @brief   サーフェスを生成する。
/// @param   width  幅。
/// @param   height 高さ。
/// @return  生成したサーフェス。
/// @throws  CreationException サーフェス生成に失敗した場合。
/// @details サーフェス使用後はFree()で解放する必要がある。
sdl.SDL_Surface *createSurface(in uint width, in uint height)
{
    auto surface = sdl.SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0);

    return surface.enforceEx!CreationException(sdl.SDL_GetError().to!string);
}

/// @brief サーフェスを解放する。
/// @param surface 解放するサーフェス。
void free(sdl.SDL_Surface *surface) nothrow @nogc
{
    if(surface)
    {
        sdl.SDL_FreeSurface(surface);
    }
}

/// @brief サーフェスを透過色で塗りつぶす。
/// @param surface 塗りつぶすサーフェス。
/// @param red     透過色の赤の明度。
/// @param green   透過色の緑の明度。
/// @param blue    透過色の青の明度。
void fillAlpha(sdl.SDL_Surface *surface, in ubyte red, in ubyte green, in ubyte blue) nothrow @nogc
{
    immutable map = sdl.SDL_MapRGB(surface.format, red, green, blue);

    sdl.SDL_SetColorKey(surface, sdl.SDL_TRUE, map);
    sdl.SDL_FillRect(surface, null, map);
}

/// @brief サーフェスに矩形を描画する。
/// @param surface 描画するサーフェス。
/// @param rect    描画する矩形。
/// @param red     矩形の赤の明度。
/// @param green   矩形の緑の明度。
/// @param blue    矩形の青の明度。
void fillRect(sdl.SDL_Surface *surface, in sdl.SDL_Rect rect, in ubyte red, in ubyte green, in ubyte blue) nothrow @nogc
{
    immutable map = sdl.SDL_MapRGB(surface.format, red, green, blue);

    sdl.SDL_FillRect(surface, &rect, map);
}

/// @brief   サーフェスをテクスチャに変換する。
/// @param   renderer 使用するレンダラ。
/// @param   surface  変換するサーフェス。
/// @return  生成したテクスチャ。
/// @throws  CreationException テクスチャ生成に失敗した場合。
/// @details テクスチャ使用後はDestroy()で破棄する必要がある。
sdl.SDL_Texture *convertToTexture(sdl.SDL_Renderer *renderer, sdl.SDL_Surface *surface)
{
    auto texture = sdl.SDL_CreateTextureFromSurface(renderer, surface);

    return texture.enforceEx!CreationException(sdl.SDL_GetError().to!string);
}

/// @brief テクスチャを破棄する。
/// @param texture 破棄するテクスチャ。
void destroy(sdl.SDL_Texture *texture) nothrow @nogc
{
    if(texture)
    {
        sdl.SDL_DestroyTexture(texture);
    }
}
