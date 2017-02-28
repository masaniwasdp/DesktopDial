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
       std.json;

import DesktopDial.Dial,
       DesktopDial.Exception,
       DesktopDial.Hand;

DialDefinition LoadDialDefinition(in string path)
{
    immutable json = path.readText.parseJSON;

    DialDefinition definition;
    parseDialDefinition(definition, json);

    return definition;
}

private void parseDialDefinition(ref DialDefinition definition, const ref JSONValue json)
{
    definition.Name = json["Name"].str;
    definition.Width = json["Width"].integer.to!(ushort);
    definition.Height = json["Height"].integer.to!(ushort);

    parseBackgroundColor(definition.Background, json["Background"]);
    parseHandVisual(definition.Hour, json["Hour"]);
    parseHandVisual(definition.Minute, json["Minute"]);
    parseHandVisual(definition.Second, json["Second"]);
}

private void parseBackgroundColor(ref BackgroundColor background, const ref JSONValue json)
{
    background.Red = json["Red"].integer.to!(ubyte);
    background.Green = json["Green"].integer.to!(ubyte);
    background.Blue = json["Blue"].integer.to!(ubyte);
}

private void parseHandVisual(ref HandVisual hand, const ref JSONValue json)
{
    parseHandSize(hand.Size, json["Size"]);
    parseHandColor(hand.Color, json["Color"]);
}

private void parseHandSize(ref HandSize size, const ref JSONValue json)
{
    size.Width = json["Width"].integer.to!(ushort);
    size.LongLength = json["LongLength"].integer.to!(ushort);
    size.ShortLength = json["ShortLength"].integer.to!(ushort);
}

private void parseHandColor(ref HandColor color, const ref JSONValue json)
{
    color.Red = json["Red"].integer.to!(ubyte);
    color.Green = json["Green"].integer.to!(ubyte);
    color.Blue = json["Blue"].integer.to!(ubyte);
    color.AlphaR = json["AlphaR"].integer.to!(ubyte);
    color.AlphaG = json["AlphaG"].integer.to!(ubyte);
    color.AlphaB = json["AlphaB"].integer.to!(ubyte);
}
