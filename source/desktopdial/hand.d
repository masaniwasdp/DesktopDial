/**
 * 時計盤の針の描画を扱うモジュール。
 *
 * Date: 2017/8/7
 * Authors: masaniwa
 */

module desktopdial.hand;

import desktopdial.exception : CreationException, DrawingException;
import desktopdial.sdlutil : Color, convertToTexture, createSurface, fillAlpha, fillRect, free;

import derelict.sdl2.sdl;

/**
 * 時計盤の針の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 * また、SDLを終了する前に破棄する必要がある。
 */
class Hand
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     renderer = 使用するレンダラ。使用を終えるまで破棄してはならない。
     *     region = 時計盤の領域。
     *     visual = 針の見た目。
     *
     * Throws:
     *     CreationException オブジェクト生成に失敗した場合。
     */
    this(SDL_Renderer* renderer, in SDL_Rect region, in HandVisual visual)
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
        SDL_RenderCopyEx(renderer, texture, null, &region, angle, null, SDL_FLIP_NONE);
    }

    private immutable SDL_Rect region; /// 時計盤の領域。

    private SDL_Renderer* renderer; /// 使用するレンダラ。

    private SDL_Texture* texture; /// 針のテクスチャ。

    invariant()
    {
        assert(renderer);
        assert(texture);
    }
}

/** 針の見た目を表す構造体。 */
struct HandVisual
{
    HandSize size; /// サイズ。

    Color color; /// 色。
    Color alpha; /// 透過色。
}

/** 針のサイズを表す構造体。 */
struct HandSize
{
    ushort width; /// 幅。

    ushort lengthL; /// 長い方の中心からの長さ。
    ushort lengthS; /// 短い方の中心からの長さ。
}

/**
 * 針を描く。
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
private SDL_Texture* drawHand(SDL_Renderer* renderer, in SDL_Rect region, in HandVisual visual)
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
            region.w / 2 - visual.size.width / 2,
            region.h / 2 - visual.size.lengthL,
            visual.size.width,
            visual.size.lengthL + visual.size.lengthS
        };

        surface.fillAlpha(visual.alpha);

        surface.fillRect(shape, visual.color);

        return renderer.convertToTexture(surface);
    }
    catch (CreationException e)
    {
        throw new DrawingException("Failed to draw the hand.", e);
    }
}
