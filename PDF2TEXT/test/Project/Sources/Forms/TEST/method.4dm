$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		Form:C1466.PDFs:=OBJECT Get pointer:C1124(Object named:K67:5; "PDFs")
		
		$PDFs:=Folder:C1567(fk resources folder:K87:11).folder("PDF").files()
		
		For each ($file; $PDFs)
			
			APPEND TO ARRAY:C911(Form:C1466.PDFs->; $file.fullName)
			
		End for each 
		
		Form:C1466.data:=New object:C1471("col"; Null:C1517; "pos"; Null:C1517; "item"; Null:C1517; "sel"; Null:C1517)
		
End case 