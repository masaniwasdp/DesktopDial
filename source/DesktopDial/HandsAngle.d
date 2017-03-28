///
/// @file      HandsAngle.d
/// @brief     時計盤の針の角度を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.HandsAngle;

import std.datetime;

public:

/// @brief 時計盤の針の角度を表す構造体。
struct HandsAngle
{
    double Hour;   ///< 時針の角度。
    double Minute; ///< 分針の角度。
    double Second; ///< 秒針の角度。
}

/// @brief  時計盤の針の角度を計算する。
/// @param  time 時刻。
/// @return 時刻を示す時計盤の針の角度。
HandsAngle CalcHandsAngle(in SysTime time) nothrow @safe
{
    immutable second = time.second + time.fracSecs.total!"msecs".upUnit(1000);
    immutable minute = time.minute + second.upUnit(60);
    immutable hour = time.hour + minute.upUnit(60);

    immutable HandsAngle angle =
    {
        Hour:   hour * hourAngleUnit,
        Minute: minute * minuteAngleUnit,
        Second: second * secondAngleUnit
    };

    return angle;
}

private:

/// @brief  値を上の単位で換算する。
/// @param  value 換算する値。
/// @param  units 上の単位に上がる値。
/// @return 上の単位で換算した値。
double upUnit(in double value, in double units) nothrow pure @safe @nogc
{
    return value / units;
}

immutable hourAngleUnit = 360 / 12.0;   ///< 時針1時の角度。
immutable minuteAngleUnit = 360 / 60.0; ///< 分針1分の角度。
immutable secondAngleUnit = 360 / 60.0; ///< 秒針1秒の角度。
