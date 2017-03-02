///
/// @file      Dial.d
/// @brief     時計盤の描画を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Dial;

import std.datetime;

import derelict.sdl2.sdl;

import DesktopDial.Exception,
       DesktopDial.Hand,
       DesktopDial.HandsAngle,
       DesktopDial.SDLUtil;

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

        background_ = definition.Background;
        window_ = CreateWindow(definition.Name, definition.Width, definition.Height);
        renderer_ = window_.CreateRenderer;

        immutable SDL_Rect region =
        {
            w: definition.Width,
            h: definition.Height
        };

        hour_ = new Hand(renderer_, region, definition.Hour);
        minute_ = new Hand(renderer_, region, definition.Minute);
        second_ = new Hand(renderer_, region, definition.Second);
    }

    /// @デストラクタ。
    ~this()
    {
        window_.Destroy;
        renderer_.Destroy;
    }

    /// @brief 時計盤を描画する。
    /// @param time 時刻。
    void Draw(in SysTime time) nothrow
    {
        clear;
        drawHands(time);
        renderer_.SDL_RenderPresent;
    }

private:
    static immutable tooSmallWindowError_ = "Window size was too small."; ///< ウィンドウが小さすぎたメッセージ。
    static immutable tooLargeWindowError_ = "Window size was too large."; ///< ウィンドウが大きすぎたメッセージ。

    static immutable minWindowSize_ = 1;    ///< 最低のウィンドウサイズ。
    static immutable maxWindowSize_ = 1024; ///< 最大のウィンドウサイズ。

    immutable BackgroundColor background_; ///< 背景色。

    /// @brief  時計盤の定義が有効かどうか検証する。
    /// @param  definition 調べる定義。
    /// @throws InvalidParamException 定義が無効だった場合。
    static void validateDefinition(in ref DialDefinition definition) @safe pure
    {
        if(definition.Width < minWindowSize_ || definition.Height < minWindowSize_)
        {
            throw new InvalidParamException(tooSmallWindowError_);
        }
        else if(definition.Width > maxWindowSize_ || definition.Height > maxWindowSize_)
        {
            throw new InvalidParamException(tooLargeWindowError_);
        }
    }

    /// @brief レンダラを消去する。
    void clear() nothrow
    {
        renderer_.SDL_SetRenderDrawColor(background_.Red, background_.Green, background_.Blue, SDL_ALPHA_OPAQUE);
        renderer_.SDL_RenderClear;
    }

    /// @brief 針を描画する。
    /// @param time 時刻。
    void drawHands(in SysTime time) nothrow
    {
        immutable angle = CalcHandsAngle(time);

        hour_.Draw(angle.Hour);
        minute_.Draw(angle.Minute);
        second_.Draw(angle.Second);
    }

    SDL_Window *window_;      ///< ウィンドウ。
    SDL_Renderer *renderer_;  ///< レンダラ。

    Hand hour_;   ///< 時針。
    Hand minute_; ///< 分針。
    Hand second_; ///< 秒針。
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
