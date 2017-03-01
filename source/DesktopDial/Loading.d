///
/// @file      Loading.d
/// @brief     リソースを読み込むモジュール。
/// @author    masaniwa
/// @date      2017/2/28
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Loading;

import std.conv,
       std.file,
       std.json;

import DesktopDial.Dial,
       DesktopDial.Hand;

/// @brief  jsonファイルから時計盤の定義を読み込む。
/// @param  path jsonファイルのパス。
/// @return 読み込んだ時計盤の定義。
/// @throws FileException ファイルの読み込みに失敗した場合。
/// @throws UtfException  UTFデコードに失敗した場合。
/// @throws JSONException jsonの変換に失敗した場合。
DialDefinition LoadDialDefinition(in string path) @safe
{
    immutable json = path.readText.parseJSON;

    return json.parseToDialDefinition;
}

/// @brief  jsonオブジェクトをDialDefinition構造体に変換する。
/// @param  json 変換するjsonオブジェクト。
/// @return 変換したDialDefinition構造体。
private DialDefinition parseToDialDefinition(in ref JSONValue json) @safe nothrow pure
{
    immutable DialDefinition definition =
    {
        Name: json.parseToString("Name"),
        Width: json.parseToInteger!ushort("Width"),
        Height: json.parseToInteger!ushort("Height"),
        Background: json.parseToBackgroundColor("Background"),
        Hour: json.parseToHandVisual("Hour"),
        Minute: json.parseToHandVisual("Minute"),
        Second: json.parseToHandVisual("Second")
    };

    return definition;
}

/// @brief  jsonオブジェクトのキーの値をBackgroundColor構造体に変換する。
/// @param  json 値を読み取るjsonオブジェクト。
/// @param  key  変換する値のキー。
/// @return 変換したBackgroundColor構造体。
private BackgroundColor parseToBackgroundColor(in ref JSONValue json, in string key) @safe nothrow pure
{
    try
    {
        immutable BackgroundColor background =
        {
            Red: json[key].parseToInteger!ubyte("Red"),
            Green: json[key].parseToInteger!ubyte("Green"),
            Blue: json[key].parseToInteger!ubyte("Blue")
        };

        return background;
    }
    catch(Exception e)
    {
        return BackgroundColor();
    }
}

/// @brief  jsonオブジェクトのキーの値をHandVisual構造体に変換する。
/// @param  json 値を読み取るjsonオブジェクト。
/// @param  key  変換する値のキー。
/// @return 変換したHandVisual構造体。
private HandVisual parseToHandVisual(in ref JSONValue json, in string key) @safe nothrow pure
{
    try
    {
        immutable HandVisual visual =
        {
            Size: json[key].parseToHandSize("Size"),
            Color: json[key].parseToHandColor("Color")
        };

        return visual;
    }
    catch(Exception e)
    {
        return HandVisual();
    }
}

/// @brief  jsonオブジェクトのキーの値をHandSize構造体に変換する。
/// @param  json 値を読み取るjsonオブジェクト。
/// @param  key  変換する値のキー。
/// @return 変換したHandSize構造体。
private HandSize parseToHandSize(in ref JSONValue json, in string key) @safe nothrow pure
{
    try
    {
        immutable HandSize size =
        {
            Width: json[key].parseToInteger!ushort("Width"),
            LongLength: json[key].parseToInteger!ushort("LongLength"),
            ShortLength: json[key].parseToInteger!ushort("ShortLength")
        };

        return size;
    }
    catch(Exception e)
    {
        return HandSize();
    }
}

/// @brief  jsonオブジェクトのキーの値をHandColor構造体に変換する。
/// @param  json 値を読み取るjsonオブジェクト。
/// @param  key  変換する値のキー。
/// @return 変換したHandColor構造体。
private HandColor parseToHandColor(in ref JSONValue json, in string key) @safe nothrow pure
{
    try
    {
        immutable HandColor color =
        {
            Red: json[key].parseToInteger!ubyte("Red"),
            Green: json[key].parseToInteger!ubyte("Green"),
            Blue: json[key].parseToInteger!ubyte("Blue"),
            AlphaR: json[key].parseToInteger!ubyte("AlphaR"),
            AlphaG: json[key].parseToInteger!ubyte("AlphaG"),
            AlphaB: json[key].parseToInteger!ubyte("AlphaB")
        };

        return color;
    }
    catch(Exception e)
    {
        return HandColor();
    }
}

/// @brief  jsonオブジェクトのkeyの値を文字列に変換する。
/// @param  json 値を読み取るjsonオブジェクト。
/// @param  key  変換する値のキー。
/// @return 変換した文字列。
private string parseToString(in ref JSONValue json, in string key) @safe nothrow pure
{
    try
    {
        return json[key].str;
    }
    catch(Exception e)
    {
        return string.init;
    }
}

/// @brief  jsonオブジェクトのkeyの値を整数に変換する。
/// @param  T    最終的に変換する整数の型。
/// @param  json 読み取るjsonオブジェクト。
/// @param  key  読み取る値のキー。
/// @return 変換した整数。
private T parseToInteger(T)(in ref JSONValue json, in string key) @safe nothrow pure
{
    try
    {
        return json[key].integer.to!T;
    }
    catch(Exception e)
    {
        return T.init;
    }
}
