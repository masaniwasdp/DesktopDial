///
/// @file      Hand.d
/// @brief     時計盤の針の描画を扱うモジュール。
/// @author    masaniwa
/// @date      2017/2/26
/// @copyright (c) 2017 masaniwa
///

module DesktopDial.Hand;

import std.exception;

import derelict.sdl2.sdl;

import DesktopDial.Exception,
       DesktopDial.SDLUtil;

/// @brief   時計盤の針の描画を扱うクラス。
/// @details 利用前にSDLを初期化、利用後にSDLを終了する必要がある。
class Hand
{
public:
    /// @brief  コンストラクタ。
    /// @param  definition 針の定義。
    /// @throws NullPointerException レンダラがnullだった場合。
    /// @throws CreationException    オブジェクト生成に失敗した場合。
    this(ref HandDefinition definition)
    {
        this(definition.Renderer, definition.Region, definition.Visual);
    }

    /// @brief  コンストラクタ。
    /// @param  renderer 使用するレンダラ。
    /// @param  region   時計盤の領域。
    /// @param  visual   針の見た目。
    /// @throws NullPointerException レンダラがnullだった場合。
    /// @throws CreationException    オブジェクト生成に失敗した場合。
    this(SDL_Renderer *renderer, const ref SDL_Rect region, const ref HandVisual visual)
    {
        static immutable error = "Renderer object was null.";

        renderer_ = renderer.enforceEx!(NullPointerException)(error);
        region_ = region;

        immutable SDL_Rect rect =
        {
            x: (region.w / 2) - (visual.Size.Width / 2),
            y: (region.h / 2) - visual.Size.LongLength,
            w: visual.Size.Width,
            h: visual.Size.LongLength + visual.Size.ShortLength
        };

        auto surface = CreateSurface(region.w, region.h);
        scope(exit) surface.SDL_FreeSurface;

        immutable background = surface.format.SDL_MapRGB(visual.Color.AlphaR, visual.Color.AlphaG, visual.Color.AlphaB);
        surface.SDL_SetColorKey(SDL_TRUE, background);
        surface.SDL_FillRect(&region, background);

        immutable foreground = surface.format.SDL_MapRGB(visual.Color.Red, visual.Color.Green, visual.Color.Blue);
        surface.SDL_FillRect(&rect, foreground);

        texture_ = ConvertToTexture(renderer, surface);
    }

    /// @デストラクタ。
    ~this()
    {
        if(texture_ !is null)
        {
            texture_.SDL_DestroyTexture;
        }
    }

    /// @brief 針を描画する。
    /// @param angle 針の角度。
    void Draw(in double angle) nothrow
    {
        renderer_.SDL_RenderCopyEx(texture_, null, &region_, angle, null, SDL_FLIP_NONE);
    }

private:
    immutable SDL_Rect region_; ///< 時計盤の領域。

    SDL_Renderer *renderer_;  ///< 使用するレンダラ。
    SDL_Texture *texture_;    ///< 針のテクスチャ。
}

/// @brief 針を定義する構造体。
struct HandDefinition
{
    SDL_Renderer *Renderer = null; ///< 使用するレンダラ。

    SDL_Rect Region;   ///< 時計盤の領域。
    HandVisual Visual; ///< 針の見た目。
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
