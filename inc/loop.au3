; Manages the main loop of the application

Global $_lootedLastMob = True

Func runLoop()
   If (clientFocused() And getState() <> $STATE_STOPPED) Then
	  updatePlayerStatsInInterface()
	  checkToUpdateWebTracker()

	  If (isDead()) Then
		 logout() ; Logs out
		 stop() ; Stop the appication
	  ElseIf (checkForBreak()) Then
		 ; On break - nothing to do!
	  ElseIf (isUnderwater()) Then
		 ; Get back up to the surface!
		 clientStopMoving();
		 Sleep(300)
		 Send("{SPACE down}")
		 Do
			Sleep(50)
		 Until (Not isUnderwater())
		 Send("{SPACE up}")
	  Else
		 If (ennemyTargeted() And ennemyIsDead()) Then
			clearTarget()
			Sleep(250)
		 EndIf

		 If (ennemyTargeted()) Then
			If (Not playerInCombat()) Then
			   playerRegen()
			EndIf

			fightingLoop()
		 ElseIf (Not playerInCombat() And playerRegen()) Then
			; Nothing to do! Regen in progress...
		 ElseIf (Not playerInCombat()) Then
			lootingLoop()
			searchingLoop()
			playerIdleBuffUp()

			; Go on break if it's time!
			checkToGoToBreak()
		 EndIf
	  EndIf
   ElseIf (clientFocused(true) And getState() == $STATE_BREAK) Then
	  checkForBreak()
   EndIf
EndFunc