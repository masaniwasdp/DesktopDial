module desktopdial.app;

import derelict.sdl2.sdl;
import desktopdial.graph.dial : Dial, DialVisual;
import jsonserialized.deserialization : deserializeFromJSONValue;
import std.datetime : Clock;
import std.file : readText;
import std.stdio : writeln;
import stdx.data.json : toJSONValue;

struct App
{
    this(in string path)
    {
        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, quality);
        SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, screensaver);

        immutable visual = path
            .readText
            .toJSONValue
            .deserializeFromJSONValue!DialVisual;

        dial = Dial(visual);
    }

    this(this) @disable;

    void run()
    {
        while (continuation)
        {
            tuneFPS;
            handleEvents;
            update;
        }
    }

    private void tuneFPS() nothrow @nogc
    {
        immutable elapsed = SDL_GetTicks() - last;

        if (elapsed < interval) SDL_Delay(interval - elapsed);

        last = SDL_GetTicks();
    }

    private void handleEvents() nothrow @nogc
    {
        SDL_Event event = void;

        while (SDL_PollEvent(&event) == 1)
        {
            if (event.type == SDL_QUIT) continuation = false;
        }
    }

    private void update()
    {
        try
        {
            dial.draw(Clock.currTime);
        }
        catch (Exception)
        {
            writeln(`Couldn't get the current time.`);
        }
    }

    private auto continuation = true;

    private uint last;

    private Dial dial;
}

private enum quality = `liner`;

private enum screensaver = `1`;

private enum interval = 16;
