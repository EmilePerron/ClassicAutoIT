$file = FileOpenDialog("Base64 Image Encoder", "", "Images (*.png;*.gif;*.jpg;*.jpeg;*.bmp;*tif;*.tiff)", 1)
If @error Then Exit
$tmp = @ScriptDir & "\temp.txt"

$type = StringSplit($file, ".")
$name = StringSplit($type[$type[0] - 1], "\")
$name = $name[$name[0]]
$type = $type[$type[0]]
RunWait(@ComSpec & ' /c base64 -e "' & $file & '" "' & $tmp & '"', @ScriptDir, @SW_HIDE)
Do
	Sleep(100)
Until FileExists($tmp)
$out = '<img src="data:image/' & $type & ';base64,' & StringTrimRight(FileRead($tmp, FileGetSize($tmp)), 1) & '"/>'

$loc = StringReplace($file, $name & "." & $type, "") & $name & "[" & $type & "].htm"
FileWrite($loc, $out)
Do
	FileDelete($tmp)
Until not FileExists($tmp)
MsgBox(0, "Done!", "File has been converted and saved as:" & @CRLF & @CRLF & $loc)