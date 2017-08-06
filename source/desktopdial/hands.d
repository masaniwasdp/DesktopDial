/**
 * 時計盤の3本の針の描画を扱うモジュール。
 *
 * Date: 2017/8/7
 * Authors: masaniwa
 */

module desktopdial.hands;

import std.datetime : SysTime;

import desktopdial.exception : CreationException;
import desktopdial.hand : Hand, HandVisual;
import desktopdial.handsangle : calcHandsAngle;

import derelict.sdl2.sdl;

/**
 * 時計盤の3本の針の描画を扱うクラス。
 *
 * 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
 * また、SDLを終了する前に破棄する必要がある。
 */
class Hands
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     renderer = 使用するレンダラ。使用を終えるまで破棄してはならない。
     *     region = 時計盤の領域。
     *     visuals = 3本の針の見た目。
     *
     * Throws:
     *     CreationException オブジェクトの生成に失敗した場合。
     */
    this(SDL_Renderer* renderer, in SDL_Rect region, in HandVisuals visuals)
    in
    {
        assert(renderer);
    }
    body
    {
        try
        {
            hour = new Hand(renderer, region, visuals.hour);
            minute = new Hand(renderer, region, visuals.minute);
            second = new Hand(renderer, region, visuals.second);
        }
        catch (CreationException e)
        {
            throw new CreationException("Failed to create hands.", e);
        }
    }

    ~this()
    {
        hour.destroy;
        minute.destroy;
        second.destroy;
    }

    /**
     * 針を描画する。
     *
     * Params:
     *     time = 時刻。
     */
    void draw(in SysTime time) nothrow
    {
        immutable angle = time.calcHandsAngle;

        hour.draw(angle.hour);
        minute.draw(angle.minute);
        second.draw(angle.second);
    }

    private Hand hour;   /// 時針。
    private Hand minute; /// 分針。
    private Hand second; /// 秒針。

    invariant()
    {
        assert(hour);
        assert(minute);
        assert(second);
    }
}

/** 3本の針の見た目を表す構造体。 */
struct HandVisuals
{
    HandVisual hour;   /// 時針。
    HandVisual minute; /// 分針。
    HandVisual second; /// 秒針。
}
