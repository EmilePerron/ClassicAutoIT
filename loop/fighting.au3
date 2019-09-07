; Handles the fighting loop

Func fightingLoop()
   setState($STATE_FIGHT)

   If (playerInCombat()) Then
	  resetFoundEnnemyTime()
	  $_lootedLastMob = False
	  clientStopMoving()

	  addInterfaceLog("Doing the attack rotation...")
	  playerAttackRotation()
   Else
	  ; Move towards the ennemy
	  addInterfaceLog("Moving towards the ennemy!")
	  clientStopMoving()
	  interactWithEnnemy()

	  If (ennemyTargetUnreachable()) Then
		 moveAwayFromUnreachableTarget()
	  EndIf
   EndIf
EndFunc