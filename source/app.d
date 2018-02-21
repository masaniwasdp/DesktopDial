import derelict.sdl2.sdl;
import desktopdial.app : App;
import desktopdial.graph.sdl.exception : SDLException;
import std.conv : ConvOverflowException;
import std.file : FileException, thisExePath;
import std.path : buildPath, dirName;
import std.stdio : StdioException, writeln;
import std.utf : UTFException;
import stdx.data.json : JSONException;

void main(string[] args)
{
    DerelictSDL2.load;

    if (SDL_Init(SDL_INIT_EVERYTHING) < 0)
    {
        return writeln(`Couldn't initialize the graphic library.`);
    }

    scope(exit) SDL_Quit();

    immutable path = args.length > 1
        ? args[1]
        : buildPath(thisExePath.dirName, directory, file);

    App(path)
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
        expression;
    }
    catch (E)
    {
        message.writeln;
    }
}
