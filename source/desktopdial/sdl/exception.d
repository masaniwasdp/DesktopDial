module desktopdial.sdl.exception;

import std.exception : basicExceptionCtors;

class SDLException : Exception
{
    mixin basicExceptionCtors;
}
