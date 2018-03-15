/**
  Provizas subtenajn funkciojn de apliko.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.support;

import desktopdial.dial : DialDesign;
import jsonserialized.deserialization : deserializeFromJSONValue;
import sdlraii;
import std.exception : basicExceptionCtors;
import std.file : thisExePath, readText;
import std.path : buildPath, dirName;
import stdx.data.json : toJSONValue;

/** Escepto de apliko. */
package class AppException : Exception
{
    mixin basicExceptionCtors;
}

/**
  Komencas la SDL bibliotekon.

  Throws:
    AppException Kiam malsukcesas komenci.
 */
package void SDL_Initialize()
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

/**
  Legas agordan dosieron de dezajno.

  Params:
    path = Vojo al la agorda dosiero. Kiam ĝi estas malpleno, elektas defaŭltan valoron.

  Returns:
    Enhava teksto de la agorda dosiero.

  Throws:
    AppException Kiam malsukcesas legi.
 */
package string readDesignFile(in string path) @safe
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

/**
  Analizas JSON kiel dezajno.

  Params:
    text = JSON teksto reprezentanta dezajno de dial-horloĝo.

  Returns:
    Dezajno analizita de JSON.

  Throws:
    AppException Kiam malsukcesas analizi.
 */
package DialDesign parseDesign(in string text) @safe
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

/** La defaŭlta valoro de vojo al la agorda dosiero. */
private enum filename = `asset/dialdesign.json`;
