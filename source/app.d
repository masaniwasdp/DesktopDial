import desktopdial.app : App;
import std.experimental.logger : critical;

void main(string[] args)
{
    try
    {
        App(args.length < 2 ? null : args[1]).run;
    }
    catch (Exception e)
    {
        e.msg.critical;
    }
}
