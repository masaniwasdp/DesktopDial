/**
  Rendas dial-horloĝon.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.dial;

import desktopdial.parts.graphic : Graphic;
import desktopdial.parts.hands : HandDesigns, Hands;
import desktopdial.parts.symbols : SymbolDesigns, Symbols;
import desktopdial.parts.types : Color, Size;
import std.datetime : SysTime;

/**
  Dial-horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
package struct Dial
{
    /**
      Konstruas horloĝon.

      Params:
        design = Dezajno de dial-horloĝo.

      Throws:
        sdlraii.SDL_Exception Kiam konstruado malsukcesas.
     */
    this(in DialDesign design)
    {
        graphic_ = Graphic(design.size, design.color);

        hands_ = Hands(graphic_.context, design.hands);

        symbols_ = Symbols(graphic_.context, design.symbols);
    }

    this(this) @disable;

    /**
      Rendas la horloĝon en fenestro.

      Params:
        time = Tempo montrota en la horloĝo.

      Throws:
        sdlraii.SDL_Exception Kiam malsukcesas rendi.
     */
    void render(in SysTime time)
    {
        graphic_.render(() {
            symbols_.draw();

            hands_.draw(time);
        }());
    }

    /* Grafika kunteksto. */
    private Graphic graphic_;

    /* Manoj de horloĝo. */
    private Hands hands_;

    /* Simboloj de horloĝo. */
    private Symbols symbols_;
}

/** Dezajno de dial-horloĝo. */
package struct DialDesign
{
    /** Grandeco de fenestro. */
    Size size;

    /** Korolo de fenestro. */
    Color color;

    /** Dezajno de manoj. */
    HandDesigns hands;

    /** Dezajno de simboloj. */
    SymbolDesigns symbols;
}
