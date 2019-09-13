; Defines helper methods to get information about the PLAYER

Func playerHealth()
   Return getPercentageFromPixel(1, 0) * 100
EndFunc

Func playerMana()
   Return getPercentageFromPixel(1, 1) * 100
EndFunc

Func playerPosition()
	Return getPositionFromPixel(0, 1)
EndFunc

Func playerX()
	$position = playerPosition()
	Return $position[0]
EndFunc

Func playerY()
	$position = playerPosition()
	Return $position[1]
EndFunc

Func playerOrientation()
	$position = playerPosition()
	Return $position[2]
EndFunc

Func playerShouldEat()
   Return playerHealth() <= 50
EndFunc

Func playerShouldDrink()
   Return playerMana() <= 50
EndFunc

Func playerShouldRegen()
   Return playerShouldDrink() Or playerShouldEat()
EndFunc

Func playerRegenIsDone()
   Return playerMana() >= 70 And playerHealth() >= 85
EndFunc

Func playerRegen()
   Local $doingRegen = False

   If (getState() <> $STATE_REGEN) Then
	  If (playerShouldEat()) Then
		 addInterfaceLog("The player needs to regen health!")

		 If (playerCanHealForRegen()) Then
			addInterfaceLog("Healing...")

			Do
			   playerHeal()
			   Sleep(2850)

			   If (isDead()) Then
				  Return False
			   EndIf
			Until playerHealth() >= 85
		 Else
			addInterfaceLog("Eating...")
			$doingRegen = True
			clientStopMoving()
			Sleep(250)
			playerEat()
		 EndIf
	  EndIf

	  If (playerShouldDrink()) Then
		 addInterfaceLog("The player needs to regen mana!")
		 addInterfaceLog("Drinking...")
		 $doingRegen = True

		 If (Not $doingRegen) Then
			clientStopMoving()
			Sleep(250)
		 EndIf

		 playerDrink()
	  EndIf

	  If ($doingRegen) Then
		 setState($STATE_REGEN)
	  EndIf
   Else
	  If (playerRegenIsDone()) Then
		 addInterfaceLog("All done with the regen!")
		 setState($STATE_IDLE)
	  Else
		 addInterfaceLog("Already regening...")
		 $doingRegen = True;
	  EndIf
   EndIf

   Return $doingRegen
EndFunc

Func playerDrink()
   Send("1")
EndFunc

Func playerEat()
   Send("2")
EndFunc

Func playerShield()
   Send("-")
EndFunc

Func playerHeal()
   Send("0")
EndFunc

Func playerStun()
   If (ennemyTargeted() And Not colorAtPositionMatches(769, 1038, 0x251A16, 10)) Then
	  Send("9")
	  Return True
   EndIf

   Return False
EndFunc

Func playerCanHeal()
   Return playerMana() > 10
EndFunc

Func playerCanHealForRegen()
   Return playerMana() > 70
EndFunc

Func playerIdleBuffUp()
   ; Put on Retribution aura
   If (Not colorAtPositionMatches(429, 937, 0XFFFBFF, 10)) Then
	  addInterfaceLog("Buffing: retribution aura")
	  MouseMove(413, 935, 2)
	  Sleep(500)
	  MouseClick("left", 413, 935)
	  Sleep(250)
	  MouseMove(Random(20, 1920), Random(20, 1000), 4)
	  Sleep(250)
   EndIf

   ; Put on Seal of Command
   If (Not colorAtPositionMatches(719, 1035, 0xF6EEE6, 5)) Then
	  addInterfaceLog("Buffing: seal of command")
	  Send("=")
	  Sleep(1500)
   EndIf

   ; Put on Blessing of might
   If (Not colorAtPositionMatches(717, 977, 0x251D1D, 5)) Then
	  addInterfaceLog("Buffing: blessing of might!")
	  Send("7")
	  Sleep(1500)
   EndIf
EndFunc

Func playerInCombat()
   Return colorAtPositionMatches(1882, 892, 0x233646, 5)
EndFunc

Func playerAttacking()
   Return Not colorAtPositionMatches(685, 1048, 0xFFFFE5, 15)
EndFunc

Func playerAutoAttack()
   interactWithEnnemy()
EndFunc

Func playerJudge()
	If (ennemyTargeted()) Then
		Send("8")
	EndIf
EndFunc

Func playerCombatBuffUp()
	If (ennemyTargeted()) Then
		; Put on Seal of Command
		If (Not colorAtPositionMatches(719, 1035, 0xF6EEE6, 5)) Then
			addInterfaceLog("Buffing: seal of command")
			Send("=")
			Sleep(1500)
		EndIf
	EndIf

	If (ennemyTargeted()) Then
		; Use Stoneform
		If (Not colorAtPositionMatches(714, 973, 0x1F1F1F, 2)) Then
			addInterfaceLog("Buffing: stoneform")
			Send("!3")
			Sleep(1500)
		EndIf
	EndIf
EndFunc

Func playerCanShield()
   Return Not colorAtPositionMatches(714, 1048, 0x452A0D, 5)
EndFunc

Func playerAttackRotation()
   clientStopMoving()
   playerAutoAttack()
   playerCombatBuffUp()

   If (playerStun()) Then
	  Sleep(500)
	  playerJudge() ; Seal of command during stun does extra damage
	  Sleep(1000)
   EndIf

   If (playerHealth() <= 15 And playerCanShield()) Then
	  addInterfaceLog("Using Divine Shield!")
	  playerShield()
	  Sleep(1500)
   EndIf

   If (playerHealth() <= 40 And playerCanHeal() And ennemyHealth() > 10) Then
	  playerHeal()
   ElseIf (playerHealth() <= 30 And playerCanHeal()) Then
	  playerHeal()
   ElseIf (playerHealth() <= 10 And Not colorAtPositionMatches(668, 971, 0x736062, 5)) Then
	  addInterfaceLog("Using Lay on Hands!")
	  Send("{F5}")
   EndIf
EndFunc

Func playerTurnTowardsPoint($x, $y)
    Local $deltaX = $x - playerX()
    Local $deltaY = $y - playerY()
    Local $distance = getDistanceBetweenPositions(playerX(), playerY(), $x, $y)
    Local $angle = ASin(Abs($deltaY) / Abs($distance))

    If ($deltaX <= 0 And $deltaY >= 0) Then
        $angle += 90
    ElseIf ($deltaX >= 0 And $deltaY >= 0) Then
        $angle += 180
    ElseIf ($deltaX >= 0 And $deltaY <= 0) Then
        $angle += 270
    EndIf

    Local $targetOrientation = (2 * $M_PI) * ($angle / 360)
    Local $playerOrientation = playerOrientation()
    Local $deltaOrientation = 0

    If ($playerOrientation > $targetOrientation) Then
        If ($playerOrientation - $targetOrientation <= $M_PI) Then
            $deltaOrientation = $playerOrientation - $targetOrientation
        Else
            $deltaOrientation = ((2 * $M_PI) - ($playerOrientation - $targetOrientation)) * -1
        EndIf
    Else
        If ($targetOrientation - $playerOrientation <= $M_PI) Then
            $deltaOrientation = $targetOrientation - $playerOrientation
        Else
            $deltaOrientation = ((2 * $M_PI) - ($targetOrientation - $playerOrientation)) * -1
        EndIf
    EndIf

    ; Return if there's no need to turn
    If ($deltaOrientation == 0) Then
        Return
    EndIf

    ; If the orientation delta is negative, turn right.
    ; If it's positive, turn left.
    Local $millisecondsPerFullTurn = 1500 ; @TODO: Figure out what that really is
    Local $turningTime = (Abs($deltaOrientation) / (2 * $M_PI)) * $millisecondsPerFullTurn
    Local $turningKey = deltaOrientation > 0 ? 'a' : 'd'

    ; Do that turny thing!
    Send("{" & $turningKey & " DOWN}")
    Sleep($turningTime)
    Send("{" & $turningKey & " UP}")
EndFunc
