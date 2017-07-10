/**
 * アプリケーションモジュール。
 *
 * Date: 2017/7/11
 * Authors: masaniwa
 */

module desktopdial.app;

import std.datetime : Clock;
import std.file : thisExePath;
import std.path : dirName, dirSeparator;

import desktopdial.dial : Dial;
import desktopdial.loading : loadDialDefinition;

import sdl = derelict.sdl2.sdl;

public:

/**
 * アプリケーションクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 */
class App
{
public:
    /**
     * コンストラクタ。
     *
     * Params:
     *     path = 定義ファイルのパス。
     *
     * Throws:
     *     Exception = 実行ファイルのパスを取得できなかった場合。
     *     std.file.FileException = 定義ファイルの読み込みに失敗した場合。
     *     desktopdial.exception.InvalidParamException = 定義ファイルが無効な場合。
     *     desktopdial.exception.CreationException = オブジェクトの生成に失敗した場合。
     */
    this(in string path = null)
    {
        immutable file = path ? path : thisExePath.dirName ~ dirSeparator ~ Path.dialDefinition;

        dial = new Dial(file.loadDialDefinition);
    }

    /** アプリケーションを実行する。 */
    void run() nothrow
    {
        while (continuation)
        {
            handleEvents;
            update;
        }
    }

private:
    /** FPSを考慮して時計盤を更新する。 */
    void update() nothrow
    {
        tuneFPS;

        try
        {
            dial.draw(Clock.currTime);
        }
        catch (Exception e)
        {
            return;
        }
    }

    /** キューに溜まったイベントを扱う。 */
    void handleEvents() nothrow @nogc
    {
        sdl.SDL_Event event;

        while (sdl.SDL_PollEvent(&event) == 1)
        {
            handleEvent(event);
        }
    }

    /**
     * イベントを扱う。
     *
     * Params:
     *     event = イベント。
     */
    void handleEvent(in sdl.SDL_Event event) nothrow pure @safe @nogc
    {
        if (event.type == sdl.SDL_QUIT)
        {
            continuation = false;
        }
    }

    /** FPSを調整する。 */
    void tuneFPS() nothrow @nogc
    {
        immutable current = sdl.SDL_GetTicks();
        immutable elapsed = current - last;

        if (elapsed < Time.interval)
        {
            sdl.SDL_Delay(Time.interval - elapsed);
        }

        last = current;
    }

    bool continuation = true; /// メインループを続行するかどうか。

    uint last; /// 最後にフレームを更新した時刻。

    Dial dial; /// 時計盤描画オブジェクト。
}

private:

/** 時間に関する定数。 */
enum Time
{
    interval = 100 /// メインループのインターバル。
}

/** パスに関する定数。 */
enum Path
{
    dialDefinition = "resource/DialDefinition.json" /// 定義ファイル。
}
