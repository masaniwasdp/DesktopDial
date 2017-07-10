/**
 * 時計盤の描画を扱うモジュール。
 *
 * Date: 2017/7/11
 * Authors: masaniwa
 */

module desktopdial.dial;

import std.datetime : SysTime;

import desktopdial.exception : InvalidParamException;
import desktopdial.face : Face, FaceVisual;
import desktopdial.hand : Hand, HandVisual;
import desktopdial.handsangle : calcHandsAngle;
import desktopdial.sdlutil : createRenderer, createWindow, destroy;

import sdl = derelict.sdl2.sdl;

public:

/**
 * 時計盤の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 */
class Dial
{
public:
    /**
     * コンストラクタ。
     *
     * Params:
     *     definition = 時計盤の定義。
     *
     * Throws:
     *     InvalidParamException = 定義が無効だった場合。
     *     desktopdial.exception.CreationException = オブジェクトの生成に失敗した場合。
     */
    this(in DialDefinition definition)
    {
        validateDefinition(definition);

        background = definition.background;
        window = createWindow(definition.name, definition.width, definition.height);
        renderer = window.createRenderer;

        immutable sdl.SDL_Rect region = { w: definition.width, h: definition.height };

        face = new Face(renderer, region, definition.face);

        hour = new Hand(renderer, region, definition.hour);
        minute = new Hand(renderer, region, definition.minute);
        second = new Hand(renderer, region, definition.second);
    }

    /** デストラクタ。 */
    ~this() nothrow @nogc
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

        sdl.SDL_RenderPresent(renderer);
    }

private:
    /** レンダラを消去する。 */
    void clear() nothrow @nogc
    {
        sdl.SDL_SetRenderDrawColor(renderer, background.r, background.g, background.b, sdl.SDL_ALPHA_OPAQUE);
        sdl.SDL_RenderClear(renderer);
    }

    /**
     * 針を描画する。
     *
     * Params:
     *     time = 時刻。
     */
    void drawHands(in SysTime time) nothrow
    {
        immutable angle = time.calcHandsAngle;

        hour.draw(angle.hour);
        minute.draw(angle.minute);
        second.draw(angle.second);
    }

    immutable BackgroundColor background; /// 背景色。

    sdl.SDL_Window* window;     /// ウィンドウ。
    sdl.SDL_Renderer* renderer; /// レンダラ。

    Face face; /// 文字盤。

    Hand hour;   /// 時針。
    Hand minute; /// 分針。
    Hand second; /// 秒針。
}

/** 時計盤を定義する構造体。 */
struct DialDefinition
{
    /** Postblits。 */
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

private:

/**
 * 時計盤の定義が有効かどうか検証する。
 *
 * Params:
 *     definition = 調べる定義。
 *
 * Throws:
 *     InvalidParamException = 定義が無効だった場合。
 */
void validateDefinition(in DialDefinition definition) pure @safe
{
    if (definition.width < WindowSize.min || definition.height < WindowSize.min)
    {
        throw new InvalidParamException(WindowError.tooSmall);
    }

    if (definition.width > WindowSize.max || definition.height > WindowSize.max)
    {
        throw new InvalidParamException(WindowError.tooLarge);
    }
}

/** ウィンドウに関するエラーメッセージ。 */
enum WindowError
{
    tooSmall = "Window size was too small.", /// ウィンドウが小さすぎたメッセージ。
    tooLarge = "Window size was too large."  /// ウィンドウが大きすぎたメッセージ。
}

/** ウィンドウサイズ。 */
enum WindowSize
{
    min = 1,   /// 最小。
    max = 1024 /// 最大。
}
