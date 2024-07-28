#cs ----------------------------------------------------------------------------

 Author: BattleNogare

 Script Function:
    CheckVersion

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
FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "CheckVersion wurde ausgeführt")

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


If $OnlineVersion <> $ClientVersion Then
	if FileExists (@WorkingDir & "\LauncherUpdate.exe") Then
		FileDelete(@WorkingDir & "\LauncherUpdate.exe")
	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "LauncherUpdate gelöscht")
	EndIf

	$LauncherUpdateURL = IniRead($sTempIni, "Downloads", "LauncherUpdate", $IniDefaultwert)
	$LauncherUpdatePath = @WorkingDir & "\LauncherUpdate.exe"
	Local $downDownload = InetGet($LauncherUpdateURL, $LauncherUpdatePath, 1, $INET_DOWNLOADWAIT)
	InetClose($downDownload)
	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "LauncherUpdate neu heruntergeladen")
	MsgBox(0,"Test",$LauncherUpdatePath)
	Run( @WorkingDir & "\LauncherUpdate.exe")

Else
	FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Versionen sind gleich; Starte Launcher")
	Run( @WorkingDir & "\LP_Launcher.exe")
EndIf

