/**
  Modulo, kiu provizas manojn de horloĝo.

  Copyright: 2017 masaniwa
  License: MIT
 */

module desktopdial.graphic.hands;

import derelict.sdl2.sdl : SDL_Color, SDL_FLIP_NONE, SDL_GetRendererOutputSize, SDL_Rect, SDL_RenderCopyEx;
import desktopdial.graphic.drawing : drawRect;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.surface : Surface, get;
import desktopdial.sdl.texture : Texture, get;
import std.datetime : SysTime;
import std.typecons : Tuple, tuple;

/** Manoj de horloĝo. Uzi tiojn postulas la SDL-bibliotekon. */
struct Hands
{
    /**
      Konstruas la manojn.

      Params:
        renderer = Rendisto uzota por konstrui la manojn.
        visual = La vido de la manoj.

      Throws:
        desktopdial.sdl.exception.SDLException Kiam konstruado malsukcesas.
     */
    this(ref Renderer renderer, in HandsVisual visual)
    {
        hour = renderer.drawHand(visual.hour);
        minute = renderer.drawHand(visual.minute);
        second = renderer.drawHand(visual.second);
    }

    this(this) @disable;

    /**
      Desegnas la manojn en fenestro.

      Params:
        renderer = Rendisto de fenestro uzota por desegni.
        time = Tempo, kiu estos montrata.
     */
    void draw(ref Renderer renderer, in SysTime time) nothrow
    {
        immutable angles = time.calcAngles;

        renderer.get.SDL_RenderCopyEx(hour.get, null, null, angles[0], null, SDL_FLIP_NONE);
        renderer.get.SDL_RenderCopyEx(minute.get, null, null, angles[1], null, SDL_FLIP_NONE);
        renderer.get.SDL_RenderCopyEx(second.get, null, null, angles[2], null, SDL_FLIP_NONE);
    }

    private Texture hour;   /// Teksturo de horoj manoj.
    private Texture minute; /// Teksturo de minutoj manoj.
    private Texture second; /// Teksturo de sekundoj manoj.
}

/** Vidoj de horloĝaj manoj. */
struct HandsVisual
{
    HandVisual hour;   /// Vido de horoj manoj.
    HandVisual minute; /// Vido de minutoj manoj.
    HandVisual second; /// Vido de sekundoj manoj.
}

/** Vido de horloĝa mano. */
struct HandVisual
{
    ushort width;   /// La larĝo de mano.
    ushort longer;  /// La pli longa longo de mano.
    ushort shorter; /// La pli mallonga longo de mano.

    SDL_Color color; /// Koloro de mano.
    SDL_Color alpha; /// Travidebla koloro de teksturo.
}

/**
  Desegnas manon en teksturo.

  Params:
    renderer = Rendisto uzota por desegni manon.
    visual = La vido de simbolo.

  Returns: Teksturo sur kiu desegnis la manon.

  Throws:
    desktopdial.sdl.exception.SDLException Kiam malsukcesas desegni.
 */
private Texture drawHand(ref Renderer renderer, in HandVisual visual)
{
    int width, height;

    renderer.get.SDL_GetRendererOutputSize(&width, &height);

    auto surface = Surface(width, height);

    immutable rect = SDL_Rect(
            width / 2 - visual.width / 2,
            height / 2 - visual.longer,
            visual.width,
            visual.longer + visual.shorter);

    surface.drawRect(rect, visual.color, visual.alpha);

    return Texture(renderer, surface);
}

/**
  Kalkuras manajn angulojn, kiuj montras tempo donita.

  Params:
    time = Tempo, kiu estos montrata.

  Returns: Anguloj de la horo, la minuto kaj la sekundo.
 */
private Tuple!(double, double, double) calcAngles(in SysTime time) nothrow @safe
{
    immutable second = time.second + time.fracSecs.total!`msecs` / 1000.0;

    immutable minute = time.minute + second / 60.0;

    immutable hour = time.hour + minute / 60.0;

    return tuple(30 * hour, 6 * minute, 6 * second);
}
