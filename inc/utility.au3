; Defines a bunch of useful utility functions

Func colorAtPositionMatches($x, $y, $expectedColor, $tolerance = 30)
   Local $pixelColor = PixelGetColor($x, $y)
   Return (Abs(_ColorGetRed($pixelColor) - _ColorGetRed($expectedColor)) <=  $tolerance) _
	  And (Abs(_ColorGetBlue($pixelColor) - _ColorGetBlue($expectedColor)) <=  $tolerance) _
	  And (Abs(_ColorGetGreen($pixelColor) - _ColorGetGreen($expectedColor)) <=  $tolerance)
EndFunc

Func randomChance($successPercentage)
   Return Random(1, 100 / $successPercentage, 1) == 1
EndFunc

Func timestamp()
   $epoch = "1970/01/01 00:00:00"
   $now = _NowCalc()
   $time = _DateDiff("s", $epoch, $now)
   Return $time
EndFunc

Func timestampToTime($nPosix)
   Local $nYear = 1970, $nMon = 1, $nDay = 1, $nHour = 00, $nMin = 00, $nSec = 00, $aNumDays = StringSplit ("31,28,31,30,31,30,31,31,30,31,30,31", ",")
   While 1
      If (Mod ($nYear + 1, 400) = 0) Or (Mod ($nYear + 1, 4) = 0 And Mod ($nYear + 1, 100) <> 0) Then; is leap year
         If $nPosix < 31536000 + 86400 Then ExitLoop
         $nPosix -= 31536000 + 86400
         $nYear += 1
      Else
         If $nPosix < 31536000 Then ExitLoop
         $nPosix -= 31536000
         $nYear += 1
      EndIf
   WEnd
   While $nPosix > 86400
      $nPosix -= 86400
      $nDay += 1
   WEnd
   While $nPosix > 3600
      $nPosix -= 3600
      $nHour += 1
   WEnd
   While $nPosix > 60
      $nPosix -= 60
      $nMin += 1
   WEnd
   $nSec = $nPosix
   For $i = 1 to 12
      If $nDay < $aNumDays[$i] Then ExitLoop
      $nDay -= $aNumDays[$i]
      $nMon += 1
   Next
   Return $nHour & ":" & $nMin
EndFunc