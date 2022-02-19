//%attributes = {}
$file:=Folder:C1567(fk desktop folder:K87:19).file("佐賀.pdf")

$options:=New object:C1471
$options.noRoundedCoordinates:=False:C215
$options.rawLineBreak:=True:C214


var $XML; $PDF : Blob

$PDF:=$file.getContent()

$XML:=PDF Get XML($PDF; $options)

If (BLOB size:C605($XML)#0)
	
	$dom:=DOM Parse XML variable:C720($XML)
	
	$t:=""
	
	DOM EXPORT TO VAR:C863($dom; $t)
	
	SET TEXT TO PASTEBOARD:C523($t)
	
	DOM CLOSE XML:C722($dom)
	
End if 