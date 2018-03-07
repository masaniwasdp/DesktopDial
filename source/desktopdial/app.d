module desktopdial.app;

import desktopdial.dial : Dial, DialDesign;
import jsonserialized.deserialization : deserializeFromJSONValue;
import sdlraii;
import std.datetime : Clock;
import std.exception : basicExceptionCtors;
import std.file : thisExePath, readText;
import std.path : buildPath, dirName;
import stdx.data.json : toJSONValue;

class AppException : Exception
{
    mixin basicExceptionCtors;
}

struct App
{
    this(in string path)
    {
        SDL_Initialize();

        dial_ = Dial(path.readDesignFile.parseDesign);
    }

    this(this) @disable;

    ~this()
    {
        SDL_Quit();
    }

    void run()
    {
        while (continuation_)
        {
            adjust;
            handle;
            update;
        }
    }

    private void adjust() nothrow @nogc
    {
        immutable elapsed = SDL_GetTicks() - last_;

        if (elapsed < interval) SDL_Delay(interval - elapsed);

        last_ = SDL_GetTicks();
    }

    private void handle() nothrow @nogc
    {
        SDL_Event event = void;

        while (SDL_PollEvent(&event) == 1)
        {
            if (event.type == SDL_QUIT) continuation_ = false;
        }
    }

    private void update()
    {
        try
        {
            dial_.draw(Clock.currTime);
        }
        catch (Exception e)
        {
            throw new AppException(`Couldn't update the clock.`, e);
        }
    }

    private auto continuation_ = true;

    private uint last_;

    private Dial dial_;
}

private enum interval = 16;

private enum directory = `asset`;

private enum filename = `dialdesign.json`;

private void SDL_Initialize()
{
    try
    {
        DerelictSDL2.load;

        SDL_Try(SDL_Init(SDL_INIT_EVERYTHING));
    }
    catch (SDL_Exception e)
    {
        throw new AppException(`Couldn't initialize the SDL library.`, e);
    }
    catch (Exception e)
    {
        throw new AppException(`Couldn't load the SDL library.`, e);
    }

    SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, `liner`);

    SDL_SetHint(SDL_HINT_VIDEO_ALLOW_SCREENSAVER, `1`);
}

private string readDesignFile(in string path) @safe
{
    try
    {
        immutable file = path
            ? path
            : buildPath(thisExePath.dirName, directory, filename);

        return file.readText;
    }
    catch (Exception e)
    {
        throw new AppException(`Couldn't read the design file.`, e);
    }
}

private DialDesign parseDesign(in string text) @safe
{
    try
    {
        return text
            .toJSONValue
            .deserializeFromJSONValue!DialDesign;
    }
    catch (Exception e)
    {
        throw new AppException(`Couldn't parse the design.`, e);
    }
}
