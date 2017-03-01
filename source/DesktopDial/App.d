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

import DesktopDial.Dial,
       DesktopDial.Loading;

/// @brief   アプリケーションクラス。
/// @details 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
class App
{
public:
    /// @brief  コンストラクタ。
    /// @throws FileException     ファイルの読み込みに失敗した場合。
    /// @throws UtfException      UTFデコードに失敗した場合。
    /// @throws JSONException     jsonの変換に失敗した場合。
    /// @throws CreationException オブジェクトの生成に失敗した場合。
    this()
    {
        continuation_ = true;

        immutable definition = dialDefinitionPath_.LoadDialDefinition;
        dial_ = new Dial(definition);
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

    static immutable dialDefinitionPath_ = "res/DialDefinition.json"; ///< 時計盤定義ファイルのパス。

    /// @brief  FPSを考慮して時計盤を更新する。
    /// @throws DateTimeException 日時の取得に失敗した場合。
    void update()
    {
        tuneFPS;
        dial_.Draw(Clock.currTime);
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
    void handleEvent(in ref SDL_Event event) @safe nothrow pure
    {
        if(event.type == SDL_QUIT)
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
    Dial dial_;         ///< 時計盤描画オブジェクト。
}
