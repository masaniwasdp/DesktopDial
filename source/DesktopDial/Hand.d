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

import DesktopDial.Exception;

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
        renderer_ = definition.Renderer.enforceEx!(NullPointerException)(rendererWasNull_);
        region_ = definition.Region;

        immutable SDL_Rect rect =
        {
            x: (region_.w / 2) - (definition.Size.Width / 2),
            y: (region_.h / 2) - definition.Size.LongLength,
            w: definition.Size.Width,
            h: definition.Size.LongLength + definition.Size.ShortLength
        };

        auto surface =
            SDL_CreateRGBSurface(0, region_.w, region_.h, depth_, 0, 0, 0, 0)
            .enforceEx!(CreationException)(failedToCreateSurface_);

        scope(exit) surface.SDL_FreeSurface;

        immutable background = surface.format.SDL_MapRGB(definition.Color.AlphaR, definition.Color.AlphaG, definition.Color.AlphaB);
        surface.SDL_SetColorKey(SDL_TRUE, background);

        immutable foreground = surface.format.SDL_MapRGB(definition.Color.Red, definition.Color.Green, definition.Color.Blue);
        surface.SDL_FillRect(&rect, foreground);

        texture_ =
            renderer_.SDL_CreateTextureFromSurface(surface)
            .enforceEx!(CreationException)(failedToCreateTexture_);
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
    /// @param angle 針の回転角。
    void Draw(in double angle) nothrow
    {
        renderer_.SDL_RenderCopyEx(texture_, null, &region_, angle, null, SDL_FLIP_NONE);
    }

private:
    static immutable depth_ = 32; ///< ビット深度。

    static immutable rendererWasNull_ = "Renderer object was null.";              ///< レンダラがnullだったエラーメッセージ。
    static immutable failedToCreateSurface_ = "Failed to create surface object."; ///< サーフェス作成に失敗したエラーメッセージ。
    static immutable failedToCreateTexture_ = "Failed to create texture object."; ///< テクスチャ作成に失敗したエラーメッセージ。

    immutable SDL_Rect region_; ///< 時計盤の領域。

    SDL_Renderer *renderer_;  ///< 使用するレンダラ。
    SDL_Texture *texture_;    ///< 針のテクスチャ。
}

/// @brief 針を定義する構造体。
struct HandDefinition
{
    SDL_Renderer *Renderer = null; ///< 使用するレンダラ。

    SDL_Rect Region; ///< 時計盤の領域。
    HandSize Size;   ///< 針のサイズ。
    HandColor Color; ///< 針の色。
}

/// @brief 針のサイズを示す構造体。
struct HandSize
{
    ushort Width;       ///< 幅。
    ushort LongLength;  ///< 長い方の中心からの長さ。
    ushort ShortLength; ///< 短い方の中心からの長さ。
}

/// @brief 針の色を示す構造体。
struct HandColor
{
    ubyte Red;   ///< 赤の明度。
    ubyte Green; ///< 緑の明度。
    ubyte Blue;  ///< 青の明度。

    ubyte AlphaR; ///< 透過色の赤の明度。
    ubyte AlphaG; ///< 透過色の緑の明度。
    ubyte AlphaB; ///< 透過色の青の明度。
}
