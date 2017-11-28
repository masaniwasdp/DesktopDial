module desktopdial.graphic.drawing;

import derelict.sdl2.sdl : SDL_Color, SDL_FillRect, SDL_MapRGB, SDL_Rect, SDL_SetColorKey, SDL_TRUE;
import desktopdial.sdl.surface : Surface, get;

void drawRect(ref Surface surface, in SDL_Rect shape, in SDL_Color color, in SDL_Color alpha) nothrow @nogc
{
    immutable alphaMap = surface.get.format.SDL_MapRGB(alpha.r, alpha.g, alpha.b);

    surface.get.SDL_SetColorKey(SDL_TRUE, alphaMap);

    surface.get.SDL_FillRect(null, alphaMap);

    immutable colorMap = surface.get.format.SDL_MapRGB(color.r, color.g, color.b);

    surface.get.SDL_FillRect(&shape, colorMap);
}
