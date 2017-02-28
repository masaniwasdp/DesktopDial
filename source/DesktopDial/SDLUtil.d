///
/// @file      SDLUtil.d
/// @brief     SDLユーティリティモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.SDLUtil;

import std.exception,
       std.string;

import derelict.sdl2.sdl;

import DesktopDial.Exception;

/// @brief   ウィンドウを生成する。
/// @param   name   名前。
/// @param   width  幅。
/// @param   height 高さ。
/// @return  生成したウィンドウ。
/// @throws  CreationException   ウィンドウ生成に失敗した場合。
/// @details ウィンドウ使用後はSDL_DestroyWindow()で破棄する必要がある。
SDL_Window *CreateWindow(in string name, in ushort width, in ushort height)
{
    static immutable error = "Failed to create window object.";

    auto window = SDL_CreateWindow(name.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_ALWAYS_ON_TOP);

    return window.enforceEx!(CreationException)(error);
}

/// @brief   ウィンドウのレンダラを生成する。
/// @param   window ウィンドウ。
/// @return  生成したレンダラ。
/// @throws  CreationException レンダラ生成に失敗した場合。
/// @details レンダラ使用後はSDL_DestroyRenderer()で破棄する必要がある。
SDL_Renderer *CreateRenderer(SDL_Window *window)
{
    static immutable error = "Failed to create renderer object.";

    auto renderer = window.SDL_CreateRenderer(-1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);

    return renderer.enforceEx!(CreationException)(error);
}

/// @brief   サーフェスを生成する。
/// @param   width  幅。
/// @param   height 高さ。
/// @return  生成したサーフェス。
/// @throws  CreationException サーフェス生成に失敗した場合。
/// @details サーフェス使用後はSDL_FreeSurface()で解放する必要がある。
SDL_Surface *CreateSurface(in uint width, in uint height)
{
    static immutable error = "Failed to create surface object.";

    auto surface = SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0);

    return surface.enforceEx!(CreationException)(error);
}

/// @brief   サーフェスをテクスチャに変換する。
/// @param   renderer 使用するレンダラ。
/// @param   surface  変換するサーフェス。
/// @return  生成したテクスチャ。
/// @throws  CreationException テクスチャ生成に失敗した場合。
/// @details テクスチャ使用後はSDL_DestroyTexture()で破棄する必要がある。
SDL_Texture *ConvertToTexture(SDL_Renderer *renderer, SDL_Surface *surface)
{
    static immutable error = "Failed to create texture object.";

    auto texture = renderer.SDL_CreateTextureFromSurface(surface);

    return texture.enforceEx!(CreationException)(error);
}
