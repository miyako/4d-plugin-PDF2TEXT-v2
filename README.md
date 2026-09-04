![version](https://img.shields.io/badge/version-17%2B-3E8B93)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-plugin-PDF2TEXT-v2)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/4d-plugin-PDF2TEXT-v2/total)

# 4d-plugin-PDF2TEXT-v2

PDF2TEXT extracts the text and layout of a PDF document as XML. It's built on [poppler](https://poppler.freedesktop.org)'s `pdftohtml` converter (specifically its `PDFDocFactory`/`HtmlOutputDev` machinery), running entirely in-process against a `BLOB` you supply — no file paths, no shelling out to a command-line tool. The result is a `BLOB` of UTF-8 XML text describing every page: text runs, their pixel positions, fonts, and sizes, in the format `pdftohtml -xml` would produce. Poppler is a rendering engine, not a document-structure parser, so the XML gives you absolute positions, not logical blocks (headings, paragraphs, table cells) — reconstructing structure from position is left to your own code (see the [Reference helper methods](#reference-helper-methods) below for a worked example of exactly that).

> **Command name is unconfirmed.** This doc's `## PDF to XML` heading follows the plugin's published `README.md`. However, the plugin's own sample method (`parse_pdf.4dm`) calls the command as `PDF Get XML` instead. Without `manifest.json` there's no way to confirm which name is actually registered — check your installed method list (or the plugin's Design Language Reference entry) before relying on either spelling.

## Summary

| Command | Returns | Purpose |
|-|-|-|
| [`PDF to XML`](#pdf-to-xml) | `BLOB` | Convert a PDF (as a `BLOB`) to an XML description of its pages' text and layout. |

**Platforms:** macOS (Intel & Apple Silicon), Windows 64-bit.

---

## Requirements & platform notes

- The plugin exposes exactly one command. There is no separate "info"/"page count" command — page count and other document metadata aren't returned; only the XML markup is.
- `options` (parameter 2) is entirely optional, and every one of its fields is independently optional with its own default — you can omit the whole object, or set only the fields you care about.
- **Failure is silent, not a 4D error.** If `pdf` is empty, if the PDF can't be parsed (wrong/missing password, corrupt file), or if the plugin can't write to its own temp folder, the command returns an **empty `BLOB`** (`BLOB size` = 0). Nothing is thrown or logged — always check the result's size before trying to parse it as XML, exactly as the plugin's own sample does (see the [Error handling](#error-handling--troubleshooting) section).
- Output encoding is fixed at UTF-8 — there's no option to change it.
- `options.scale` and `options.firstPage`/`options.lastPage` are silently clamped to valid ranges rather than raising an error on out-of-range input (details in the command section below).
- `options.imageFormat` is accepted without error but currently has **no effect** on the returned XML in this build — see the caveat under [Description](#description) below. Don't rely on it to change output behavior.
- No behavioral differences between macOS and Windows were found in how this command processes input or shapes its output — the platform branching in the source is all internal (temp-file/UUID handling), not user-visible.

---

## PDF to XML

### Syntax

```4d
xml:=PDF to XML(pdf;options)
```

| Parameter | Type | Description |
|-|-|-|
| `pdf` | BLOB | The raw bytes of a PDF file. Required — if this is empty, the command returns an empty `BLOB` rather than raising an error. |
| `options` | Object | Optional. See the fields below; omit entirely to use every default. |
| `Result` | BLOB | UTF-8-encoded XML markup describing the PDF's pages. Empty (`BLOB size` = 0) if `pdf` is empty or the PDF fails to parse. |

### `options` object

| Property | Type | Default | Description |
|-|-|-|-|
| `firstPage` | Number | `1` | First page to include. Values below `1` are silently clamped to `1`. |
| `lastPage` | Number | `0` | Last page to include. `0` (or any value `< 1` or greater than the document's actual page count) means "the document's last page." If `lastPage` ends up before `firstPage`, `firstPage` is pulled back to match `lastPage`. |
| `ownerPassword` | Text | *(empty)* | Owner password for an encrypted PDF. |
| `userPassword` | Text | *(empty)* | User password for an encrypted PDF. |
| `scale` | Number | `1.0` | Rendering scale, silently clamped to the range `0.5`–`3.0`. Higher values increase the precision of reported text/image coordinates (and the size of any embedded raster images) at the cost of processing time. |
| `noRoundedCoordinates` | Boolean | `true` | When `true`, coordinates are reported at full precision instead of rounded to whole pixels. |
| `wordBreakThreshold` | Number | `1` | Threshold used to decide where word breaks occur when reconstructing text runs. |
| `rawLineBreak` | Boolean | `false` | When `true`, line breaks in the output are plain `\n` characters instead of `<br/>` tags. |
| `lineBreakThreshold` | Number | `0.7` | Vertical-gap threshold used to decide whether two text runs are on separate lines. |
| `ignoreHorizontalAlign` | Boolean | `false` | When `true`, a line break can be inferred even when the next run isn't left-aligned with the previous one. |
| `ignoreFont` | Boolean | `false` | When `true`, a font change between two adjacent runs is not by itself treated as a line break. |
| `ignoreBoldItalic` | Boolean | `false` | When `true`, bold/italic differences are not reflected as `<b>`/`<i>` tags in the output. |
| `horizontalBreakThreshold` | Number | `0.7` | Horizontal-gap threshold used in the same line-reconstruction heuristic as `lineBreakThreshold`. Not listed in the plugin's published `README.md`, but present and functional in the source. |
| `imageFormat` | Text | — | Accepted (`".jpg"`/`".jpeg"` vs. anything else) with no error, but the parsed value is **not currently consumed anywhere** in the plugin — verified directly from source. Setting it has no observable effect on the returned XML as of this build. |

### Description

The command writes `pdf` out to a temporary file (a fresh, randomly-named file per call — nothing is cached or reused between calls), opens it with poppler, and if the document parses successfully (`ownerPassword`/`userPassword` are tried if the PDF is encrypted), renders `firstPage` through `lastPage` through poppler's HTML/XML output device and reads the resulting XML back into the returned `BLOB`. If the document doesn't parse at all — wrong password, corrupt file — you get an empty `BLOB`, not an error.

`noRoundedCoordinates`, `wordBreakThreshold`, `lineBreakThreshold`, `horizontalBreakThreshold`, `ignoreHorizontalAlign`, `ignoreFont`, and `ignoreBoldItalic` all tune the same underlying problem: poppler reports individual glyph positions, and these options control the heuristics used to group them back into words, lines, and styled runs. The defaults match poppler's own `pdftohtml -xml` defaults; you generally only need to touch these if the extracted line/column structure looks wrong for a particular PDF's layout (the plugin's own sample, below, turns off `noRoundedCoordinates` and turns on the three `ignore*`/`rawLineBreak` flags to get more forgiving column reconstruction for tabular data).

`scale` doesn't change the page's logical content — only the coordinate precision (and, incidentally, the size of any embedded raster images poppler emits). It corresponds to poppler's `-zoom`.

**On both platforms**, the command uses the OS temp folder and a fresh random file name per call; nothing is written to a predictable or shared location, and nothing is left behind for you to clean up (the plugin manages its own temp files internally, on both platforms).

### Example

From the plugin's own sample method (`parse_pdf.4dm`):

```4d
//%attributes = {"invisible":true}
C_OBJECT:C1216($1; $file; $2; $format)

$file:=$1
$format:=$2

$options:=New object:C1471
$options.noRoundedCoordinates:=False:C215
$options.rawLineBreak:=True:C214
$options.ignoreHorizontalAlign:=True:C214
$options.ignoreFont:=True:C214
$options.ignoreBoldItalic:=True:C214

C_COLLECTION:C1488($data)
$data:=New collection:C1472

C_BLOB:C604($XML; $PDF)

$PDF:=$file.getContent()

$XML:=PDF Get XML($PDF; $options)

SET TEXT TO PASTEBOARD:C523(Convert to text:C1012($XML; "utf-8"))

If (BLOB size:C605($XML)#0)
    C_LONGINT:C283($intValue)
    C_TEXT:C284($stringValue)
    $dom:=DOM Parse XML variable:C720($XML)
    If (OK=1)
        $pdf2xml:=DOM Find XML element:C864($dom; "/pdf2xml")
        If (OK=1)
            ARRAY TEXT:C222($pages; 0)
            $page:=DOM Find XML element:C864($pdf2xml; "pdf2xml/page"; $pages)
            If (OK=1)
                For ($i; 1; Size of array:C274($pages))
                    $page:=$pages{$i}
                    DOM GET XML ATTRIBUTE BY NAME:C728($page; "number"; $intValue)
                    $datum:=New object:C1471("page"; $intValue; "rows"; New collection:C1472)
                    DOM GET XML ATTRIBUTE BY NAME:C728($page; "width"; $intValue)
                    $left:=$intValue  //start with page width=right
                    $data.push($datum)
                    ARRAY TEXT:C222($texts; 0)
                    $text:=DOM Find XML element:C864($page; "page/text"; $texts)
                    C_OBJECT:C1216($column)
                    For ($ii; 1; Size of array:C274($texts))
                        $text:=$texts{$ii}
                        DOM GET XML ATTRIBUTE BY NAME:C728($text; "top"; $intValue)
                        If ($intValue>=$format.top)
                            $column:=New object:C1471("top"; $intValue)
                            DOM GET XML ATTRIBUTE BY NAME:C728($text; "left"; $intValue)
                            If ($left>$intValue)
                                //new line
                                $columns:=New collection:C1472
                                $datum.rows.push($columns)
                            End if 
                            $left:=$intValue
                        Else 
                            CLEAR VARIABLE:C89($column)
                        End if 
                        If ($column#Null:C1517)
                            
                            DOM GET XML ATTRIBUTE BY NAME:C728($text; "left"; $intValue)
                            $column.left:=$intValue
                            
                            //fill empty cells
                            If ($format.left#Null:C1517)
                                $l:=1
                                C_VARIANT:C1683($value)
                                For each ($value; $format.left)
                                    If ($value#Null:C1517)
                                        If ($column.left>$value)
                                            If ($l>$columns.length)
                                                $columns.push(Null:C1517)
                                            End if 
                                        End if 
                                    End if 
                                    $l:=$l+1
                                End for each 
                            End if 
                            
                            DOM GET XML ATTRIBUTE BY NAME:C728($text; "height"; $intValue)
                            $column.height:=$intValue
                            DOM GET XML ATTRIBUTE BY NAME:C728($text; "width"; $intValue)
                            $column.width:=$intValue
                            DOM GET XML ELEMENT VALUE:C731($text; $stringValue)
                            $column.value:=$stringValue
                            
                            $columns.push($column)
                        End if 
                    End for 
                End for   //pages
            End if 
        End if 
    End if 
    DOM CLOSE XML:C722($dom)
End if 

$0:=$data.reduce("reduce_pdf"; New collection:C1472; $format)
```

A minimal call with no options, just checking for success:

```4d
C_BLOB:C604($pdf; $xml)

$pdf:=Document to blob:C1024("/RESOURCES/sample.pdf")

$xml:=PDF to XML($pdf; New object:C1471)

If (BLOB size:C605($xml)#0)
    ALERT:C41("Got "+String:C10(BLOB size:C605($xml))+" bytes of XML")
Else 
    ALERT:C41("PDF could not be parsed")
End if 
```

Restricting to a page range and password-protected input:

```4d
C_OBJECT:C1216($options)
$options:=New object:C1471
$options.firstPage:=2
$options.lastPage:=4
$options.userPassword:="secret"

$xml:=PDF to XML($pdf; $options)
```

---

## Reference helper methods

These aren't plugin commands — they're the project methods the plugin's own author ships alongside it to turn the raw XML `BLOB` into something directly usable (page → row → column objects). Included because reconstructing this from scratch is exactly the non-trivial part `pdftohtml`'s flat, position-only XML leaves to you.

**`Reduce_pdf ( object ; collection ; object ) → Collection`** — the reducer function called by `$data.reduce("reduce_pdf"; ...)` inside `parse_pdf.4dm`, one call per accumulated page/row object. It maps each row's raw columns onto named fields (`$format`'s column-index map), stitches multi-line "annotation" text back onto the correct preceding row when a `$format.annotation` mapping is supplied, and folds consecutive rows lacking a primary key column (`事業所名` in the source's own sample data) into whichever row eventually supplies one — a common pattern for tabular PDF data.

```4d
//%attributes = {"invisible":true}
C_OBJECT:C1216($1; $2; $format; $value)
C_COLLECTION:C1488($accumulator)

$accumulator:=$1.accumulator
$format:=$2

$value:=$1.value

C_TEXT:C284($stringValue)
C_LONGINT:C283($i)

$columnNames:=New collection:C1472("事業所名"; "所在地"; "電話番号"; "PCR検査"; "抗原定性検査"; "店舗内検査"; "ドライブスルー検査"; "診療"; "検査"; "日時"; "特記事項")

C_COLLECTION:C1488($row)

$事業所なし:=New collection:C1472

$annotations:=False:C215

For each ($row; $value.rows)
    
    $object:=New object:C1471
    
    $i:=0
    
    For each ($column; $row)
        
        If ($column#Null:C1517)
            
            $stringValue:=$column.value
            
            For each ($columnName; $columnNames)
                If ($format[$columnName]#Null:C1517)
                    If ($format[$columnName]=$i)
                        $object[$columnName]:=$stringValue
                    End if 
                End if 
            End for each 
            
            $object.top:=$column.top
            $object.left:=$column.left
            
        End if 
        
        $i:=$i+1
        
        If ($column#Null:C1517)
            
            If ($object.事業所名=Null:C1517)
                
                $obj:=$column
                
                If ($format.annotation#Null:C1517)
                    
                    $left:=$object.left
                    
                    $annotation:=False:C215
                    
                    For each ($column; $accumulator; -$value.rows.length+1) Until ($annotation)
                        If ($column.top>$obj.top)
                            For each ($columnName; $format.annotation)
                                If ($column[$columnName]#Null:C1517)
                                    If ($format.annotation[$columnName]<=$obj.left)
                                        If ($column[$columnName]#Null:C1517)
                                            $column[$columnName]:=$stringValue
                                            $annotation:=True:C214
                                        End if 
                                    End if 
                                End if 
                            End for each 
                        End if 
                    End for each 
                    
                    If ($annotation)
                        $annotations:=True:C214
                    End if 
                    
                End if 
                
            End if 
            
        End if 
        
    End for each 
    
    If ($annotations)
        CLEAR VARIABLE:C89($object)
    End if 
    
    If ($object#Null:C1517)
        
        Case of 
            : ($object.事業所名=Null:C1517)
                
                $事業所なし.push($object)
                
            : ($row.query("value != :1"; "").length=1)
                
                If ($事業所なし.length#0)
                    For each ($c; $事業所なし)
                        $c.事業所名:=$object.事業所名
                    End for each 
                    $事業所なし.clear()
                End if 
                
                CLEAR VARIABLE:C89($object)
                
        End case 
        
    End if 
    
    If ($object#Null:C1517)
        $accumulator.push($object)
    End if 
    
End for each 
```

`$format`'s exact shape (the `top`, `left`, and per-column-name-to-index mapping, plus the optional `annotation` map) is entirely specific to whatever PDF layout you're parsing — the values above (`事業所名`, `所在地`, etc.) are the source project's own sample column names and aren't part of the plugin's interface; treat this as a template for the *shape* of the reduction, not literal column names to reuse.

### Worked end-to-end example

Chaining the command with the two helpers above — this is exactly what `parse_pdf.4dm` itself does, generalized to any document:

```4d
C_OBJECT:C1216($format)
$format:=New object:C1471
$format.top:=0
$format.事業所名:=0
$format.所在地:=1

C_BLOB:C604($xml)
$xml:=PDF to XML(Document to blob:C1024("/RESOURCES/table.pdf"); New object:C1471)

If (BLOB size:C605($xml)#0)
    $rows:=parse_pdf(Document to blob:C1024("/RESOURCES/table.pdf"); $format)
    // $rows is now a Collection of reduced row objects, one per detected table row
Else 
    ALERT:C41("Could not extract text from PDF")
End if 
```

---

## Error handling & troubleshooting

- **Always check `BLOB size` before parsing the result.** An empty `BLOB` means the PDF didn't parse (bad/missing password, corrupt or non-PDF input) or `pdf` itself was empty — no 4D error is raised in any of these cases.
- **Confirm the exact command name before shipping.** This doc uses `PDF to XML` per the published `README.md`, but the plugin's own sample calls it `PDF Get XML`. Check your installed method list or Design Language Reference rather than trusting either name blindly.
- **`imageFormat` currently does nothing.** If you need JPEG vs. PNG control over embedded images, don't rely on this option in the current build — it's parsed but not wired to anything downstream.
- **Encrypted PDFs need the right password in the right field.** There's no single generic "password" field — pass `ownerPassword` and/or `userPassword` depending on which the PDF was encrypted with; an incorrect password produces the same silent "empty `BLOB`" result as a corrupt file, not a distinguishable error.
- **Out-of-range `firstPage`/`lastPage`/`scale` don't error — they clamp.** A `firstPage` below `1`, a `lastPage` of `0`/negative/beyond the real page count, or a `scale` outside `0.5`–`3.0` are all silently adjusted rather than rejected.
- **The output is `pdftohtml`-style XML, not HTML.** Parse it with `DOM Parse XML variable`/`DOM Find XML element` as the sample does — a generic HTML parser will not handle this markup correctly.
- **Coordinates are absolute pixel positions, not logical structure.** There's no notion of "paragraph" or "table cell" in the returned XML; reconstructing rows/columns from `top`/`left`/`width`/`height` attributes (as the helper methods above do) is expected, not a workaround.

---

## Quick reference

```4d
// Minimal call
C_BLOB:C604($pdf; $xml)
$pdf:=Document to blob:C1024("/RESOURCES/sample.pdf")
$xml:=PDF to XML($pdf; New object:C1471)
If (BLOB size:C605($xml)#0)
    // ... parse $xml with DOM Parse XML variable / DOM Find XML element
End if 

// With page range + password + layout-tuning options
C_OBJECT:C1216($options)
$options:=New object:C1471
$options.firstPage:=1
$options.lastPage:=0                    // 0 = last page of the document
$options.scale:=1.0                     // clamped to 0.5–3.0
$options.userPassword:=""
$options.ownerPassword:=""
$options.noRoundedCoordinates:=True:C214
$options.rawLineBreak:=False:C215
$options.ignoreHorizontalAlign:=False:C215
$options.ignoreFont:=False:C215
$options.ignoreBoldItalic:=False:C215
$options.wordBreakThreshold:=1
$options.lineBreakThreshold:=.7
$options.horizontalBreakThreshold:=.7   // undocumented in README; functional
// $options.imageFormat is accepted but has no effect in this build

$xml:=PDF to XML($pdf; $options)
```
