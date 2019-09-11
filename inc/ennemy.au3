; Defines helper methods to get information about the ENNEMY

Func ennemyHealth()
   Return getPercentageFromPixel(2, 0) * 100
EndFunc

Func ennemyMana()
   Return getPercentageFromPixel(2, 1) * 100
EndFunc

Func ennemyTargeted()
   Return colorAtPositionMatches(1080, 611, 0xCC0000) Or colorAtPositionMatches(1080, 611, 0xCCC900)
EndFunc

Func ennemyIsDead()
   Return colorAtPositionMatches(1138, 631, 0xAB8D02)
EndFunc

Func ennemyIsElite()
   Return colorAtPositionMatches(1235, 593, 0xAA8A0B, 10) And colorAtPositionMatches(1317, 631, 0x32140A, 10)
EndFunc

Func ennemyIsUnwantedLevel()
   Local $greenResult = PixelSearch(1287, 648, 1305, 660, 0x3DB43C, 5)
   Local $yellowResult = PixelSearch(1287, 648, 1305, 660, 0xFFFF00, 5)

   Return Not (IsArray($greenResult) Or IsArray($yellowResult))
EndFunc

Func interactWithEnnemy($skinning = False)
	If (_IsPressed(57)) Then
		Send("{W up}")
	EndIf

	If (ennemyTargeted()) Then
		Send("{SHIFTDOWN}")
		Send("E")

		If ($skinning) Then
			Sleep(3500)
		Else
			Sleep(250)
		EndIf

		Send("{SHIFTUP}")
	EndIf
EndFunc

Func ennemyIsHorde()
   Return ennemyTargeted() And colorAtPositionMatches(1318, 615, 0xE52300, 5) And colorAtPositionMatches(1306, 628, 0x3F2310, 5)
EndFunc