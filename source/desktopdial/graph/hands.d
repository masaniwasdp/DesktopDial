/**
  Modulo, kiu provizas manojn de horloĝo.

  Copyright: 2018 masaniwa
  License:   MIT
 */

module desktopdial.graph.hands;

import derelict.sdl2.sdl;
import desktopdial.graph.drawing : draw;
import desktopdial.graph.sdl.renderer : Renderer;
import desktopdial.graph.sdl.surface : Surface, get;
import desktopdial.graph.sdl.texture : Texture, get;
import std.datetime : SysTime;
import std.typecons : Tuple, tuple;

/** Manoj de horloĝo. Uzi tiojn postulas la SDL-bibliotekon. */
struct Hands
{
    /**
      Konstruas la manojn.

      Params:
        renderer = Rendisto uzota por konstrui la manojn.
        visual   = La vido de la manoj.

      Throws:
        desktopdial.graph.sdl.exception.SDLException Kiam konstruado malsukcesas.
     */
    this(ref Renderer renderer, in HandsVisual visual)
    {
        hou = renderer.draw(visual.hou);
        min = renderer.draw(visual.min);
        sec = renderer.draw(visual.sec);
    }

    this(this) @disable;

    /**
      Desegnas la manojn en fenestro.

      Params:
        renderer = Rendisto de fenestro uzota por desegni.
        time     = Tempo, kiu estos montrata.
     */
    void draw(ref Renderer renderer, in SysTime time) nothrow
    {
        immutable angles = time.calcAngles;

        SDL_RenderCopyEx(renderer.get, hou.get, null, null, angles[0], null, SDL_FLIP_NONE);
        SDL_RenderCopyEx(renderer.get, min.get, null, null, angles[1], null, SDL_FLIP_NONE);
        SDL_RenderCopyEx(renderer.get, sec.get, null, null, angles[2], null, SDL_FLIP_NONE);
    }

    private Texture hou; /// Teksturo de horoj manoj.
    private Texture min; /// Teksturo de minutoj manoj.
    private Texture sec; /// Teksturo de sekundoj manoj.
}

/** Vidoj de horloĝaj manoj. */
struct HandsVisual
{
    HandVisual hou; /// Vido de horoj manoj.
    HandVisual min; /// Vido de minutoj manoj.
    HandVisual sec; /// Vido de sekundoj manoj.
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
    visual   = La vido de simbolo.

  Returns: Teksturo sur kiu desegnis la manon.

  Throws:
    desktopdial.graph.sdl.exception.SDLException Kiam malsukcesas desegni.
 */
private Texture draw(ref Renderer renderer, in HandVisual visual)
{
    int width, height;

    SDL_GetRendererOutputSize(renderer.get, &width, &height);

    auto surface = Surface(width, height);

    immutable rect = SDL_Rect(
        width / 2 - visual.width / 2,
        height / 2 - visual.longer,
        visual.width,
        visual.longer + visual.shorter);

    surface.draw(rect, visual.color, visual.alpha);

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
    immutable sec = time.second + time.fracSecs.total!`msecs` / 1000.0;

    immutable min = time.minute + sec / 60.0;

    immutable hou = time.hour + min / 60.0;

    return tuple(30 * hou, 6 * min, 6 * sec);
}
