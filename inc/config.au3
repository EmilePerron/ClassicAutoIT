Local $_config = Null

Func loadConfig()
	$_config = ObjCreate("Scripting.Dictionary")

	Local $file = @ScriptDir & "\setup.conf"
	FileOpen($file, $FO_READ)

	For $i = 1 to _FileCountLines($file)
		$line = FileReadLine($file, $i)

		If (StringLen($line) > 0) Then
			Local $parts = StringSplit($line, "=")

			If ($parts[0] >= 2) Then
				$_config.add($parts[1], $parts[2])
			EndIf
		EndIf
	Next

	FileClose($file)
EndFunc

Func getConfig($key)
	If ($_config == Null) Then
		loadConfig()
	EndIf

	If ($_config.Exists($key)) Then
		Return StringReplace($_config.Item($key), @CRLF, "")
	EndIf

	Return ""
EndFunc

Func setConfig($key, $value)
	If ($_config == Null) Then
		loadConfig()
	EndIf

	$_config.Item($key) = $value
	saveConfig()
EndFunc

Func saveConfig()
	Local $filename = @ScriptDir & "\setup.conf"
	Local $fileHandle = FileOpen($filename, $FO_OVERWRITE)

	For $key In $_config
	   FileWrite($fileHandle, $key & "=" & getConfig($key) & @CRLF)
	Next

	FileClose($fileHandle)
EndFunc