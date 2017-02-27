///
/// @file      Graph.d
/// @brief     時計盤の描画を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Graph;

import std.datetime;

import derelict.sdl2.sdl;

import DesktopDial.Clock,
       DesktopDial.Exception,
       DesktopDial.Hand,
       DesktopDial.SDLUtil;

/// @brief   時計盤の描画を扱うクラス。
/// @details 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
class Graph
{
public:
    /// @brief  コンストラクタ。
    /// @param  definition        時計盤の定義。
    /// @throws CreationException オブジェクトの生成に失敗した場合。
    this(const ref GraphDefinition definition)
    {
        window_ = CreateWindow(definition.Name, definition.Width, definition.Height);
        renderer_ = window_.CreateRenderer;

        immutable SDL_Rect region = {w: definition.Width, h: definition.Height};

        HandDefinition hour = {Renderer: renderer_, Region: region, Size: definition.HourSize, Color: definition.HourColor};
        HandDefinition minute = {Renderer: renderer_, Region: region, Size: definition.MinuteSize, Color: definition.MinuteColor};
        HandDefinition second = {Renderer: renderer_, Region: region, Size: definition.SecondSize, Color: definition.SecondColor};

        hour_ = new Hand(hour);
        minute_ = new Hand(minute);
        second_ = new Hand(second);
    }

    /// @デストラクタ。
    ~this()
    {
        if(window_ !is null)
        {
            window_.SDL_DestroyWindow;
        }

        if(renderer_ !is null)
        {
            renderer_.SDL_DestroyRenderer;
        }
    }

    /// @brief 時計盤を描画する。
    /// @param time 時刻。
    void Draw(const ref SysTime time) nothrow
    {
        clear;
        drawHands(time);
        renderer_.SDL_RenderPresent;
    }

private:
    /// @brief レンダラを消去する。
    void clear() nothrow
    {
        renderer_.SDL_SetRenderDrawColor(255, 255, 255, 255);
        renderer_.SDL_RenderClear;
    }

    /// @brief 針を描画する。
    /// @param time 時刻。
    void drawHands(const ref SysTime time) nothrow
    {
        immutable angle = time.CalcHandAngle;

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
struct GraphDefinition
{
    string Name; ///< ウィンドウの名前。

    ushort Width;  ///< ウィンドウの幅。
    ushort Height; ///< ウィンドウの高さ。

    HandSize HourSize;   ///< 時針のサイズ。
    HandSize MinuteSize; ///< 分針のサイズ。
    HandSize SecondSize; ///< 秒針のサイズ。

    HandColor HourColor;   ///< 時針の色。
    HandColor MinuteColor; ///< 分針の色。
    HandColor SecondColor; ///< 秒針の色。
}
