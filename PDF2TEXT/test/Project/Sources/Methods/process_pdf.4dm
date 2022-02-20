//%attributes = {"invisible":true}
C_TEXT:C284($1; $name)
C_COLLECTION:C1488($0)

$name:=$1

$file:=Folder:C1567(fk resources folder:K87:11).folder("PDF").file($name+".pdf")

$format:=JSON Parse:C1218(Folder:C1567(fk resources folder:K87:11).folder("formats").file($name+".json").getText(); Is object:K8:27)

$0:=parse_pdf($file; $format)