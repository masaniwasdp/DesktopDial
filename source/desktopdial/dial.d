/**
 * 時計盤の描画を扱うモジュール。
 *
 * Date: 2017/7/24
 * Authors: masaniwa
 */

module desktopdial.dial;

import std.datetime : SysTime;

import desktopdial.exception : CreationException;
import desktopdial.face : Face, FaceVisual;
import desktopdial.hand : Hand, HandVisual;
import desktopdial.handsangle : calcHandsAngle;
import desktopdial.sdlutil : createRenderer, createWindow, destroy;

import derelict.sdl2.sdl;

/**
 * 時計盤の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
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
        immutable SDL_Rect region = { w: definition.width, h: definition.height };

        background = definition.background;

        try
        {
            window = createWindow(definition.name, definition.width, definition.height);
            renderer = window.createRenderer;

            face = new Face(renderer, region, definition.face);

            hour = new Hand(renderer, region, definition.hour);
            minute = new Hand(renderer, region, definition.minute);
            second = new Hand(renderer, region, definition.second);
        }
        catch (CreationException e)
        {
            throw new CreationException("Failed to create the dial.", e);
        }
    }

    ~this()
    {
        window.destroy;
        renderer.destroy;
    }

    /**
     * 時計盤を描画する。
     *
     * Params:
     *     time = 時刻。
     */
    void draw(in SysTime time) nothrow
    {
        clear;

        face.draw;

        drawHands(time);

        SDL_RenderPresent(renderer);
    }

    /** レンダラを消去する。 */
    private void clear() nothrow @nogc
    {
        SDL_SetRenderDrawColor(renderer, background.r, background.g, background.b, SDL_ALPHA_OPAQUE);
        SDL_RenderClear(renderer);
    }

    /**
     * 針を描画する。
     *
     * Params:
     *     time = 時刻。
     */
    private void drawHands(in SysTime time) nothrow
    {
        immutable angle = time.calcHandsAngle;

        hour.draw(angle.hour);
        minute.draw(angle.minute);
        second.draw(angle.second);
    }

    private immutable BackgroundColor background; /// 背景色。

    private SDL_Window* window;     /// ウィンドウ。
    private SDL_Renderer* renderer; /// レンダラ。

    private Face face; /// 文字盤。

    private Hand hour;   /// 時針。
    private Hand minute; /// 分針。
    private Hand second; /// 秒針。

    invariant()
    {
        assert(window);
        assert(renderer);
        assert(face);
        assert(hour);
        assert(minute);
        assert(second);
    }
}

/** 時計盤を定義する構造体。 */
struct DialDefinition
{
    this(this)
    {
        name = name.dup;
    }

    string name; /// ウィンドウの名前。

    ushort width;  /// ウィンドウの幅。
    ushort height; /// ウィンドウの高さ。

    BackgroundColor background; /// 背景色。

    FaceVisual face; /// 文字盤。

    HandVisual hour;   /// 時針。
    HandVisual minute; /// 分針。
    HandVisual second; /// 秒針。
}

/** 背景色を表す構造体。 */
struct BackgroundColor
{
    ubyte r; /// 赤の明度。
    ubyte g; /// 青の明度。
    ubyte b; /// 緑の明度。
}
