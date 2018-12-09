/**
  Rendas dial-horloĝon en la fenestro.

  Authors:   masaniwa
  Copyright: 2018 masaniwa
  License:   MIT
 */
module desktopdial.view.dial;

import desktopdial.view.unit.graphic : Graphic;
import desktopdial.view.unit.hand : HandDesigns, Hands;
import desktopdial.view.unit.prop : Color, Size;
import desktopdial.view.unit.sign : SignDesigns, Signs;
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

      Params: design = Dezajno de dial-horloĝo.

      Throws: SDL_Exception Kiam konstruado malsukcesas.
     */
    this(in DialDesign design)
    {
        graphic = Graphic(design.size, design.back);

        hands = Hands(graphic.context, design.hands);

        signs = Signs(graphic.context, design.signs);
    }

    this(this) @disable;

    /**
      Rendas la dial-horloĝon en la fenestro.

      Params: time = Tempo montrota en la dial-horloĝo.

      Throws: SDL_Exception Kiam malsukcesas rendi la dial-horloĝon.
     */
    void render(in SysTime time)
    {
        graphic.render({
            signs.draw();

            hands.draw(time);
        }());
    }

    /** Grafika kunteksto. */
    private Graphic graphic;

    /** Manoj de horloĝo. */
    private Hands hands;

    /** Simboloj de horloĝo. */
    private Signs signs;
}

/** Dezajno de dial-horloĝo. */
struct DialDesign
{
    Size size; /// Grandeco de fenestro.

    Color back; /// Korolo de fenestro.

    HandDesigns hands; /// Dezajno de manoj.

    SignDesigns signs; /// Dezajno de simboloj.
}
