Func Armastart()

	$parfilepath = @WorkingDir & "\LP-Data\arma3parameter.txt"
	$serverdataini =  @WorkingDir & "\LP-Data\serverdata.ini"

	$connect = IniRead($serverdataini, "Serverdata", "connect", "Fehler: Parameter nicht gefunden")
	$port = IniRead($serverdataini, "Serverdata", "port", "Fehler: Parameter nicht gefunden")
	$password = IniRead($serverdataini, "Serverdata", "password", "Fehler: Parameter nicht gefunden")
	$mod = IniRead($serverdataini, "Serverdata", "mod", "Fehler: Parameter nicht gefunden")

	$parfile = FileOpen($parfilepath, 2)
	FileWriteLine ($parfile, $sParameters)
	FileWriteLine($parfile, "-connect=" & $connect)
	FileWriteLine($parfile, "-port=" & $port)
	FileWriteLine($parfile, "-password=" & $password)
	FileWriteLine($parfile, "-mod=" & $mod)
	FileClose($parfile)
	RunWait(@ComSpec & " /c attrib +h " & $parfilepath, "", @SW_HIDE)

	$parfile = FileOpen($parfilepath, 0)
	$parcontent = FileRead($parfile)
	FileClose($parfile)

	MsgBox (0, "Arma3exePath", GUICtrlRead($ExecutablePath))
	MsgBox (0, "Arma3Start Parameter", $parcontent)
EndFunc