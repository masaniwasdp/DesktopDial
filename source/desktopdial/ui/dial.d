/**
  Rendas dial-horloĝon.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.ui.dial;

import desktopdial.ui.units.graphic : Graphic;
import desktopdial.ui.units.hands : HandDesigns, Hands;
import desktopdial.ui.units.property : Color, Size;
import desktopdial.ui.units.symbols : SymbolDesigns, Symbols;
import sdlraii;
import std.datetime : SysTime;

/**
  Dial-horloĝo.

  Uzi tiojn postulas la SDL bibliotekon.
 */
struct Dial
{
    /**
      Konstruas dial-horloĝon.

      Params:
        design = Dezajno de dial-horloĝo.

      Throws:
        SDL_Exception Kiam konstruado malsukcesas.
     */
    this(in DialDesign design)
    {
        graphic_ = Graphic(design.size, design.color);

        hands_ = Hands(graphic_.context, design.hands);

        symbols_ = Symbols(graphic_.context, design.symbols);
    }

    this(this) @disable;

    /**
      Rendas la dial-horloĝon en la fenestro.

      Params:
        time = Tempo montrota en la dial-horloĝo.

      Throws:
        SDL_Exception Kiam malsukcesas rendi la dial-horloĝon.
     */
    void render(in SysTime time)
    {
        graphic_.render({
            symbols_.draw();

            hands_.draw(time);
        }());
    }

    /** Grafika kunteksto. */
    private Graphic graphic_;

    /** Manoj de horloĝo. */
    private Hands hands_;

    /** Simboloj de horloĝo. */
    private Symbols symbols_;
}

/** Dezajno de dial-horloĝo. */
struct DialDesign
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
