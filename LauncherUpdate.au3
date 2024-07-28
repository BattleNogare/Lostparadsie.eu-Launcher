#cs ----------------------------------------------------------------------------

 Author: BattleNogare

 Script Function:
    Lostparadise.eu Update-Launcher

#ce ----------------------------------------------------------------------------

#include <IE.au3>
#include <File.au3>
#include <Array.au3>
#include <Inet.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>

#AutoIt3Wrapper_icon=LPicon.ico

; Log-Datei
Local $sLogFilePath = @WorkingDir & "\LP-Data\Launcher-Log.txt"
Local $hLogFile = FileOpen($sLogFilePath, 9)
Local $sTimeStamp = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC
FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Launcher wurde ausgeführt")

; URL INI-Datei
Local $sUrl = "https://raw.githubusercontent.com/BattleNogare/Lostparadsie.eu-Launcher/main/config.ini"

; INI-Datei aus Internet laden
Local $sData = _INetGetSource($sUrl)

; INI-Daten in eine virtuelle INI-File schreiben
Local $sTempIni = @WorkingDir & "\LP-Data\temp_config.ini"

If FileExists($sTempIni) Then
	FileDelete($sTempIni)
EndIf

FileWrite($sTempIni, $sData)

$IniDefaultwert = "Wert nicht gefunden"
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

; Vergleiche Versionen
If $OnlineVersion <> $ClientVersion Then
	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Versionen sind nicht gleich; Starte Update" & @CRLF)
	Local $updatefenster = GUICreate("Bitte warten...", 300, 100, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
	Local $label = GUICtrlCreateLabel("Bitte warten, bis die Aktualisierung abgeschlossen ist.", 10, 10, 280, 20, $SS_CENTER)
	Local $progressbar = GUICtrlCreateProgress(10, 40, 280, 20, $PBS_SMOOTH)
	Local $progresstext = GUICtrlCreateLabel("Aktualisierung startet...", 10, 65, 280, 20, $SS_CENTER)
	GUICtrlSetData($progressbar, 0)
	$progressbari = 1
	GUICtrlSetFont($progresstext, 10, 400)
	GUISetState(@SW_SHOW, $updatefenster)


	FileDelete(@WorkingDir & "\LP_Launcher.exe")
	FileDelete(@WorkingDir & "\LP-Data\background.jpg")
	FileDelete(@WorkingDir & "\LP-Data\LP-Logo.png")
	FileDelete(@WorkingDir & "\LP-Data\syncdata.png")
	FileDelete(@WorkingDir & "\LP-Data\syncdata-stop.png")
	FileDelete(@WorkingDir & "\LP-Data\lostparadisestart.png")
	FileDelete(@WorkingDir & "\LP-Data\LPicon.ico")
	FileDelete(@WorkingDir & "\LP-Data\LauncherText.txt")
	FileDelete(@WorkingDir & "\LP-Data\lostparadisestartdisabled.png")

	FileWrite($hLogFile, $sTimeStamp & " - " & "Vorherige Dateien gelöscht")

	Local $aPID[7]

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

	; INI-Daten lesen
	Local $repositoryname = IniRead($sTempIni, "Repository", "repositoryname", $IniDefaultwert)
	Local $repositoryprotocol = IniRead($sTempIni, "Repository", "repositoryprotocol", $IniDefaultwert)
	Local $repositoryport = IniRead($sTempIni, "Repository", "repositoryport", $IniDefaultwert)
	Local $repositoryuserlogin = IniRead($sTempIni, "Repository", "userlogin", $IniDefaultwert)
	Local $repositoryuserpassword = IniRead($sTempIni, "Repository", "userpassword", $IniDefaultwert)
	Local $repositoryurl = IniRead($sTempIni, "Repository", "repositoryurl", $IniDefaultwert)

	; Pfad zur Console.Bat
	Local $sBatchFilePath = @WorkingDir & '\ArmA3Sync-console.bat'
	Local $sDirectory = @WorkingDir

	; CMD - Hide, erstelle das Fenster
	Local $iPID = Run(@ComSpec & " /k cd /d " & '"' & $sDirectory & '"' & " && " & '"' & $sBatchFilePath & '"', "", @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD + $STDERR_CHILD)

	Sleep(1000)
	; Lese bestehendes Repo
	StdinWrite($iPID, "LIST" & @CRLF)
	Local $sOutput = ""
	While 1
		$sOutput &= StdoutRead($iPID)
		If @error Then ExitLoop
	WEnd

	If StringInStr($sOutput, "Number of repositories found: 0") Then
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
		; Variablen für die gesuchten Werte
		Local $sRepoName = ""
		Local $sProtocol = ""
		Local $sUrl = ""
		Local $sPort = ""
		Local $sLogin = ""
		Local $sPassword = ""

		; Suche nach den spezifischen Informationen und extrahiere die Werte
		If StringInStr($sOutput, "Repository name:") Then
			$sRepoName = StringTrimLeft($sOutput, StringInStr($sOutput, "Repository name:") + StringLen("Repository name:") + 1)
			$sRepoName = StringLeft($sRepoName, StringInStr($sRepoName, @CRLF) - 1)
		EndIf

		If StringInStr($sOutput, "Protocole:") Then
			$sProtocol = StringTrimLeft($sOutput, StringInStr($sOutput, "Protocole:") + StringLen("Protocole:") + 1)
			$sProtocol = StringLeft($sProtocol, StringInStr($sProtocol, @CRLF) - 1)
		EndIf

		If StringInStr($sOutput, "Url:") Then
			$sUrl = StringTrimLeft($sOutput, StringInStr($sOutput, "Url:") + StringLen("Url:") + 1)
			$sUrl = StringLeft($sUrl, StringInStr($sUrl, @CRLF) - 1)
		EndIf

		If StringInStr($sOutput, "Port:") Then
			$sPort = StringTrimLeft($sOutput, StringInStr($sOutput, "Port:") + StringLen("Port:") + 1)
			$sPort = StringLeft($sPort, StringInStr($sPort, @CRLF) - 1)
		EndIf

		If StringInStr($sOutput, "Login:") Then
			$sLogin = StringTrimLeft($sOutput, StringInStr($sOutput, "Login:") + StringLen("Login:") + 1)
			$sLogin = StringLeft($sLogin, StringInStr($sLogin, @CRLF) - 1)
		EndIf

		If StringInStr($sOutput, "Password:") Then
			$sPassword = StringTrimLeft($sOutput, StringInStr($sOutput, "Password:") + StringLen("Password:") + 1)
			$sPassword = StringLeft($sPassword, StringInStr($sPassword, @CRLF) - 1)
		EndIf

		; Vergleich der extrahierten Werte mit den INI-Werten
		Local $bDifferent = False

		If $sRepoName <> $repositoryname Then $bDifferent = True
		If $sProtocol <> $repositoryprotocol Then $bDifferent = True
		If $sUrl <> $repositoryurl Then $bDifferent = True
		If $sPort <> $repositoryport Then $bDifferent = True
		If $sLogin <> $repositoryuserlogin Then $bDifferent = True
		If $sPassword <> $repositoryuserpassword Then $bDifferent = True

		If $bDifferent Then
			FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Repository hat sich geändert; wird neu angelegt" & @CRLF)
			Sleep(100)
			StdinWrite($iPID, "DELETE" & @CRLF)
			Sleep(100)
			StdinWrite($iPID, $sRepoName & @CRLF)
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

		Else
			; Weiter mit dem Skript, falls alles gleich ist
			FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Repository hat sich nicht geändert" & @CRLF)
		EndIf
	EndIf

	; Kill CMD
	If ProcessExists($iPID) Then
		ProcessClose($iPID)
		Sleep(1000)
	EndIf

	FileWrite($ClientVersionFile, $OnlineVersion)
	FileClose($ClientVersionFile)
	GUISetState(@SW_HIDE, $updatefenster)
	Run(@WorkingDir & "\LP_Launcher.exe")
	;FileDelete($sTempIni)

Else
	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Versionen sind gleich; Starte Lostparadise Launcher" & @CRLF)
	Run(@WorkingDir & "\LP_Launcher.exe")
	;FileDelete($sTempIni)
EndIf

#cs
#ce
