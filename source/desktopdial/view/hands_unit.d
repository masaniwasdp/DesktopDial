/**
  Provizas unuecon de manoj de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.hands_unit;

import derelict.sdl2.sdl;
import desktopdial.view.texture : TextureProperty, create;
import sdlraii.except;
import std.datetime : SysTime;
import std.typecons : Tuple, tuple;

/**
  Unueco de manoj de horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
class HandsUnit
{
    /**
      Konstruas unuecon.

      Params: renderer = Rendisto uzota por desegni manojn.
              property = Proprieto de unueco.

      Throws: SDL_Exception Kiam konstruado malsukcesas.
     */
    this(SDL_Renderer* renderer, in HandsUnitProperty property)
    {
        this.renderer = renderer;

        hHand = renderer.create(property.hHand);
        mHand = renderer.create(property.mHand);
        sHand = renderer.create(property.sHand);
    }

    ~this() @nogc nothrow
    {
        SDL_DestroyTexture(hHand);
        SDL_DestroyTexture(mHand);
        SDL_DestroyTexture(sHand);
    }

    /**
      Desegnas la manojn en fenestro.

      Params: time = Tempo, kiu estos montrata.

      Throws: SDL_Exception Kiam malsukcesas desegni.
     */
    void draw(in SysTime time)
    {
        immutable angles = time.calcAngles;

        SDL_Try(SDL_RenderCopyEx(renderer, hHand, null, null, angles[0], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer, mHand, null, null, angles[1], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer, sHand, null, null, angles[2], null, SDL_FLIP_NONE));
    }

    /** Rendisto por desegni manojn. */
    private SDL_Renderer* renderer;

    /** Teksturo de h manoj. */
    private SDL_Texture* hHand;

    /** Teksturo de m manoj. */
    private SDL_Texture* mHand;

    /** Teksturo de s manoj. */
    private SDL_Texture* sHand;

    invariant
    {
        assert(renderer !is null);
        assert(hHand !is null);
        assert(mHand !is null);
        assert(sHand !is null);
    }
}

/** Proprieto de unueco de horloĝaj manoj. */
struct HandsUnitProperty
{
    TextureProperty hHand; /// Proprieto de h manoj.
    TextureProperty mHand; /// Proprieto de m manoj.
    TextureProperty sHand; /// Proprieto de s manoj.
}

private enum hUnitAngle = 30; /// La angulo de h manoj por horo.
private enum mUnitAngle = 6;  /// La angulo de m manoj por minuto.
private enum sUnitAngle = 6;  /// La angulo de s manoj por sekundo.

/**
  Kalkuras angulojn de manoj, kiuj montras tempo donita.

  Params: time = Tempo, kiu estos montrata.

  Returns: Anguloj de la horo, la minuto kaj la sekundo.
 */
private Tuple!(double, double, double) calcAngles(in SysTime time) nothrow @safe
{
    immutable sHand = cast(double) time.second;
    immutable mHand = time.minute + sHand / 60;
    immutable hHand = time.hour + mHand / 60;

    return tuple(hUnitAngle * hHand, mUnitAngle * mHand, sUnitAngle * sHand);
}
