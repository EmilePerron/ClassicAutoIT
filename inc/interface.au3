; Manages everything about the app's interface

#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#Include <EditConstants.au3>
#include <ProgressConstants.au3>

Global $_interface = Null
Global $_stateLabel = Null
Global $_killsLabel = Null
Global $_runtimeLabel = Null
Global $_routeDescriptionLabel = Null
Global $_startButton = Null
Global $_stopButton = Null
Global $_copyTargetingMacroButton = Null
Global $_routeDropdown = Null
Global $_profileDropdown = Null
Global $_stopButton = Null
Global $_healthBar = Null
Global $_manaBar = Null
Global $_logsBox = Null
Global $_lootingCheckbox = Null
Global $_skinningCheckbox = Null
Global $_breaksCheckbox = Null
Global $_ignoreHordeCheckbox = Null
Global $_ignoreEliteCheckbox = Null
Global $_ignoreWrongLevelCheckbox = Null
Global $_previousLogMessage = Null
Global $_killCount = 0

Func createInterface()
	$_interface = GUICreate("Progress Status", 450, 478)

	; Create groups and read-only labels
	GuiCtrlCreateGroup("Route", 10, 10, 210, 110)
	GuiCtrlCreateGroup("Profile", 230, 10, 210, 110)
	GuiCtrlCreateGroup("Options", 10, 136, 428, 124)
	GuiCtrlCreateGroup("Status", 10, 270, 428, 140)
	GuiCtrlCreateLabel("State", 20, 360, 60, 15)
	GuiCtrlCreateLabel("Health", 20, 295, 40, 15)
	GuiCtrlCreateLabel("Mana", 233, 295, 58, 15)
	GuiCtrlCreateLabel("Kill count", 233, 360, 60, 28)
	GuiCtrlCreateLabel("Runtime", 333, 360, 60, 20)

	; Main action buttons
	$_startButton = GuiCtrlCreateButton("Start", 107, 420, 113, 41)
	$_stopButton = GuiCtrlCreateButton("Stop", 234, 420, 113, 41)

	; Route group
	$_routeDropdown = GuiCtrlCreateCombo("", 20, 34, 190, 21)
	GUICtrlSetData($_routeDropdown, getAvailableRoutes())
	$_copyTargetingMacroButton = GuiCtrlCreateButton("Copy targeting macro", 50, 88, 130, 22)
	$_routeDescriptionLabel = GuiCtrlCreateLabel("No route selected", 22, 64, 188, 16)

	; Profile group
	$_profileDropdown = GuiCtrlCreateCombo("Select a profile", 240, 34, 190, 21)

	; Status group
	$_stateLabel = GuiCtrlCreateLabel("Click start to begin", 20, 380, 190, 20)
	$_killsLabel = GuiCtrlCreateLabel("0", 233, 380, 60, 20)
	$_runtimeLabel = GuiCtrlCreateLabel("0s", 333, 380, 60, 20)
	$_healthBar = GUICtrlCreateProgress(20, 320, 195, 30, $PBS_SMOOTH)
	$_manaBar = GUICtrlCreateProgress(233, 320, 195, 30, $PBS_SMOOTH)

	; Options group
	$_lootingCheckbox = GuiCtrlCreateCheckbox("Loot mobs", 20, 155, 205, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$_skinningCheckbox = GuiCtrlCreateCheckbox("Skin beasts", 20, 180, 205, 20)
	$_breaksCheckbox = GuiCtrlCreateCheckbox("Take breaks during long sessions", 20, 205, 205, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$_ignoreHordeCheckbox = GuiCtrlCreateCheckbox("Ignore Horde players", 240, 155, 205, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$_ignoreEliteCheckbox = GuiCtrlCreateCheckbox("Ignore elites", 240, 180, 205, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$_ignoreWrongLevelCheckbox = GuiCtrlCreateCheckbox("Ignore grey/red level mobs", 240, 205, 205, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)

	; Legacy
	$_logsBox = GUICtrlCreateEdit("Opened the application", 2000, 0, 0, 0, $ES_MULTILINE)

	GUISetState(@SW_SHOW)
EndFunc

Func updateStateLabel()
   Local $state = getState()
   Local $text = ""

   Select
      Case $state = $STATE_STOPPED
         $text = "Stopped - click Start to continue"
      Case $state = $STATE_BREAK
         $text = "On break until " & getBreakEndTime()
      Case $state = $STATE_IDLE
         $text = "Idle"
      Case $state = $STATE_FIGHT
         $text = "Fighting"
      Case $state = $STATE_REGEN
         $text = "Taking time to regen..."
      Case $state = $STATE_DEAD
         $text = "Dead"
      Case $state = $STATE_POST_FIGHT
         $text = "Just finished a fight"
      Case $state = $STATE_SEARCH
         $text = "Looking for mobs"
      Case $state = $STATE_HERB
         $text = "Picking up herbs"
	EndSelect

   GUICtrlSetData($_stateLabel, $text)
EndFunc

Func getStateLabel()
   Return GUICtrlRead($_stateLabel)
EndFunc

Func handleInterfaceInteractions()
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         close()
      Case $msg = $_startButton
		 start()
      Case $msg = $_stopButton
		 stop()
      Case $msg = $_routeDropdown
		 updateRouteDescriptionLabel()
      Case $msg = $_copyTargetingMacroButton
		 copyTargetMacroText()
   EndSelect
EndFunc

Func addInterfaceLog($text)
   If ($text <> $_previousLogMessage) Then
	  GUICtrlSetData($_logsBox, "[" & _Now() & "] " & $text & @CRLF & GUICtrlRead($_logsBox))
	  $_previousLogMessage = $text
   EndIf
EndFunc

Func updatePlayerStatsInInterface()
   GUICtrlSetData($_healthBar, playerHealth())
   GUICtrlSetData($_manaBar, playerMana())
EndFunc

Func incrementKillCounter()
   $_killCount += 1
   GUICtrlSetData($_killsLabel, $_killCount & " kills")
EndFunc

Func getKillCount()
   Return $_killCount
EndFunc