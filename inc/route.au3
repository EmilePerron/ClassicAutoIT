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

Func getAvailableRoutesArray()
	Return _FileListToArray(@ScriptDir & "\routes")
EndFunc

Func getCurrentRoutePath()
	Local $routeFilename = GUICtrlRead($_routeDropdown)

	If ($routeFilename == "") Then
		Return ""
	EndIf

	Return @ScriptDir & "\routes\" & $routeFilename
EndFunc

Func getRouteXMLObject()
	Local $oXML = ObjCreate("Microsoft.XMLDOM")
	$oXML.load(getCurrentRoutePath())
	Return $oXML
EndFunc

Func getRouteFileContent()
	Local $file = FileOpen(getCurrentRoutePath(), $FO_READ)

    If $file = -1 Then
        Return ""
    EndIf

    Local $content = FileRead($file)
    FileClose($file)

	Return $content
EndFunc

Func setRouteFileContent($content)
	Local $file = FileOpen(getCurrentRoutePath(), $FO_OVERWRITE)

    If $file = -1 Then
        Return False
    EndIf

	FileWrite($file, $content)
    FileClose($file)

	Return True
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
	Local $movementNode = getRouteNode("//movement")

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

Func createRoute()
	Local $filename = StringReplace(GUICtrlRead($_routeDropdown), ".xml", "")
	Local $found = False
	Local $counter = 1

	If ($filename == "") Then
		$filename = "New Route"
	EndIf

	Local $originalFilename = $filename

	Do
		If ($found) Then
			$filename = $originalFilename & " (" & $counter & ")"
		EndIf

		$found = False

		For $route In getAvailableRoutesArray()
			If ($route == $filename & ".xml") Then
				$found = True
				ExitLoop
			EndIf
		Next

		$counter += 1
	Until Not $found

	$file = FileOpen(@ScriptDir & "\routes\" & $filename & ".xml", $FO_OVERWRITE)

	If $file = -1 Then
		MsgBox(0, "Error", "Unable to create the new route's file.")
	Else
		FileWrite($file,'<route>'&@CRLF& _
						'<description>New route</description>'&@CRLF& _
						'<targets>'&@CRLF& _
						'</targets>'&@CRLF& _
						'<coords>'&@CRLF& _
						'</coords>'&@CRLF& _
						'</route>')
		FileClose($file)
	EndIf

	GUICtrlSetData($_routeDropdown, "|" & getAvailableRoutes(), $filename & ".xml")
EndFunc

Func startRecordingRoute()
	GUICtrlSetState($_recordRouteButton, $GUI_DISABLE)

	If (getCurrentRoutePath() == "") Then
		createRoute()
	EndIf

	; Wait for the client to be focused
	Do
		Sleep(100)
	Until (clientFocused())

	; Start recording the coordinates every 1s
	Local $previousX = -100
	Local $previousY = -100
	Local $coordsList = ObjCreate("System.Collections.ArrayList")

	Do
		Local $x = playerX()
		Local $y = playerY()
		Local $distance = getDistanceBetweenPositions($x, $y, $previousX, $previousY)

		If ($distance >= 0.35) Then
			$coordsList.Add("<coord>" & $x & ", " & $y & "</coord>")
			$previousX = $x
			$previousY = $y
		EndIf

		Sleep(100)
	Until (Not clientFocused())

	addNodesToRouteXml("coords", $coordsList)
	GUICtrlSetState($_recordRouteButton, $GUI_ENABLE)
EndFunc

Func addTargetToRoute()
	Do
		Sleep(100)
	Until (clientFocused())

	sendChatCommand("/run ft__wait(0.25, ft_enterTargetNameInEditBox)")
	Sleep(300)
	Send("^a")
	Send("^x")
	Send("{ESCAPE}")

	addNodeToRouteXml("targets", "<target>" & ClipGet() & "</target>")
EndFunc

Func addNodeToRouteXml($parentNode, $node)
	Local $list = ObjCreate("System.Collections.ArrayList")
	$list.Add($node)
	addNodesToRouteXml($parentNode, $list)
EndFunc

Func addNodesToRouteXml($parentNode, $nodeList)
	Local $content = getRouteFileContent()
	Local $parentClosingTag = "</" & $parentNode & ">"

	If (StringInStr($content, $parentClosingTag) == 0) Then
		addNodeToRouteXml("route", "<coords>" & @CRLF & "</coords>")
		$content = getRouteFileContent()
	EndIf

	For $node In $nodeList
		$content = StringReplace($content, $parentClosingTag, $node & @CRLF & $parentClosingTag)
	Next

	setRouteFileContent($content)
EndFunc