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
