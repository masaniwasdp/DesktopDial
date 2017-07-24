/**
 * 時計盤の文字盤の描画を扱うモジュール。
 *
 * Date: 2017/7/24
 * Authors: masaniwa
 */

module desktopdial.face;

import std.range : iota;

import desktopdial.exception : CreationException, DrawingException;
import desktopdial.sdlutil : convertToTexture, createSurface, fillAlpha, fillRect, free;

import derelict.sdl2.sdl;

/**
 * 時計盤の文字盤の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 */
class Face
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     renderer = 使用するレンダラ。
     *     region = 時計盤の領域。
     *     visual = 文字盤の見た目。
     *
     * Throws:
     *     CreationException オブジェクト生成に失敗した場合。
     */
    this(SDL_Renderer* renderer, in SDL_Rect region, in FaceVisual visual)
    in
    {
        assert(renderer);
    }
    body
    {
        this.renderer = renderer;
        this.region = region;

        try
        {
            large = renderer.drawChar(region, visual.large);
            small = renderer.drawChar(region, visual.small);
        }
        catch (DrawingException e)
        {
            throw new CreationException("Failed to create the face.", e);
        }
    }

    ~this()
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

    private immutable SDL_Rect region; /// 時計盤の領域。

    private SDL_Renderer* renderer; /// 使用するレンダラ。
    private SDL_Texture* large;     /// 大きな文字のテクスチャ。
    private SDL_Texture* small;     /// 小さな文字のテクスチャ。

    invariant()
    {
        assert(renderer);
        assert(large);
        assert(small);
    }
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
 *     DrawingException 描画に失敗した場合。
 */
private SDL_Texture* drawChar(SDL_Renderer* renderer, in SDL_Rect region, in CharVisual visual)
in
{
    assert(renderer);
}
body
{
    try
    {
        auto surface = createSurface(region.w, region.h);

        scope (exit) surface.free;

        immutable SDL_Rect shape =
        {
            x: region.w / 2 - visual.size.width / 2,
            y: region.h / 2 - visual.size.start - visual.size.length,
            w: visual.size.width,
            h: visual.size.length
        };

        surface.fillAlpha(visual.color.alphaR, visual.color.alphaG, visual.color.alphaB);
        surface.fillRect(shape, visual.color.r, visual.color.g, visual.color.b);

        return renderer.convertToTexture(surface);
    }
    catch (CreationException e)
    {
        throw new DrawingException("Failed to draw the character.", e);
    }
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
private void overlaid(SDL_Renderer* renderer, in SDL_Rect region, SDL_Texture* texture, in ushort unit) nothrow @nogc
in
{
    assert(renderer);
    assert(texture);
}
body
{
    foreach (angle; iota(0, 360, unit))
    {
        SDL_RenderCopyEx(renderer, texture, null, &region, angle, null, SDL_FLIP_NONE);
    }
}

/** 文字盤の文字1単位の角度。 */
private enum AngleUnit
{
    large = 90, /// 大きな文字。
    small = 30  /// 小さな文字。
}
