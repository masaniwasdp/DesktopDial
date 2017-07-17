/**
 * 例外を扱うモジュール。
 *
 * Date: 2017/7/18
 * Authors: masaniwa
 */

module desktopdial.exception;

import std.exception : basicExceptionCtors;

/** 時計盤の定義に関する例外クラス。 */
class DefinitionException : Exception
{
    mixin basicExceptionCtors;
}

/** オブジェクト生成に関する例外クラス。 */
class CreationException : Exception
{
    mixin basicExceptionCtors;
}

/** 描画に関する例外クラス。 */
class DrawingException : Exception
{
    mixin basicExceptionCtors;
}

/** 設定に関する例外クラス。 */
class SetupException : Exception
{
    mixin basicExceptionCtors;
}
