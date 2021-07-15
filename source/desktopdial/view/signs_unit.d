/**
  Provizas unuecon de simboloj de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.signs_unit;

import derelict.sdl2.sdl;
import desktopdial.view.texture : TextureProperty, create;
import sdlraii.except;
import sdlraii.raii;
import std.range : iota;

/**
  Unueco de simboloj de horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
class SignsUnit
{
    /**
      Konstruas unuecon.

      Params: renderer = Rendisto uzota por desegni simbolojn.
              property = Proprieto de unueco.

      Throws: SDL_Exception Kiam konstruado malsukcesas.
     */
    this(SDL_Renderer* renderer, in SignsUnitProperty property)
    {
        this.renderer = renderer;

        small = renderer.create(property.small);
        large = renderer.create(property.large);
    }

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
        assert(renderer !is null);
    }
}

/** Proprieto de unueco de horloĝaj simboloj. */
struct SignsUnitProperty
{
    TextureProperty small; /// Proprieto de S simboloj.
    TextureProperty large; /// Proprieto de L simboloj.
}

private enum smallInterval = 30; /// La angula interspaco de S simboloj.
private enum largeInterval = 90; /// La angula interspaco de L simboloj.
