//%attributes = {"invisible":true}
C_OBJECT:C1216($1; $file; $2; $format)

$file:=$1
$format:=$2

$options:=New object:C1471
$options.noRoundedCoordinates:=False:C215
$options.rawLineBreak:=True:C214
$options.ignoreHorizontalAlign:=True:C214
$options.ignoreFont:=True:C214

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
												//If ($columns.length#0)
												$columns.push(Null:C1517)
												//End if 
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