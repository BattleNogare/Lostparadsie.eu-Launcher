#include <Inet.au3>

; Argumente auslesen
If $CmdLine[0] < 3 Then
    Exit
EndIf

Local $sFileName = $CmdLine[1]
Local $sDestKey = $CmdLine[2]
Local $sTempIni = $CmdLine[3]

; Log-Datei Pfad
Local $sLogFilePath = @WorkingDir & "\LP-Data\Launcher-Log.txt"

; Funktion zum Schreiben ins Log-File
Func WriteLog($sMessage)
    Local $hFile = FileOpen($sLogFilePath, $FO_APPEND)
    If $hFile = -1 Then
        ConsoleWrite("Fehler: Kann die Log-Datei nicht öffnen. " & @error & @CRLF)
        Return
    EndIf
    FileWriteLine($hFile, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC & " - " & $sMessage)
    FileClose($hFile)
EndFunc

; Download-URL und Zielpfad ermitteln
Local $sUrl = IniRead($sTempIni, "Downloads", $sFileName, "")
Local $sDestPath = IniRead($sTempIni, "Downloads", $sDestKey, "")

WriteLog("Starte Download: " & $sFileName & " von " & $sUrl & " nach @WorkingDir" & $sDestPath)

If $sUrl = "" Or $sDestPath = "" Then
    WriteLog("Fehler: Ungültige URL oder Zielpfad für " & $sFileName)
    Exit
EndIf

; Download starten
Local $qDownload = InetGet($sUrl, @WorkingDir & $sDestPath, 1, 1)
If @error Then
    WriteLog("Fehler: Download konnte nicht gestartet werden für " & $sFileName & ". Fehlercode: " & @error)
    Exit
EndIf

; Download-Fortschritt überwachen
Do
    Sleep(100)
Until InetGetInfo($qDownload, $INET_DOWNLOADCOMPLETE) = 1

; Fehlerprüfung nach Download-Abschluss
If InetGetInfo($qDownload, $INET_DOWNLOADSUCCESS) Then
    WriteLog("Download abgeschlossen: " & $sFileName)
Else
    ; Spezifische Fehlerdetails ermitteln
    Local $iError = InetGetInfo($qDownload, $INET_DOWNLOADERROR)
    Local $sErrorMessage = "Unbekannter Fehler"

    Switch $iError
        Case 1
            $sErrorMessage = "Host konnte nicht aufgelöst werden"
        Case 2
            $sErrorMessage = "Verbindung konnte nicht hergestellt werden"
        Case 3
            $sErrorMessage = "Server antwortet nicht"
        Case 4
            $sErrorMessage = "HTTP-Fehler"
        Case 5
            $sErrorMessage = "Datei konnte nicht erstellt werden"
        Case Else
            $sErrorMessage = "Fehlercode: " & $iError
    EndSwitch

    WriteLog("Fehler: Download fehlgeschlagen für " & $sFileName & ". Grund: " & $sErrorMessage)
EndIf

InetClose($qDownload)
