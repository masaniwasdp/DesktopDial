/**
  Provizas manojn de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.units.hands;

import desktopdial.view.units.texture : RectTextureDesign, draw;
import sdlraii;
import std.datetime : SysTime;
import std.typecons : Tuple, tuple;

/**
  Manoj de horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
struct Hands
{
    /**
      Konstruas manojn.

      Params:
        renderer = Rendisto uzota por desegni manojn.
        designs  = Dezajnoj de manoj.

      Throws:
        SDL_Exception Kiam konstruado malsukcesas.
     */
    this(ref SDL_RAII_Renderer renderer, in HandDesigns designs)
    {
        renderer_ = renderer.ptr;

        hHand_ = renderer.draw(designs.hHand);
        mHand_ = renderer.draw(designs.mHand);
        sHand_ = renderer.draw(designs.sHand);
    }

    this(this) @disable;

    /**
      Desegnas la manojn en fenestro.

      Params:
        time = Tempo, kiu estos montrata.

      Throws:
        SDL_Exception Kiam malsukcesas desegni.
     */
    void draw(in SysTime time)
    {
        immutable angles = time.calcAngles;

        SDL_Try(SDL_RenderCopyEx(renderer_, hHand_.ptr, null, null, angles[0], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer_, mHand_.ptr, null, null, angles[1], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer_, sHand_.ptr, null, null, angles[2], null, SDL_FLIP_NONE));
    }

    /** Rendisto por desegni manojn. */
    private SDL_Renderer* renderer_;

    /** Teksturoj de horoj manoj. */
    private SDL_RAII_Texture hHand_;

    /** Teksturoj de minutoj manoj. */
    private SDL_RAII_Texture mHand_;

    /** Teksturoj de sekundoj manoj. */
    private SDL_RAII_Texture sHand_;

    invariant
    {
        assert(renderer_);
    }
}

/** Dezajnoj de horloĝaj manoj. */
struct HandDesigns
{
    RectTextureDesign hHand; /// Dezajno de horoj manoj.
    RectTextureDesign mHand; /// Dezajno de minutoj manoj.
    RectTextureDesign sHand; /// Dezajno de sekundoj manoj.
}

private enum hUnitAngle = 30; /// La angulo de manoj por horo.
private enum mUnitAngle = 6;  /// La angulo de manoj por minuto.
private enum sUnitAngle = 6;  /// La angulo de manoj por sekundo.

/**
  Kalkuras angulojn de manoj, kiuj montras tempo donita.

  Params:
    time = Tempo, kiu estos montrata.

  Returns:
    Anguloj de la horo, la minuto kaj la sekundo.
 */
private Tuple!(double, double, double) calcAngles(in SysTime time) nothrow @safe
{
    immutable sHand = cast(double) time.second;

    immutable mHand = time.minute + sHand / 60;

    immutable hHand = time.hour + mHand / 60;

    return tuple(hUnitAngle * hHand, mUnitAngle * mHand, sUnitAngle * sHand);
}
