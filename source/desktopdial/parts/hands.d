/**
  Provizas manojn de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.parts.hands;

import desktopdial.parts.radiorect : RadioRectTextureDesign, draw;
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
        sdlraii.SDL_Exception Kiam konstruado malsukcesas.
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
        sdlraii.SDL_Exception Kiam malsukcesas desegni.
     */
    void draw(in SysTime time)
    {
        immutable angles = time.calcAngles;

        SDL_Try(SDL_RenderCopyEx(renderer_, hHand_.ptr, null, null, angles[0], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer_, mHand_.ptr, null, null, angles[1], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer_, sHand_.ptr, null, null, angles[2], null, SDL_FLIP_NONE));
    }

    private SDL_Renderer* renderer_; // Rendisto por desegni manojn.

    private SDL_RAII_Texture hHand_; // Teksturo de horoj manoj.
    private SDL_RAII_Texture mHand_; // Teksturo de minutoj manoj.
    private SDL_RAII_Texture sHand_; // Teksturo de sekundoj manoj.

    invariant
    {
        assert(renderer_);
    }
}

/** Dezajnoj de horloĝaj manoj. */
struct HandDesigns
{
    RadioRectTextureDesign hHand; /// Dezajno de horoj manoj.
    RadioRectTextureDesign mHand; /// Dezajno de minutoj manoj.
    RadioRectTextureDesign sHand; /// Dezajno de sekundoj manoj.
}

private enum hUnitAngle = 30; // La angulo de manoj por horo.
private enum mUnitAngle = 6;  // La angulo de manoj por minuto.
private enum sUnitAngle = 6;  // La angulo de manoj por sekundo.

/*
  Kalkuras angulojn de manoj, kiuj montras tempo donita.

  Params:
    time = Tempo, kiu estos montrata.

  Returns: Anguloj de la horo, la minuto kaj la sekundo.
 */
private Tuple!(double, double, double) calcAngles(in SysTime time) nothrow @safe
{
    immutable sHand = cast(double) time.second;

    immutable mHand = time.minute + sHand / 60;

    immutable hHand = time.hour + mHand / 60;

    return tuple(hUnitAngle * hHand, mUnitAngle * mHand, sUnitAngle * sHand);
}
