///
/// @file      handsangle.d
/// @brief     時計盤の針の角度を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module desktopdial.handsangle;

import std.datetime:
    SysTime;

public:

/// @brief 時計盤の針の角度を表す構造体。
struct HandsAngle
{
    double hour;   ///< 時針の角度。
    double minute; ///< 分針の角度。
    double second; ///< 秒針の角度。
}

/// @brief  時計盤の針の角度を計算する。
/// @param  time 時刻。
/// @return 時刻を示す時計盤の針の角度。
HandsAngle calcHandsAngle(in SysTime time) nothrow @safe
{
    immutable second = time.second + time.fracSecs.total!"msecs".upUnit(1000);
    immutable minute = time.minute + second.upUnit(60);
    immutable hour = time.hour + minute.upUnit(60);

    immutable HandsAngle angle =
    {
        hour: hour * AngleUnit.hour,
        minute: minute * AngleUnit.minute,
        second: second * AngleUnit.second
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

/// @brief 時計の針1単位の角度。
enum AngleUnit
{
    hour = 30,  ///< 時針1時の角度。
    minute = 6, ///< 分針1分の角度。
    second = 6  ///< 秒針1秒の角度。
}
