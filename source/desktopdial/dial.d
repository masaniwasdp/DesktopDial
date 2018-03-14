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

    private Graphic graphic_; // Grafika kunteksto.

    private Hands hands_; // Manoj de horloĝo.

    private Symbols symbols_; // Simboloj de horloĝo.
}

/** Dezajno de dial-horloĝo. */
package struct DialDesign
{
    Size size; /// Grandeco de fenestro.

    Color color; /// Korolo de fenestro.

    HandDesigns hands; /// Dezajno de manoj.

    SymbolDesigns symbols; /// Dezajno de simboloj.
}
