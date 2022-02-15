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
|options.start|Number|`-f` このページから (`1`)|
|options.end|Number|`-l` このページまで (`1`)|
|options.owner|Text|`-opw` オーナーパスワード|
|options.user|Text|`-upw` ユーザーパスワード|
|options.imageFormat|Text|`-fmt` 画像形式 (`.png`) `.jpg`|
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

* `-h` `-?` `-help` `--help`
* `-p`
* `-s`
* `-i`
* `-v`
* `-stdout`
* `-nodrm`
* `-fontfullname`
