///
/// @file      App.d
/// @brief     アプリケーションモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.App;

import std.datetime,
       std.exception;

import derelict.sdl2.sdl;

import DesktopDial.Graph;

/// @brief   アプリケーションクラス。
/// @details 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
class App
{
public:
    /// @brief  コンストラクタ。
    /// @throws CreationException オブジェクトの生成に失敗した場合。
    this()
    {
        continuation_ = true;
        graph_ = new Graph(graphDefinition_);
    }

    /// @brief  アプリケーションを実行する。
    /// @throws DateTimeException 日時の取得に失敗した場合。
    void Run()
    {
        while(continuation_)
        {
            handleEvents;
            update;
        }
    }

private:
    static immutable interval_ = 100; ///< メインループのインターバル。

    /// @brief 時計盤描画オブジェクトのパラメタ。
    static immutable GraphDefinition graphDefinition_ =
    {
        Name: "DesktopDial",
        Width: 256,
        Height: 256,
        HourSize: {Width: 3, LongLength: 80, ShortLength: 10},
        MinuteSize: {Width: 3, LongLength: 100, ShortLength: 10},
        SecondSize: {Width: 3, LongLength: 120, ShortLength: 10},
        HourColor: {Red: 255},
        MinuteColor: {Green: 255},
        SecondColor: {Blue: 255}
    };

    /// @brief  FPSを考慮して時計盤を更新する。
    /// @throws DateTimeException 日時の取得に失敗した場合。
    void update()
    {
        tuneFPS;

        immutable time = Clock.currTime;
        graph_.Draw(time);
    }

    /// @brief キューに溜まったイベントを扱う。
    void handleEvents() nothrow
    {
        SDL_Event event;

        while(SDL_PollEvent(&event) == 1)
        {
            handleEvent(event);
        }
    }

    /// @brief イベントを扱う。
    /// @param event イベントオブジェクト。
    void handleEvent(const ref SDL_Event event) @safe nothrow pure
    {
        immutable type = event.type;

        if(type == SDL_QUIT)
        {
            handleQuitEvent(event);
        }
        else if(type == SDL_KEYDOWN)
        {
            handleKeyDownEvent(event);
        }
    }

    /// @brief 終了イベントを扱う。
    /// @param event イベントオブジェクト。
    void handleQuitEvent(const ref SDL_Event event) @safe nothrow pure
    {
        continuation_ = false;
    }

    /// @brief キーダウンイベントを扱う。
    /// @param event イベントオブジェクト。
    void handleKeyDownEvent(const ref SDL_Event event) @safe nothrow pure
    {
        immutable symbol = event.key.keysym.sym;

        if(symbol == SDLK_ESCAPE)
        {
            continuation_ = false;
        }
    }

    /// @brief FPSを調整する。
    void tuneFPS() nothrow
    {
        immutable current = SDL_GetTicks();
        immutable elapsed = current - last_;

        if(elapsed < interval_)
        {
            SDL_Delay(interval_ - elapsed);
        }

        last_ = current;
    }

    bool continuation_; ///< メインループを続行するかどうか。
    uint last_;         ///< 最後にフレームを更新した時刻。
    Graph graph_;       ///< 時計盤描画オブジェクト。
}
