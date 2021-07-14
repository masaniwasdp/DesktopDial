/**
  Provizas subtenajn funkciojn de apliko.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.loader;

import derelict.sdl2.sdl;
import jsonserialized : deserializeFromJSONValue;
import sdlraii;
import stdx.data.json : toJSONValue;
import std.exception : basicExceptionCtors;
import std.file : thisExePath, readText;
import std.path : buildPath, dirName;

/** Escepto de subtena funkcio. */
class LoaderException : Exception
{
    mixin basicExceptionCtors;
}

/**
  Komencas la SDL bibliotekon.

  Throws: LoaderException Kiam malsukcesas komenci.
 */
package void SDL_Initialize()
{
    try
    {
        DerelictSDL2.load;

        SDL_Try(SDL_Init(SDL_INIT_EVERYTHING));

        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, `liner`);
    }
    catch (Exception e)
    {
        throw new LoaderException(`Couldn't initialize the SDL library.`, e);
    }
}

/**
  Legas agordan dosieron.

  Params: path = Vojo al la agorda dosiero. Kiam ĝi estas malpleno, elektas defaŭltan valoron.

  Returns: Enhava teksto de la agorda dosiero.

  Throws: LoaderException Kiam malsukcesas legi.
 */
package string readSettingFile(in string path) @safe
{
    try
    {
        immutable file = path ? path : buildPath(thisExePath.dirName, filename);

        return file.readText;
    }
    catch (Exception e)
    {
        throw new LoaderException(`Couldn't read the setting file.`, e);
    }
}

/**
  Analizas JSON kiel agordo.

  Params: text = JSON teksto reprezentanta agordo.

  Returns: Agordo analizita de JSON.

  Throws: LoaderException Kiam malsukcesas analizi.
 */
package T parseText(T)(in string text) @safe
{
    try
    {
        return text.toJSONValue.deserializeFromJSONValue!T;
    }
    catch (Exception e)
    {
        throw new LoaderException(`Couldn't parse the setting.`, e);
    }
}

private enum filename = `asset/dial.json`; /// La defaŭlta valoro de vojo al la agorda dosiero.
