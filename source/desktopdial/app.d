/**
 * アプリケーションモジュール。
 *
 * Date: 2017/8/2
 * Authors: masaniwa
 */

module desktopdial.app;

import std.datetime : Clock;
import std.file : FileException, thisExePath;
import std.path : dirName, dirSeparator;

import desktopdial.dial : Dial;
import desktopdial.exception : CreationException, DefinitionException, SetupException;
import desktopdial.loading : loadDialDefinition;

import derelict.sdl2.sdl;

/**
 * アプリケーションクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 * また、SDLを終了する前に破棄する必要がある。
 */
class App
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     path = 定義ファイルのパス。nullなら自動で決定する。
     *
     * Throws:
     *     SetupException アプリケーションの構築に失敗した場合。
     */
    this(in string path = null)
    {
        try
        {
            immutable file = path ? path : thisExePath.dirName ~ dirSeparator ~ definitionPath;

            dial = new Dial(file.loadDialDefinition);
        }
        catch (DefinitionException e)
        {
            throw new SetupException("Failed to load the definition.", e);
        }
        catch (CreationException e)
        {
            throw new SetupException("Failed to set up the application.", e);
        }
        catch (Exception e)
        {
            throw new SetupException("Failed to get the exe path.", e);
        }
    }

    ~this()
    {
        dial.destroy;
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

    /** FPSを考慮して時計盤を更新する。 */
    private void update() nothrow
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
    private void handleEvents() nothrow @nogc
    {
        SDL_Event event;

        while (SDL_PollEvent(&event) == 1)
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
    private void handleEvent(in SDL_Event event) pure nothrow @nogc @safe
    {
        if (event.type == SDL_QUIT) continuation = false;
    }

    /** FPSを調整する。 */
    private void tuneFPS() nothrow @nogc
    {
        immutable elapsed = SDL_GetTicks() - last;

        if (elapsed < interval) SDL_Delay(interval - elapsed);

        last = SDL_GetTicks();
    }

    private auto continuation = true; /// メインループを続行するかどうか。

    private uint last; /// 最後にフレームを更新した時刻。

    private Dial dial; /// 時計盤描画オブジェクト。

    invariant()
    {
        assert(dial);
    }
}

private enum interval = 100; /// メインループのインターバル。

private enum definitionPath = "resource/DialDefinition.json"; /// 定義ファイルのパス。
