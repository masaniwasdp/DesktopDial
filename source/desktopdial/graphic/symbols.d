/**
  Modulo, kiu provizas simbolojn de horloĝo.

  Copyright: 2017 masaniwa
  License: MIT
 */

module desktopdial.graphic.symbols;

import derelict.sdl2.sdl : SDL_Color, SDL_FLIP_NONE, SDL_GetRendererOutputSize, SDL_Rect, SDL_RenderCopyEx;
import desktopdial.graphic.drawing : drawRect;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.surface : Surface;
import desktopdial.sdl.texture : Texture;
import std.range : iota;

/** Simboloj de horloĝo. Uzi tiojn postulas la SDL-bibliotekon. */
struct Symbols
{
    /**
      Konstruas la simbolojn.

      Params:
        renderer = Rendisto uzota por konstrui la simbolojn.
        visual = La vido de la simboloj.

      Throws:
        desktopdial.sdl.exception.SDLException Kiam konstruado malsukcesas.
     */
    this(ref Renderer renderer, in SymbolsVisual visual)
    {
        small = renderer.drawSymbol(visual.small);
        large = renderer.drawSymbol(visual.large);
    }

    this(this) @disable;

    /**
      Desegnas la simbolojn en fenestro.

      Params:
        renderer = Rendisto de fenestro uzota por desegni.
     */
    void draw(ref Renderer renderer) nothrow @nogc
    {
        foreach (angle; iota(0, 360, smallInterval))
        {
            renderer.SDL_RenderCopyEx(small, null, null, angle, null, SDL_FLIP_NONE);
        }

        foreach (angle; iota(0, 360, largeInterval))
        {
            renderer.SDL_RenderCopyEx(large, null, null, angle, null, SDL_FLIP_NONE);
        }
    }

    private Texture small; /// Teksturo de malgrandaj horloĝaj simboloj.
    private Texture large; /// Teksturo de grandaj horloĝaj simboloj.
}

/** Vidoj de horloĝaj simboloj. */
struct SymbolsVisual
{
    SymbolVisual small; /// Vido de malgrandaj horloĝaj simboloj.
    SymbolVisual large; /// Vido de grandaj horloĝaj simboloj.
}

/** Vido de horloĝa simbolo. */
struct SymbolVisual
{
    ushort width;  /// La larĝo de simbolo.
    ushort start;  /// La distanco de la centro de komencpunkto.
    ushort length; /// La longo de simbolo.

    SDL_Color color; /// Koloro de simbolo.
    SDL_Color alpha; /// Travidebla koloro de teksturo.
}

private enum smallInterval = 30; /// La angula interspaco de malgrandaj simboloj.
private enum largeInterval = 90; /// La angula interspaco de grandaj simboloj.

/**
  Desegnas simbolon en teksturo.

  Params:
    renderer = Rendisto uzota por desegni simbolon.
    visual = La vido de simbolo.

  Returns: Teksturo sur kiu desegnis la simbolon.

  Throws:
    desktopdial.sdl.exception.SDLException Kiam malsukcesas desegni.
 */
private Texture drawSymbol(ref Renderer renderer, in SymbolVisual visual)
{
    int width, height;

    renderer.SDL_GetRendererOutputSize(&width, &height);

    auto surface = Surface(width, height);

    immutable rect = SDL_Rect(
            width / 2 - visual.width / 2,
            height / 2 - visual.start - visual.length,
            visual.width,
            visual.length);

    surface.drawRect(rect, visual.color, visual.alpha);

    return Texture(renderer, surface);
}
