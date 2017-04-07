///
/// @file      hand.d
/// @brief     時計盤の針の描画を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module desktopdial.hand;

import std.exception:
    enforceEx;

import desktopdial.exception:
    InvalidParamException;

import desktopdial.sdlutil:
    convertToTexture, createSurface, fillAlpha, fillRect, free;

import sdl = derelict.sdl2.sdl;

public:

/// @brief   時計盤の針の描画を扱うクラス。
/// @details 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
class Hand
{
public:
    /// @brief  コンストラクタ。
    /// @param  definition 針の定義。
    /// @throws InvalidParamException レンダラが無効だった場合。
    /// @throws CreationException     オブジェクト生成に失敗した場合。
    this(ref HandDefinition definition)
    {
        this(definition.Renderer, definition.Region, definition.Visual);
    }

    /// @brief  コンストラクタ。
    /// @param  renderer 使用するレンダラ。
    /// @param  region   時計盤の領域。
    /// @param  visual   針の見た目。
    /// @throws InvalidParamException レンダラが無効だった場合。
    /// @throws CreationException     オブジェクト生成に失敗した場合。
    this(sdl.SDL_Renderer *renderer, in sdl.SDL_Rect region, in HandVisual visual)
    {
        this.renderer = renderer.enforceEx!InvalidParamException(invalidRendererError);
        this.region = region;

        auto surface = createSurface(region.w, region.h);
        scope(exit) surface.free;

        immutable shape = calcShape(region, visual.Size);

        surface.fillAlpha(visual.Color.AlphaR, visual.Color.AlphaG, visual.Color.AlphaB);
        surface.fillRect(shape, visual.Color.Red, visual.Color.Green, visual.Color.Blue);

        texture = renderer.convertToTexture(surface);
    }

    /// @デストラクタ。
    ~this() nothrow @nogc
    {
        texture.destroy;
    }

    /// @brief 針を描画する。
    /// @param angle 針の角度。
    void draw(in double angle) nothrow @nogc
    {
        sdl.SDL_RenderCopyEx(renderer, texture, null, &region, angle, null, sdl.SDL_FLIP_NONE);
    }

private:
    immutable sdl.SDL_Rect region; ///< 時計盤の領域。

    sdl.SDL_Renderer *renderer;  ///< 使用するレンダラ。
    sdl.SDL_Texture *texture;    ///< 針のテクスチャ。
}

/// @brief 針を定義する構造体。
struct HandDefinition
{
    sdl.SDL_Renderer *Renderer; ///< 使用するレンダラ。
    sdl.SDL_Rect Region;        ///< 時計盤の領域。
    HandVisual Visual;          ///< 針の見た目。
}

/// @brief 針の見た目を表す構造体。
struct HandVisual
{
    HandSize Size;   ///< サイズ。
    HandColor Color; ///< 色。
}

/// @brief 針のサイズを表す構造体。
struct HandSize
{
    ushort Width;       ///< 幅。
    ushort LongLength;  ///< 長い方の中心からの長さ。
    ushort ShortLength; ///< 短い方の中心からの長さ。
}

/// @brief 針の色を表す構造体。
struct HandColor
{
    ubyte Red;   ///< 赤の明度。
    ubyte Green; ///< 緑の明度。
    ubyte Blue;  ///< 青の明度。

    ubyte AlphaR; ///< 透過色の赤の明度。
    ubyte AlphaG; ///< 透過色の緑の明度。
    ubyte AlphaB; ///< 透過色の青の明度。
}

private:

/// @brief  針の形を計算する。
/// @param  region 時計盤の領域。
/// @param  size   針のサイズ。
/// @return 計算した針の形。
sdl.SDL_Rect calcShape(in sdl.SDL_Rect region, in HandSize size) nothrow pure @safe @nogc
{
    immutable sdl.SDL_Rect shape =
    {
        x: (region.w / 2) - (size.Width / 2),
        y: (region.h / 2) - size.LongLength,
        w: size.Width,
        h: size.LongLength + size.ShortLength
    };

    return shape;
}

immutable invalidRendererError = "Renderer object was invalid."; ///< レンダラが無効だったメッセージ。
