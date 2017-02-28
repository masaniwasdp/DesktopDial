///
/// @file      HandsAngle.d
/// @brief     時計盤の針の角度を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.HandsAngle;

import std.datetime;

/// @brief 時計盤の針の角度を扱うクラス。
class HandsAngle
{
public:
    immutable double Hour;   ///< 時針の角度。
    immutable double Minute; ///< 分針の角度。
    immutable double Second; ///< 秒針の角度。

    /// @brief コンストラクタ。
    /// @param time 時刻。
    this(const ref SysTime time) @safe nothrow
    {
        immutable msecond = time.fracSecs.total!("msecs");
        immutable second = time.second + (msecond / 1000.0);
        immutable minute = time.minute + (second / 60.0);
        immutable hour = time.hour + (minute / 60.0);

        Hour = hour * hourAngleUnit_;
        Minute = minute * minuteAngleUnit_;
        Second = second * secondAngleUnit_;
    }

private:
    immutable hourAngleUnit_ = 360 / 12.0;   ///< 時針1時間の角度。
    immutable minuteAngleUnit_ = 360 / 60.0; ///< 分針1分の角度。
    immutable secondAngleUnit_ = 360 / 60.0; ///< 秒針1秒の角度。
}
