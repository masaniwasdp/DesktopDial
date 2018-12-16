/**
  Provizas efektivigo de apliko.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.app;

import desktopdial.loader : LoaderException, SDL_Initialize, parseText, readSettingFile;
import desktopdial.view.dial : Dial, DialDesign;
import sdlraii;
import std.datetime : Clock;
import std.exception : basicExceptionCtors;

/** Escepto de apliko. */
class AppException : Exception
{
    mixin basicExceptionCtors;
}

/** Efektivigo de apliko. */
struct App
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

            dial = Dial(path.readSettingFile.parseText!DialDesign);
        }
        catch (SDL_Exception e)
        {
            throw new LoaderException(`Couldn't initialize graphic objects.`, e);
        }
    }

    this(this) @disable;

    ~this()
    {
        SDL_Quit();
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
        SDL_Event event = void;

        while (SDL_PollEvent(&event) == 1)
        {
            if (event.type == SDL_QUIT) continuation = false;
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
            dial.render(Clock.currTime);
        }
        catch (Exception e)
        {
            throw new AppException(`Couldn't update the clock.`, e);
        }
    }

    /** Flago indikanta ĉu daŭri. */
    private auto continuation = true;

    /** Lasta ĝisdatigita tempo. */
    private uint last;

    /** Rendisto de dial-horloĝo. */
    private Dial dial;
}

private enum interval = 16; /// La intertempo por ĝisdatigi aplikon.
