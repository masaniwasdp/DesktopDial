/**
 * 時計盤の文字盤の描画を扱うモジュール。
 *
 * Date: 2017/7/10
 * Authors: masaniwa
 */

module desktopdial.face;

import std.exception : enforceEx;
import std.range : iota;

import desktopdial.exception : InvalidParamException;
import desktopdial.sdlutil : convertToTexture, createSurface, fillAlpha, fillRect, free;

import sdl = derelict.sdl2.sdl;

public:

/**
 * 時計盤の文字盤の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 */
class Face
{
public:
    /**
     * コンストラクタ。
     *
     * Params:
     *     renderer = 使用するレンダラ。
     *     region = 時計盤の領域。
     *     visual = 文字盤の見た目。
     *
     * Throws:
     *     InvalidParamException = レンダラが無効だった場合。
     *     desktopdial.exception.CreationException = オブジェクト生成に失敗した場合。
     */
    this(sdl.SDL_Renderer* renderer, in sdl.SDL_Rect region, in FaceVisual visual)
    {
        this.renderer = renderer.enforceEx!InvalidParamException(Error.invalidRenderer);
        this.region = region;

        large = renderer.drawChar(region, visual.large);
        small = renderer.drawChar(region, visual.small);
    }

    /** デストラクタ。 */
    ~this() nothrow @nogc
    {
        large.destroy;
        small.destroy;
    }

    /** 文字盤を描画する。 */
    void draw() nothrow @nogc
    {
        renderer.overlaid(region, small, AngleUnit.small);
        renderer.overlaid(region, large, AngleUnit.large);
    }

private:
    immutable sdl.SDL_Rect region; /// 時計盤の領域。

    sdl.SDL_Renderer* renderer; /// 使用するレンダラ。
    sdl.SDL_Texture* large;     /// 大きな文字のテクスチャ。
    sdl.SDL_Texture* small;     /// 小さな文字のテクスチャ。
}

/** 文字盤の見た目を表す構造体。 */
struct FaceVisual
{
    CharVisual large; /// 大きな文字。
    CharVisual small; /// 小さな文字。
}

/** 文字盤の文字の見た目を表す構造体。 */
struct CharVisual
{
    CharSize size;   /// サイズ。
    CharColor color; /// 色。
}

/** 文字盤の文字のサイズを表す構造体。 */
struct CharSize
{
    ushort width;  /// 幅。
    ushort start;  /// 時計盤の中心から始点までの距離。
    ushort length; /// 長さ。
}

/** 文字盤の文字の色を表す構造体。 */
struct CharColor
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
 * 文字の形を計算する。
 *
 * Params:
 *     region = 時計盤の領域。
 *     size = 文字のサイズ。
 *
 * Returns: 計算した針の形。
 */
sdl.SDL_Rect calcShape(in sdl.SDL_Rect region, in CharSize size) nothrow pure @safe @nogc
{
    immutable sdl.SDL_Rect shape =
    {
        x: (region.w / 2) - (size.width / 2),
        y: (region.h / 2) - size.start - size.length,
        w: size.width,
        h: size.length
    };

    return shape;
}

/**
 * 0時の部分に文字を描く。
 *
 * テクスチャ使用後はfree()で破棄する必要がある。
 *
 * Params:
 *     renderer = 使用するレンダラ。
 *     region = 時計盤の領域。
 *     visual = 文字の見た目。
 *
 * Returns: 文字を描いたテクスチャ。
 *
 * Throws:
 *     desktopdial.exception.CreationException = オブジェクト生成に失敗した場合。
 */
sdl.SDL_Texture* drawChar(sdl.SDL_Renderer* renderer, in sdl.SDL_Rect region, in CharVisual visual)
{
    auto surface = createSurface(region.w, region.h);
    scope(exit) surface.free;

    immutable shape = calcShape(region, visual.size);

    surface.fillAlpha(visual.color.alphaR, visual.color.alphaG, visual.color.alphaB);
    surface.fillRect(shape, visual.color.r, visual.color.g, visual.color.b);

    return renderer.convertToTexture(surface);
}

/**
 * テクスチャを回転させながら重ねてレンダリングする。
 *
 * Params:
 *     renderer = 使用するレンダラ。
 *     region = 時計盤の領域。
 *     texture = レンダリングするテクスチャ。
 *     step = 1単位の回転角。
 */
void overlaid(
        sdl.SDL_Renderer* renderer, in sdl.SDL_Rect region, sdl.SDL_Texture* texture, in ushort unit) nothrow @nogc
{
    foreach (angle; iota(0, 360, unit))
    {
        sdl.SDL_RenderCopyEx(renderer, texture, null, &region, angle, null, sdl.SDL_FLIP_NONE);
    }
}

/** 文字盤の文字1単位の角度。 */
enum AngleUnit
{
    large = 90, /// 大きな文字。
    small = 30  /// 小さな文字。
}

/** エラーメッセージ。 */
enum Error
{
    invalidRenderer = "Renderer object was invalid." /// レンダラが無効だったメッセージ。
}
