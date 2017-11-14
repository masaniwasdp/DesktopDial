/**
  Modulo, kiu provizas la esceptojn de la SDL-biblioteko.

  Copyright: 2017 masaniwa
  License: MIT
 */

module desktopdial.sdl.exception;

import std.exception : basicExceptionCtors;

/** Escepto de la SDL-biblioteko. */
class SDLException : Exception
{
    mixin basicExceptionCtors;
}
