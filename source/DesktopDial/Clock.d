///
/// @file      Clock.d
/// @brief     時計に関わるモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Clock;

import std.datetime,
       std.typecons;

import derelict.sdl2.sdl;

/// @brief 時計盤の針の角度を表すタプル。時,分,秒の順。
alias HandAngle = Tuple!(double, "Hour", double, "Minute", double, "Second");

/// @brief  時計盤の針の角度を計算する。
/// @param  時刻。
/// @return 針の角度。
HandAngle CalcHandAngle(const ref SysTime time) @safe nothrow
{
    immutable msecond = time.fracSecs.total!("msecs");
    immutable second = time.second + (msecond / 1000.0);
    immutable minute = time.minute + (second / 60.0);
    immutable hour = time.hour + (minute / 60.0);

    return HandAngle(hour * anglePerHour, minute * anglePerMinute, second * anglePerSecond);
}

private immutable anglePerHour = 360 / 12.0;   ///< 時針1時間の角度。
private immutable anglePerMinute = 360 / 60.0; ///< 分針1分の角度。
private immutable anglePerSecond = 360 / 60.0; ///< 秒針1秒の角度。
