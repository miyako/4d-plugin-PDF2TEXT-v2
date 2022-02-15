# 4d-plugin-PDF2TEXT-v2
PDF text extractor based on [poppler](https://poppler.freedesktop.org).

### pdftoxml

based on poppler/utils/pdftohtml.cc


using `PDFDocFactory` API.

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
|options.imageFormat|Text|`-fmt` 画像形式 (`.png`) `.jpg`|
|options.scale|Number|`-zoom` 座標係数 (`.1.5`)|
|options.noRoundedCoordinates|Boolean|`-noroundcoord` 座標を丸めない (`false`)|
|options.wordBreakThreshold|Number|`-wbt` (`10`)|
|xml|BLOB||

#### 常に有効なオプション

* `-xml`
* `-v`
* `-q`
* `-c`
* `-hidden`
* `-noframes`
* `-noMerge`

#### 常に無効なオプション

* `-h`
* `-p`
* `-s`
* `-i`
* `-stdout`
* `-nodrm`
* `-fontfullname`
* `-dataurls`
