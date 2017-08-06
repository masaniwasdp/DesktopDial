/**
 * 時計盤の描画を扱うモジュール。
 *
 * Date: 2017/8/7
 * Authors: masaniwa
 */

module desktopdial.dial;

import std.datetime : SysTime;

import desktopdial.exception : CreationException;
import desktopdial.face : Face, FaceVisual;
import desktopdial.hands : Hands, HandVisuals;
import desktopdial.handsangle : calcHandsAngle;
import desktopdial.sdlutil : Color, createRenderer, createWindow, destroy;

import derelict.sdl2.sdl;

/**
 * 時計盤の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 * また、SDLを終了する前に破棄する必要がある。
 */
class Dial
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     definition = 時計盤の定義。
     *
     * Throws:
     *     CreationException オブジェクトの生成に失敗した場合。
     */
    this(in DialDefinition definition)
    {
        immutable SDL_Rect region = { 0, 0, definition.width, definition.height };

        background = definition.background;

        try
        {
            window = createWindow(definition.name, definition.width, definition.height);

            renderer = window.createRenderer;

            face = new Face(renderer, region, definition.face);

            hands = new Hands(renderer, region, definition.hands);
        }
        catch (CreationException e)
        {
            throw new CreationException("Failed to create the dial.", e);
        }
    }

    ~this()
    {
        object.destroy(face);
        object.destroy(hands);

        renderer.destroy;
        window.destroy;
    }

    /**
     * 時計盤を描画する。
     *
     * Params:
     *     time = 時刻。
     */
    void draw(in SysTime time) nothrow
    {
        SDL_SetRenderDrawColor(renderer, background.r, background.g, background.b, SDL_ALPHA_OPAQUE);

        SDL_RenderClear(renderer);

        face.draw;

        hands.draw(time);

        SDL_RenderPresent(renderer);
    }

    private immutable Color background; /// 背景色。

    private SDL_Window* window; /// ウィンドウ。

    private SDL_Renderer* renderer; /// レンダラ。

    private Face face; /// 文字盤。

    private Hands hands; /// 針。

    invariant()
    {
        assert(window);
        assert(renderer);
        assert(face);
        assert(hands);
    }
}

/** 時計盤を定義する構造体。 */
struct DialDefinition
{
    string name; /// ウィンドウの名前。

    ushort width;  /// ウィンドウの幅。
    ushort height; /// ウィンドウの高さ。

    Color background; /// 背景色。

    FaceVisual face;   /// 文字盤。

    HandVisuals hands; /// 針。
}
