DesktopDial
===

![DesktopDial](https://github.com/masaniwasdp/Screenshots/blob/master/DesktopDial.png)

デスクトップ上で動作する時計盤です。

## 概要
デスクトップ上で現在時刻を表示する時計盤のアプリケーションです。
時計盤は常に最前面に表示されます。

## 依存
+ [dmd](https://dlang.org/download.html#dmd)
+ [dub](https://code.dlang.org/download.html)

## インストール

``` bash
$ cd ~
$ git clone https://github.com/masaniwasdp/DesktopDial.git
$ cd DesktopDial
$ dub --build=release
```

## 実行

``` bash
$ cd ~/DesktopDial
$ bin/desktopdial [path]
```

+ path: 設定ファイルのパスです。省略時はbin/res/DialDefinition.jsonとなります。

## アンインストール

``` bash
$ cd ~
$ rm -rf DesktopDial
```

## ライセンス
[MITライセンス](https://github.com/masaniwasdp/DesktopDial/blob/master/Licence.txt)が適用されます。

## 作者
+ masaniwa