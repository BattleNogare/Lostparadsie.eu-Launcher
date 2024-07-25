#cs ----------------------------------------------------------------------------

 Author: BattleNogare

 Script Function:
    Lostparadise.eu Arma3Sync-Laucher

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <GuiTab.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <IE.au3>
#include <Inet.au3>
#include <FileConstants.au3>
#include <InetConstants.au3>
#include <ColorConstants.au3>
#include <ButtonConstants.au3>
#include <GuiEdit.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <WinAPIFiles.au3>
#include <Process.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <GDIPlus.au3>
#include <WinAPISysWin.au3>
#include <WinAPIHObj.au3>
#include <Array.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <File.au3>
#include <Inet.au3>
#include <GuiConstants.au3>

;#RequireAdmin
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)

$ParainiFile = @WorkingDir & "\LP-Data\Launcherconfig.ini"
Global $sParameters = ""
Global $iPID = 0
Global $sOutput = ""
;Global $WM_LBUTTONDOWN = 0x0201

; GUI erstellen
$Form1 = GUICreate("[Lostparadise.eu]", 800, 570, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
;GUIRegisterMsg($WM_LBUTTONDOWN, "WM_LBUTTONDOWN")
GUICtrlSetDefColor(0xcdd8e0)
GUICtrlSetDefBkColor(0x252729)

; Background Pic
$background = GUICtrlCreatePic(@WorkingDir & "\LP-Data\background.jpg", 0, 0, 800, 570)
GUICtrlSetState(-1, $GUI_DISABLE)

; Exit Button
$ButtonExit = GUICtrlCreateLabel("X", 780, 2, 18, 18, $SS_CENTER + $SS_CENTERIMAGE)
GUICtrlSetOnEvent($ButtonExit, "_Exit")
GUICtrlSetFont(-1, 12, 900, 0, "")
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)

; Erstelle Reiter
$hTab = GUICtrlCreateTab(0, 0, 800, 570)
;Reiter 1
$hTab1 = GUICtrlCreateTabItem("Launcher")

; Bild Logo
$Logo = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\LP-Logo.png", 10, 31, 280, 204)
GUICtrlSetState(-1, $GUI_DISABLE)

; Button Sync
$SyncButton = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\syncdata.png", 494, 505, 144, 54)

; Button Sync-Cancel
$SyncButtonCancel = GUICtrlCreatePic(@WorkingDir & "\LP-Data\syncdata-stop.png", 494, 505, 144, 54)
GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)

;Button Launch
$LPLaunchButton = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\lostparadisestart.png", 642, 505, 144, 54)
GUICtrlSetState($LPLaunchButton, $GUI_DISABLE)

;$LPLauchButtondisabled = GUICtrlCreateLabel("", 642, 505, 144, 54)
;GUICtrlSetBkColor (-1, 0xFF0000)



;CMD-Ausgabe
$Output = GUICtrlCreateEdit("", 410, 250, 375, 240, $ES_READONLY)
GUICtrlSetData(-1, "")
Local $sBanner = "     __                 __   ____                           __ _                           " & @CRLF & _
		"    / /   ____   _____ / /_ / __ \ ____ _ _____ ____ _ ____/ /(_)_____ ___     ___   __  __" & @CRLF & _
		"   / /   / __ \ / ___// __// /_/ // __ `// ___// __ `// __  // // ___// _ \   / _ \ / / / /" & @CRLF & _
		"  / /___/ /_/ /(__  )/ /_ / ____// /_/ // /   / /_/ // /_/ // /(__  )/  __/_ /  __// /_/ / " & @CRLF & _
		" /_____/\____//____/ \__//_/     \__,_//_/    \__,_/ \__,_//_//____/ \___/(_)\___/ \__,_/  " & @CRLF

GUICtrlSetFont($Output, 5, 5000, 0, "Courier New") ;
GUICtrlSetData($Output, $sBanner)
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)

;Informationen
Local $hInfoLabel = GUICtrlCreateLabel("", 310, 35, 475, 205)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT) ;$GUI_BKCOLOR_TRANSPARENT; $COLOR_RED
GUICtrlSetFont(-1, 12, 400, 0, "")
;GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)

Local $sInfoFilePath = @WorkingDir & "\LP-Data\LPInfos.txt"
Local $sInfoFileContent = FileRead($sInfoFilePath)
GUICtrlSetData($hInfoLabel, $sInfoFileContent)
;GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)


; Dashboard
Local $oIE = ObjCreate("Shell.Explorer.2")
Local $IECtrl = GUICtrlCreateObj($oIE, 10, 250, 390, 310)

$oIE.navigate("https://lostparadise.eu/wcf/lexicon/index.php?entry/31-serverrestarts-wann-sind-diese/") ;Website
While $oIE.ReadyState <> 4
	Sleep(50)
WEnd
Local $oDoc = $oIE.document
$oDoc.parentWindow.execScript("document.body.innerHTML = document.getElementById('lexiconEntryContent').outerHTML;")

;Erstellung 2 Reiter
$hTab2 = GUICtrlCreateTabItem("Optionen")
GUICtrlSetColor(-1, 0xcdd8e0)

;Gruppe Parameter
GUICtrlCreateGroup("Startparameter", 258, 31, 264, 212)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
GUICtrlSetColor(-1, 0xcdd8e0)
$RunParameters = GUICtrlCreateEdit("", 268, 51, 244, 180, $ES_READONLY)
GUICtrlSetData(-1, "")
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Zusätzliche Parameter
GUICtrlCreateGroup(" zus Paramenter", 258, 253, 264, 222)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$AdditionalParameters = GUICtrlCreateEdit("", 268, 273, 244, 192)
GUICtrlSetData(-1, "")
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;Gruppe Laucher
$LauncherOptions = GUICtrlCreateGroup("Launcher Einstellungen", 6, 31, 250, 212)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$ShowScriptErrors = GUICtrlCreateCheckbox("Zeige Script Fehler", 16, 52, 200, 20)
GUICtrlSetTip(-1, "Zeige Ingame Script Errors")
GUICtrlSetColor(-1, 0xcdd8e0)
$NoPause = GUICtrlCreateCheckbox("Keine Pause", 16, 75, 200, 20)
GUICtrlSetTip(-1, "Pausiert nicht das Game wenn im Hintergrund")
$NoPauseAudio = GUICtrlCreateCheckbox("Keine Pause des Sounds", 16, 98, 200, 20)
GUICtrlSetTip(-1, "Pausiert nicht das Game-Audio wenn im Hintergrund")
$WindowMode = GUICtrlCreateCheckbox("Window Mode", 16, 121, 200, 20)
GUICtrlSetTip(-1, "Zeigt das Game im Fenstermodus an")
$FilePatching = GUICtrlCreateCheckbox("Ungepackte Dateien laden", 16, 144, 200, 20)
GUICtrlSetTip(-1, "Erlaubt das Game ungepackte Files zu laden")
$CheckSignatures = GUICtrlCreateCheckbox("Überprüfe Signaturen", 16, 167, 200, 20)
GUICtrlSetTip(-1, "Überprüfe Signaturen von PBO Files")
$EnableBattlEye = GUICtrlCreateCheckbox("Aktiviere BattlEye", 16, 190, 200, 20) ; Disabled da immer nötig
GUICtrlSetTip(-1, "Unter Lostparadise.eu immer nötig")
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;Gruppe Performance
GUICtrlCreateGroup("Leistung", 6, 253, 250, 222)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$EnableHT = GUICtrlCreateCheckbox("Aktiviere Hyper-Threading", 16, 276, 200, 20)
GUICtrlSetTip(-1, "Aktiviert Hyper-Threading")
$HugePages = GUICtrlCreateCheckbox("Große Speicherseiten", 16, 300, 200, 20)
$NoSplash = GUICtrlCreateCheckbox("Keine Default-Arma3 Splash Screens", 16, 325, 200, 20)
GUICtrlSetTip(-1, "Deaktiviert Default-Arma3 Splash Screens")
$NoLogs = GUICtrlCreateCheckbox("Deaktiviert RPT-Logging", 16, 350, 200, 20)
GUICtrlSetTip(-1, "Deaktiviert RPT-Logging")
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;Gruppe Arma3 Exe
GUICtrlCreateGroup("Arma III Executable mit BattlEye", 6, 485, 516, 52)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$ExecutablePath = GUICtrlCreateInput("", 16, 505, 420, 22)
$ExecutablePathSelect = GUICtrlCreateButton("Durchsuchen", 446, 505, 70, 20)
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Update
GUICtrlCreateGroup("Update", 524, 31, 172, 65)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Arma3SyncUpdate = GUICtrlCreateButton("Nach Updates suchen", 538, 56, 143, 25)
GUICtrlSetTip(-1, "Update Arma3Sync")
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Debug
GUICtrlCreateGroup("Debug", 524, 103, 172, 65)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Arma3SyncDebug = GUICtrlCreateCheckbox("Debug", 533, 128, 60, 25)
GUICtrlSetTip(-1, "Zeigt alles im Output an")
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Mods
GUICtrlCreateGroup("Auswahl Mods", 524, 172, 172, 65)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Arma3SyncDebug = GUICtrlCreateCheckbox("Mod1", 533, 128, 60, 25)
GUICtrlSetTip(-1, "Zeigt alles im Output an")
GUICtrlSetBkColor(-1, 0x252729)
GUICtrlSetColor(-1, 0xcdd8e0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateTabItem("")

LoadSettings()
_UpdateParameters()
_SyncInfos()

GUISetState(@SW_SHOW)

GUICtrlSetState($hTab2, $GUI_HIDE)
GUICtrlSetState($hTab1, $GUI_SHOW)

; Haupt-Loop
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $ButtonExit
			SaveSettings()
			ExitLoop
		Case $hTab
			Switch _GUICtrlTab_GetCurSel($hTab)
				Case 0 ; Tab 1 ausgewählt
					;GUICtrlSetState($Logo, $GUI_SHOW)
					GUICtrlSetState($LauncherOptions, $GUI_HIDE)
				Case 1 ; Tab 2 ausgewählt
					;GUICtrlSetState($Logo, $GUI_HIDE)
					;GUICtrlSetState($Logo, $GUI_HIDE)
					GUICtrlSetState($LauncherOptions, $GUI_SHOW)
			EndSwitch
		Case $SyncButton
			_SyncButtonClick()
		Case $LPLaunchButton

		Case $ShowScriptErrors
			_UpdateParameters()
		Case $NoPause
			_UpdateParameters()
		Case $NoPauseAudio
			_UpdateParameters()
		Case $WindowMode
			_UpdateParameters()
		Case $FilePatching
			_UpdateParameters()
		Case $CheckSignatures
			_UpdateParameters()
		Case $EnableBattlEye
			_UpdateParameters()

		Case $EnableHT
			_UpdateParameters()
		Case $HugePages
			_UpdateParameters()
		Case $NoSplash
			_UpdateParameters()
		Case $NoLogs
			_UpdateParameters()
		Case $ExecutablePathSelect
			Local $sFile = FileOpenDialog("Wähle die arma3battleye.exe Datei", "C:\", "Executables (*.exe)", 1)
			If @error Then
				GUICtrlSetData($ExecutablePath, "Keine Datei ausgewählt")
			Else
				If StringInStr($sFile, "arma3battleye") Then
					GUICtrlSetData($ExecutablePath, $sFile)
				Else
					GUICtrlSetData($ExecutablePath, "Eine .exe ausgewählt, die jedoch nicht arma3battleye ist")
				EndIf
			EndIf
		Case $Arma3SyncUpdate
			_UpdateArma3SyncButtonClick()

	EndSwitch
	Sleep(50)
WEnd

Func _Exit()
	Exit
EndFunc   ;==>_Exit


#cs
#ce
Func _SyncButtonClick()
	Local $sOutput = ""
	Local $iExitStatus = 0
	Local $sExitMessage = "Sync completed successfully."

	GUICtrlSetState($SyncButton, $GUI_HIDE)
	GUICtrlSetState($SyncButtonCancel, $GUI_SHOW)
	GUICtrlSetState($SyncButtonCancel, $GUI_DISABLE)
	GUICtrlSetState($LPLaunchButton, $GUI_DISABLE)
	_SyncInfos()

	Local $sCommand = 'java -jar "' & @WorkingDir & '\ArmA3Sync.jar" -SYNC "[GER] LostParadise - HohensteinLife - DEVELOPMENT" "C:\Program Files (x86)\Steam\steamapps\common\Arma 3" False'
	$iPID = Run($sCommand, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)

	If @error Then
		MsgBox(16, "Error", "Failed to run command: " & @error)
		Return
	EndIf

	GUICtrlSetFont($Output, 9, 400, 0, "")

	While 1
		#cs
		      Switch GUIGetMsg()
		          Case $SyncButtonCancel
		              GUICtrlSetState($SyncButton, $GUI_SHOW)
		              GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
		              GUICtrlSetState($LPLaunchButton, $GUI_DISABLE)
		              $iExitStatus = 1
		              $sExitMessage = "Sync was cancelled by user."
		              ExitLoop
		      EndSwitch
		#ce

		Local $sLine = StdoutRead($iPID)

		If @error Then
			Local $iError = @error
			Local $sErrorDesc = "Unknown error"
			Switch $iError
				Case 1
					;$sErrorDesc = "StdoutRead encountered a problem"
				Case 2
					$sErrorDesc = "Der HintergrundProzess dafür wurde beendet"
				Case 3
					$sErrorDesc = "Die Prozess-ID ist ungültig"
			EndSwitch
			GUICtrlSetState($SyncButton, $GUI_SHOW)
			GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
			GUICtrlSetState($LPLaunchButton, $GUI_ENABLE)
			$iExitStatus = 2
			$sExitMessage = "Error: " & $iError & " - " & $sErrorDesc
			ExitLoop
		EndIf

		If $sLine <> "" Then

			; Überprüfen, ob die Checkbox "$Arma3SyncDebug" gecheckt ist
			If GUICtrlRead($Arma3SyncDebug) = $GUI_CHECKED Then
				; Zeige alle Zeilen an
				$sOutput &= $sLine
			Else
				; Zeige nur Zeilen mit den gewünschten Schlüsselwörtern an
				If StringInStr($sLine, "Synchronising with repository") Or StringInStr($sLine, "Number of files to") Or StringInStr($sLine, "Download complete:") Then
					$sOutput &= $sLine
				EndIf
			EndIf
			#cs
			            ; Begrenze Länge von $sOutput auf 1.000 Zeichen
			            If StringLen($sOutput) > 1000 Then
			                $sOutput = StringTrimLeft($sOutput, StringLen($sOutput) - 1000)
			            EndIf
			#ce
			GUICtrlSetData($Output, $sOutput)
			_GUICtrlEdit_LineScroll($Output, 0, _GUICtrlEdit_GetLineCount($Output))
		EndIf

		Sleep(200) ; CPU entlasten
	WEnd

	; Zeige eine abschließende Nachricht an
	; MsgBox(64, "Sync Status", $sExitMessage)
	; Setze die Steuerelemente zurück
	GUICtrlSetState($SyncButton, $GUI_SHOW)
	GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButton, $GUI_ENABLE)
EndFunc   ;==>_SyncButtonClick


Func _SyncButtonCancelClick()
	If $iPID <> 0 Then
		ProcessClose($iPID)
		$iPID = 0
	EndIf
	GUICtrlSetState($SyncButton, $GUI_ENABLE)
	GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButton, $GUI_ENABLE)
EndFunc   ;==>_SyncButtonCancelClick

Func _SyncInfos()
	Local $sInfoUrl = "https://cloud.sbe.de/s/9AxjmkDGRq4SyR4/download/LP-Launcher-Infos.txt"
	Local $sInfoFilePath = @WorkingDir & "\LP-Data\LPInfos.txt"
	Local $kDownload = InetGet($sInfoUrl, $sInfoFilePath, 1, 1)
	Do
		Sleep(100)
	Until InetGetInfo($kDownload, $INET_DOWNLOADCOMPLETE) = 1
	InetClose($kDownload)
	Local $sInfoFileContent = FileRead($sInfoFilePath)
	GUICtrlSetData($hInfoLabel, $sInfoFileContent)
EndFunc   ;==>_SyncInfos

Func _UpdateParameters()
	GUICtrlSetState($EnableBattlEye, $GUI_CHECKED)
	$sParameters = ""

	If BitAND(GUICtrlRead($ShowScriptErrors), $GUI_CHECKED) Then $sParameters &= "-ShowScriptErrors" & @CRLF
	If BitAND(GUICtrlRead($NoPause), $GUI_CHECKED) Then $sParameters &= "-noPause" & @CRLF
	If BitAND(GUICtrlRead($NoPauseAudio), $GUI_CHECKED) Then $sParameters &= "-noPauseAudio" & @CRLF
	If BitAND(GUICtrlRead($WindowMode), $GUI_CHECKED) Then $sParameters &= "-window" & @CRLF
	If BitAND(GUICtrlRead($FilePatching), $GUI_CHECKED) Then $sParameters &= "-filePatching" & @CRLF
	If BitAND(GUICtrlRead($CheckSignatures), $GUI_CHECKED) Then $sParameters &= "-checkSignatures" & @CRLF
	If BitAND(GUICtrlRead($EnableBattlEye), $GUI_CHECKED) Then $sParameters &= "-enableBattlEye" & @CRLF

	If BitAND(GUICtrlRead($EnableHT), $GUI_CHECKED) Then $sParameters &= "-EnableHT" & @CRLF
	If BitAND(GUICtrlRead($HugePages), $GUI_CHECKED) Then $sParameters &= "-hugePages" & @CRLF
	If BitAND(GUICtrlRead($NoSplash), $GUI_CHECKED) Then $sParameters &= "-noSplash" & @CRLF
	If BitAND(GUICtrlRead($NoLogs), $GUI_CHECKED) Then $sParameters &= "-noLogs" & @CRLF


	GUICtrlSetData($RunParameters, $sParameters)
EndFunc   ;==>_UpdateParameters


Func SaveSettings()
	IniWrite($ParainiFile, "Options", "ShowScriptErrors", GUICtrlRead($ShowScriptErrors))
	IniWrite($ParainiFile, "Options", "NoPause", GUICtrlRead($NoPause))
	IniWrite($ParainiFile, "Options", "WindowMode", GUICtrlRead($WindowMode))
	IniWrite($ParainiFile, "Options", "FilePatching", GUICtrlRead($FilePatching))
	IniWrite($ParainiFile, "Options", "CheckSignatures", GUICtrlRead($CheckSignatures))
	IniWrite($ParainiFile, "Options", "EnableBattlEye", GUICtrlRead($EnableBattlEye))

	IniWrite($ParainiFile, "Performance", "EnableHT", GUICtrlRead($EnableHT))
	IniWrite($ParainiFile, "Performance", "HugePages", GUICtrlRead($HugePages))
	IniWrite($ParainiFile, "Performance", "NoSplash", GUICtrlRead($NoSplash))
	IniWrite($ParainiFile, "Performance", "NoLogs", GUICtrlRead($NoLogs))

	IniWrite($ParainiFile, "AddParamters", "AddPara", GUICtrlRead($AdditionalParameters))

	IniWrite($ParainiFile, "Arma3exe", "ExePath", GUICtrlRead($ExecutablePath))
EndFunc   ;==>SaveSettings

Func LoadSettings()
	GUICtrlSetState($ShowScriptErrors, IniRead($ParainiFile, "Options", "ShowScriptErrors", $GUI_UNCHECKED))
	GUICtrlSetState($NoPause, IniRead($ParainiFile, "Options", "NoPause", $GUI_UNCHECKED))
	GUICtrlSetState($WindowMode, IniRead($ParainiFile, "Options", "WindowMode", $GUI_UNCHECKED))
	GUICtrlSetState($FilePatching, IniRead($ParainiFile, "Options", "FilePatching", $GUI_UNCHECKED))
	GUICtrlSetState($CheckSignatures, IniRead($ParainiFile, "Options", "CheckSignatures", $GUI_UNCHECKED))
	GUICtrlSetState($EnableBattlEye, IniRead($ParainiFile, "Options", "EnableBattlEye", $GUI_UNCHECKED))

	GUICtrlSetState($EnableHT, IniRead($ParainiFile, "Performance", "EnableHT", $GUI_UNCHECKED))
	GUICtrlSetState($HugePages, IniRead($ParainiFile, "Performance", "HugePages", $GUI_UNCHECKED))
	GUICtrlSetState($NoSplash, IniRead($ParainiFile, "Performance", "NoSplash", $GUI_UNCHECKED))
	GUICtrlSetState($NoLogs, IniRead($ParainiFile, "Performance", "NoLogs", $GUI_UNCHECKED))

	GUICtrlSetData($AdditionalParameters, IniRead($ParainiFile, "AddParamters", "AddPara", ""))

	GUICtrlSetData($ExecutablePath, IniRead($ParainiFile, "Arma3exe", "ExePath", ""))
EndFunc   ;==>LoadSettings

Func _UpdateArma3SyncButtonClick()
	GUICtrlSetState($SyncButton, $GUI_DISABLE)
	GUICtrlSetState($LPLaunchButton, $GUI_DISABLE)
	GUICtrlSetState($Arma3SyncUpdate, $GUI_DISABLE)

	Local $sCommand2 = 'java -jar "' & @WorkingDir & '\ArmA3Sync.jar" -UPDATE' ; Arma3Sync Update-CMD-Befehl
	;MsgBox(0,"SyncUpdate", $sCommand2)
	$iPID = Run($sCommand2, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $sOutput = ""
	GUICtrlSetFont($Output, 9, 400, 0, "")

	While 1
		Local $sLine = StdoutRead($iPID)
		If @error Then
			GUICtrlSetState($SyncButton, $GUI_ENABLE)
			GUICtrlSetState($LPLaunchButton, $GUI_ENABLE)
			GUICtrlSetState($Arma3SyncUpdate, $GUI_ENABLE)
			ExitLoop
		EndIf

		$sOutput &= $sLine
		GUICtrlSetData($Output, $sOutput)
		_GUICtrlEdit_LineScroll($Output, 0, _GUICtrlEdit_GetLineCount($Output))

		Sleep(50) ; CPU entlasten
	WEnd

	GUICtrlSetState($SyncButton, $GUI_ENABLE)
	GUICtrlSetState($LPLaunchButton, $GUI_ENABLE)
	GUICtrlSetState($Arma3SyncUpdate, $GUI_ENABLE)
EndFunc   ;==>_UpdateArma3SyncButtonClick


Func _GUICtrlPic_Create($sFilename, $iLeft, $iTop, $iWidth = -1, $iHeight = -1, $iStyle = -1, $iExStyle = -1)
	_GDIPlus_Startup()
	Local $idPic = GUICtrlCreatePic("", $iLeft, $iTop, $iWidth, $iHeight, $iStyle, $iExStyle)
	Local $hBitmap = _GDIPlus_BitmapCreateFromFile($sFilename)
	If $iWidth = -1 Then $iWidth = _GDIPlus_ImageGetWidth($hBitmap)
	If $iHeight = -1 Then $iHeight = _GDIPlus_ImageGetHeight($hBitmap)
	Local $hBitmap_Resized = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
	Local $hBMP_Ctxt = _GDIPlus_ImageGetGraphicsContext($hBitmap_Resized)
	_GDIPlus_GraphicsSetInterpolationMode($hBMP_Ctxt, $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC)
	_GDIPlus_GraphicsDrawImageRect($hBMP_Ctxt, $hBitmap, 0, 0, $iWidth, $iHeight)
	Local $hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap_Resized)
	Local $hPrevImage = GUICtrlSendMsg($idPic, $STM_SETIMAGE, 0, $hHBitmap)     ; $STM_SETIMAGE = 0x0172
	_WinAPI_DeleteObject($hPrevImage)    ; Delete Prev image if any
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap_Resized)
	_GDIPlus_GraphicsDispose($hBMP_Ctxt)
	_WinAPI_DeleteObject($hHBitmap)
	_GDIPlus_Shutdown()

	Return $idPic
EndFunc   ;==>_GUICtrlPic_Create

Func UpdateGUI()
	Sleep(50)
EndFunc   ;==>UpdateGUI

#cs
Func WM_LBUTTONDOWN($hWnd, $iMsg, $wParam, $lParam)
    If BitAND(WinGetState($hWnd), 32) Then Return $GUI_RUNDEFMSG
    DllCall("user32.dll", "long", "SendMessage", "hwnd", $hWnd, "int", $WM_SYSCOMMAND, "int", 0xF009, "int", 0)
EndFunc
#ce

;FileDelete($sTempIni)


