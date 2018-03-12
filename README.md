DesktopDial
===

[![Build Status](https://travis-ci.org/masaniwasdp/DesktopDial.svg?branch=master)](https://travis-ci.org/masaniwasdp/DesktopDial)

![DesktopDial](https://masaniwasdp.github.io/DesktopDial/Screenshot.png)

Montras la aktualan tempon en dial-horloĝo.

## Priskribo

La apliko montras la aktualan tempon en dial-horloĝo.
Ĉi tio ĉiam montriĝos en la fronto kiam vi uzas X11 medio.

## Dependeco
+ [SDL2.0.5](https://www.libsdl.org)

## Konstruaĵo

``` bash
$ cd ~
$ git clone https://github.com/masaniwasdp/DesktopDial.git --depth 1
$ cd DesktopDial
$ dub build --build release
```

## Ekzekuto

``` bash
$ cd ~/DesktopDial
$ build/desktopdial [path]
```

+ `path` estas la vojo al la agorda dosiero. La defaŭlta valoro estas `build/asset/dialdesign.json`.

## Permesiro
© 2018, masaniwa

La programaro estas licencita sub la [MIT](https://github.com/masaniwasdp/DesktopDial/blob/master/LICENCE).
