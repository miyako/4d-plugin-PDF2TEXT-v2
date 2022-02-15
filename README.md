# 4d-plugin-PDF2TEXT-v2
PDF text extractor based on [poppler](https://poppler.freedesktop.org).

based on poppler/utils/pdftohtml.cc `PDFDocFactory` API.

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
|xml|BLOB|エンコーディングは固定値 (`UTF-8`)|

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
* `-fmt`
 
### 論考

Popplerはレンダリングエンジンであるので，テキストは論理的なブロックではなく，絶対値で返される。
