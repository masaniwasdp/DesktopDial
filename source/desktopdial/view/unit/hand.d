/**
  Provizas manojn de horloĝo.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.unit.hand;

import derelict.sdl2.sdl;
import desktopdial.view.unit.texture : TextureDesign, draw;
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

      Params: renderer = Rendisto uzota por desegni manojn.
              designs  = Dezajnoj de manoj.

      Throws: SDL_Exception Kiam konstruado malsukcesas.
     */
    this(SDL_Renderer* renderer, in HandDesigns designs)
    {
        this.renderer = renderer;

        this.hHand = renderer.draw(designs.hHand);
        this.mHand = renderer.draw(designs.mHand);
        this.sHand = renderer.draw(designs.sHand);
    }

    this(this) @disable;

    /**
      Desegnas la manojn en fenestro.

      Params: time = Tempo, kiu estos montrata.

      Throws: SDL_Exception Kiam malsukcesas desegni.
     */
    void draw(in SysTime time)
    {
        immutable angles = time.calcAngles;

        SDL_Try(SDL_RenderCopyEx(renderer, hHand.ptr, null, null, angles[0], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer, mHand.ptr, null, null, angles[1], null, SDL_FLIP_NONE));
        SDL_Try(SDL_RenderCopyEx(renderer, sHand.ptr, null, null, angles[2], null, SDL_FLIP_NONE));
    }

    /** Rendisto por desegni manojn. */
    private SDL_Renderer* renderer;

    /** Teksturoj de h manoj. */
    private SDL_RAII!(SDL_Texture*) hHand;

    /** Teksturoj de m manoj. */
    private SDL_RAII!(SDL_Texture*) mHand;

    /** Teksturoj de s manoj. */
    private SDL_RAII!(SDL_Texture*) sHand;

    invariant
    {
        assert(renderer);
    }
}

/** Dezajnoj de horloĝaj manoj. */
struct HandDesigns
{
    TextureDesign hHand; /// Dezajno de h manoj.
    TextureDesign mHand; /// Dezajno de m manoj.
    TextureDesign sHand; /// Dezajno de s manoj.
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
