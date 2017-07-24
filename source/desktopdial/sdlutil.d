/**
 * SDLユーティリティモジュール。
 *
 * Date: 2017/7/24
 * Authors: masaniwa
 */

module desktopdial.sdlutil;

import std.conv : to;
import std.exception : enforceEx;
import std.string : toStringz;

import desktopdial.exception : CreationException;

import derelict.sdl2.sdl;

/**
 * ウィンドウを生成する。
 *
 * ウィンドウ使用後はdestroy()で破棄する必要がある。
 *
 * Params:
 *     name = 名前。
 *     width = 幅。
 *     height = 高さ。
 *
 * Returns: 生成したウィンドウ。
 *
 * Throws:
 *     CreationException ウィンドウ生成に失敗した場合。
 */
SDL_Window* createWindow(in string name, in ushort width, in ushort height)
in
{
    assert(name);
}
body
{
    auto window = SDL_CreateWindow(
            name.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_ALWAYS_ON_TOP);

    return window.enforceEx!CreationException(SDL_GetError().to!string);
}

/**
 * ウィンドウを破棄する。
 *
 * Params:
 *     window = 破棄するウィンドウ。nullでもよい。
 */
void destroy(SDL_Window* window) nothrow @nogc
{
    SDL_DestroyWindow(window);
}

/**
 * レンダラを生成する。
 *
 * レンダラ使用後はdestroy()で破棄する必要がある。
 *
 * Params:
 *     window = ウィンドウ。
 *
 * Returns: 生成したレンダラ。
 *
 * Throws:
 *     CreationException レンダラ生成に失敗した場合。
 */
SDL_Renderer* createRenderer(SDL_Window* window)
in
{
    assert(window);
}
body
{
    auto renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);

    return renderer.enforceEx!CreationException(SDL_GetError().to!string);
}

/**
 * レンダラを破棄する。
 *
 * Params:
 *     renderer = 破棄するレンダラ。nullでもよい。
 */
void destroy(SDL_Renderer* renderer) nothrow @nogc
{
    if (renderer) SDL_DestroyRenderer(renderer);
}

/**
 * サーフェスを生成する。
 *
 * サーフェス使用後はfree()で解放する必要がある。
 *
 * Params:
 *     width = 幅。
 *     height = 高さ。
 *
 * Returns: 生成したサーフェス。
 *
 * Throws:
 *     CreationException サーフェス生成に失敗した場合。
 */
SDL_Surface* createSurface(in uint width, in uint height)
{
    auto surface = SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0);

    return surface.enforceEx!CreationException(SDL_GetError().to!string);
}

/**
 * サーフェスを解放する。
 *
 * Params:
 *     surface = 解放するサーフェス。nullでもよい。
 */
void free(SDL_Surface* surface) nothrow @nogc
{
    SDL_FreeSurface(surface);
}

/**
 * サーフェスを透過色で塗りつぶす。
 *
 * Params:
 *     surface = 塗りつぶすサーフェス。
 *     red = 透過色の赤の明度。
 *     green = 透過色の緑の明度。
 *     blue = 透過色の青の明度。
 */
void fillAlpha(SDL_Surface* surface, in ubyte red, in ubyte green, in ubyte blue) nothrow @nogc
in
{
    assert(surface);
}
body
{
    immutable map = SDL_MapRGB(surface.format, red, green, blue);

    SDL_SetColorKey(surface, SDL_TRUE, map);
    SDL_FillRect(surface, null, map);
}

/**
 * サーフェスに矩形を描画する。
 *
 * Params:
 *     surface = 描画するサーフェス。
 *     rect = 描画する矩形。
 *     red = 矩形の赤の明度。
 *     green = 矩形の緑の明度。
 *     blue = 矩形の青の明度。
 */
void fillRect(SDL_Surface* surface, in SDL_Rect rect, in ubyte red, in ubyte green, in ubyte blue) nothrow @nogc
in
{
    assert(surface);
}
body
{
    immutable map = SDL_MapRGB(surface.format, red, green, blue);

    SDL_FillRect(surface, &rect, map);
}

/**
 * サーフェスをテクスチャに変換する。
 *
 * テクスチャ使用後はdestroy()で破棄する必要がある。
 *
 * Params:
 *     renderer = 使用するレンダラ。
 *     surface = 変換するサーフェス。
 *
 * Returns: 生成したテクスチャ。
 *
 * Throws:
 *     CreationException テクスチャ生成に失敗した場合。
 */
SDL_Texture* convertToTexture(SDL_Renderer* renderer, SDL_Surface* surface)
in
{
    assert(renderer);
    assert(surface);
}
body
{
    auto texture = SDL_CreateTextureFromSurface(renderer, surface);

    return texture.enforceEx!CreationException(SDL_GetError().to!string);
}

/**
 * テクスチャを破棄する。
 *
 * Params:
 *     texture = 破棄するテクスチャ。nullでもよい。
 */
void destroy(SDL_Texture* texture) nothrow @nogc
{
    SDL_DestroyTexture(texture);
}
