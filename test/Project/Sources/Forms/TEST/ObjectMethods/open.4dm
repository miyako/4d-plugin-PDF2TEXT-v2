If (Form event code:C388=On Clicked:K2:4)
	
	$name:=Form:C1466.GetName()
	
	OPEN URL:C673(Folder:C1567(fk resources folder:K87:11).folder("PDF").file($name+".pdf").platformPath)
	
End if 