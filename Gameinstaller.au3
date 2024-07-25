#cs ----------------------------------------------------------------------------

 Author: BattleNogare

 Script Function:
    Installer Lostparadise.eu Arma3Sync-Laucher

#ce ----------------------------------------------------------------------------

#RequireAdmin

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Inet.au3>
#include <FileConstants.au3>
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <ComboConstants.au3>
#include <ProgressConstants.au3>
#include <File.au3>

Global $DefaultArma3Path = "C:\Program Files (x86)\Steam\steamapps\common\Arma 3\arma3battleye.exe"
Global $DefaultInstallPath = "C:\Program Files (x86)\Lostparadise Laucher\"


#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Lostparadise.eu Installer", 520, 320, 640, 265)
$Install = GUICtrlCreateButton("Installieren", 408, 272, 91, 25)
$Speicherort = GUICtrlCreateLabel("Wo soll der Launcher installiert werden?", 16, 104, 202, 17)
$SpeicherInput = GUICtrlCreateInput("", 16, 128, 377, 21)
$SpeicherButton = GUICtrlCreateButton("Durchsuchen...", 408, 128, 91, 25)

$Label1 = GUICtrlCreateLabel("Lostparadise.eu", 16, 16, 273, 43)
GUICtrlSetFont(-1, 20, 400, 0, "Gill Sans Ultra Bold")
$Label2 = GUICtrlCreateLabel("Installer", 16, 56, 138, 38)
GUICtrlSetFont(-1, 20, 400, 0, "Gill Sans Ultra Bold")

$Group1 = GUICtrlCreateGroup("Infos", 24, 208, 361, 89)
$Info1 = GUICtrlCreateLabel("Dies ist ein Installer für den Arma3-Server ", 32, 224, 204, 17)
$hLinkButton = GUICtrlCreateButton("[Lostparadise.eu]", 230, 223, 91, 16, $BS_FLAT)
GUICtrlSetBkColor($hLinkButton, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor($hLinkButton, 0x0000FF)
GUICtrlSetCursor($hLinkButton, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Arma3found = GUICtrlCreateLabel("Arma3 gefunden:", 16, 160, 330, 17)
$Armafoundpath = GUICtrlCreateLabel($DefaultArma3Path, 16, 176, 378, 17)
GUICtrlSetColor(-1, 0x008000)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


Func OpenWebpage($sURL)
	ShellExecute($sURL)
EndFunc   ;==>OpenWebpage

; Überprüfung Arma3 im Defaultpfad?
CheckArma3File()
Func CheckArma3File()
	Local $Arma3FilePath = $DefaultArma3Path
	If FileExists($Arma3FilePath) Then
		GUICtrlSetState($Arma3found, $GUI_SHOW)
		GUICtrlSetState($Armafoundpath, $GUI_SHOW)
	Else
		GUICtrlSetState($Arma3found, $GUI_HIDE)
		GUICtrlSetState($Armafoundpath, $GUI_HIDE)
	EndIf
EndFunc   ;==>CheckArma3File

; Überprüfung Java da?
Func javaversion($sCommand)
	Local $iPID = Run(@ComSpec & " /c " & $sCommand, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $sOutput = ""

	While 1
		$sOutput &= StdoutRead($iPID)
		$sOutput &= StderrRead($iPID)
		If @error Then ExitLoop
		Sleep(25)
	WEnd
	Return $sOutput
EndFunc   ;==>javaversion

Local $sCommand = "java -version"
Local $javaver = javaversion($sCommand)

If StringInStr($javaver, "is not recognized") Or StringInStr($javaver, "konnte nicht gefunden werden") Then
	MsgBox(16, "Fehler", " Es konnte nicht festgestellt werden, ob java installiert ist. Bitte installiere Java")
	Exit
EndIf

;While
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

			;Speicherort-Button
		Case $SpeicherButton
			Local $sFolderPathInstall = FileSelectFolder("Wählen Sie den Installationsordner", "", 3)
			If @error Then
				GUICtrlSetData($SpeicherInput, "")
			Else
				Local $LPOrdnerName = "Lostparadise-Laucher"
				$NewFolderPathInstall = $sFolderPathInstall & "\" & $LPOrdnerName
				GUICtrlSetData($SpeicherInput, $NewFolderPathInstall & "\")
			EndIf
			; Link-Button
		Case $hLinkButton
			$sURL = "https://lostparadise.eu/"
			ShellExecute($sURL)
			Sleep(2000)

			; Install-Button
		Case $Install

			GUISetState(@SW_DISABLE, $Form1_1)
			Local $wartenfenster = GUICreate("Bitte warten...", 300, 100, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
			Local $label = GUICtrlCreateLabel("Bitte warten bis die Installation abgeschlossen ist.", 10, 10, 280, 20, $SS_CENTER)
			Local $progressbar = GUICtrlCreateProgress(10, 40, 280, 20, $PBS_SMOOTH)
			Local $progresstext = GUICtrlCreateLabel("Installation startet...", 10, 65, 280, 20, $SS_CENTER)
			GUICtrlSetData($progressbar, 0)
			$progressbari = 1
			GUICtrlSetFont($progresstext, 10, 400)
			GUISetState(@SW_SHOW, $wartenfenster)

			Local $SpeicherInput2 = GUICtrlRead($SpeicherInput)
			If StringStripWS($SpeicherInput2, 8) = "" Then
				GUICtrlSetData($SpeicherInput, $DefaultInstallPath)
				;MsgBox("info","Speicherinput", GUICtrlRead($SpeicherInput))
				;MsgBox(64, "Info", "Das Input-Feld war leer und wurde mit dem Pfad ausgefüllt: " & GUICtrlRead($SpeicherInput))
			Else
				;MsgBox(64, "Info", "Das Input-Feld ist nicht leer: " & $SpeicherInput2)
			EndIf

			; Erstellung SpeicherOrdner
			DirCreate(GUICtrlRead($SpeicherInput))

			; Log erstellen
			GUICtrlSetData($progresstext, "Erstelle Log")
			GUICtrlSetData($progressbar, 7)
			Local $sLogFilePath = GUICtrlRead($SpeicherInput) & "Launcher-Log.txt"
			;MsgBox("info","install_log", $sLogFilePath)

			; Log öffnen
			Local $hLogFile = FileOpen($sLogFilePath, 9)
			If $hLogFile = -1 Then
				ConsoleWrite("Die Datei konnte nicht erstellt oder geöffnet werden: " & $sLogFilePath)
				Exit
			EndIf

			Local $sTimeStamp = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC
			FileWrite($hLogFile, @CRLF & $sTimeStamp & " - " & "Installer wurde ausgeführt" & @CRLF)
			FileWrite($hLogFile, $javaver)
			WriteLog("Launcher Speicherort: " & GUICtrlRead($SpeicherInput) & @CRLF)

			; INI-Datei aus Internet laden
			Local $sURL = "https://raw.githubusercontent.com/BattleNogare/Lostparadsie.eu-Launcher/main/config.ini"
			Local $sData = _INetGetSource($sURL)

			; INI-Daten in eine virtuelle INI-File schreiben
			Local $sTempIni = GUICtrlRead($SpeicherInput) & "temp_config.ini"
			If FileExists($sTempIni) Then
				FileDelete($sTempIni)
			EndIf

			FileWrite($sTempIni, $sData)
			$IniDefaultwert = "Wert nicht in .ini gefunden"

			; Download Arma3Sync.zip
			GUICtrlSetData($progresstext, "Download Sync")
			GUICtrlSetData($progressbar, 14)
			WriteLog("Arma3Sync.zip download gestartet" & @CRLF)
			$Arma3SyncFileURL = IniRead($sTempIni, "Downloads", "Arma3Sync", $IniDefaultwert)
			$Arma3Syncmove = GUICtrlRead($SpeicherInput)
			$Arma3SyncZipPath = "C:\Arma3Sync.zip"
			$Arma3SyncunZipPath = "C:\Arma3Sync\Arma3Sync"
			Local $zipDownload = InetGet($Arma3SyncFileURL, $Arma3SyncZipPath, 1, $INET_DOWNLOADWAIT)
			InetClose($zipDownload)

			WriteLog("Arma3Sync.zip download fertig" & @CRLF)

			; Unzip + Rename + Move Ordner
			GUICtrlSetData($progresstext, "Endpacke Sync")
			GUICtrlSetData($progressbar, 21)
			$pscommand = 'Expand-Archive -Path ''C:\Arma3Sync.zip'' -DestinationPath ''C:\Arma3Sync9a9VuaZP\'''
			Local $powerShellCommand = $pscommand
			Local $psScriptFile = "C:\ExpandArchive.ps1"
			FileWrite($psScriptFile, $powerShellCommand)
			;WriteLog("Powershell-Datei erstellt: " & $powerShellCommand & @CRLF)
			Local $command = 'powershell.exe -ExecutionPolicy Bypass -File "' & $psScriptFile & '"'
			RunWait(@ComSpec & ' /c ' & $command, "", @SW_HIDE)
			;WriteLog("Powershell-Datei ausgeführt" & @CRLF)
			FileDelete($psScriptFile)
			;WriteLog("Powershell-Datei gelöscht" & @CRLF)
			FileDelete($Arma3SyncZipPath)
			WriteLog("Arma3Sync.zip-Datei entpackt" & @CRLF)


			; Pfad zum Ursprungsordner
			Local $sOriginalPath = "C:\Arma3Sync9a9VuaZP\"
			; Neuer Name für den Ordner
			Local $sNewFolderName = "ArmA3Sync"
			; Zielpfad, wohin der Ordner verschoben werden soll
			Local $sDestinationPath = GUICtrlRead($SpeicherInput)

			; Holen Sie sich den Namen des ersten Ordners im Ursprungsordner
			Local $aFolders = _FileListToArray($sOriginalPath, "*", $FLTA_FOLDERS)
			If @error Then
				WriteLog("Fehler: " & "Keine Ordner gefunden oder Fehler beim Abrufen der Ordnerliste." & @CRLF)
				Exit
			EndIf

			; Wenn mindestens ein Ordner gefunden wurde
			If UBound($aFolders) > 1 Then
				; Neuen Ordnernamen vorbereiten
				Local $sOriginalFolderName = $aFolders[1]
				Local $sNewPath = $sOriginalPath & $sNewFolderName

				Sleep(1000)

				; Verschieben und umbenennen des Ordners
				Local $sFinalPath = $sDestinationPath & $sNewFolderName
				DirMove($sOriginalPath & $sOriginalFolderName, $sFinalPath)
				If @error Then
					WriteLog("Fehler: " & "Fehler beim Umbenennen des Ordners." & @CRLF)
					Exit
				EndIf

				;MsgBox(0,"test",$sOriginalPath & $sOriginalFolderName & " -> "& $sFinalPath)
				WriteLog("Erfolg: " & "Ordner erfolgreich umbenannt und verschoben." & @CRLF)

			Else
				WriteLog("Fehler: " & "Kein Ordner im angegebenen Pfad gefunden." & @CRLF)
			EndIf
			Sleep(300)
			DirRemove("C:\Arma3Sync9a9VuaZP", 1)

			; INI-Daten lesen
			Local $repositoryname = IniRead($sTempIni, "Repository", "repositoryname", $IniDefaultwert)
			Local $repositoryprotocol = IniRead($sTempIni, "Repository", "repositoryprotocol", $IniDefaultwert)
			Local $repositoryport = IniRead($sTempIni, "Repository", "repositoryport", $IniDefaultwert)
			Local $repositoryuserlogin = IniRead($sTempIni, "Repository", "userlogin", $IniDefaultwert)
			Local $repositoryuserpassword = IniRead($sTempIni, "Repository", "userpassword", $IniDefaultwert)
			Local $repositoryurl = IniRead($sTempIni, "Repository", "repositoryurl", $IniDefaultwert)

			; Pfad zur Console.Bat
			GUICtrlSetData($progresstext, "Erstelle Repository")
			GUICtrlSetData($progressbar, 35)
			Local $sBatchFilePath = GUICtrlRead($SpeicherInput) & '\Arma3Sync\ArmA3Sync-console.bat'
			Local $sDirectory = GUICtrlRead($SpeicherInput) & 'Arma3Sync'

			; CMD- Hide, erstelle das Fenster
			Local $iPID = Run(@ComSpec & " /k cd /d " & '"' & $sDirectory & '"' & " && " & '"' & $sBatchFilePath & '"', "", @SW_HIDE, $STDIN_CHILD + $STDOUT_CHILD + $STDERR_CHILD)

			Sleep(1000)

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

			WriteLog($repositoryname & " - Repo eingegeben" & @CRLF)

			; Exit
			StdinWrite($iPID, "exit" & @CRLF)

			; Kill CMD
			If ProcessExists($iPID) Then
				ProcessClose($iPID)
				Sleep(1000)
			EndIf


			; Download Downloader
			WriteLog("Starte Download-Downloader" & @CRLF)
			$downDownloaderURL = IniRead($sTempIni, "Downloads", "downDownloader", $IniDefaultwert)
			$downDownloaderpath = GUICtrlRead($SpeicherInput) & "Arma3Sync\download.exe"
			Local $downDownload = InetGet($downDownloaderURL, $downDownloaderpath, 1, $INET_DOWNLOADWAIT)
			InetClose($downDownload)
			WriteLog("Download-Downloader abgeschlossen" & @CRLF)

			; Download LauncherUpdate
			WriteLog("Starte Download LauncherUpdate" & @CRLF)
			$downDownloaderURL = IniRead($sTempIni, "Downloads", "LauncherUpdate", $IniDefaultwert)
			$downDownloaderpath = GUICtrlRead($SpeicherInput) & "Arma3Sync\LauncherUpdate.exe"
			Local $downDownload = InetGet($downDownloaderURL, $downDownloaderpath, 1, $INET_DOWNLOADWAIT)
			InetClose($downDownload)
			WriteLog("Download LauncherUpdate abgeschlossen" & @CRLF)

			; Download .ico
			;MsgBox(0,"test", $downDownloaderURL & " - " & $downDownloaderpath)
			$LPicoURL = IniRead($sTempIni, "Downloads", "LPicon.ico", $IniDefaultwert)
			$LPicopath = IniRead($sTempIni, "Downloads", "LPicon_dest", $IniDefaultwert)
			$LPDatapath = GUICtrlRead($SpeicherInput) & "Arma3Sync\LP-Data"
			DirCreate($LPDatapath)
			WriteLog("Starte .ico Download" & @CRLF)
			Local $icoDownload = InetGet($LPicoURL, $sDirectory & $LPicopath, 1, $INET_DOWNLOADWAIT)
			InetClose($icoDownload)
			WriteLog("Download .ico abgeschlossen" & @CRLF)

			; Erstelle Desktop-Verknüpfung
			GUICtrlSetData($progresstext, "Erstelle Desktop-Lostparadise-Verknüpfung")
			GUICtrlSetData($progressbar, 98)
			Local $iconPath = $sDirectory & "\LP-Data\LPicon.ico"
			Local $LostparadiseexePath = $sDirectory & "\LauncherUpdate.exe"
			FileCreateShortcut($LostparadiseexePath, @DesktopDir & "\Lostparadise.lnk", $sDirectory, "", "Lostparadise Launcher", $iconPath)
			WriteLog("Desktopverknüpfung erstellt" & @CRLF)


			;#########################################################################################
			FileClose($hLogFile)
			Sleep(200)
			FileMove($sLogFilePath, GUICtrlRead($SpeicherInput) & "Arma3Sync\LP-Data\Launcher-Log.txt", 8)

			GUIDelete($wartenfenster)
			GUIDelete($Form1_1)

			Sleep(200)

			FileDelete($sTempIni)

			Local $End = MsgBox(4, "[Lostparadise.eu]", "Installation abgeschlossen" & @CRLF & "Soll die Anwendung nun gestartet werden?")

			If $End = 6 Then
				;Run(@DesktopDir & "\Lostparadise.lnk")
				MsgBox(0, "End", @DesktopDir & "\Lostparadise.lnk" & " wird gestartet!")
			EndIf

			ExitLoop

	EndSwitch
WEnd

Exit

Func WriteLog($sMessage)
	Local $hFile = FileOpen($sLogFilePath, $FO_APPEND)
	If $hFile = -1 Then
		ConsoleWrite("Fehler: Kann die Log-Datei nicht öffnen. " & @error & @CRLF)
		Return
	EndIf
	FileWriteLine($hFile, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC & " - " & $sMessage)
	FileClose($hFile)
EndFunc   ;==>WriteLog
