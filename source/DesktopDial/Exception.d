///
/// @file      Exception.d
/// @brief     例外を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Exception;

import std.exception;

/// @brief 無効なパラメタに関する例外クラス。
class InvalidParamException: Exception
{
    /// @brief コンストラクタ。
    /// @param message エラーメッセージ。
    /// @param file    例外が発生したファイル名。
    /// @param line    例外が発生した行。
    this(in string message, in string file = __FILE__, in ulong line = __LINE__)
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
    this(in string message, in string file = __FILE__, in ulong line = __LINE__)
    {
        super(message, file, line);
    }
}
