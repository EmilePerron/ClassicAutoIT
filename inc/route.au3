Func getAvailableRoutes()
	Local $routes = "Random"
	$routesArray = _FileListToArray(@ScriptDir & "\routes")

	If (@error == 0) Then
		For $i = 1 To $routesArray[0] Step 1
			$routes &= "|" & $routesArray[$i]
		Next
	EndIf

	Return $routes
EndFunc

Func getCurrentRoutePath()
	Return @ScriptDir & "\routes\" & GUICtrlRead($_routeDropdown)
EndFunc

Func getRouteXMLObject()
	Local $oXML = ObjCreate("Microsoft.XMLDOM")
	$oXML.load(getCurrentRoutePath())
	Return $oXML
EndFunc

Func getRouteNode($selector)
	Local $oXML = getRouteXMLObject()
	Return $oXML.SelectSingleNode($selector)
EndFunc

Func getRouteNodes($selector)
	Local $oXML = getRouteXMLObject()
	Return $oXML.SelectNodes($selector)
EndFunc

Func getRouteMovementType()
	Local $movementNode = getRouteNode("//movement").text

	If (@error) Then
		Return "random"
	EndIf

	Return $movementNode.text
EndFunc

Func buildTargetMacroText()
	Local $text = "/stopmacro [combat]" & @CRLF
	Local $targets = getRouteNodes("//targets/target")
	Local $messageSent = False;

	For $target In $targets
		$newLine = "/tar [noexists] " & $target.text & @CRLF
		If (StringLen($text & $newLine) <= 255) Then
			$text &= $newLine
		ElseIf (Not $messageSent) Then
			$messageSent = True
			MsgBox(64, "Macro length", "This route has too many targets. The targeting macro will contain as many targets as it can fit in 255 characters.")
		EndIf
	Next

	Return $text
EndFunc

Func copyTargetMacroText()
	ClipPut(buildTargetMacroText())
EndFunc

Func updateRouteDescriptionLabel()
	Local $descriptionNode = getRouteNode("//description")

	If (Not @error) Then
		GUICtrlSetData($_routeDescriptionLabel, $descriptionNode.text)
	Else
		GUICtrlSetData($_routeDescriptionLabel, "This route has no description")
	EndIf
EndFunc