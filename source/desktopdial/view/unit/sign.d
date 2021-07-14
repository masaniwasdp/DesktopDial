/**
  Provizas simbolojn de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.unit.sign;

import derelict.sdl2.sdl;
import desktopdial.view.unit.texture : TextureDesign, draw;
import sdlraii;
import std.range : iota;

/**
  Simboloj de horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
struct Signs
{
    /**
      Konstruas simbolojn.

      Params: renderer = Rendisto uzota por desegni simbolojn.
              designs  = Dezajnoj de simboloj.

      Throws: SDL_Exception Kiam konstruado malsukcesas.
     */
    this(SDL_Renderer* renderer, in SignDesigns designs)
    {
        this.renderer = renderer;

        this.small = renderer.draw(designs.small);
        this.large = renderer.draw(designs.large);
    }

    this(this) @disable;

    /**
      Desegnas la simbolojn en fenestro.

      Throws: SDL_Exception Kiam malsukcesas desegni.
     */
    void draw()
    {
        foreach (angle; iota(0, 360, smallInterval))
        {
            SDL_Try(SDL_RenderCopyEx(renderer, small.ptr, null, null, angle, null, SDL_FLIP_NONE));
        }

        foreach (angle; iota(0, 360, largeInterval))
        {
            SDL_Try(SDL_RenderCopyEx(renderer, large.ptr, null, null, angle, null, SDL_FLIP_NONE));
        }
    }

    /** Rendisto por desegni simbolojn; */
    private SDL_Renderer* renderer;

    /** Teksturo de S horloĝaj simboloj. */
    private SDL_RAII!(SDL_Texture*) small;

    /** Teksturo de L horloĝaj simboloj. */
    private SDL_RAII!(SDL_Texture*) large;

    invariant
    {
        assert(renderer);
    }
}

/** Dezajnoj de horloĝaj simboloj. */
struct SignDesigns
{
    TextureDesign small; /// Dezajno de S simboloj.
    TextureDesign large; /// Dezajno de L simboloj.
}

private enum smallInterval = 30; /// La angula interspaco de S simboloj.
private enum largeInterval = 90; /// La angula interspaco de L simboloj.
