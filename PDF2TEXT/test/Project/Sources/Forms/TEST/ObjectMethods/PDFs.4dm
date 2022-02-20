$event:=FORM Event:C1606

Case of 
	: ($event.code=On Data Change:K2:15)
		
		Form:C1466.data.col:=process_pdf(Path to object:C1547(Self:C308->{Self:C308->}).name)
		
End case 