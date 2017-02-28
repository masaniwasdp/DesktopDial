///
/// @file      SDLUtil.d
/// @brief     SDLユーティリティモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.SDLUtil;

import std.string,
       std.exception;

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
    return
        SDL_CreateWindow(name.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_ALWAYS_ON_TOP)
        .enforceEx!(CreationException)(failedToCreateWindow);
}

/// @brief   ウィンドウのレンダラを生成する。
/// @param   window ウィンドウ。
/// @return  生成したレンダラ。
/// @throws  CreationException レンダラ生成に失敗した場合。
/// @details レンダラ使用後はSDL_DestroyRenderer()で破棄する必要がある。
SDL_Renderer *CreateRenderer(SDL_Window *window)
{
    return
        window.SDL_CreateRenderer(-1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED)
        .enforceEx!(CreationException)(failedToCreateRenderer);
}

/// @brief   サーフェスを生成する。
/// @param   width  幅。
/// @param   height 高さ。
/// @param   depth  ビット深度。
/// @return  生成したサーフェス。
/// @throws  CreationException サーフェス生成に失敗した場合。
/// @details サーフェス使用後はSDL_FreeSurface()で解放する必要がある。
SDL_Surface *CreateSurface(in uint width, in uint height, in uint depth)
{
    return
        SDL_CreateRGBSurface(0, width, height, depth, 0, 0, 0, 0)
        .enforceEx!(CreationException)(failedToCreateSurface);
}

/// @brief   サーフェスをテクスチャに変換する。
/// @param   renderer 使用するレンダラ。
/// @param   surface  変換するサーフェス。
/// @return  生成したテクスチャ。
/// @throws  CreationException テクスチャ生成に失敗した場合。
/// @details テクスチャ使用後はSDL_DestroyTexture()で破棄する必要がある。
SDL_Texture *ConvertToTexture(SDL_Renderer *renderer, SDL_Surface *surface)
{
    return
        renderer.SDL_CreateTextureFromSurface(surface)
        .enforceEx!(CreationException)(failedToCreateTexture);
}

private immutable failedToCreateWindow = "Failed to create window object.";     ///< ウィンドウの生成に失敗したエラーメッセージ。
private immutable failedToCreateRenderer = "Failed to create renderer object."; ///< レンダラの生成に失敗したエラーメッセージ。
private immutable failedToCreateSurface = "Failed to create surface object.";   ///< サーフェス作成に失敗したエラーメッセージ。
private immutable failedToCreateTexture = "Failed to create texture object.";   ///< テクスチャ作成に失敗したエラーメッセージ。
