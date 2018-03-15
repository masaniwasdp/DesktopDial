/**
  Provizas efektivigo de apliko.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.app;

import desktopdial.dial : Dial, DialDesign;
import jsonserialized.deserialization : deserializeFromJSONValue;
import sdlraii;
import std.datetime : Clock;
import std.exception : basicExceptionCtors;
import std.file : thisExePath, readText;
import std.path : buildPath, dirName;
import stdx.data.json : toJSONValue;

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

      Params:
        path = Vojo al la agorda dosiero de dezajno.

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

    /* Alĝustigas FPS. */
    private void adjust() nothrow @nogc
    {
        immutable elapsed = SDL_GetTicks() - last_;

        if (elapsed < interval) SDL_Delay(interval - elapsed);

        last_ = SDL_GetTicks();
    }

    /* Manipulas eventojn. */
    private void handle() nothrow @nogc
    {
        SDL_Event event = void;

        while (SDL_PollEvent(&event) == 1)
        {
            if (event.type == SDL_QUIT) continuation_ = false;
        }
    }

    /*
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

    /* Flago indikanta ĉu daŭri. */
    private auto continuation_ = true;

    /* Lasta ĝisdatigita tempo. */
    private uint last_;

    /* Rendisto de dial-horloĝo. */
    private Dial dial_;
}

/* La intertempo por ĝisdatigi aplikon. */
private enum interval = 16;

/* La defaŭlta valoro de vojo al la agorda dosiero. */
private enum filename = `asset/dialdesign.json`;

/*
  Komencas la SDL bibliotekon.

  Throws:
    AppException Kiam malsukcesas komenci.
 */
private void SDL_Initialize()
{
    try
    {
        DerelictSDL2.load;

        SDL_Try(SDL_Init(SDL_INIT_EVERYTHING));

        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, `liner`);

        SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, `1`);
    }
    catch (Exception e)
    {
        throw new AppException(`Couldn't initialize the SDL library.`, e);
    }
}

/*
  Legas agordan dosieron de dezajno.

  Params:
    path = Vojo al la agorda dosiero. Kiam ĝi estas malpleno, elektas defaŭltan valoron.

  Returns:
    Enhava teksto de la agorda dosiero.

  Throws:
    AppException Kiam malsukcesas legi.
 */
private string readDesignFile(in string path) @safe
{
    try
    {
        immutable file = path
            ? path
            : buildPath(thisExePath.dirName, filename);

        return file.readText;
    }
    catch (Exception e)
    {
        throw new AppException(`Couldn't read the design file.`, e);
    }
}

/*
  Analizas JSON kiel dezajno.

  Params:
    text = JSON teksto reprezentanta dezajno.

  Returns:
    Dezajno analizita de JSON.

  Throws:
    AppException Kiam malsukcesas analizi.
 */
private DialDesign parseDesign(in string text) @safe
{
    try
    {
        return text
            .toJSONValue
            .deserializeFromJSONValue!DialDesign;
    }
    catch (Exception e)
    {
        throw new AppException(`Couldn't parse the design.`, e);
    }
}
