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
    this(in SysTime time) @safe nothrow
    {
        immutable second = time.second + (time.fracSecs.total!"msecs" / 1000.0);
        immutable minute = time.minute + (second / 60.0);
        immutable hour = time.hour + (minute / 60.0);

        Hour = hour * hourAngleUnit_;
        Minute = minute * minuteAngleUnit_;
        Second = second * secondAngleUnit_;
    }

private:
    static immutable hourAngleUnit_ = 360 / 12.0;   ///< 時針1時の角度。
    static immutable minuteAngleUnit_ = 360 / 60.0; ///< 分針1分の角度。
    static immutable secondAngleUnit_ = 360 / 60.0; ///< 秒針1秒の角度。
}
