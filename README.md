![version](https://img.shields.io/badge/version-17%2B-3E8B93)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-plugin-PDF2TEXT-v2)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/4d-plugin-PDF2TEXT-v2/total)

# 4d-plugin-PDF2TEXT-v2
PDF text extractor based on [poppler](https://poppler.freedesktop.org).

XML version in [pdftoxml](https://github.com/miyako/4d-plugin-PDF2TEXT-v2/tree/pdftoxml) branch

## PDF Get text

```4d
text:=PDF Get text(pdf;options)
```

|パラメーター|データ型|説明|
|-|-|-|
|pdf|BLOB||
|options|Object||
|options.start|Number|このページから (`1`)|
|options.end|Number|このページまで (`1`)|
|options.password|Text|パスワード|
|options.method|Text|コールバックメソッド|
|options.version|Number|コールバックメソッドの仕様|
|text|Collection||

### コールバックメソッド v1

```4d
#DECLARE(position:Integer;total:Integer;page:Integer;text:Text)->abort:Boolean
```

### コールバックメソッド v2

```4d
#DECLARE(info:Object)->abort:Boolean
```

|パラメーター|データ型|説明|
|-|-|-|
|info|Object||
|info.position|Number||
|info.total|Number||
|info.page|Number||
|info.text|Text||
