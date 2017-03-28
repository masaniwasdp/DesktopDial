///
/// @file      SDLUtil.d
/// @brief     SDLユーティリティモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.SDLUtil;

import std.conv,
       std.exception,
       std.string;

import derelict.sdl2.sdl;

import DesktopDial.Exception;

public:

/// @brief   ウィンドウを生成する。
/// @param   name   名前。
/// @param   width  幅。
/// @param   height 高さ。
/// @return  生成したウィンドウ。
/// @throws  CreationException   ウィンドウ生成に失敗した場合。
/// @details ウィンドウ使用後はDestroy()で破棄する必要がある。
SDL_Window *CreateWindow(in string name, in ushort width, in ushort height)
{
    return
        SDL_CreateWindow(name.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_ALWAYS_ON_TOP)
        .enforceEx!CreationException(SDL_GetError().to!string);
}

/// @brief ウィンドウを破棄する。
/// @param window 破棄するウィンドウ。
void Destroy(SDL_Window *window) nothrow @nogc
{
    if(window !is null)
    {
        window.SDL_DestroyWindow;
    }
}

/// @brief   レンダラを生成する。
/// @param   window ウィンドウ。
/// @return  生成したレンダラ。
/// @throws  CreationException レンダラ生成に失敗した場合。
/// @details レンダラ使用後はDestroy()で破棄する必要がある。
SDL_Renderer *CreateRenderer(SDL_Window *window)
{
    return
        window.SDL_CreateRenderer(-1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED)
        .enforceEx!CreationException(SDL_GetError().to!string);
}

/// @brief レンダラを破棄する。
/// @param renderer 破棄するレンダラ。
void Destroy(SDL_Renderer *renderer) nothrow @nogc
{
    if(renderer !is null)
    {
        renderer.SDL_DestroyRenderer;
    }
}

/// @brief   サーフェスを生成する。
/// @param   width  幅。
/// @param   height 高さ。
/// @return  生成したサーフェス。
/// @throws  CreationException サーフェス生成に失敗した場合。
/// @details サーフェス使用後はFree()で解放する必要がある。
SDL_Surface *CreateSurface(in uint width, in uint height)
{
    return
        SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0)
        .enforceEx!CreationException(SDL_GetError().to!string);
}

/// @brief サーフェスを解放する。
/// @param surface 解放するサーフェス。
void Free(SDL_Surface *surface) nothrow @nogc
{
    if(surface !is null)
    {
        surface.SDL_FreeSurface;
    }
}

/// @brief サーフェスを透過色で塗りつぶす。
/// @param surface 塗りつぶすサーフェス。
/// @param red     透過色の赤の明度。
/// @param green   透過色の緑の明度。
/// @param blue    透過色の青の明度。
void FillAlpha(SDL_Surface *surface, in ubyte red, in ubyte green, in ubyte blue) nothrow @nogc
{
    immutable map = surface.format.SDL_MapRGB(red, green, blue);

    surface.SDL_SetColorKey(SDL_TRUE, map);
    surface.SDL_FillRect(null, map);
}

/// @brief サーフェスに矩形を描画する。
/// @param surface 描画するサーフェス。
/// @param rect    描画する矩形。
/// @param red     矩形の赤の明度。
/// @param green   矩形の緑の明度。
/// @param blue    矩形の青の明度。
void FillRect(SDL_Surface *surface, in SDL_Rect rect, in ubyte red, in ubyte green, in ubyte blue) nothrow @nogc
{
    immutable map = surface.format.SDL_MapRGB(red, green, blue);

    surface.SDL_FillRect(&rect, map);
}

/// @brief   サーフェスをテクスチャに変換する。
/// @param   renderer 使用するレンダラ。
/// @param   surface  変換するサーフェス。
/// @return  生成したテクスチャ。
/// @throws  CreationException テクスチャ生成に失敗した場合。
/// @details テクスチャ使用後はDestroy()で破棄する必要がある。
SDL_Texture *ConvertToTexture(SDL_Renderer *renderer, SDL_Surface *surface)
{
    return
        renderer.SDL_CreateTextureFromSurface(surface)
        .enforceEx!CreationException(SDL_GetError().to!string);
}

/// @brief テクスチャを破棄する。
/// @param texture 破棄するテクスチャ。
void Destroy(SDL_Texture *texture) nothrow @nogc
{
    if(texture !is null)
    {
        texture.SDL_DestroyTexture;
    }
}
