Global $_foundEnnemyTime = ""

Func searchingLoop()
	; Find a target...
	clientFindTarget()

	; Check if we have a valid target
	If (ennemyTargeted() And Not playerInCombat()) Then
		If (ennemyIsHorde() And optionIsSet("ignoreHorde")) Then
			addInterfaceLog("Found a horde player / NPC - switching target...")
			clearTarget()
			Sleep(250)
		ElseIf (ennemyIsElite() And optionIsSet("ignoreElite")) Then
			addInterfaceLog("Found an elite mod! Not heading there...")
			clearTarget()
			Sleep(250)
		ElseIf (ennemyIsUnwantedLevel() And optionIsSet("ignoreWrongLevel")) Then
			clearTarget()
			Sleep(250)
		EndIf
	EndIf

	; If the current ennemy is unreachable, clear target and change direction
	If (ennemyTargeted()) Then
		If ($_foundEnnemyTime == "") Then
			$_foundEnnemyTime = timestamp()
		ElseIf (ennemyTargetUnreachable()) Then
			moveAwayFromUnreachableTarget()
		EndIf
	EndIf

	; No target? Move to try and find one!
	If (Not playerInCombat() And Not ennemyTargeted()) Then
		$movementType = getRouteMovementType()

		Select
			Case $movementType = "route"
				moveAlongRoute()
			Case $movementType = "stationary"
				; Nothing to do!
			Case Else
				moveRandomly()
		EndSelect
	EndIf
EndFunc

Func moveRandomly()
	If (_IsPressed(41)) Then
		Send("{A up}")
	ElseIf (randomChance(5.5)) Then
		Send("{A down}")
	EndIf

	If (_IsPressed(44)) Then
		Send("{D up}")
	ElseIf (randomChance(5.5)) Then
		Send("{D down}")
	EndIf

	Send("{W down}")
EndFunc

Func moveAlongRoute()
	MsgBox(64, "In development", "Movement along a predefined route is not available yet.")
EndFunc

Func moveAwayFromUnreachableTarget()
	addInterfaceLog("Target unreacheable - turning around...")
	clearTarget()
	resetFoundEnnemyTime()
	Sleep(100)
	Send("{D down}")
	Sleep(500)
	Send("{D up}")
	Sleep(750)
	Send("{W down}")
	Sleep(2000)
	Send("{W up}")
EndFunc

Func ennemyTargetUnreachable()
	If ($_foundEnnemyTime <> "" And (timestamp() - $_foundEnnemyTime) > 60) Then
		Return True
	EndIf

	Return False
EndFunc

Func resetFoundEnnemyTime()
	$_foundEnnemyTime = ""
EndFunc