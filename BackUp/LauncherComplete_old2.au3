#cs ----------------------------------------------------------------------------

 Author: BattleNogare

 Script Function:
    Lostparadise.eu Arma3Sync-GUI-Launcher

#ce ----------------------------------------------------------------------------

#include <IE.au3>
#include <File.au3>
#include <Array.au3>
#include <Inet.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
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

#AutoIt3Wrapper_icon=LPicon.ico

; Log-Datei
Local $sLogFilePath = @WorkingDir & "\LP-Data\Launcher-Log.txt"
Local $hLogFile = FileOpen($sLogFilePath, 9)
Local $sTimeStamp = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC

; Config.ini-File
Local $sUrl = "https://raw.githubusercontent.com/BattleNogare/Lostparadsie.eu-Launcher/main/config.ini"
Local $sData = _INetGetSource($sUrl)
Local $sTempIni = @WorkingDir & "\LP-Data\temp_config.ini"
If FileExists($sTempIni) Then
	FileDelete($sTempIni)
EndIf
FileWrite($sTempIni, $sData)
$IniDefaultwert = "Wert nicht gefunden"


; �berpr�fen, ob das Skript mit dem Parameter "Update" aufgerufen wurde
If $CmdLine[0] > 0 And $CmdLine[1] = "Update" Then

	; LauncherUpdate
	FileWrite($hLogFile, $sTimeStamp & " - " & "LauncherUpdate wird ausgef�hrt")

	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Versionen sind nicht gleich; Starte Update" & @CRLF)
	Local $updatefenster = GUICreate("Bitte warten...", 300, 100, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
	Local $label = GUICtrlCreateLabel("Bitte warten, bis die Aktualisierung abgeschlossen ist.", 10, 10, 280, 20, $SS_CENTER)
	Local $progressbar = GUICtrlCreateProgress(10, 40, 280, 20, $PBS_SMOOTH)
	Local $progresstext = GUICtrlCreateLabel("Aktualisierung startet...", 10, 65, 280, 20, $SS_CENTER)
	GUICtrlSetData($progressbar, 0)
	$progressbari = 1
	GUICtrlSetFont($progresstext, 10, 400)
	GUISetState(@SW_SHOW, $updatefenster)

	GUICtrlSetData($progresstext, "Entferne alte Dateien")
	GUICtrlSetData($progressbar, 10)


	FileDelete(@WorkingDir & "\LP_Launcher.exe")
	FileDelete(@WorkingDir & "\LP-Data\background.jpg")
	FileDelete(@WorkingDir & "\LP-Data\LP-Logo.png")
	FileDelete(@WorkingDir & "\LP-Data\syncdata.png")
	FileDelete(@WorkingDir & "\LP-Data\syncdata-stop.png")
	FileDelete(@WorkingDir & "\LP-Data\lostparadisestart.png")
	FileDelete(@WorkingDir & "\LP-Data\LPicon.ico")
	FileDelete(@WorkingDir & "\LP-Data\LauncherText.txt")
	FileDelete(@WorkingDir & "\LP-Data\lostparadisestartdisabled.png")

	FileWrite($hLogFile, $sTimeStamp & " - " & "Vorherige Dateien gel�scht")

	Local $aPID[8]

	GUICtrlSetData($progresstext, "Lade neue Dateien")
	GUICtrlSetData($progressbar, 20)

	Local $sDownloadExe = @WorkingDir & "\download.exe"
	Run('"' & $sDownloadExe & '" "LP_Launcher.exe" "LP_Launcher_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "background.jpg" "background_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "LP-Logo.png" "LP-Logo_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "syncdata.png" "syncdata_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "syncdata-stop.png" "syncdata-stop_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "lostparadisestart.png" "lostparadisestart_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "lostparadisestartdisabled.png" "lostparadisestartdisabled_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "LPicon.ico" "LPicon_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)
	Run('"' & $sDownloadExe & '" "LauncherText.txt" "LauncherText_dest" "' & $sTempIni & '"', @ScriptDir)
	Sleep(100)

	For $i = 0 To UBound($aPID) - 1
		If $aPID[$i] Then
			ProcessWaitClose($aPID[$i])
		EndIf
	Next

	GUICtrlSetData($progresstext, "Einlesen Online Repository-Daten")
	GUICtrlSetData($progressbar, 30)

	; INI-Daten lesen
	Local $repositoryname = IniRead($sTempIni, "Repository", "repositoryname", $IniDefaultwert)
	Local $repositoryprotocol = IniRead($sTempIni, "Repository", "repositoryprotocol", $IniDefaultwert)
	Local $repositoryport = IniRead($sTempIni, "Repository", "repositoryport", $IniDefaultwert)
	Local $repositoryuserlogin = IniRead($sTempIni, "Repository", "userlogin", $IniDefaultwert)
	Local $repositoryuserpassword = IniRead($sTempIni, "Repository", "userpassword", $IniDefaultwert)
	Local $repositoryurl = IniRead($sTempIni, "Repository", "repositoryurl", $IniDefaultwert)

	GUICtrlSetData($progresstext, "Einlesen Lokaler Repository-Daten")
	GUICtrlSetData($progressbar, 40)

	; Pfad zur Console.Bat
	Local $sBatchFilePath = @WorkingDir & '\ArmA3Sync-console.bat'
	Local $sDirectory = @WorkingDir
	#cs
		Local $sCommand = $sBatchFilePath
		$iPID = Run($sCommand, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)

		If @error Then
			MsgBox(16, "Error", "Failed to run command: " & @error)
		EndIf
	#ce
	; CMD - Hide, erstelle das Fenster
	Local $iPID = Run(@ComSpec & " /k cd /d " & '"' & $sDirectory & '"' & " && " & '"' & $sBatchFilePath & '"', "", @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD + $STDERR_CHILD)


	Sleep(1000)
	Local $LocalRepo = ""
	Local $sFolderPath = @WorkingDir & "\resources\ftp"

	; �berpr�fen, ob im ftp-Ordner was existiert
	If FileExists($sFolderPath) Then
		Local $hSearch = FileFindFirstFile($sFolderPath & "\*")

		If $hSearch = -1 Then
			$LocalRepo = "0"
		Else
			Local $sFile = FileFindNextFile($hSearch)
			FileClose($hSearch)
			If @error Then
				$LocalRepo = "0"
			Else
				Local $iPos = StringInStr($sFile, ".", 0, 1)
				If $iPos > 0 Then
					$sFile = StringLeft($sFile, $iPos - 1)
				EndIf
				Local $LocalRepo = $sFile
			EndIf
		EndIf
	Else
		$LocalRepo = "2"
	EndIf

	If $LocalRepo = "0" Then

		GUICtrlSetData($progresstext, "Erstelle Repository")
		GUICtrlSetData($progressbar, 40)
		; Eingabe Repo
		StdinWrite($iPID, "NEW" & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryname & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryprotocol & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryport & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryuserlogin & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryuserpassword & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryurl & @CRLF)
		Sleep(100)
		StdinWrite($iPID, @CRLF)
		Sleep(100)
		StdinWrite($iPID, "QUIT" & @CRLF)
		Sleep(100)
		StdinWrite($iPID, " ")

		; Exit
		StdinWrite($iPID, "exit" & @CRLF)

	Else
		GUICtrlSetData($progresstext, "�ndere bestehendes Repository")
		GUICtrlSetData($progressbar, 40)
		FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Repository hat sich ge�ndert; wird neu angelegt" & @CRLF)
		Sleep(100)
		StdinWrite($iPID, "DELETE" & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $LocalRepo & @CRLF)
		Sleep(200)
		StdinWrite($iPID, "NEW" & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryname & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryprotocol & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryport & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryuserlogin & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryuserpassword & @CRLF)
		Sleep(100)
		StdinWrite($iPID, $repositoryurl & @CRLF)
		Sleep(100)
		StdinWrite($iPID, @CRLF)
		Sleep(100)
		StdinWrite($iPID, "QUIT" & @CRLF)
		Sleep(100)
		StdinWrite($iPID, " ")

		; Exit
		StdinWrite($iPID, "exit" & @CRLF)

	EndIf

	; Kill CMD
	If ProcessExists($iPID) Then
		ProcessClose($iPID)
		Sleep(1000)
	EndIf

	Local $ClientVersionFile = @WorkingDir & "\LP-Data\version.txt"
	Local $OnlineVersion = IniRead($sTempIni, "Version", "version", $IniDefaultwert)
	FileWrite($ClientVersionFile, $OnlineVersion)
	GUISetState(@SW_HIDE, $updatefenster)

Else
	; �berpr�fen auf neue Version
	; INI-Daten lesen
	Local $OnlineVersion = IniRead($sTempIni, "Version", "version", $IniDefaultwert)
	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Online Version: " & $OnlineVersion)

	; Lese Client Version
	Local $ClientVersionFile = @WorkingDir & "\LP-Data\version.txt"
	Local $ClientVersion = "0"
	If FileExists($ClientVersionFile) Then
		FileOpen($ClientVersionFile, 10)
		$ClientVersion = FileRead($ClientVersionFile)
	EndIf
	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Client Version: " & $ClientVersion)


	If $OnlineVersion <> $ClientVersion Then
		 Run('"' & @ScriptFullPath & '" Update', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD))

	Else
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)

$ParaIniFile = @WorkingDir & "\LP-Data\Launcherconfig.ini"
Global $sParameters = ""
Global $iPID = 0
Global $sOutput = ""
Local $sTempIni = @WorkingDir & "\LP-Data\temp_config.ini"
$IniDefaultwert = "Wert nicht gefunden"

Local $BKColor = IniRead($sTempIni, "Launcher", "BKColor", $IniDefaultwert)
Local $TextColor = IniRead($sTempIni, "Launcher", "TextColor", $IniDefaultwert)
Local $repositoryname = IniRead($sTempIni, "Repository", "repositoryname", $IniDefaultwert)

; GUI erstellen
$Form1 = GUICreate("[Lostparadise.eu]", 800, 570, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
;GUIRegisterMsg($WM_LBUTTONDOWN, "WM_LBUTTONDOWN")
GUICtrlSetDefColor($TextColor)
GUICtrlSetDefBkColor($BKColor)

GUISetIcon(@WorkingDir & "\LP-Data\LPicon.ico")

; Background Pic
$background = GUICtrlCreatePic(@WorkingDir & "\LP-Data\background.jpg", 0, 0, 800, 570)
GUICtrlSetState(-1, $GUI_DISABLE)

; Top Buttons
$LauncherTab = GUICtrlCreateButton("Launcher", 2, 2, 60, 18)
$OptionenTab = GUICtrlCreateButton("Optionen", 62, 2, 60, 18)
$Dashboard = GUICtrlCreateButton("Dashboard", 378, 2, 80, 18)
$Wiki = GUICtrlCreateButton("Wiki", 458, 2, 80, 18)
$ControlPanel = GUICtrlCreateButton("ControlPanel", 538, 2, 80, 18)
$TeamSpeak = GUICtrlCreateButton("TeamSpeak", 618, 2, 80, 18)
$Discord = GUICtrlCreateButton("Discord", 698, 2, 80, 18)

; Exit Button
$ButtonExit = GUICtrlCreateLabel("X", 780, 2, 18, 18, $SS_CENTER + $SS_CENTERIMAGE)
GUICtrlSetOnEvent($ButtonExit, "_Exit")
GUICtrlSetFont(-1, 12, 900, 0, "")
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)

; Erstelle Reiter
$hTab = GUICtrlCreateTab(0, 0, 800, 570)
;Reiter 1
$hTab1 = GUICtrlCreateTabItem("Launcher")

; Bild Logo
$Logo = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\LP-Logo.png", 10, 31, 280, 204)
GUICtrlSetState(-1, $GUI_DISABLE)

; Reparatur Label
$ReparaturLabel = GUICtrlCreateLabel("Check aller Dateien gestartet..." & @CRLF & "Dies kann einen Moment dauern...", 420 ,505, 355, 30,$SS_CENTER)
GUICtrlSetState($ReparaturLabel, $GUI_HIDE)

; Button Sync
$SyncButton = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\syncdata.png", 494, 505, 144, 54)

; Button Sync-Cancel
$SyncButtonCancel = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\syncdata-stop.png", 494, 505, 144, 54)
GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)

;Button Launch
$LPLaunchButton = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\lostparadisestart.png", 642, 505, 144, 54)
GUICtrlSetState($LPLaunchButton, $GUI_HIDE)

;Button Launch-Disabled
$LPLaunchButtonDisabled = _GUICtrlPic_Create(@WorkingDir & "\LP-Data\lostparadisestartdisabled.png", 642, 505, 144, 54)
GUICtrlSetState($LPLaunchButtonDisabled, $GUI_SHOW)



;CMD-Ausgabe
$Output = GUICtrlCreateEdit("", 410, 250, 375, 240, $ES_READONLY + $ES_AUTOHSCROLL)
GUICtrlSetData(-1, "")
Local $sBanner = "     __                 __   ____                           __ _                           " & @CRLF & _
		"    / /   ____   _____ / /_ / __ \ ____ _ _____ ____ _ ____/ /(_)_____ ___     ___   __  __" & @CRLF & _
		"   / /   / __ \ / ___// __// /_/ // __ `// ___// __ `// __  // // ___// _ \   / _ \ / / / /" & @CRLF & _
		"  / /___/ /_/ /(__  )/ /_ / ____// /_/ // /   / /_/ // /_/ // /(__  )/  __/_ /  __// /_/ / " & @CRLF & _
		" /_____/\____//____/ \__//_/     \__,_//_/    \__,_/ \__,_//_//____/ \___/(_)\___/ \__,_/  " & @CRLF

GUICtrlSetFont($Output, 5, 5000, 0, "Courier New") ;
GUICtrlSetData($Output, $sBanner)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)

;Informationen
Local $hInfoLabel = GUICtrlCreateLabel("", 310, 35, 475, 205)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT) ;$GUI_BKCOLOR_TRANSPARENT; $COLOR_RED
GUICtrlSetFont(-1, 12, 400, 0, "")
;GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)

Local $sInfoFilePath = @WorkingDir & "\LP-Data\LauncherText.txt"
Local $sInfoFileContent = FileRead($sInfoFilePath)
GUICtrlSetData($hInfoLabel, $sInfoFileContent)
;GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)

; Dashboard
Local $oIE = ObjCreate("Shell.Explorer.2")
Local $IECtrl = GUICtrlCreateObj($oIE, 10, 250, 390, 310)

Local $Inet = IniRead($sTempIni, "Launcher", "Inet", $IniDefaultwert)
Local $InetHTMLid = IniRead($sTempIni, "Launcher", "InetHTMLid", $IniDefaultwert)

$oIE.navigate($Inet)
While $oIE.ReadyState <> 4
	Sleep(50)
WEnd
Local $oDoc = $oIE.document
Local $oElement = $oDoc.getElementById($InetHTMLid)

If IsObj($oElement) Then
	Local $innerHTML = $oElement.outerHTML
	$oDoc.body.innerHTML = $innerHTML
Else
	;MsgBox(0, "Fehler", "Das Element mit der ID " & $InetHTMLid & " wurde nicht gefunden.")
EndIf

; Erstellung 2 Reiter
$hTab2 = GUICtrlCreateTabItem("Optionen")
GUICtrlSetColor(-1, $TextColor)

;Erstellung 2 Reiter
$hTab2 = GUICtrlCreateTabItem("Optionen")
GUICtrlSetColor(-1, $TextColor)

;Gruppe Parameter
GUICtrlCreateGroup("Startparameter", 258, 31, 264, 212)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
GUICtrlSetColor(-1, $TextColor)
$RunParameters = GUICtrlCreateEdit("", 268, 51, 244, 180, $ES_READONLY)
GUICtrlSetData(-1, "")
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;Gruppe Laucher
$LauncherOptions = GUICtrlCreateGroup("Launcher Einstellungen", 6, 31, 250, 212)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$ShowScriptErrors = GUICtrlCreateCheckbox("Zeige Script Fehler", 16, 52, 200, 20)
GUICtrlSetTip(-1, "Zeige Ingame Script Errors")
GUICtrlSetColor(-1, $TextColor)
$NoPause = GUICtrlCreateCheckbox("Keine Pause", 16, 75, 200, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, "Pausiert nicht das Game wenn im Hintergrund")
$NoPauseAudio = GUICtrlCreateCheckbox("Keine Pause des Sounds", 16, 98, 200, 20)
GUICtrlSetTip(-1, "Pausiert nicht das Game-Audio wenn im Hintergrund")
$WindowMode = GUICtrlCreateCheckbox("Window Mode", 16, 121, 200, 20)
GUICtrlSetTip(-1, "Zeigt das Game im Fenstermodus an")
$FilePatching = GUICtrlCreateCheckbox("Ungepackte Dateien laden", 16, 144, 200, 20)
GUICtrlSetTip(-1, "Erlaubt das Game ungepackte Files zu laden")
$CheckSignatures = GUICtrlCreateCheckbox("�berpr�fe Signaturen", 16, 167, 200, 20)
GUICtrlSetTip(-1, "�berpr�fe Signaturen von PBO Files")
$EnableBattlEye = GUICtrlCreateCheckbox("Aktiviere BattlEye", 16, 190, 200, 20) ; Disabled da immer n�tig
GUICtrlSetTip(-1, "Unter Lostparadise.eu immer n�tig")
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)

;Gruppe Performance
GUICtrlCreateGroup("Leistung", 6, 253, 250, 222)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$EnableHT = GUICtrlCreateCheckbox("Aktiviere Hyper-Threading", 16, 276, 200, 20)
GUICtrlSetTip(-1, "Aktiviert Hyper-Threading")
$HugePages = GUICtrlCreateCheckbox("Gro�e Speicherseiten", 16, 300, 200, 20)
$NoSplash = GUICtrlCreateCheckbox("Keine Default-Arma3 Splash Screens", 16, 325, 200, 20)
GUICtrlSetTip(-1, "Deaktiviert Default-Arma3 Splash Screens")
$NoLogs = GUICtrlCreateCheckbox("Deaktiviert RPT-Logging", 16, 350, 200, 20)
GUICtrlSetTip(-1, "Deaktiviert RPT-Logging")
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;Gruppe Arma3 Exe
GUICtrlCreateGroup("Arma III Executable mit BattlEye", 6, 485, 516, 52)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$ExecutablePath = GUICtrlCreateInput("", 16, 505, 420, 22)
$ExecutablePathSelect = GUICtrlCreateButton("Durchsuchen", 446, 505, 70, 20)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Update
GUICtrlCreateGroup("Update", 524, 31, 172, 65)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Arma3SyncUpdate = GUICtrlCreateButton("Nach Updates suchen", 538, 56, 143, 25)
GUICtrlSetTip(-1, "Update Arma3Sync")
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Debug
GUICtrlCreateGroup("Debug", 524, 104, 172, 65)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Arma3SyncDebug = GUICtrlCreateCheckbox("Debug", 533, 128, 60, 25)
GUICtrlSetTip(-1, "Zeigt alles im Ausgabefeld an")
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Reparatur
GUICtrlCreateGroup("Reparatur", 524, 178, 172, 65)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
$Arma3SyncCheck = GUICtrlCreateButton("�berpr�fe Daten", 538, 202, 143, 25)
GUICtrlSetTip(-1, "�berpr�ft alle Mod-Daten")
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetColor(-1, $TextColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Gruppe Mod-Auswahl
GUICtrlCreateGroup("Mod-Auswahl", 258, 253, 264, 105)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
GUICtrlSetColor(-1, $TextColor)
$ModPack = GUICtrlCreateCheckbox("Lostparadise Arma3", 265, 277, 180, 25)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$ModPackOptional = GUICtrlCreateCheckbox("Lostparadise Optional", 265, 309, 180, 25)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)

#cs
; Gruppe Repository
$RepoGroup = GUICtrlCreateGroup("Repository-Auswahl", 258, 370, 264, 105)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
GUICtrlSetColor(-1, $TextColor)
$RepoLife = GUICtrlCreateCheckbox("Hohenstein-Life", 265, 389, 180, 25)
GUICtrlSetBkColor(-1, $BKColor)
$RepoDev = GUICtrlCreateCheckbox("Hohenstein-Life Dev", 265, 421, 180, 25)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, @SW_HIDE)

; Gruppe Dev
$DevGroup = GUICtrlCreateGroup("Dev", 524, 253, 172, 222)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
GUICtrlSetColor(-1, $TextColor)
$ListRepos = GUICtrlCreateButton("ListRepos", 538, 277, 143, 25)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetTip(-1, "List Repos")
$ListRepos = GUICtrlCreateButton("EditRepos", 538, 309, 143, 25)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetTip(-1, "Edit Repos")
$SyncDev = GUICtrlCreateButton("SyncDev", 538, 389, 143, 25)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetTip(-1, "Sync Dev Repo")
$SyncDev = GUICtrlCreateButton("Start Arma mit Dev", 538, 421, 143, 25)
GUICtrlSetBkColor(-1, $BKColor)
GUICtrlSetTip(-1, "Starte Arma mit Dev Repo")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState(-1, @SW_HIDE)
#ce

GUICtrlCreateTabItem("")

LoadSettings()
_UpdateParameters()


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
				Case 0 ; Tab 1 ausgew�hlt
					;GUICtrlSetState($Logo, $GUI_SHOW)
					GUICtrlSetState($LauncherOptions, $GUI_HIDE)

				Case 1 ; Tab 2 ausgew�hlt
					;GUICtrlSetState($Logo, $GUI_HIDE)
					;GUICtrlSetState($Logo, $GUI_HIDE)
					GUICtrlSetState($LauncherOptions, $GUI_SHOW)

			EndSwitch
		Case $SyncButton
			_SyncButtonClick()
		Case $LPLaunchButton
			;FileDelete($sTempIni)
		Case $LauncherTab
			GUICtrlSetState($hTab1, $GUI_SHOW)
			GUICtrlSetState($hTab2, $GUI_HIDE)
		Case $OptionenTab
			GUICtrlSetState($hTab2, $GUI_SHOW)
			GUICtrlSetState($hTab1, $GUI_HIDE)
		Case $Dashboard
			$sURL1 = "https://lostparadise.eu/"
			ShellExecute($sURL1)
			Sleep(200)
		Case $Wiki
			$sURL2 = "https://lostparadise.eu/wcf/lexicon/index.php"
			ShellExecute($sURL2)
			Sleep(200)
		Case $ControlPanel
			$sURL3 = "https://lostparadise.eu/controlpanel/index.php"
			ShellExecute($sURL3)
			Sleep(200)
		Case $TeamSpeak
			$sURL4 = "ts3server://ts.lostparadise.eu?port=9987"
			ShellExecute($sURL4)
			Sleep(200)
		Case $Discord
			$sURL5 = "https://discord.gg/sKTYkSJMTd"
			ShellExecute($sURL5)
			Sleep(200)


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
			Local $sFile = FileOpenDialog("W�hle die arma3battleye.exe Datei", "C:\", "Executables (*.exe)", 1)
			If @error Then
				GUICtrlSetData($ExecutablePath, "Keine Datei ausgew�hlt")
			Else
				If StringInStr($sFile, "arma3battleye") Then
					GUICtrlSetData($ExecutablePath, $sFile)
				Else
					GUICtrlSetData($ExecutablePath, "Eine .exe ausgew�hlt, die jedoch nicht arma3battleye ist")
				EndIf
			EndIf
		Case $Arma3SyncUpdate
			_UpdateArma3SyncButtonClick()
		Case $Arma3SyncCheck
			_CheckArma3SyncRepoClick()

	EndSwitch
	Sleep(50)
WEnd

Func _Exit()
	;FileDelete($sTempIni)
	Exit
EndFunc   ;==>_Exit

Func _SyncButtonClick()
	Local $sOutput = ""
	$sOutput = "Synchronisation gestartet..." & @CRLF
	Local $iExitStatus = 0
	Local $sExitMessage = "Sync completed successfully."

	GUICtrlSetState($SyncButton, $GUI_HIDE)
	GUICtrlSetState($SyncButtonCancel, $GUI_SHOW)
	GUICtrlSetState($LPLaunchButton, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButtonDisabled, $GUI_SHOW)

	Local $sCommand = 'java -jar "' & @WorkingDir & '\ArmA3Sync.jar" -SYNC "' & $repositoryname & '" "C:\Program Files (x86)\Steam\steamapps\common\Arma 3" False'
	;MsgBox(0,"SyncUpdate", $sCommand)
	$iPID = Run($sCommand, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)

	If @error Then
		MsgBox(16, "Error", "Failed to run command: " & @error)
		Return
	EndIf

	GUICtrlSetFont($Output, 9, 400, 0, "")

	While 1

		      Switch GUIGetMsg()
		          Case $SyncButtonCancel
		              GUICtrlSetState($SyncButton, $GUI_SHOW)
		              GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
		              GUICtrlSetState($LPLaunchButton, $GUI_HIDE)
					  GUICtrlSetState($LPLaunchButtonDisabled, $GUI_SHOW)
		              $iExitStatus = 1
		              $sExitMessage = "Sync was cancelled by user."
		              ExitLoop
		      EndSwitch


		Local $sLine = StdoutRead($iPID)

		If @error Then
			Local $iError = @error
			Local $sErrorDesc = "Unknown error"
			Switch $iError
				Case 1
					;$sErrorDesc = "StdoutRead encountered a problem"
				Case 2
					$sErrorDesc = "Der HintergrundProzess daf�r wurde beendet"
				Case 3
					$sErrorDesc = "Die Prozess-ID ist ung�ltig"
			EndSwitch
			GUICtrlSetState($SyncButton, $GUI_SHOW)
			GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
			GUICtrlSetState($LPLaunchButton, $GUI_SHOW)
			GUICtrlSetState($LPLaunchButtonDisabled, $GUI_HIDE)
			$iExitStatus = 2
			$sExitMessage = "Error: " & $iError & " - " & $sErrorDesc
			ExitLoop
		EndIf

		If $sLine <> "" Then

			If GUICtrlRead($Arma3SyncDebug) = $GUI_CHECKED Then
				$sOutput &= $sLine
			Else
				Select
					Case StringInStr($sLine, "Number of files to update")
						$sLine = StringReplace($sLine, "Number of files to update = ", "Anzahl der ge�nderten Dateien = ")
						$sLine = StringReplace($sLine, "Update files size:", "Aktualisierte Dateigr��e:")
						$sLine = StringReplace($sLine, "Number of files to delete", "Anzahl der gel�schten Dateien")
						$sLine = StringReplace($sLine, "Synchronization with repository ", "Synchronisation mit Repository ")
						$sLine = StringReplace($sLine, "Downloading from repository", "Lade von Repository")
						$sOutput &= $sLine

					Case StringInStr($sLine, "Download complete")
						$sLine = StringReplace($sLine, "Download complete: ","Herunterladen: ")
						$sLine = StringReplace($sLine, "Uncompressing file: ","Entpacke: ")
						$sLine = StringReplace($sLine, "Downloading file", "Lade Datei")

						$sOutput &= $sLine

					Case StringInStr($sLine, "Uncompressing file:")
					Case StringInStr($sLine, "Downloading file:")
					Case StringInStr($sLine, "Downloading from repository")
					Case StringInStr($sLine, "Checking repository:")
				EndSelect


			EndIf
			#cs
			            ; Begrenze L�nge von $sOutput auf 1.000 Zeichen
			            If StringLen($sOutput) > 1000 Then
			                $sOutput = StringTrimLeft($sOutput, StringLen($sOutput) - 1000)
			            EndIf
			#ce
			GUICtrlSetData($Output, $sOutput)
			_GUICtrlEdit_LineScroll($Output, 0, _GUICtrlEdit_GetLineCount($Output))
		EndIf

		;Sleep(1000) ; CPU entlasten
	WEnd

	$Text = GUICtrlRead($Output)
	$FileOutputPath = @WorkingDir & "\output.txt"
	$FileOutput = FileOpen($FileOutputPath, 1)
	    FileWrite($FileOutput, $Text)
		FileWrite($FileOutput, @CRLF & @CRLF & @CRLF)
    FileClose($FileOutput)
	$sOutput &= @CRLF & "Synchronization abgeschlossen" & @CRLF & "Viel Spa�"

	GUICtrlSetState($SyncButton, $GUI_SHOW)
	GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButton, $GUI_SHOW)
	GUICtrlSetState($LPLaunchButtonDisabled, $GUI_HIDE)
EndFunc   ;==>_SyncButtonClick


Func _SyncButtonCancelClick()
	If $iPID <> 0 Then
		ProcessClose($iPID)
		$iPID = 0
	EndIf
	GUICtrlSetState($SyncButton, $GUI_ENABLE)
	GUICtrlSetState($SyncButtonCancel, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButton, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButtonDisabled, $GUI_SHOW)
EndFunc   ;==>_SyncButtonCancelClick

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
	IniWrite($ParaIniFile, "Options", "ShowScriptErrors", GUICtrlRead($ShowScriptErrors))
	IniWrite($ParaIniFile, "Options", "NoPause", GUICtrlRead($NoPause))
	IniWrite($ParaIniFile, "Options", "WindowMode", GUICtrlRead($WindowMode))
	IniWrite($ParaIniFile, "Options", "FilePatching", GUICtrlRead($FilePatching))
	IniWrite($ParaIniFile, "Options", "CheckSignatures", GUICtrlRead($CheckSignatures))
	IniWrite($ParaIniFile, "Options", "EnableBattlEye", GUICtrlRead($EnableBattlEye))

	IniWrite($ParaIniFile, "Performance", "EnableHT", GUICtrlRead($EnableHT))
	IniWrite($ParaIniFile, "Performance", "HugePages", GUICtrlRead($HugePages))
	IniWrite($ParaIniFile, "Performance", "NoSplash", GUICtrlRead($NoSplash))
	IniWrite($ParaIniFile, "Performance", "NoLogs", GUICtrlRead($NoLogs))

	IniWrite($ParaIniFile, "Arma3exe", "ExePath", GUICtrlRead($ExecutablePath))
	IniWrite($ParaIniFile, "Modpack", "Optional", GUICtrlRead($ModPackOptional))

EndFunc   ;==>SaveSettings

Func LoadSettings()
	GUICtrlSetState($ShowScriptErrors, IniRead($ParaIniFile, "Options", "ShowScriptErrors", $GUI_UNCHECKED))
	GUICtrlSetState($NoPause, IniRead($ParaIniFile, "Options", "NoPause", $GUI_UNCHECKED))
	GUICtrlSetState($WindowMode, IniRead($ParaIniFile, "Options", "WindowMode", $GUI_UNCHECKED))
	GUICtrlSetState($FilePatching, IniRead($ParaIniFile, "Options", "FilePatching", $GUI_UNCHECKED))
	GUICtrlSetState($CheckSignatures, IniRead($ParaIniFile, "Options", "CheckSignatures", $GUI_UNCHECKED))
	GUICtrlSetState($EnableBattlEye, IniRead($ParaIniFile, "Options", "EnableBattlEye", $GUI_UNCHECKED))

	GUICtrlSetState($EnableHT, IniRead($ParaIniFile, "Performance", "EnableHT", $GUI_UNCHECKED))
	GUICtrlSetState($HugePages, IniRead($ParaIniFile, "Performance", "HugePages", $GUI_UNCHECKED))
	GUICtrlSetState($NoSplash, IniRead($ParaIniFile, "Performance", "NoSplash", $GUI_UNCHECKED))
	GUICtrlSetState($NoLogs, IniRead($ParaIniFile, "Performance", "NoLogs", $GUI_UNCHECKED))

	GUICtrlSetData($ExecutablePath, IniRead($ParaIniFile, "Arma3exe", "ExePath", ""))
	GUICtrlSetData($ModPackOptional, IniRead($ParaIniFile, "Modpack", "Optional", $GUI_UNCHECKED))
EndFunc   ;==>LoadSettings

Func _UpdateArma3SyncButtonClick()
	GUICtrlSetState($SyncButton, $GUI_DISABLE)
	GUICtrlSetState($LPLaunchButton, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButtonDisabled, $GUI_SHOW)
	GUICtrlSetState($Arma3SyncUpdate, $GUI_DISABLE)
	GUICtrlSetState($Arma3SyncCheck, $GUI_DISABLE)

	Local $sCommand2 = 'java -jar "' & @WorkingDir & '\ArmA3Sync.jar" -UPDATE' ; Arma3Sync Update-CMD-Befehl
	;MsgBox(0,"SyncUpdate", $sCommand2)
	$iPID = Run($sCommand2, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	GUICtrlSetState($hTab1, $GUI_SHOW)
	GUICtrlSetState($hTab2, $GUI_HIDE)
	Local $sOutput = "Arma3Sync Update gestartet..." & @CRLF
	GUICtrlSetFont($Output, 9, 400, 0, "")

	While 1
		Local $sLine = StdoutRead($iPID)
		If @error Then
			GUICtrlSetState($SyncButton, $GUI_SHOW)
			GUICtrlSetState($LPLaunchButton, $GUI_SHOW)
			GUICtrlSetState($LPLaunchButtonDisabled, $GUI_HIDE)
			GUICtrlSetState($Arma3SyncUpdate, $GUI_ENABLE)
			GUICtrlSetState($Arma3SyncCheck, $GUI_ENABLE)
			ExitLoop
		EndIf

		If $sLine <> "" Then

			If GUICtrlRead($Arma3SyncDebug) = $GUI_CHECKED Then
				$sOutput &= $sLine
			Else

				If StringInStr($sLine, "ArmA3Sync Installed version =") Then
					$sLine = StringReplace($sLine, "ArmA3Sync Installed version =", "Installierte ArmA3Sync Version =")
					$sOutput &= $sLine
				EndIf
				If StringInStr($sLine, "ArmA3Sync Available update version =") Then
					$sLine = StringReplace($sLine, "ArmA3Sync Available update version =", @CRLF & "Verf�gbare Online-ArmA3Sync Version =")
					$sOutput &= $sLine
				EndIf
				If StringInStr($sLine, "No new update available.") Then
					$sLine = StringReplace($sLine, "No new update available.","Keine neue Version von ArmA3Sync gefunden")
					$sOutput &= $sLine
				EndIf
			EndIf

			GUICtrlSetData($Output, $sOutput)
			_GUICtrlEdit_LineScroll($Output, 0, _GUICtrlEdit_GetLineCount($Output))
		EndIf

		;Sleep(10) ; CPU entlasten
	WEnd


	GUICtrlSetState($SyncButton, $GUI_SHOW)
	GUICtrlSetState($LPLaunchButton, $GUI_SHOW)
	GUICtrlSetState($LPLaunchButtonDisabled, $GUI_HIDE)
	GUICtrlSetState($Arma3SyncUpdate, $GUI_ENABLE)
	GUICtrlSetState($Arma3SyncCheck, $GUI_ENABLE)
EndFunc   ;==>_UpdateArma3SyncButtonClick


Func _CheckArma3SyncRepoClick()
	GUICtrlSetState($SyncButton, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButton, $GUI_HIDE)
	GUICtrlSetState($LPLaunchButtonDisabled, $GUI_HIDE)
	GUICtrlSetState($Arma3SyncUpdate, $GUI_DISABLE)
	GUICtrlSetState($Arma3SyncCheck, $GUI_DISABLE)
	GUICtrlSetState($ReparaturLabel, $GUI_SHOW)


	Local $sCommand3 = 'java -jar "' & @WorkingDir & '\ArmA3Sync.jar" -CHECK "' & $repositoryname & '"' ; Arma3Sync CHECK-CMD-Befehl
	;MsgBox(0,"SyncCheck", $sCommand3)
	$iPID = Run($sCommand3, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	GUICtrlSetState($hTab1, $GUI_SHOW)
	GUICtrlSetState($hTab2, $GUI_HIDE)
	Local $sOutput = "Arma3Sync Check gestartet..." & @CRLF & "Dies kann einen Moment dauern..." & @CRLF
	GUICtrlSetFont($Output, 9, 400, 0, "")

	While 1
		Local $sLine = StdoutRead($iPID)
		If @error Then
			GUICtrlSetState($SyncButton, $GUI_SHOW)

			GUICtrlSetState($LPLaunchButton, $GUI_SHOW)
			GUICtrlSetState($Arma3SyncUpdate, $GUI_SHOW)
			GUICtrlSetState($Arma3SyncCheck, $GUI_ENABLE)
			ExitLoop
		EndIf

		If $sLine <> "" Then
			$sOutput &= $sLine
		EndIf

		GUICtrlSetData($Output, $sOutput)
		_GUICtrlEdit_LineScroll($Output, 0, _GUICtrlEdit_GetLineCount($Output))


		Sleep(50) ; CPU entlasten
	WEnd

	GUICtrlSetState($ReparaturLabel, $GUI_HIDE)


	GUICtrlSetState($SyncButton, $GUI_SHOW)
	GUICtrlSetState($LPLaunchButton, $GUI_SHOW)
	GUICtrlSetState($LPLaunchButtonDisabled, $GUI_HIDE)
	GUICtrlSetState($Arma3SyncUpdate, $GUI_ENABLE)
	GUICtrlSetState($Arma3SyncCheck, $GUI_ENABLE)
EndFunc   ;==>_CheckArma3SyncRepoClick

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

;FileDelete($sTempIni)
	EndIf
EndIf













































































































































































