/**
 * 例外を扱うモジュール。
 *
 * Date: 2017/7/10
 * Authors: masaniwa
 */

module desktopdial.exception;

public:

/** 無効なパラメタに関する例外クラス。 */
class InvalidParamException : Exception
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     message = エラーメッセージ。
     *     file = 例外が発生したファイル名。
     *     line = 例外が発生した行。
     */
    this(in string message, in string file = __FILE__, in ulong line = __LINE__) nothrow pure @safe @nogc
    {
        super(message, file, cast(uint) line);
    }
}

/** オブジェクト生成に関する例外クラス。 */
class CreationException : Exception
{
    /**
     * コンストラクタ。
     *
     * Params:
     *     message = エラーメッセージ。
     *     file = 例外が発生したファイル名。
     *     line = 例外が発生した行。
     */
    this(in string message, in string file = __FILE__, in ulong line = __LINE__) nothrow pure @safe @nogc
    {
        super(message, file, cast(uint) line);
    }
}
