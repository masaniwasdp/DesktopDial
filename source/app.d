import desktopdial.app : App;
import std.experimental.logger : critical;

void main(string[] args)
{
    immutable path = args.length < 2 ? null : args[1];

    try
    {
        App(path).run;
    }
    catch (Throwable e)
    {
        e.msg.critical;
    }
}
