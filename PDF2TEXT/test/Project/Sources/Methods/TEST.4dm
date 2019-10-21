//%attributes = {}
$path:=Get 4D folder:C485(Current resources folder:K5:16)+"test1.pdf"
C_BLOB:C604($pdf)

DOCUMENT TO BLOB:C525($path;$pdf)

$o:=New object:C1471
$o.start:=1
  //$o.end:=3
$o.password:=""
$o.method:="CB"
  //$o.version:=1//old callback signature (long,long,long,text)

$pages:=PDF Get text ($pdf;$o)