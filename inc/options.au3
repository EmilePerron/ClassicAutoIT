Func optionIsSet($name)
	Local $checkbox = Null

	Select
	  Case $name = "looting"
		 $checkbox = $_lootingCheckbox
	  Case $name = "skinning"
		 $checkbox = $_skinningCheckbox
	  Case $name = "breaks"
		 $checkbox = $_breaksCheckbox
	  Case $name = "ignoreHorde"
		 $checkbox = $_ignoreHordeCheckbox
	  Case $name = "ignoreElite"
		 $checkbox = $_ignoreEliteCheckbox
	  Case $name = "ignoreWrongLevel"
		 $checkbox = $_ignoreWrongLevelCheckbox
	EndSelect

	Return GUICtrlRead($checkbox) == $GUI_CHECKED
EndFunc