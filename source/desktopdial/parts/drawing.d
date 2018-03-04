module desktopdial.parts.drawing;

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
    immutable max = renderer.size;

    auto surface = SDL_RAII_Surface(SDL_CreateRGBSurface(0, max.w, max.h, 32, 0, 0, 0, 0));

    surface.draw(design.back);

    immutable SDL_Rect rect = {
        max.w / 2 - design.size.w / 2,
        max.h / 2 - design.distance - design.size.h,
        design.size.w,
        design.size.h
    };

    surface.draw(rect, design.front);

    return SDL_RAII_Texture(SDL_CreateTextureFromSurface(renderer.ptr, surface.ptr));
}

private Size size(ref SDL_RAII_Renderer renderer)
{
    Size size = void;

    SDL_Try(SDL_GetRendererOutputSize(renderer.ptr, &size.w, &size.h));

    return size;
}

private void draw(ref SDL_RAII_Surface surface, in Color color)
{
    immutable pixel = SDL_MapRGB(surface.ptr.format, color.r, color.g, color.b);

    SDL_Try(SDL_SetColorKey(surface.ptr, true, pixel));

    SDL_Try(SDL_FillRect(surface.ptr, null, pixel));
}

private void draw(ref SDL_RAII_Surface surface, in SDL_Rect rect, in Color color)
{
    immutable pixel = SDL_MapRGB(surface.ptr.format, color.r, color.g, color.b);

    SDL_Try(SDL_FillRect(surface.ptr, &rect, pixel));
}
