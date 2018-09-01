#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Aroche-Delta-Clock.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>

Opt("TrayMenuMode", 3)
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode", 1)

$TrayMaxTime = TrayCreateItem("Zmieñ limit czasowy")
$TrayCurrentTime = TrayCreateItem("Zmieñ wykorzystany czas")
TrayCreateItem("")
$TrayShowTime = TrayCreateItem("Pozosta³y czas")
TrayCreateItem("")
$TrayClose = TrayCreateItem("Wy³¹cz")

TrayItemSetOnEvent($TrayMaxTime, "TrayMaxTime")
TrayItemSetOnEvent($TrayCurrentTime, "TrayCurrentTime")
TrayItemSetOnEvent($TrayShowTime, "TrayShowTime")
TrayItemSetOnEvent($TrayClose, "TrayClose")

HotKeySet("^{F12}", "Zarzadzanie")

Global $IniConf = "C:\Kontrola Czasu\Conf.ini"
Global $IniTime = "C:\Kontrola Czasu\Time.ini"
Global $Haslo = "jacocok"
Global $HasloAdmin = "Turtyiwsoide11!"

DirExists()
IniExists()
Sprawdzenie()

AdlibRegister("minuta", 60000)

While 1
WEnd

Func Sprawdzenie()
	If Int(IniRead($IniTime, "time", "TimeToday", "99999999")) < Int(IniRead($IniConf, "conf", "MaxTime", "0")) Then
		MsgBox(64, "Kontrola czasu", "Kubuœ, siedzisz bardzo d³ugo i nikogo nie s³uchasz kiedy koñczyæ." & @CRLF & "Przez to na³ozony zosta³ limit czasu." & @CRLF & "Pozosta³o Ci " & _
				Int(IniRead($IniConf, "conf", "MaxTime", "0")) - Int(IniRead($IniTime, "time", "TimeToday", "99999999")) & " minut.", 15)
		For $i = 1 To 3 Step 1
			If Autoryzacja(3, $i) Then exi()
		Next
		MsgBox(64, "B³êdne has³o", "Wpisane has³o by³o b³êdne we wszystkich trzech próbach, czas bêdzie normalnie odliczany.", 15)
	Else
		MsgBox(48, "Koniec czasu", "Wykorzysta³eœ dzisiaj juz ca³y czas.", 15)
		For $i = 1 To 3 Step 1
			$Odp = Autoryzacja(1, $i)
			If $Odp = "asd" Then
				Zarzadzanie()
				exi()
			ElseIf $Odp = True Then
				exi()
			EndIf
		Next
		MsgBox(64, "B³êdne has³o", "Wpisane has³o by³o b³êdne we wszystkich trzech próbach, komputer zostanie wy³¹czony.", 15)
		shut()
	EndIf
EndFunc   ;==>Sprawdzenie

Func DirExists()
	If Not FileExists("C:\Kontrola Czasu") Then DirCreate("C:\Kontrola Czasu")
EndFunc   ;==>DirExists

Func IniExists()
	If Not FileExists($IniConf) Then
		FileOpen($IniConf, 1)
		IniWrite($IniConf, "conf", "MaxTime", "120")
	EndIf
	If Not FileExists($IniTime) Then
		FileOpen($IniTime, 1)
		IniWrite($IniTime, "time", "Date", _NowDate())
		IniWrite($IniTime, "time", "TimeToday", "0")
	EndIf
	If IniRead($IniTime, "time", "Date", "") <> _NowDate() Then
		IniWrite($IniTime, "time", "Date", _NowDate())
		IniWrite($IniTime, "time", "TimeToday", "0")
	EndIf
EndFunc   ;==>IniExists

Func ChangeMaxTime()
	Local $MaxTime = InputBox("Nowy maksymalny czas", "Wpisz nowy maksymalny czas uzywania komputera", IniRead($IniConf, "conf", "MaxTime", ""), default, -1, -1, 10, 10)
	$MaxTime = Int($MaxTime)
	If IsInt($MaxTime) And $MaxTime > 0 Then
		IniWrite($IniConf, "conf", "MaxTime", $MaxTime)
	Else
		MsgBox(16, "B³¹d", "Podano b³êdn¹ wartoœæ!", 3)
	EndIf
EndFunc   ;==>ChangeMaxTime

Func ChangeCurrentTime()
	Local $CurrentTime = InputBox("Nowy czas wykorzystany", "Wpisz nowy wykorzystany czas uzywania komputera", IniRead($IniTime, "time", "TimeToday", ""), default, -1, -1, 10, 10)
	$CurrentTime = Int($CurrentTime)
	If IsInt($CurrentTime) And $CurrentTime >= 0 Then
		IniWrite($IniTime, "time", "TimeToday", $CurrentTime)
	Else
		MsgBox(16, "B³¹d", "Podano b³êdn¹ wartoœæ!", 3)
	EndIf
EndFunc   ;==>ChangeCurrentTime

Func Autoryzacja($Mode = 0, $i = 1)
	Local $PodaneHaslo

	If $Mode = 0 Then
		$PodaneHaslo = InputBox("Podaj has³o", "Aby zmieniæ ustawienia wpisz has³o", "", "*", -1, -1, 10, 10, 15)
	ElseIf $Mode = 1 Then
		$PodaneHaslo = InputBox("Podaj has³o", "Wykorzysta³eœ juz dzisiaj ca³y czas, wpisz has³o, aby korzystaæ nadal z komputera!" & @CRLF & "Masz 30 sekund na próbê." & @CRLF & "Próba " & $i & "/3", "", "*", -1, -1, 10, 10, 30)
	ElseIf $Mode = 2 Then
		$PodaneHaslo = InputBox("Podaj has³o", "Czas min¹³, wpisz has³o, aby korzystaæ nadal z komputera!" & @CRLF & "Masz 30 sekund na próbê." & @CRLF & "Próba " & $i & "/3", "", "*", -1, -1, 10, 10, 30)
	ElseIf $Mode = 3 Then
		$PodaneHaslo = InputBox("Podaj has³o", "Aby korzystaæ bez limitu czasowego, podaj has³o. Nie s³uchasz nikogo kiedy koñczysz, wiêc masz ustalony limit dzienny " & IniRead($IniConf, "conf", "MaxTime", "") & " minut." & @CRLF & "Masz 30 sekund na próbê." & @CRLF & "Próba " & $i & "/3", "", "*", -1, -1, 10, 10, 30)
	ElseIf $Mode = 4 Then
		$PodaneHaslo = InputBox("Podaj has³o", "Podaj has³o, aby zmieniæ dzienny limit czasowy.", "", "*", -1, -1, 10, 10, 30)
	ElseIf $Mode = 5 Then
		$PodaneHaslo = InputBox("Podaj has³o", "Podaj has³o, aby zmieniæ wykorzystany dzisiaj czas.", "", "*", -1, -1, 10, 10, 30)
	ElseIf $Mode = 6 Then
		$PodaneHaslo = InputBox("Podaj has³o", "Podaj has³o, aby wy³¹czyæ ograniczenie czasowe.", "", "*", -1, -1, 10, 10, 30)
	EndIf

	If $PodaneHaslo = $Haslo Then Return True
	If $PodaneHaslo = $HasloAdmin Then Return "asd"
EndFunc   ;==>Autoryzacja

Func Zarzadzanie()
	If Autoryzacja(0) Then
		Local $Odp = InputBox("Zarz¹dzanie", "Wybierz funkcjê:" & @CRLF & "1: Zmieñ maksymalny czas" & @CRLF & "2: Zmieñ wykorzystany czas" & @CRLF & "3: Wy³¹cz")
		Select
			Case $Odp = 1
				ChangeMaxTime()
			Case $Odp = 2
				ChangeCurrentTime()
			Case $Odp = 3
				exi()
			Case Else
				MsgBox(16, "B³êdna funkcja", "Wybrano funkcjê która nie istnieje!", 3)

		EndSelect
	Else
		MsgBox(16, "B³êdne has³o", "Has³o nieprawid³owe!", 3)
	EndIf
EndFunc   ;==>Zarzadzanie

Func minuta()
	Local $minuty
	Local $MaxTime = IniRead($IniConf, "conf", "MaxTime", "120")
	$minuty = Int(IniRead($IniTime, "time", "TimeToday", "120"))
	If $minuty < $MaxTime Then
		$minuty += 1
		IniWrite($IniTime, "time", "TimeToday", $minuty)
	Else
		AdlibUnRegister("minuta")
		MsgBox(48, "Koniec czasu", "Czas siê skoñczy³, aby korzystaæ dalej bêdziesz musia³ podaæ has³o, masz 3 próby.", 15)
		For $i = 1 To 3 Step 1
			If Autoryzacja(2, $i) Then exi()
		Next
		shut()
	EndIf
EndFunc   ;==>minuta

Func TrayMaxTime()
	If Autoryzacja(4) Then
		ChangeMaxTime()
	Else
		MsgBox(16, "B³êdne has³o", "Wpisane has³o nie jest poprawne!", 15)
	EndIf
EndFunc   ;==>TrayMaxTime

Func TrayCurrentTime()
	If Autoryzacja(5) Then
		ChangeCurrentTime()
	Else
		MsgBox(16, "B³êdne has³o", "Wpisane has³o nie jest poprawne!", 15)
	EndIf
EndFunc   ;==>TrayCurrentTime

Func TrayClose()
	If Autoryzacja(6) Then
		exi()
	Else
		MsgBox(16, "B³êdne has³o", "Wpisane has³o nie jest poprawne!", 15)
	EndIf
EndFunc   ;==>TrayClose

Func TrayShowTime()
	minuta()
	MsgBox(64, "Pozosta³y czas", "Pozosta³o Ci " & Int(IniRead($IniConf, "conf", "MaxTime", "0")) - Int(IniRead($IniTime, "time", "TimeToday", "99999999")) & " minut z " & Int(IniRead($IniConf, "conf", "MaxTime", "0")) & "." & @CRLF & "Czyli wykorzysta³eœ juz " & Int(IniRead($IniTime, "time", "TimeToday", "99999999")) & " minut." & @CRLF & @CRLF & "Kombinujesz, wiêc kazde takie sprawdzenie, kosztuje Ciê 1 minutê." & @CRLF & "To okno zniknie za 30 sekund.", 30)
EndFunc   ;==>TrayShowTime

Func shut()
	Shutdown(1)
EndFunc   ;==>shut

Func exi()
	MsgBox(64, "Koñczenie pracy programu", "Program zosta³ wy³¹czony, czas nie bêdzie liczony do momentu ponownego uruchomienia programu.")
	Exit
EndFunc   ;==>exi


