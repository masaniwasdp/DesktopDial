import desktopdial.app : App;
import std.experimental.logger : critical;

void main(string[] args)
{
    try
    {
        scope app = new App(args.length < 2 ? null : args[1]);

        app.run;
    }
    catch (Exception e)
    {
        e.msg.critical;
    }
}
