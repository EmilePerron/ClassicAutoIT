; Handles all generic access and interactions to the WoW Client

Global $_hasReleased = False

Func clientFocused($allowLoggedOut = False)
   If (Not WinActive("World of Warcraft")) Then
	  Return False
   EndIf

   Return $allowLoggedOut Or colorAtPositionMatches(0, 0, 0x008080, 1)
EndFunc

Func clientDimensions()
   Local $dimensions[2] = [1920, 1080]
   Return $dimensions
EndFunc

Func clientStopMoving()
   Sleep(50)
   Send("{W up}")
   Sleep(100)
   Send("{A up}")
   Sleep(100)
   Send("{S up}")
   Sleep(100)
   Send("{D up}")
   Sleep(100)
EndFunc


Func clientBarPercentage($startX, $y, $fillColor, $step = 5, $tolerance = 30)
   Local $barWidth = 140
   Local $count = 0
   Local $x = $startX + $barWidth

   While ($count < (100 / $step) And Not colorAtPositionMatches($x, $y, $fillColor, $tolerance))
	  $count += 1
	  $x -= ($barWidth / (100 / $step))
   WEnd

   Return 100 - ($count * $step)
EndFunc

Func clientTabTarget()
   Send("{TAB}")
EndFunc

Func clientMacroTarget()
   Send("4")
EndFunc

Func clientFindTarget()
   clientTabTarget()
   Sleep(500)

   If (Not ennemyTargeted()) Then
	  clientMacroTarget()
   EndIf
EndFunc

Func sendChatCommand($command)
	Opt("SendKeyDelay", 5)
	Sleep(50)
	Send("{ENTER}")
	Sleep(50)
	ClipPut($command)
	Send("^v")
	Sleep(50)
	Send("{ENTER}")
	Sleep(50)
EndFunc

Func lootPreviousTarget()
	Sleep(250)
	Send("+{TAB}") ; Shift + Tab to target the previous ennemy
	Sleep(250)

	If (Not ennemyIsDead()) Then
		Return False
	EndIf

	If (optionIsSet("looting")) Then
		addInterfaceLog("Looting the ennemy")
		interactWithEnnemy()
		Sleep(500)

		; Skinning is disabled until a way to target the previous ennemy after looting is found
		If (False And optionIsSet("skinning")) Then
			sendChatCommand("/targetlasttarget") ; This doesn't work, just like re-doing Shift Tab does not work...
			interactWithEnnemy(True)
			Sleep(250)
		EndIf
	Else
		clearTarget()
	EndIf

   Return True
EndFunc

Func clearTarget()
   Send("{ESC}")
EndFunc

Func isOnReleaseSpirit()
   Return colorAtPositionMatches(901, 229, 0x76000) And colorAtPositionMatches(1154, 250, 0x848182)
EndFunc

Func releaseSpirit()
   If (isOnReleaseSpirit()) Then
	  MouseMove(991, 228, 2)
	  Sleep(100)
	  MouseClick("left", 991, 228)
	  $_hasReleased = True
	  addInterfaceLog("Released spirit...")
	  Sleep(1000)
   EndIf
EndFunc

Func isDead()
   If (isOnReleaseSpirit()) Then
	  releaseSpirit()
   EndIf

   Return $_hasReleased And colorAtPositionMatches(1642, 171, 0x5E6373) And colorAtPositionMatches(1659, 160, 0x720000)
EndFunc

Func logout()
   addInterfaceLog("Logging out!")
   Send("{ENTER}")
   Sleep(150)
   Opt("SendKeyDelay", 50)
   Send("/logout")
   Opt("SendKeyDelay", 5)
   Sleep(150)
   Send("{ENTER}")
   Sleep(150)
EndFunc

Func switchToActionBar()
   Send("{SHIFTDOWN}")
   Sleep(150)
   Send("2")
   Sleep(250)
   Send("{SHIFTUP}")
   Sleep(150)
EndFunc

Func isUnderwater()
   Return colorAtPositionMatches(846, 130, 0x004D9B, 15) And colorAtPositionMatches(937, 127, 0xFFFFFF, 15) And colorAtPositionMatches(1084, 128, 0x363130, 15) And Not colorAtPositionMatches(1007, 128, 0x363130, 15)
EndFunc