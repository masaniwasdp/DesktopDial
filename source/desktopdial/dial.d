module desktopdial.dial;

import desktopdial.graphic : Graphic;
import desktopdial.parts.hands : HandDesigns, Hands;
import desktopdial.parts.symbols : SymbolDesigns, Symbols;
import desktopdial.parts.types : Color, Size;
import sdlraii;
import std.datetime : SysTime;

package struct Dial
{
    this(in DialDesign design)
    {
        color_ = design.color;

        graphic_ = Graphic(design.size);

        hands_ = Hands(graphic_.obj, design.hands);

        symbols_ = Symbols(graphic_.obj, design.symbols);
    }

    this(this) @disable;

    void draw(in SysTime time)
    {
        SDL_Try(SDL_SetRenderDrawColor(graphic_.obj.ptr, color_.r, color_.g, color_.b, SDL_ALPHA_OPAQUE));

        SDL_Try(SDL_RenderClear(graphic_.obj.ptr));

        symbols_.draw();

        hands_.draw(time);

        SDL_RenderPresent(graphic_.obj.ptr);
    }

    private immutable Color color_;

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
