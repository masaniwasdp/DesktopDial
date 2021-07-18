/**
  Rendas ciferdiskan horloĝon en la fenestro.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.clock_window;

import automem.unique : Unique;
import derelict.sdl2.sdl;
import desktopdial.view.hands_unit : HandsUnit, HandsUnitProperty;
import desktopdial.view.signs_unit : SignsUnit, SignsUnitProperty;
import desktopdial.view.types : Color, Size;
import sdlraii.except;
import sdlraii.raii;
import std.datetime : SysTime;

/**
  Fenestro por prezentas ciferdiska horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
class ClockWindow
{
    /**
      Konstruas fenestron.

      Params: property = Proprieto de la fenestro.

      Throws: SDL_Exception Kiam konstruado malsukcesas.
     */
    this(in ClockWindowProperty property)
    {
        bgColor = property.bgColor;

        window = typeof(window).construct(SDL_CreateWindow(
            null,
            SDL_WINDOWPOS_UNDEFINED,
            SDL_WINDOWPOS_UNDEFINED,
            property.size.w,
            property.size.h,
            SDL_WINDOW_ALWAYS_ON_TOP));

        renderer = typeof(renderer).construct(SDL_CreateRenderer(
            window.ptr, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED));

        handsUnit = typeof(handsUnit).construct(renderer.ptr, property.handsUnit);
        signsUnit = typeof(signsUnit).construct(renderer.ptr, property.signsUnit);
    }

    ~this()
    {
        if (_dtorFlag) { return; }

        handsUnit.unique;
        signsUnit.unique;
        renderer.unique;
        window.unique;

        _dtorFlag = true;
    }

    /**
      Rendas la ciferdiskan horloĝon en la fenestro.

      Params: time = Tempo montrota en la ciferdiska horloĝo.

      Throws: SDL_Exception Kiam malsukcesas rendi la ciferdiskan horloĝon.
     */
    void render(in SysTime time)
    {
        SDL_Try(SDL_SetRenderDrawColor(renderer.ptr, bgColor.r, bgColor.g, bgColor.b, SDL_ALPHA_OPAQUE));
        SDL_Try(SDL_RenderClear(renderer.ptr));

        signsUnit.draw;
        handsUnit.draw(time);

        SDL_RenderPresent(renderer.ptr);
    }

    private bool _dtorFlag = false;

    /** La koloro de la fenestro. */
    private immutable Color bgColor;

    /** Fenestro por prezentas grafikon. */
    private Unique!(SDL_RAII!(SDL_Window*)) window;

    /** Rendisto de la fenestro. */
    private Unique!(SDL_RAII!(SDL_Renderer*)) renderer;

    /** Unueco de manoj de horloĝo. */
    private Unique!HandsUnit handsUnit;

    /** Unueco de simboloj de horloĝo. */
    private Unique!SignsUnit signsUnit;

    invariant
    {
        assert(_dtorFlag || window, `The window should not be empty.`);
        assert(_dtorFlag || renderer, `The renderer should not be empty.`);
        assert(_dtorFlag || handsUnit, `The handsUnit should not be empty.`);
        assert(_dtorFlag || signsUnit, `The signsUnit should not be empty.`);
    }
}

/** Proprieto de la fenestro. */
struct ClockWindowProperty
{
    Size size; /// Grandeco de fenestro.

    Color bgColor; /// Korolo de fenestro.

    HandsUnitProperty handsUnit; /// Proprieto de unueco de manoj.

    SignsUnitProperty signsUnit; /// Proprieto de unueco de simboloj.
}
