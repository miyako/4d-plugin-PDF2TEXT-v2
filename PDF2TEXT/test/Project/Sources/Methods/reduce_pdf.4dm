//%attributes = {"invisible":true}
C_OBJECT:C1216($1; $2; $format; $value; $row)
C_COLLECTION:C1488($accumulator)

$accumulator:=$1.accumulator
$format:=$2

$value:=$1.value

C_TEXT:C284($stringValue)
C_LONGINT:C283($i)

$columnNames:=New collection:C1472("事業所名"; "所在地"; "電話番号"; "PCR検査"; "抗原定性検査"; "店舗内検査"; "ドライブスルー検査"; "日時"; "特記事項")

C_COLLECTION:C1488($columns)
C_COLLECTION:C1488($row)

For each ($row; $value.rows)
	
	$object:=New object:C1471
	
	$i:=0
	
	For each ($column; $row)
		
		$stringValue:=$column.value
		
		For each ($columnName; $columnNames)
			If ($format[$columnName]#Null:C1517)
				If ($format[$columnName]=$i)
					$object[$columnName]:=$stringValue
				End if 
			End if 
		End for each 
		
		$i:=$i+1
		
	End for each 
	
	$accumulator.push($object)
	
End for each 
