module desktopdial.graph.drawing;

import derelict.sdl2.sdl;
import desktopdial.graph.sdl.surface : Surface, get;

void draw(ref Surface surface, in SDL_Rect shape, in SDL_Color color, in SDL_Color alpha) nothrow @nogc
{
    immutable alphaMap = SDL_MapRGB(surface.get.format, alpha.r, alpha.g, alpha.b);

    SDL_SetColorKey(surface.get, SDL_TRUE, alphaMap);

    SDL_FillRect(surface.get, null, alphaMap);

    immutable colorMap = SDL_MapRGB(surface.get.format, color.r, color.g, color.b);

    SDL_FillRect(surface.get, &shape, colorMap);
}
