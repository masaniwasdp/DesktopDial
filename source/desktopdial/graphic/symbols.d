module desktopdial.graphic.symbols;

import derelict.sdl2.sdl : SDL_Color, SDL_FLIP_NONE, SDL_GetRendererOutputSize, SDL_Rect, SDL_RenderCopyEx;
import desktopdial.graphic.drawing : drawRect;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.surface : Surface;
import desktopdial.sdl.texture : Texture;
import std.range : iota;

struct Symbols
{
    this(ref Renderer renderer, in SymbolsVisual visual)
    {
        small = renderer.drawSymbol(visual.small);
        large = renderer.drawSymbol(visual.large);
    }

    this(this) @disable;

    void draw(ref Renderer renderer) nothrow @nogc
    {
        foreach (angle; iota(0, 360, smallInterval))
        {
            renderer.SDL_RenderCopyEx(small, null, null, angle, null, SDL_FLIP_NONE);
        }

        foreach (angle; iota(0, 360, largeInterval))
        {
            renderer.SDL_RenderCopyEx(large, null, null, angle, null, SDL_FLIP_NONE);
        }
    }

    private Texture small;
    private Texture large;
}

struct SymbolsVisual
{
    SymbolVisual small;
    SymbolVisual large;
}

struct SymbolVisual
{
    ushort width;
    ushort start;
    ushort length;

    SDL_Color color;
    SDL_Color alpha;
}

private enum smallInterval = 30;
private enum largeInterval = 90;

private Texture drawSymbol(ref Renderer renderer, in SymbolVisual visual)
{
    int width, height;

    renderer.SDL_GetRendererOutputSize(&width, &height);

    auto surface = Surface(width, height);

    immutable rect = SDL_Rect(
            width / 2 - visual.width / 2,
            height / 2 - visual.start - visual.length,
            visual.width,
            visual.length);

    surface.drawRect(rect, visual.color, visual.alpha);

    return Texture(renderer, surface);
}
