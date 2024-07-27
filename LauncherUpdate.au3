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
