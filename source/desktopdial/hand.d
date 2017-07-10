/**
 * 時計盤の針の描画を扱うモジュール。
 *
 * Date: 2017/7/10
 * Authors: masaniwa
 */

module desktopdial.hand;

import std.exception : enforceEx;

import desktopdial.exception : InvalidParamException;
import desktopdial.sdlutil : convertToTexture, createSurface, fillAlpha, fillRect, free;

import sdl = derelict.sdl2.sdl;

public:

/**
 * 時計盤の針の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 */
class Hand
{
public:
    /**
     * コンストラクタ。
     *
     * Params:
     *     renderer = 使用するレンダラ。
     *     region = 時計盤の領域。
     *     visual = 針の見た目。
     *
     * Throws:
     *     InvalidParamException = レンダラが無効だった場合。
     *     desktopdial.exception.CreationException = オブジェクト生成に失敗した場合。
     */
    this(sdl.SDL_Renderer* renderer, in sdl.SDL_Rect region, in HandVisual visual)
    {
        this.renderer = renderer.enforceEx!InvalidParamException(Error.invalidRenderer);
        this.region = region;

        auto surface = createSurface(region.w, region.h);
        scope(exit) surface.free;

        immutable shape = calcShape(region, visual.size);

        surface.fillAlpha(visual.color.alphaR, visual.color.alphaG, visual.color.alphaB);
        surface.fillRect(shape, visual.color.r, visual.color.g, visual.color.b);

        texture = renderer.convertToTexture(surface);
    }

    /** デストラクタ。 */
    ~this() nothrow @nogc
    {
        texture.destroy;
    }

    /**
     * 針を描画する。
     *
     * Params:
     *     angle = 針の角度。
     */
    void draw(in double angle) nothrow @nogc
    {
        sdl.SDL_RenderCopyEx(renderer, texture, null, &region, angle, null, sdl.SDL_FLIP_NONE);
    }

private:
    immutable sdl.SDL_Rect region; /// 時計盤の領域。

    sdl.SDL_Renderer* renderer;  /// 使用するレンダラ。
    sdl.SDL_Texture* texture;    /// 針のテクスチャ。
}

/** 針の見た目を表す構造体。 */
struct HandVisual
{
    HandSize size;   /// サイズ。
    HandColor color; /// 色。
}

/** 針のサイズを表す構造体。 */
struct HandSize
{
    ushort width;       /// 幅。
    ushort longLength;  /// 長い方の中心からの長さ。
    ushort shortLength; /// 短い方の中心からの長さ。
}

/** 針の色を表す構造体。 */
struct HandColor
{
    ubyte r; /// 赤の明度。
    ubyte g; /// 緑の明度。
    ubyte b; /// 青の明度。

    ubyte alphaR; /// 透過色の赤の明度。
    ubyte alphaG; /// 透過色の緑の明度。
    ubyte alphaB; /// 透過色の青の明度。
}

private:

/**
 * 針の形を計算する。
 *
 * Params:
 *     region = 時計盤の領域。
 *     size = 針のサイズ。
 *
 * Returns: 計算した針の形。
 */
sdl.SDL_Rect calcShape(in sdl.SDL_Rect region, in HandSize size) nothrow pure @safe @nogc
{
    immutable sdl.SDL_Rect shape =
    {
        x: (region.w / 2) - (size.width / 2),
        y: (region.h / 2) - size.longLength,
        w: size.width,
        h: size.longLength + size.shortLength
    };

    return shape;
}

/** エラーメッセージ。 */
enum Error
{
    invalidRenderer = "Renderer object was invalid." /// レンダラが無効だったメッセージ。
}
