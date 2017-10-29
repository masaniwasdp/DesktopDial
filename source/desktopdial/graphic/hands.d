module desktopdial.graphic.hands;

import std.datetime : SysTime;

import derelict.sdl2.sdl : SDL_Color, SDL_FLIP_NONE, SDL_GetRendererOutputSize, SDL_Rect, SDL_RenderCopyEx;

import desktopdial.graphic.drawing : drawRect;
import desktopdial.sdl.renderer : Renderer;
import desktopdial.sdl.surface : Surface;
import desktopdial.sdl.texture : Texture;

struct Hands
{
    this(ref Renderer renderer, in HandsVisual visual)
    {
        hour = renderer.drawHand(visual.hour);
        minute = renderer.drawHand(visual.minute);
        second = renderer.drawHand(visual.second);
    }

    this(this) @disable;

    void draw(ref Renderer renderer, in SysTime time) nothrow
    {
        immutable angles = time.calcAngles;

        renderer.SDL_RenderCopyEx(hour, null, null, angles.hour, null, SDL_FLIP_NONE);
        renderer.SDL_RenderCopyEx(minute, null, null, angles.minute, null, SDL_FLIP_NONE);
        renderer.SDL_RenderCopyEx(second, null, null, angles.second, null, SDL_FLIP_NONE);
    }

    private Texture hour;
    private Texture minute;
    private Texture second;
}

unittest
{
    import std.exception : assertNotThrown;

    import derelict.sdl2.sdl : DerelictSDL2, SDL_INIT_EVERYTHING, SDL_Init, SDL_Quit;

    import desktopdial.sdl.window : Window;

    DerelictSDL2.load;

    if (SDL_Init(SDL_INIT_EVERYTHING) == 0)
    {
        scope(exit) SDL_Quit();

        auto window = Window(`Alice`, 77, 16);

        auto renderer = Renderer(window);

        immutable visual = HandsVisual(
                HandVisual(0, 1, 6, SDL_Color(0, 6, 7), SDL_Color(0, 1, 7)),
                HandVisual(7, 0, 6, SDL_Color(1, 0, 7), SDL_Color(6, 0, 7)),
                HandVisual(7, 1, 0, SDL_Color(1, 6, 0), SDL_Color(6, 1, 0)));

        assertNotThrown(Hands(renderer, visual));
    }
    else
    {
        import std.stdio : writeln;

        writeln(__FILE__ ~ `: The test of class Hands was disable.`);
    }
}

struct HandsVisual
{
    HandVisual hour;
    HandVisual minute;
    HandVisual second;
}

struct HandVisual
{
    ushort width;
    ushort longer;
    ushort shorter;

    SDL_Color color;
    SDL_Color alpha;
}

private struct HandAngles
{
    double hour;
    double minute;
    double second;
}

private Texture drawHand(ref Renderer renderer, in HandVisual visual)
{
    int width, height;

    renderer.SDL_GetRendererOutputSize(&width, &height);

    auto surface = Surface(width, height);

    immutable rect = SDL_Rect(
            width / 2 - visual.width / 2,
            height / 2 - visual.longer,
            visual.width,
            visual.longer + visual.shorter);

    surface.drawRect(rect, visual.color, visual.alpha);

    return Texture(renderer, surface);
}

private HandAngles calcAngles(in SysTime time) nothrow @safe
{
    immutable second = time.second + time.fracSecs.total!`msecs` / 1000.0;
    immutable minute = time.minute + second / 60.0;
    immutable hour = time.hour + minute / 60.0;

    return HandAngles(30 * hour, 6 * minute, 6 * second);
}
