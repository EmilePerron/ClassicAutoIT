#include <GuiConstants.au3>
#include <WinAPIFiles.au3>
#include <FileConstants.au3>
#include <File.au3>
#include <Date.au3>
#Include <Color.au3>
#include <Misc.au3>
#include <ScreenCapture.au3>
#include <FTPEx.au3>
#include "lib/WinHttp.au3"
#include "inc/log.au3"
#include "inc/utility.au3"
#include "inc/config.au3"
#include "inc/states.au3"
#include "inc/client.au3"
#include "inc/route.au3"
#include "inc/options.au3"
#include "inc/player.au3"
#include "inc/ennemy.au3"
#include "inc/controls.au3"
#include "inc/hotkeys.au3"
#include "inc/interface.au3"
#include "loop/fighting.au3"
#include "loop/looting.au3"
#include "loop/searching.au3"
#include "inc/loop.au3"
#include "inc/web.au3"

setConfig("test", "value")
setConfig("test2", "value is here")
setConfig("test", "replaced value")


createInterface()

Local $loopsCount = 0
Do
   handleInterfaceInteractions()

   $loopsCount += 1

   If (Mod($loopsCount, 10) == 0) Then
	  runLoop()
   EndIf

   Sleep(1)
Until closeRequested()

clientStopMoving()

