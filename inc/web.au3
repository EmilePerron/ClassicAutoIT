; Handles updates to the web status tracker

Local $_lastWebUpdate = timestamp()
Local $_lastScreenshotUpdate = timestamp()
Local $_webUpdateInProgress = False

Func updateWebTracker($killCount, $stateLabel)
   If ($_webUpdateInProgress)  Then
	  Return ""
   EndIf

   $_webUpdateInProgress = True

   Local $query = ""
   $query &= "health=" & playerHealth()
   $query &= "&mana=" & playerMana()
   $query &= "&state=" & $stateLabel
   $query &= "&killCount=" & $killCount
   HttpPost("YOUR_API_ENDPOINT_URL", $query)

   $_webUpdateInProgress = False
EndFunc

Func checkToUpdateWebTracker()
   If (timestamp() - $_lastWebUpdate > 2) Then
	  Execute('Run(@AutoItExe & " " & @ScriptDir & "\webupdate.au3 " & getKillCount() & " """ & getStateLabel() & """")')
   EndIf
EndFunc

Func uploadScreenshot()
   Local Const $remoteFilename = "YOUR_FTP_REMOTE_FILEPATH"
   Local Const $iW = @DesktopWidth, $iH = @DesktopHeight
   Local Const $quality = 40
   Local $filename = @ScriptDir & "\screenshot\" & timestamp() & ".jpg"

   _ScreenCapture_SetJPGQuality($quality)
   $hCapture = _ScreenCapture_Capture()

   _GDIPlus_Startup()
   $hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hCapture)
   $hImage2 = _GDIPlus_ImageResize($hImage1, $iW / 2.5, $iH / 2.5)
   _GDIPlus_ImageSaveToFile($hImage2, $filename)

   _WinAPI_DeleteObject($hCapture)
   _GDIPlus_ImageDispose($hImage1)
   _GDIPlus_ImageDispose($hImage2)
   _GDIPlus_Shutdown()

   $server = 'YOUR_FTP_HOST'
   $username = 'YOUR_FTP_USERNAME'
   $pass = 'YOUR_FTP_PWD'
   $Open = _FTP_Open('MyFTP Control')
   $Conn = _FTP_Connect($Open, $server, $username, $pass)
   $Ftpp = _FTP_FilePut($Conn, $filename, $remoteFilename)
   $Ftpc = _FTP_Close($Open)

   FileDelete($filename)
EndFunc
