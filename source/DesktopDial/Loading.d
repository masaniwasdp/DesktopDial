///
/// @file      Loading.d
/// @brief     リソースを読み込むモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Loading;

import std.conv,
       std.exception,
       std.file,
       std.utf;

import jsonserialized.deserialization,
       stdx.data.json,
       stdx.data.json.foundation;

import DesktopDial.Dial,
       DesktopDial.Exception;

/// @brief  jsonファイルから時計盤の定義を読み込む。
/// @param  path jsonファイルのパス。
/// @return 読み込んだ時計盤の定義。
/// @throws FileException         jsonファイルの読み込みに失敗した場合。
/// @throws InvalidParamException jsonファイルの形式が誤っている場合。
DialDefinition LoadDialDefinition(in string path) @safe
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

private immutable wrongEncodingError = "Definition file encoding should be Unicode."; ///< 無効なファイルエンコーディングであるメッセージ。
private immutable wrongFormatError = "JSON string was wrong format.";                 ///< json文字列の形式が誤っているメッセージ。
private immutable valueOverflowError = "Definition value was too larger or smaller."; ///< 定義の値がオーバーフローしたメッセージ。
