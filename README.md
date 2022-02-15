# 4d-plugin-PDF2TEXT-v2
PDF text extractor based on [poppler](https://poppler.freedesktop.org).

### pdftoxml

based on poppler/utils/pdftohtml.cc

## PDF to XML

```4d
xml:=PDF to XML(pdf;options)
```

|パラメーター|データ型|説明|
|-|-|-|
|pdf|BLOB||
|options|Object||
|options.first|Number|`-f` このページから (`1`)|
|options.last|Number|`-l` このページまで (`0`)|
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
* `-dataurls`
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
