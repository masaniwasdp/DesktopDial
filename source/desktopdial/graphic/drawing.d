module desktopdial.graphic.drawing;

import derelict.sdl2.sdl : SDL_Color, SDL_FillRect, SDL_MapRGB, SDL_Rect, SDL_SetColorKey, SDL_TRUE;

import desktopdial.sdl.surface : Surface;

void drawRect(ref Surface surface, in SDL_Rect shape, in SDL_Color color, in SDL_Color alpha) nothrow @nogc
{
    immutable alphaMap = surface.format.SDL_MapRGB(alpha.r, alpha.g, alpha.b);

    surface.SDL_SetColorKey(SDL_TRUE, alphaMap);

    surface.SDL_FillRect(null, alphaMap);

    immutable colorMap = surface.format.SDL_MapRGB(color.r, color.g, color.b);

    surface.SDL_FillRect(&shape, colorMap);
}
