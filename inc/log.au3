; Handles logging for the application

Func writeLog($filename, $text)
   Local $directory = @ScriptDir & "\logs"
   Local $logFilename = $directory & "\" & $filename & ".log"

   DirCreate($directory)
   Local $file = FileOpen($logFilename, $FO_APPEND)

   FileWrite($file, "[" & _Now() & "] " & $text & @CRLF)
EndFunc