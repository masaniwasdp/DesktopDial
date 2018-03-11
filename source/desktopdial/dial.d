module desktopdial.dial;

import desktopdial.parts.graphic : Graphic;
import desktopdial.parts.hands : HandDesigns, Hands;
import desktopdial.parts.symbols : SymbolDesigns, Symbols;
import desktopdial.parts.types : Color, Size;
import std.datetime : SysTime;

package struct Dial
{
    this(in DialDesign design)
    {
        graphic_ = Graphic(design.size, design.color);

        hands_ = Hands(graphic_.context, design.hands);

        symbols_ = Symbols(graphic_.context, design.symbols);
    }

    this(this) @disable;

    void render(in SysTime time)
    {
        graphic_.render(() {
            symbols_.draw();

            hands_.draw(time);
        }());
    }

    private Graphic graphic_;

    private Hands hands_;

    private Symbols symbols_;
}

package struct DialDesign
{
    Size size;

    Color color;

    HandDesigns hands;

    SymbolDesigns symbols;
}
