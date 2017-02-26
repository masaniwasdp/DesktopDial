///
/// @file      Graph.d
/// @brief     時計盤の描画を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Graph;

import std.datetime,
       std.exception,
       std.string,
       std.typecons;

import derelict.sdl2.sdl;

import DesktopDial.Exception,
       DesktopDial.Hand;

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
        window_ =
            SDL_CreateWindow(
                    definition.Name.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
                    definition.Width, definition.Height, SDL_WINDOW_ALWAYS_ON_TOP)
            .enforceEx!(CreationException)(failedToCreateWindow_);

        renderer_ =
            window_.SDL_CreateRenderer(-1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED)
            .enforceEx!(CreationException)(failedToCreateRenderer_);

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
            SDL_DestroyWindow(window_);
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
        renderer_.SDL_SetRenderDrawColor(255, 255, 255, 255);
        renderer_.SDL_RenderClear;

        immutable angle = CalcAngle(time);

        hour_.Draw(angle[0]);
        minute_.Draw(angle[1]);
        second_.Draw(angle[2]);

        renderer_.SDL_RenderPresent;
    }

private:
    static immutable failedToCreateWindow_ = "Failed to create window object.";     ///< ウィンドウの生成に失敗したエラーメッセージ。
    static immutable failedToCreateRenderer_ = "Failed to create renderer object."; ///< レンダラの生成に失敗したエラーメッセージ。

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

/// @brief  時計の針の角度を計算する。
/// @param  時刻。
/// @return 針の角度の入ったタプル。時間,分,秒の順。
Tuple!(double, double, double) CalcAngle(const ref SysTime time) @safe nothrow
{
    static immutable anglePerHour = 360 / 12.0;
    static immutable anglePerMinute = 360 / 60.0;
    static immutable anglePerSecond = 360 / 60.0;

    auto hour = time.hour + (time.minute / 60.0) + (time.second / 3600.0);
    auto minute = time.minute + (time.second / 60.0);
    auto second = time.second;

    return typeof(return)(hour * anglePerHour, minute * anglePerMinute, second * anglePerSecond);
}
