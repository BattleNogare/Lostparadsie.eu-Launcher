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


; Überprüfen, ob das Skript mit dem Parameter "Update" aufgerufen wurde
If $CmdLine[0] > 0 And $CmdLine[1] = "Update" Then

	; LauncherUpdate
	FileWrite($hLogFile, $sTimeStamp & " - " & "LauncherUpdate wird ausgeführt")

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

	FileWrite($hLogFile, $sTimeStamp & " - " & "Vorherige Dateien gelöscht")

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

	; Überprüfen, ob im ftp-Ordner was existiert
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
		GUICtrlSetData($progresstext, "Ändere bestehendes Repository")
		GUICtrlSetData($progressbar, 40)
		FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Repository hat sich geändert; wird neu angelegt" & @CRLF)
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
	; Überprüfen auf neue Version
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
		 Run('"' & @ScriptFullPath & '" Update', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)
		 FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Neue Version gefunden - Launcher Neustart")
		 FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & '"' & @ScriptFullPath & '" Update')
		 Exit

	Else
			MsgBox(0, "[Lostparadise.eu]", "Installation abgeschlossen" & @CRLF & "Nun startet der Launcher")
	EndIf
EndIf













































































































































































