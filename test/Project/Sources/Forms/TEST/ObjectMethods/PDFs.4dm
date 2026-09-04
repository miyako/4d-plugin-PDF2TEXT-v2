$event:=FORM Event:C1606

Case of 
	: ($event.code=On Data Change:K2:15)
		
		$name:=Form:C1466.GetName()
		
		$file:=Folder:C1567(fk resources folder:K87:11).folder("PDF").file($name+".pdf")
		
		$format:=JSON Parse:C1218(Folder:C1567(fk resources folder:K87:11).folder("formats").file($name+".json").getText(); Is object:K8:27)
		
		$data:=parse_pdf($file; $format)
		
		OBJECT SET VISIBLE:C603(*; "Column@"; True:C214)
		
		COLLECTION TO ARRAY:C1562($data; \
			Form:C1466.事業所名->; "事業所名"; \
			Form:C1466.所在地->; "所在地"; \
			Form:C1466.電話番号->; "電話番号"; \
			Form:C1466.PCR検査->; "PCR検査"; \
			Form:C1466.抗原定性検査->; "抗原定性検査"; \
			Form:C1466.店舗内検査->; "店舗内検査"; \
			Form:C1466.ドライブスルー検査->; "ドライブスルー検査"; \
			Form:C1466.診療->; "診療"; \
			Form:C1466.検査->; "検査"; \
			Form:C1466.日時->; "日時"; \
			Form:C1466.特記事項->; "特記事項")
		
		$objects:=New object:C1471
		$objects.事業所名:="Column1"
		$objects.所在地:="Column2"
		$objects.電話番号:="Column3"
		$objects.PCR検査:="Column4"
		$objects.抗原定性検査:="Column5"
		$objects.店舗内検査:="Column6"
		$objects.ドライブスルー検査:="Column7"
		$objects.診療:="Column8"
		$objects.検査:="Column9"
		$objects.日時:="Column10"
		$objects.特記事項:="Column11"
		
		For each ($object; $objects)
			
			OBJECT SET VISIBLE:C603(*; $objects[$object]; $format[$object]#Null:C1517)
			
		End for each 
		
		OBJECT SET ENABLED:C1123(*; "open"; True:C214)
		
End case 