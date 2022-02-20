//%attributes = {}
$file:=Folder:C1567(fk desktop folder:K87:19).file("佐賀.pdf")

$data:=parse_pdf($file; $format)

SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($data; *))