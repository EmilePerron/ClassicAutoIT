; Checks to setup all the pre-requisites before we get started

Func setup()
	WinWaitActive("World of Wacraft")
	setupTargetingMacro()
EndFunc

Func setupTargetingMacro()
	; Creates the targeting macro and places it in the last slot of the 2nd action bar
	Local $macroName = getConfig("targetingMacroName")

	If ($macroName == "") Then
		$macroName = "TargetMobs"
	EndIf

	Sleep(150)
	sendChatCommand('DeleteMacro("' & $macroName & '")')
	Sleep(250)
	sendChatCommand('CreateMacro("' & $macroName & '", "INV_MISC_QUESTIONMARK", "' & buildTargetMacroText() & '", nil)')
	Sleep(250)
	sendChatCommand('PickupMacro("' & $macroName & '") PlaceAction(24)')
	Sleep(250)
EndFunc