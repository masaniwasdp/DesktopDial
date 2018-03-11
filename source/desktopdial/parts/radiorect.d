module desktopdial.parts.radiorect;

import desktopdial.parts.types : Color, Size;
import sdlraii;

package struct RadioRectTextureDesign
{
    int distance;

    Size size;

    Color front;
    Color back;
}

package SDL_RAII_Texture draw(ref SDL_RAII_Renderer renderer, in RadioRectTextureDesign design)
{
    immutable size = renderer.size;

    auto surface = SDL_RAII_Surface(SDL_CreateRGBSurface(0, size.w, size.h, 32, 0, 0, 0, 0));

    surface.drawBack(design.back);

    surface.drawFront(design.front, design.size, design.distance);

    return SDL_RAII_Texture(SDL_CreateTextureFromSurface(renderer.ptr, surface.ptr));
}

private Size size(ref SDL_RAII_Renderer renderer)
{
    Size size = void;

    SDL_Try(SDL_GetRendererOutputSize(renderer.ptr, &size.w, &size.h));

    return size;
}

private void drawFront(ref SDL_RAII_Surface surface, in Color color, in Size size, in int distance)
{
    immutable SDL_Rect rect = {
        surface.ptr.w / 2 - size.w / 2,
        surface.ptr.h / 2 - distance - size.h,
        size.w,
        size.h
    };

    immutable pixel = SDL_MapRGB(surface.ptr.format, color.r, color.g, color.b);

    SDL_Try(SDL_FillRect(surface.ptr, &rect, pixel));
}

private void drawBack(ref SDL_RAII_Surface surface, in Color color)
{
    immutable pixel = SDL_MapRGB(surface.ptr.format, color.r, color.g, color.b);

    SDL_Try(SDL_SetColorKey(surface.ptr, true, pixel));

    SDL_Try(SDL_FillRect(surface.ptr, null, pixel));
}
