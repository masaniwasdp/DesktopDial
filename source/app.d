import derelict.sdl2.sdl : DerelictSDL2, SDL_INIT_EVERYTHING, SDL_Init, SDL_Quit;
import desktopdial.app : App;
import desktopdial.sdl.exception : SDLException;
import std.conv : ConvOverflowException;
import std.file : FileException, thisExePath;
import std.path : buildPath, dirName;
import std.stdio : StdioException, writeln;
import std.utf : UTFException;
import stdx.data.json : JSONException;

void main(string[] args)
{
    DerelictSDL2.load;

    if (SDL_Init(SDL_INIT_EVERYTHING) < 0) return writeln(`Couldn't initialize the graphic library.`);

    scope(exit) SDL_Quit();

    (args.length > 1 ? App(args[1]) : App(buildPath(thisExePath.dirName, directory, file)))
            .run
            .handle!FileException(`The setting file wasn't found.`)
            .handle!UTFException(`The setting file must be unicode encoding.`)
            .handle!JSONException(`The setting file was wrong format.`)
            .handle!ConvOverflowException(`The setting value was invalid.`)
            .handle!SDLException(`Couldn't initialize grahic objects.`)
            .handle!StdioException(`Couldn't write a message.`)
            .handle!Exception(`Couldn't get setting file path.`);
}

private enum directory = `resource`;

private enum file = `dialvisual.json`;

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
