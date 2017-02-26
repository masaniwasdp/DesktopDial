///
/// @file      Exception.d
/// @brief     例外を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Exception;

import std.exception;

import derelict.sdl2.sdl;

/// @brief nullポインタに関する例外クラス。
class NullPointerException: Exception
{
    /// @brief コンストラクタ。
    /// @param message エラーメッセージ。
    /// @param file    例外が発生したファイル名。
    /// @param line    例外が発生した行。
    this(string message, string file = __FILE__, ulong line = __LINE__)
    {
        super(message, file, line);
    }
}

/// @brief オブジェクト生成に関する例外クラス。
class CreationException: Exception
{
    /// @brief コンストラクタ。
    /// @param message エラーメッセージ。
    /// @param file    例外が発生したファイル名。
    /// @param line    例外が発生した行。
    this(string message, string file = __FILE__, ulong line = __LINE__)
    {
        super(message, file, line);
    }
}
