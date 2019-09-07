Func lootingLoop()
   If ((getState() == $STATE_FIGHT) Or (Not $_lootedLastMob)) Then
	  setState($STATE_POST_FIGHT)
	  clientStopMoving()
	  Sleep(500)

	  If (lootPreviousTarget()) Then
		 incrementKillCounter()
	  EndIf

	  setState($STATE_SEARCH)
	  $_lootedLastMob = True
	  Sleep(250)
   EndIf
EndFunc