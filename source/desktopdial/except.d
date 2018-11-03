/**
  Provizas esceptojn de la apliko.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.except;

import std.exception : basicExceptionCtors;

/** Escepto de apliko. */
class AppException : Exception
{
    mixin basicExceptionCtors;
}

/** Escepto de subtena funkcio. */
class LoaderException : Exception
{
    mixin basicExceptionCtors;
}
