/**
  Provizas efektivigo de apliko.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.app;

import automem.unique : Unique;
import derelict.sdl2.sdl;
import desktopdial.loader : LoaderException, SDL_Initialize, parseText, readSettingFile;
import desktopdial.view.clock_window : ClockWindow, ClockWindowProperty;
import sdlraii.except;
import std.datetime : Clock;
import std.exception : basicExceptionCtors;

/** Escepto de apliko. */
class AppException : Exception
{
    mixin basicExceptionCtors;
}

/** Efektivigo de apliko. */
class App
{
    /**
      Komencas aplikon.

      Params: path = Vojo al la agorda dosiero.
                     Kiam ĝi estas malpleno, elektas defaŭltan valoron.

      Throws: LoaderException Kiam malsukcesas komenci la aplikon.
     */
    this(in string path)
    {
        try
        {
            SDL_Initialize();

            clockWindow = typeof(clockWindow)
                .construct(path.readSettingFile.parseText!ClockWindowProperty);
        }
        catch (SDL_Exception e)
        {
            throw new LoaderException(`Couldn't initialize a window.`, e);
        }
    }

    ~this()
    {
        if (_dtorFlag) { return; }

        clockWindow.unique;

        SDL_Quit();

        _dtorFlag = true;
    }

    /**
      Kuras la aplikon.

      Throws: AppException Kiam malsukcesas ĝisdatigi horloĝon.
     */
    void run()
    {
        while (continuation)
        {
            adjust;
            handle;
            update;
        }
    }

    /** Alĝustigas FPS. */
    private void adjust() nothrow @nogc
    {
        immutable elapsed = SDL_GetTicks() - last;

        if (elapsed < interval) SDL_Delay(interval - elapsed);

        last = SDL_GetTicks();
    }

    /** Manipulas eventojn. */
    private void handle() nothrow @nogc
    {
        SDL_Event event;

        while (SDL_PollEvent(&event) == 1)
        {
            if (event.type == SDL_WINDOWEVENT)
            {
                switch (event.window.event)
                {
                    case SDL_WINDOWEVENT_MINIMIZED:
                    case SDL_WINDOWEVENT_CLOSE:
                        continuation = false;
                        break;

                    default:
                        break;
                }
            }
        }
    }

    /**
      Ĝisdatigas horloĝon.

      Throws: AppException Kiam malsukcesas ĝisdatigi.
     */
    private void update()
    {
        try
        {
            clockWindow.render(Clock.currTime);
        }
        catch (Exception e)
        {
            throw new AppException(`Couldn't update the clock.`, e);
        }
    }

    private bool _dtorFlag = false;

    /** Flago indikanta ĉu daŭri. */
    private auto continuation = true;

    /** Lasta ĝisdatigita tempo. */
    private uint last;

    /** Fenestro por prezentas ciferdiska horloĝo. */
    private Unique!ClockWindow clockWindow;

    invariant
    {
        assert(_dtorFlag || clockWindow, `The clockWindow should not be empty.`);
    }
}

private enum interval = 16; /// La intertempo por ĝisdatigi aplikon.
