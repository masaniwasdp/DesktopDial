/**
  Rendas ciferdiskan horloĝon en la fenestro.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.clock_window;

import derelict.sdl2.sdl;
import desktopdial.view.data : Color, Size;
import desktopdial.view.hands_unit : HandsUnit, HandsUnitProperty;
import desktopdial.view.signs_unit : SignsUnit, SignsUnitProperty;
import sdlraii.except;
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

        window = SDL_CreateWindow(
            null,
            SDL_WINDOWPOS_UNDEFINED,
            SDL_WINDOWPOS_UNDEFINED,
            property.size.w,
            property.size.h,
            SDL_WINDOW_ALWAYS_ON_TOP);

        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED);

        handsUnit = new HandsUnit(renderer, property.handsUnit);
        signsUnit = new SignsUnit(renderer, property.signsUnit);
    }

    ~this() nothrow
    {
        handsUnit.destroy;
        signsUnit.destroy;

        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }

    /**
      Rendas la ciferdiskan horloĝon en la fenestro.

      Params: time = Tempo montrota en la ciferdiska horloĝo.

      Throws: SDL_Exception Kiam malsukcesas rendi la ciferdiskan horloĝon.
     */
    void render(in SysTime time)
    {
        SDL_Try(SDL_SetRenderDrawColor(renderer, bgColor.r, bgColor.g, bgColor.b, SDL_ALPHA_OPAQUE));
        SDL_Try(SDL_RenderClear(renderer));

        signsUnit.draw;
        handsUnit.draw(time);

        SDL_RenderPresent(renderer);
    }

    /** La koloro de la fenestro. */
    private immutable Color bgColor;

    /** Fenestro por prezentas grafikon. */
    private SDL_Window* window;

    /** Rendisto de la fenestro. */
    private SDL_Renderer* renderer;

    /** Unueco de manoj de horloĝo. */
    private HandsUnit handsUnit;

    /** Unueco de simboloj de horloĝo. */
    private SignsUnit signsUnit;

    invariant
    {
        assert(window !is null);
        assert(renderer !is null);
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
