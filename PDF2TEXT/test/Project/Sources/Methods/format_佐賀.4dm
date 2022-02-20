//%attributes = {"invisible":true}
$format:=New object:C1471("name"; "佐賀")
$format.top:=70  //読み取りエリアの上端
$format.columns:=12

$format.事業所名:=2
$format.所在地:=3
$format.電話番号:=4

$format.PCR検査:=5
$format.抗原定性検査:=6
$format.店舗内検査:=7
$format.ドライブスルー検査:=8

$format.日時:=10
$format.特記事項:=11

$formatsFolder:=Folder:C1567(fk resources folder:K87:11).folder("formats")
$formatsFolder.create()

$formatsFolder.file("佐賀.json").setText(JSON Stringify:C1217($format; *))