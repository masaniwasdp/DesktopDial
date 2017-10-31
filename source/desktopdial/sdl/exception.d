/**
  Modulo, kiu provizas la esceptojn de la SDL-biblioteko.

  Date: 2017/11/1
  Author: masaniwa
 */

module desktopdial.sdl.exception;

import std.exception : basicExceptionCtors;

/** Escepto de la SDL-biblioteko. */
class SDLException : Exception
{
    mixin basicExceptionCtors;
}
