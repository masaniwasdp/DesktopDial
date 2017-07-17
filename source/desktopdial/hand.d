/**
 * 時計盤の針の描画を扱うモジュール。
 *
 * Date: 2017/7/18
 * Authors: masaniwa
 */

module desktopdial.hand;

import desktopdial.exception : CreationException, DrawingException;
import desktopdial.sdlutil : convertToTexture, createSurface, fillAlpha, fillRect, free;

import sdl = derelict.sdl2.sdl;

/**
 * 時計盤の針の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 */
class Hand
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     renderer = 使用するレンダラ。
     *     region = 時計盤の領域。
     *     visual = 針の見た目。
     *
     * Throws:
     *     CreationException オブジェクト生成に失敗した場合。
     */
    this(sdl.SDL_Renderer* renderer, in sdl.SDL_Rect region, in HandVisual visual)
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
            texture = renderer.drawHand(region, visual);
        }
        catch (DrawingException e)
        {
            throw new CreationException("Failed to create the hand.", e);
        }
    }

    ~this()
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

    private immutable sdl.SDL_Rect region; /// 時計盤の領域。

    private sdl.SDL_Renderer* renderer; /// 使用するレンダラ。
    private sdl.SDL_Texture* texture;   /// 針のテクスチャ。

    invariant()
    {
        assert(renderer);
        assert(texture);
    }
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

/**
 * 針を描く。
 *
 * テクスチャ使用後はfree()で解放する必要がある。
 *
 * Params:
 *     renderer = 使用するレンダラ。
 *     region = 時計盤の領域。
 *     visual = 針の見た目。
 *
 * Returns: 針を描いたテクスチャ。
 *
 * Throws:
 *     DrawingException 描画に失敗した場合。
 */
private sdl.SDL_Texture* drawHand(sdl.SDL_Renderer* renderer, in sdl.SDL_Rect region, in HandVisual visual)
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

        immutable sdl.SDL_Rect shape =
        {
            x: region.w / 2 - visual.size.width / 2,
            y: region.h / 2 - visual.size.longLength,
            w: visual.size.width,
            h: visual.size.longLength + visual.size.shortLength
        };

        surface.fillAlpha(visual.color.alphaR, visual.color.alphaG, visual.color.alphaB);
        surface.fillRect(shape, visual.color.r, visual.color.g, visual.color.b);

        return renderer.convertToTexture(surface);
    }
    catch (CreationException e)
    {
        throw new DrawingException("Failed to draw the hand.", e);
    }
}
