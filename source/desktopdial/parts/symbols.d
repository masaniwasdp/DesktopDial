/**
  Provizas simbolojn de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.parts.symbols;

import desktopdial.parts.drawing : RadioRectTextureDesign, draw;
import sdlraii;
import std.range : iota;

/**
  Simboloj de horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
struct Symbols
{
    /**
      Konstruas la simbolojn.

      Params:
        renderer = Rendisto uzota por konstrui la simbolojn.
        designs  = Dezajnoj de simboloj.

      Throws:
        sdlraii.SDL_Exception Kiam konstruado malsukcesas.
     */
    this(ref SDL_RAII_Renderer renderer, in SymbolDesigns designs)
    {
        small_ = renderer.draw(designs.small);
        large_ = renderer.draw(designs.large);
    }

    this(this) @disable;

    /**
      Desegnas la simbolojn en fenestro.

      Params:
        renderer = Rendisto de fenestro uzota por desegni.

      Throws:
        sdlraii.SDL_Exception Kiam malsukcesas desegni.
     */
    void draw(ref SDL_RAII_Renderer renderer)
    {
        foreach (angle; iota(0, 360, smallInterval))
        {
            SDL_Try(SDL_RenderCopyEx(renderer.ptr, small_.ptr, null, null, angle, null, SDL_FLIP_NONE));
        }

        foreach (angle; iota(0, 360, largeInterval))
        {
            SDL_Try(SDL_RenderCopyEx(renderer.ptr, large_.ptr, null, null, angle, null, SDL_FLIP_NONE));
        }
    }

    private SDL_RAII_Texture small_; // Teksturo de malgrandaj horloĝaj simboloj.
    private SDL_RAII_Texture large_; // Teksturo de grandaj horloĝaj simboloj.
}

/** Dezajnoj de horloĝaj simboloj. */
struct SymbolDesigns
{
    RadioRectTextureDesign small; /// Dezajno de malgrandaj simboloj.
    RadioRectTextureDesign large; /// Dezajno de grandaj simboloj.
}

private enum smallInterval = 30; // La angula interspaco de malgrandaj simboloj.
private enum largeInterval = 90; // La angula interspaco de grandaj simboloj.
