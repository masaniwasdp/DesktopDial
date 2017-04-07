///
/// @file      app.d
/// @brief     アプリケーションモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module desktopdial.app;

import std.datetime:
    Clock;

import std.file:
    thisExePath;

import std.path:
    dirName, dirSeparator;

import desktopdial.dial:
    Dial;

import desktopdial.loading:
    loadDialDefinition;

import sdl = derelict.sdl2.sdl;

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
        this(thisExePath.dirName ~ dirSeparator ~ dialDefinitionPath);
    }

    /// @brief  コンストラクタ。
    /// @param  path 定義ファイルのパス。
    /// @throws FileException           定義ファイルの読み込みに失敗した場合。
    /// @throws InvalidParamException   定義ファイルが無効な場合。
    /// @throws CreationException       オブジェクトの生成に失敗した場合。
    this(in string path)
    {
        continuation = true;

        immutable definition = path.loadDialDefinition;

        dial = new Dial(definition);
    }

    /// @brief アプリケーションを実行する。
    void run() nothrow
    {
        while(continuation)
        {
            handleEvents;
            update;
        }
    }

private:
    /// @brief FPSを考慮して時計盤を更新する。
    void update() nothrow
    {
        tuneFPS;

        try
        {
            dial.draw(Clock.currTime);
        }
        catch(Exception e)
        {
            return;
        }
    }

    /// @brief キューに溜まったイベントを扱う。
    void handleEvents() nothrow @nogc
    {
        sdl.SDL_Event event;

        while(sdl.SDL_PollEvent(&event) == 1)
        {
            handleEvent(event);
        }
    }

    /// @brief イベントを扱う。
    /// @param event イベントオブジェクト。
    void handleEvent(in ref sdl.SDL_Event event) nothrow pure @safe @nogc
    {
        if(event.type == sdl.SDL_QUIT)
        {
            continuation = false;
        }
    }

    /// @brief FPSを調整する。
    void tuneFPS() nothrow @nogc
    {
        immutable current = sdl.SDL_GetTicks();
        immutable elapsed = current - last;

        if(elapsed < interval)
        {
            sdl.SDL_Delay(interval - elapsed);
        }

        last = current;
    }

    bool continuation; ///< メインループを続行するかどうか。
    uint last;         ///< 最後にフレームを更新した時刻。
    Dial dial;         ///< 時計盤描画オブジェクト。
}

private:

static immutable interval = 100; ///< メインループのインターバル。

static immutable dialDefinitionPath = "resource/DialDefinition.json"; ///< 定義ファイルのパス。
