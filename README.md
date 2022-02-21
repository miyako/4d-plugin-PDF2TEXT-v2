# 4d-plugin-PDF2TEXT-v2
PDF text extractor based on [poppler](https://poppler.freedesktop.org).

based on poppler/utils/pdftohtml.cc `PDFDocFactory` API.

### build notes on Windows

* Use Visual Studio 2017 or later

### build notes on macOS

* `CLANG_CXX_LANGUAGE_STANDARD` = `c++14`
* `CLANG_CXX_LIBRARY` = `libc++`

## PDF to XML

```4d
xml:=PDF to XML(pdf;options)
```

|パラメーター|データ型|説明|
|-|-|-|
|pdf|BLOB||
|options|Object||
|options.firstPage|Number|`-f` このページから (`1`)|
|options.lastPage|Number|`-l` このページまで (`0`)|
|options.ownerPassword|Text|`-opw` オーナーパスワード|
|options.userPassword|Text|`-upw` ユーザーパスワード|
|options.scale|Number|`-zoom` 拡大率 (`.1.0`) `0.5`⇢`3.0`|
|options.noRoundedCoordinates|Boolean|`-noroundcoord` 座標を丸めない (`true`)|
|options.wordBreakThreshold|Number|`-wbt` わかち書きの閾値 (`1`)|
|options.rawLineBreak|Boolean|`<br/>`の代わりに`\n`を出力する (`false`)|
|options.lineBreakThreshold|Number|改行の閾値 (`0.7`)|
|options.ignoreHorizontalAlign|Boolean|左揃えでなくても改行判定する (`false`)|
|options.ignoreFont|Boolean|改行の場合はフォントの違いを無視する (`false`)|
|options.ignoreBoldItalic|Boolean|`<b>` `<i>`タグを出力しない (`false`)|
|xml|BLOB|エンコーディングは固定値 (`UTF-8`)|

#### 常に有効なオプション

* `-xml`
* `-v`
* `-q`
* `-c`
* `-hidden`
* `-noframes`

#### 常に無効なオプション

* `-h`
* `-p`
* `-s`
* `-i`
* `-stdout`
* `-nodrm`
* `-fontfullname`
* `-dataurls`
* `-fmt`
* `-noMerge`
  
### 論考

Popplerはレンダリングエンジンであるので，テキストは論理的なブロックではなく，絶対値で返される。
