/**
  Provizas simbolojn de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.parts.symbols;

import desktopdial.parts.radiorect : RadioRectTextureDesign, draw;
import sdlraii;
import std.range : iota;

/**
  Simboloj de horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
struct Symbols
{
    /**
      Konstruas simbolojn.

      Params:
        renderer = Rendisto uzota por desegni simbolojn.
        designs  = Dezajnoj de simboloj.

      Throws:
        sdlraii.SDL_Exception Kiam konstruado malsukcesas.
     */
    this(ref SDL_RAII_Renderer renderer, in SymbolDesigns designs)
    {
        renderer_ = renderer.ptr;

        small_ = renderer.draw(designs.small);
        large_ = renderer.draw(designs.large);
    }

    this(this) @disable;

    /**
      Desegnas la simbolojn en fenestro.

      Throws:
        sdlraii.SDL_Exception Kiam malsukcesas desegni.
     */
    void draw()
    {
        foreach (angle; iota(0, 360, smallInterval))
        {
            SDL_Try(SDL_RenderCopyEx(renderer_, small_.ptr, null, null, angle, null, SDL_FLIP_NONE));
        }

        foreach (angle; iota(0, 360, largeInterval))
        {
            SDL_Try(SDL_RenderCopyEx(renderer_, large_.ptr, null, null, angle, null, SDL_FLIP_NONE));
        }
    }

    /* Rendisto por desegni simbolojn; */
    private SDL_Renderer* renderer_;

    /* Teksturo de malgrandaj horloĝaj simboloj. */
    private SDL_RAII_Texture small_;

    /* Teksturo de grandaj horloĝaj simboloj. */
    private SDL_RAII_Texture large_;

    invariant
    {
        assert(renderer_);
    }
}

/** Dezajnoj de horloĝaj simboloj. */
struct SymbolDesigns
{
    /** Dezajno de malgrandaj simboloj. */
    RadioRectTextureDesign small;

    /** Dezajno de grandaj simboloj. */
    RadioRectTextureDesign large;
}

/* La angula interspaco de malgrandaj simboloj. */
private enum smallInterval = 30;

/* La angula interspaco de grandaj simboloj. */
private enum largeInterval = 90;
