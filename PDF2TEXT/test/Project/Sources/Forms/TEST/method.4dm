$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		Form:C1466.PDFs:=OBJECT Get pointer:C1124(Object named:K67:5; "PDFs")
		
		$PDFs:=Folder:C1567(fk resources folder:K87:11).folder("PDF").files()
		
		For each ($file; $PDFs)
			
			APPEND TO ARRAY:C911(Form:C1466.PDFs->; $file.fullName)
			
		End for each 
		
		Form:C1466.事業所名:=OBJECT Get pointer:C1124(Object named:K67:5; "Column1")
		Form:C1466.所在地:=OBJECT Get pointer:C1124(Object named:K67:5; "Column2")
		Form:C1466.電話番号:=OBJECT Get pointer:C1124(Object named:K67:5; "Column3")
		Form:C1466.PCR検査:=OBJECT Get pointer:C1124(Object named:K67:5; "Column4")
		Form:C1466.抗原定性検査:=OBJECT Get pointer:C1124(Object named:K67:5; "Column5")
		Form:C1466.店舗内検査:=OBJECT Get pointer:C1124(Object named:K67:5; "Column6")
		Form:C1466.ドライブスルー検査:=OBJECT Get pointer:C1124(Object named:K67:5; "Column7")
		Form:C1466.日時:=OBJECT Get pointer:C1124(Object named:K67:5; "Column8")
		Form:C1466.特記事項:=OBJECT Get pointer:C1124(Object named:K67:5; "Column9")
		
End case 