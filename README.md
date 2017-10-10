DesktopDial
===

![DesktopDial](https://masaniwasdp.github.io/DesktopDial/Screenshot.png)

デスクトップ上で動作する時計盤です。

## 概要
デスクトップ上で現在時刻を表示する時計盤のアプリケーションです。
X11環境では時計盤は常に最前面に表示されます。

## 依存
+ [SDL2.0.5](https://www.libsdl.org)

## ビルド

``` bash
$ cd ~
$ git clone https://github.com/masaniwasdp/DesktopDial.git
$ cd DesktopDial
$ dub --build=release
```

## 実行

``` bash
$ cd ~/DesktopDial
$ build/desktopdial [path]
```

+ `path`: 設定ファイルのパスです。省略時は`build/resource/dialvisual.json`となります。

## ライセンス
[MITライセンス](https://github.com/masaniwasdp/DesktopDial/blob/master/LICENCE)が適用されます。

## 作者
+ masaniwa
