import std.conv : ConvOverflowException;
import std.datetime : Clock;
import std.file : FileException, readText, thisExePath;
import std.path : dirName, dirSeparator;
import std.stdio : writeln;
import std.utf : UTFException;

import derelict.sdl2.sdl :
    DerelictSDL2,
    SDL_Delay,
    SDL_Event,
    SDL_GetTicks,
    SDL_HINT_NO_SIGNAL_HANDLERS,
    SDL_HINT_RENDER_SCALE_QUALITY,
    SDL_HINT_VIDEO_ALLOW_SCREENSAVER,
    SDL_INIT_EVERYTHING,
    SDL_Init,
    SDL_PollEvent,
    SDL_QUIT,
    SDL_Quit,
    SDL_SetHint;

import jsonserialized.deserialization : deserializeFromJSONValue;
import stdx.data.json : JSONException, toJSONValue;

import desktopdial.graphic.dial : Dial, DialVisual;
import desktopdial.sdl.exception : SDLException;

void main(string[] args)
{
    DerelictSDL2.load;

    if (SDL_Init(SDL_INIT_EVERYTHING) < 0) return `Failed to initialize the graphic library.`.writeln;

    scope(exit) SDL_Quit();

    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, `liner`);
    SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, `1`);

    (args.length > 1 ? App(args[1]) : App(thisExePath.dirName ~ dirSeparator ~ resource))
            .run
            .handle!FileException(`The setting file wasn't found.`)
            .handle!UTFException(`The setting file must be unicode encoding.`)
            .handle!JSONException(`The setting file was wrong format.`)
            .handle!ConvOverflowException(`The setting value was invalid.`)
            .handle!SDLException(`Failed to initialize grahic objects.`)
            .handle!Exception(`Failed to get setting file path`);
}

private enum interval = 16;

private enum resource = `resource` ~ dirSeparator ~ `dialvisual.json`;

private struct App
{
    this(in string path)
    in
    {
        assert(path);
    }
    body
    {
        dial = Dial(path.readText.toJSONValue.deserializeFromJSONValue!DialVisual);
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

        if (elapsed < interval) (interval - elapsed).SDL_Delay;

        last = SDL_GetTicks();
    }

    private void handleEvents() nothrow @nogc
    {
        SDL_Event event;

        while ((&event).SDL_PollEvent == 1)
        {
            if (event.type == SDL_QUIT) continuation = false;
        }
    }

    private void update()
    {
        dial.draw(Clock.currTime).handle!Exception(`Failed to get the current time.`);
    }

    private auto continuation = true;

    private uint last;

    private Dial dial;
}

private void handle(E : Throwable)(lazy scope void expression, in string message)
{
    try
    {
        return expression;
    }
    catch (E)
    {
        message.writeln;
    }
}
