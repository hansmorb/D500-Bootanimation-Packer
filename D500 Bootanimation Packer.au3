#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Phone-Icon.ico
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>

FileInstall("META-INF.zip",@TempDir & "\META-INF.zip")
FileInstall("7za.exe",@TempDir & "\7za.exe")
$sTempPath = @ScriptDir & "\DBPtemp"

$hMainForm = GUICreate("D500 Bootanimation Packer", 860, 117, 538, 654)
$hMainLabel1 = GUICtrlCreateLabel("Startup Animation:", 0, 0, 136, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$hStartupInput = GUICtrlCreateInput("", 152, 0, 617, 21)
$hStartupSearchButton = GUICtrlCreateButton("Search...", 768, 0, 89, 24)
$hMainLabel2 = GUICtrlCreateLabel("Shutdown Animation:", 0, 24, 155, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$hShutdownInput = GUICtrlCreateInput("", 152, 24, 617, 21)
$hShutdownSearchButton = GUICtrlCreateButton("Search...", 768, 24, 89, 24)
$hMainLabel3 = GUICtrlCreateLabel("Booting Sound:", 0, 48, 114, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$hBootSoundInput = GUICtrlCreateInput("", 152, 48, 617, 21)
$hBootSoundSearchButton = GUICtrlCreateButton("Search...", 768, 48, 89, 24)
$hPackButton = GUICtrlCreateButton("Pack", 0, 72, 857, 41)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hStartupSearchButton
			GUICtrlSetData($hStartupInput,FileOpenDialog("Please select your Startup Animation:","","ZIP (*.zip)"))
		Case $hShutdownSearchButton
			GUICtrlSetData($hShutdownInput,FileOpenDialog("Please select your Shutdown Animation:","","ZIP (*.zip)"))
		Case $hBootSoundSearchButton
			GUICtrlSetData($hBootSoundInput,FileOpenDialog("Please select your Boot Sound:","","MP3 File (*.mp3)"))
		Case $hPackButton
			If FileExists(GUICtrlRead($hStartupInput)) = 0 and FileExists(GUICtrlRead($hShutdownInput)) = 0 and FileExists(GUICtrlRead($hBootSoundInput)) = 0 Then
				MsgBox(16,"D500 Bootanimation Packer","Please select at least one valid path!")
				ContinueLoop
			EndIf
			DirCreate($sTempPath)
			ShellExecuteWait(@TempDir & '\7za.exe','x META-INF.zip -o"' & $sTempPath & '" -y',@TempDir)
			DirCreate($sTempPath & "\system\customize\resource")
			If FileExists(GUICtrlRead($hStartupInput)) = 1 Then FileCopy(GUICtrlRead($hStartupInput),$sTempPath & "\system\customize\resource\hTC_bootup.zip")
			If FileExists(GUICtrlRead($hShutdownInput)) = 1 Then FileCopy(GUICtrlRead($hShutdownInput),$sTempPath & "\system\customize\resource\htc_downanimation.zip")
			If FileExists(GUICtrlRead($hBootSoundInput)) = 1 Then FileCopy(GUICtrlRead($hBootSoundInput),$sTempPath & "\system\customize\resource\HTC_Sense5_Boot.mp3")
			ShellExecuteWait(@TempDir & '\7za.exe','a btanim.zip META-INF\',$sTempPath)
			ShellExecuteWait(@TempDir & '\7za.exe','a btanim.zip system\',$sTempPath)
			$sSavePath = FileSaveDialog("D500 Bootanimation Packer","","Flashable Bootanimation (*.zip)")
			If StringRight($sSavePath,4) <> '.zip' Then $sSavePath = $sSavePath & '.zip'
			FileMove($sTempPath & "\btanim.zip",$sSavePath)
			DirRemove($sTempPath,1)
			FileDelete(@TempDir & "\META-INF.zip")
			FileDelete(@TempDir & "\7za.exe")
			MsgBox(0,"D500 Bootanimation Packer","Thank you very much for using this little Tool" & @CRLF & "Fliwatt")
			Exit
	EndSwitch
WEnd
