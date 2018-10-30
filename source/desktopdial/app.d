/**
  Provizas efektivigo de apliko.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.app;

import desktopdial.ui.dial : Dial;
import desktopdial.util : AppException, SDL_Initialize, parseDesign, readDesignFile;
import sdlraii;
import std.datetime : Clock;

/** Efektivigo de apliko. */
struct App
{
    /**
      Komencas aplikon.

      Params:
        path = Vojo al la agorda dosiero. Kiam ĝi estas malpleno, elektas defaŭltan valoron.

      Throws:
        AppException Kiam malsukcesas komenci la aplikon.
     */
    this(in string path)
    {
        try
        {
            SDL_Initialize();

            dial_ = Dial(path.readDesignFile.parseDesign);
        }
        catch (SDL_Exception e)
        {
            throw new AppException(`Couldn't initialize graphic objects.`, e);
        }
    }

    this(this) @disable;

    ~this()
    {
        SDL_Quit();
    }

    /**
      Kuras la aplikon.

      Throws:
        AppException Kiam malsukcesas ĝisdatigi horloĝon.
     */
    void run()
    {
        while (continuation_)
        {
            adjust;
            handle;
            update;
        }
    }

    /** Alĝustigas FPS. */
    private void adjust() nothrow @nogc
    {
        immutable elapsed = SDL_GetTicks() - last_;

        if (elapsed < interval) SDL_Delay(interval - elapsed);

        last_ = SDL_GetTicks();
    }

    /** Manipulas eventojn. */
    private void handle() nothrow @nogc
    {
        SDL_Event event = void;

        while (SDL_PollEvent(&event) == 1)
        {
            if (event.type == SDL_QUIT) continuation_ = false;
        }
    }

    /**
      Ĝisdatigas horloĝon.

      Throws:
        AppException Kiam malsukcesas ĝisdatigi.
     */
    private void update()
    {
        try
        {
            dial_.render(Clock.currTime);
        }
        catch (Exception e)
        {
            throw new AppException(`Couldn't update the clock.`, e);
        }
    }

    /** Flago indikanta ĉu daŭri. */
    private auto continuation_ = true;

    /** Lasta ĝisdatigita tempo. */
    private uint last_;

    /** Rendisto de dial-horloĝo. */
    private Dial dial_;
}

/** La intertempo por ĝisdatigi aplikon. */
private enum interval = 16;
