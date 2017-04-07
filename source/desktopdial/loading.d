///
/// @file      loading.d
/// @brief     リソースを読み込むモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module desktopdial.loading;

import std.conv:
    ConvOverflowException;

import std.file:
    readText;

import std.utf:
    UTFException;

import jsonserialized.deserialization:
    deserializeFromJSONValue;

import stdx.data.json:
    toJSONValue;

import stdx.data.json.foundation:
    JSONException;

import desktopdial.dial:
    DialDefinition;

import desktopdial.exception:
    InvalidParamException;

public:

/// @brief  jsonファイルから時計盤の定義を読み込む。
/// @param  path jsonファイルのパス。
/// @return 読み込んだ時計盤の定義。
/// @throws FileException         jsonファイルの読み込みに失敗した場合。
/// @throws InvalidParamException jsonファイルの形式が誤っている場合。
DialDefinition loadDialDefinition(in string path) @safe
{
    try
    {
        immutable json = path.readText.toJSONValue;

        DialDefinition definition;
        definition.deserializeFromJSONValue(json);

        return definition;
    }
    catch(JSONException e)
    {
        throw new InvalidParamException(wrongFormatError);
    }
    catch(UTFException e)
    {
        throw new InvalidParamException(wrongEncodingError);
    }
    catch(ConvOverflowException e)
    {
        throw new InvalidParamException(valueOverflowError);
    }
}

private:

immutable wrongEncodingError = "Definition file encoding should be Unicode."; ///< 無効なファイルエンコーディングであるメッセージ。
immutable wrongFormatError = "JSON string was wrong format.";                 ///< json文字列の形式が誤っているメッセージ。
immutable valueOverflowError = "Definition value was too larger or smaller."; ///< 定義の値がオーバーフローしたメッセージ。
