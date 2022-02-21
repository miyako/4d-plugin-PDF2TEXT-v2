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

$事業所なし:=New collection:C1472

For each ($row; $value.rows)
	
	Case of 
		: ($row.count()-$row.query("value == :1"; "").length=0)
			//休止中
		Else 
			
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
					
				End if 
				
				$i:=$i+1
				
			End for each 
			
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
				Else 
			End case 
			
			If ($object#Null:C1517)
				$accumulator.push($object)
			End if 
			
	End case 
	
End for each 
