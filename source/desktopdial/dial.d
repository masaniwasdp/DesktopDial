///
/// @file      dial.d
/// @brief     時計盤の描画を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module desktopdial.dial;

import std.datetime:
    SysTime;

import desktopdial.exception:
    InvalidParamException;

import desktopdial.hand:
    Hand, HandVisual;

import desktopdial.handsangle:
    calcHandsAngle;

import desktopdial.sdlutil:
    createRenderer, createWindow, destroy;

import sdl = derelict.sdl2.sdl;

public:

/// @brief   時計盤の描画を扱うクラス。
/// @details 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
class Dial
{
public:
    /// @brief  コンストラクタ。
    /// @param  definition 時計盤の定義。
    /// @throws InvalidParamException   定義が無効だった場合。
    /// @throws CreationException       オブジェクトの生成に失敗した場合。
    this(in ref DialDefinition definition)
    {
        validateDefinition(definition);

        background = definition.Background;
        window = createWindow(definition.Name, definition.Width, definition.Height);
        renderer = window.createRenderer;

        immutable sdl.SDL_Rect region =
        {
            w: definition.Width,
            h: definition.Height
        };

        hour = new Hand(renderer, region, definition.Hour);
        minute = new Hand(renderer, region, definition.Minute);
        second = new Hand(renderer, region, definition.Second);
    }

    /// @デストラクタ。
    ~this() nothrow @nogc
    {
        window.destroy;
        renderer.destroy;
    }

    /// @brief 時計盤を描画する。
    /// @param time 時刻。
    void draw(in SysTime time) nothrow
    {
        clear;
        drawHands(time);
        sdl.SDL_RenderPresent(renderer);
    }

private:
    immutable BackgroundColor background; ///< 背景色。

    /// @brief レンダラを消去する。
    void clear() nothrow @nogc
    {
        sdl.SDL_SetRenderDrawColor(renderer, background.Red, background.Green, background.Blue, sdl.SDL_ALPHA_OPAQUE);
        sdl.SDL_RenderClear(renderer);
    }

    /// @brief 針を描画する。
    /// @param time 時刻。
    void drawHands(in SysTime time) nothrow
    {
        immutable angle = time.calcHandsAngle;

        hour.draw(angle.Hour);
        minute.draw(angle.Minute);
        second.draw(angle.Second);
    }

    sdl.SDL_Window *window;      ///< ウィンドウ。
    sdl.SDL_Renderer *renderer;  ///< レンダラ。

    Hand hour;   ///< 時針。
    Hand minute; ///< 分針。
    Hand second; ///< 秒針。
}

/// @brief 時計盤を定義する構造体。
struct DialDefinition
{
    string Name; ///< ウィンドウの名前。

    ushort Width;  ///< ウィンドウの幅。
    ushort Height; ///< ウィンドウの高さ。

    BackgroundColor Background; ///< 背景色。

    HandVisual Hour;   ///< 時針。
    HandVisual Minute; ///< 分針。
    HandVisual Second; ///< 秒針。
}

/// @brief 背景色を表す構造体。
struct BackgroundColor
{
    ubyte Red;   ///< 赤の明度。
    ubyte Green; ///< 青の明度。
    ubyte Blue;  ///< 緑の明度。
}

private:

/// @brief  時計盤の定義が有効かどうか検証する。
/// @param  definition 調べる定義。
/// @throws InvalidParamException 定義が無効だった場合。
void validateDefinition(in ref DialDefinition definition) pure @safe
{
    if(definition.Width < minWindowSize || definition.Height < minWindowSize) throw new InvalidParamException(tooSmallWindowError);

    if(definition.Width > maxWindowSize || definition.Height > maxWindowSize) throw new InvalidParamException(tooLargeWindowError);
}

immutable tooSmallWindowError = "Window size was too small."; ///< ウィンドウが小さすぎたメッセージ。
immutable tooLargeWindowError = "Window size was too large."; ///< ウィンドウが大きすぎたメッセージ。

immutable minWindowSize = 1;    ///< 最低のウィンドウサイズ。
immutable maxWindowSize = 1024; ///< 最大のウィンドウサイズ。
