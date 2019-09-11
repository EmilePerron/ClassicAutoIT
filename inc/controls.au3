; Defines listener functions that control the application

Local $_shouldStop = False
Local $_shouldTakeBreak = False
Local $_onBreakUntil = timestamp()
Local $_nextBreakAt = timestamp() + Random(3600, 10800)

Func start()
   addInterfaceLog("Starting")
   WinActivate("World of Warcraft")
   setState($STATE_IDLE)
   ;setup()
EndFunc

Func stop()
   addInterfaceLog("Stopping")
   setState($STATE_STOPPED)
EndFunc

Func close()
   setState($STATE_STOPPED)
   $_shouldStop = True
EndFunc

Func closeRequested()
   Return $_shouldStop;
EndFunc

Func breakIsDone()
   Return timestamp() >= $_onBreakUntil
EndFunc

Func checkForBreak()
   If (getState() == $STATE_BREAK) Then
	  If (breakIsDone()) Then
		 addInterfaceLog("Login back in from the break...")
		 Send("{ENTER}")
		 Sleep(5000)
		 switchToActionBar()
		 Sleep(1000)
		 setState($STATE_IDLE)
		 Return False
	  Else
		 Return True
	  EndIf
   ElseIf (Not $_shouldTakeBreak And timestamp() >= $_nextBreakAt) Then
	  addInterfaceLog("It's about time to go on a break: waiting for Idle...")
	  $_shouldTakeBreak = true
	  $_nextBreakAt = timestamp() + Random(3600, 10800)
	  Return False
   EndIf

   Return False
EndFunc

Func checkToGoToBreak()
   If ($_shouldTakeBreak) Then
	  addInterfaceLog("Going on break!")
	  $_shouldTakeBreak = False
	  $_onBreakUntil = timestamp() + (60 * 1) ; Random(5, 20)
	  setState($STATE_BREAK)
	  clientStopMoving()
	  logout()

	  ; Check to make sure we're not attacked during the logout
	  For $i = 0 To 20 Step 1
		 If (playerInCombat()) Then
			; We're being attacked! Cancel the logout
			addInterfaceLog("We're being attacked! Delaying the logout...")
			$_shouldTakeBreak = True
			setState($STATE_IDLE)
			Send("{ESC}")
			Return Null
		 Else
			Sleep(1000)
		 EndIf
	  Next
   EndIf
EndFunc

Func getBreakEndTime()
   Return timestampToTime($_onBreakUntil)
EndFunc