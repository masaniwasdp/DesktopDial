///
/// @file      App.d
/// @brief     アプリケーションモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.App;

import std.datetime,
       std.conv,
       std.file,
       std.path;

import derelict.sdl2.sdl;

import DesktopDial.Dial,
       DesktopDial.Exception,
       DesktopDial.Loading;

public:

/// @brief   アプリケーションクラス。
/// @details 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
class App
{
public:
    /// @brief  コンストラクタ。
    /// @throws FileException         定義ファイルの読み込みに失敗した場合。
    /// @throws InvalidParamException 定義ファイルが無効な場合。
    /// @throws Exception             実行ファイルのパスを取得できなかった場合。
    /// @throws CreationException     オブジェクトの生成に失敗した場合。
    this()
    {
        this(thisExePath.dirName ~ dirSeparator ~ dialDefinitionPath_);
    }

    /// @brief  コンストラクタ。
    /// @param  path 定義ファイルのパス。
    /// @throws FileException           定義ファイルの読み込みに失敗した場合。
    /// @throws InvalidParamException   定義ファイルが無効な場合。
    /// @throws CreationException       オブジェクトの生成に失敗した場合。
    this(in string path)
    {
        continuation_ = true;

        immutable definition = path.LoadDialDefinition;

        dial_ = new Dial(definition);
    }

    /// @brief アプリケーションを実行する。
    void Run() nothrow
    {
        while(continuation_)
        {
            handleEvents;
            update;
        }
    }

private:
    static immutable interval_ = 100; ///< メインループのインターバル。

    static immutable dialDefinitionPath_ = "resource/DialDefinition.json"; ///< 定義ファイルのパス。

    /// @brief FPSを考慮して時計盤を更新する。
    void update() nothrow
    {
        tuneFPS;

        try
        {
            dial_.Draw(Clock.currTime);
        }
        catch(Exception e)
        {
            return;
        }
    }

    /// @brief キューに溜まったイベントを扱う。
    void handleEvents() nothrow @nogc
    {
        SDL_Event event;

        while(SDL_PollEvent(&event) == 1)
        {
            handleEvent(event);
        }
    }

    /// @brief イベントを扱う。
    /// @param event イベントオブジェクト。
    void handleEvent(in ref SDL_Event event) nothrow pure @safe @nogc
    {
        if(event.type == SDL_QUIT)
        {
            continuation_ = false;
        }
    }

    /// @brief FPSを調整する。
    void tuneFPS() nothrow @nogc
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
