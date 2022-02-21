$event:=FORM Event:C1606

Case of 
	: ($event.code=On Data Change:K2:15)
		
		$data:=process_pdf(Path to object:C1547(Self:C308->{Self:C308->}).name)
		
		SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($data; *))
		
		COLLECTION TO ARRAY:C1562($data; \
			Form:C1466.事業所名->; "事業所名"; \
			Form:C1466.所在地->; "所在地"; \
			Form:C1466.電話番号->; "電話番号"; \
			Form:C1466.PCR検査->; "PCR検査"; \
			Form:C1466.抗原定性検査->; "抗原定性検査"; \
			Form:C1466.店舗内検査->; "店舗内検査"; \
			Form:C1466.ドライブスルー検査->; "ドライブスルー検査"; \
			Form:C1466.日時->; "日時"; \
			Form:C1466.特記事項->; "特記事項")
		
End case 