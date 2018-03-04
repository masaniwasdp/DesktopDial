import desktopdial.app : App, GraphicInitException, ReadingDesignException;
import std.experimental.logger : critical;

void main(string[] args)
{
    try
    {
        App(args.length > 1 ? args[1] : null).run;
    }
    catch (GraphicInitException)
    {
        critical(`Failed to initialize the SDL library.`);
    }
    catch (ReadingDesignException)
    {
        critical(`Failed to read the design of the dial.`);
    }
}
