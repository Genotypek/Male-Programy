#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Ikony\Cards.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <ComboConstants.au3>
#include <Array.au3>

Global $config = "C:\Tysiac\Data.ini"
Global $Session
Global $p1, $p2, $p3, $p4, $b
Global $pp1, $pp2, $pp3, $pp4
Global $RozdaniaCount
Global $Gracz
Global $Rozdajacy

If IniRead($config, "INFO", "Create", "0") = 0 Then
	DirCreate("C:\Tysiac")
	IniWrite($config, "INFO", "Create", "1")
	IniWrite($config, "INFO", "Count", "0")
EndIf

Global $MainGUI, $Opcje, $NewGame, $Rozdania, $Load

#Region
$Load = GUICreate("Zapisane Gry", 375, 288, 789, 372, $WS_CLIPSIBLINGS, -1, $MainGUI)
$ZapisaneGry = GUICtrlCreateListView("Count|Nazwa Gry", 24, 24, 322, 182)
_GUICtrlListView_SetColumn($ZapisaneGry, 0, "Count", 0)
_GUICtrlListView_SetColumn($ZapisaneGry, 1, "Nazwa Gry", 302)
$Wczytaj = GUICtrlCreateButton("Wczytaj", 24, 216, 99, 25)
$Usun = GUICtrlCreateButton("Usuñ", 136, 216, 99, 25)
$NieWczytaj = GUICtrlCreateButton("Anuluj", 248, 216, 99, 25)
#EndRegion

#Region
$MainGUI = GUICreate("Tysi¹c - Gra Karciana", 322, 442, -1, -1)
$New_Game = GUICtrlCreateButton("Nowa Gra", 24, 24, 123, 25)
$Load_Game = GUICtrlCreateButton("Wczytaj Grê", 176, 24, 123, 25)
$wyniki = GUICtrlCreateListView("Gracz 1| Gracz 2| Gracz 3| Gracz 4", 24, 64, 273, 357, $WS_VSCROLL, $LVS_EX_GRIDLINES + $LVS_EX_FULLROWSELECT + $LVS_EX_INFOTIP)
GUICtrlSetState(-1, $GUI_DISABLE)
For $i = 0 To 3
	_GUICtrlListView_SetColumn($wyniki, $i, "Gracz " & $i + 1, 63)
Next
ControlDisable($MainGUI, "", HWnd(_GUICtrlListView_GetHeader($wyniki)))
GUISetState(@SW_SHOW)
#EndRegion

#Region
$NewGame = GUICreate("Nowa Gra", 160, 306, -1, -1, $WS_CLIPSIBLINGS, -1, $MainGUI)
$NazwaGry = GUICtrlCreateInput("", 16, 16, 121, 21)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, 0, "Nazwa gry")
$IloscGraczy2 = GUICtrlCreateRadio("2 graczy", 16, 48, 113, 17)
$IloscGraczy3 = GUICtrlCreateRadio("3 graczy", 16, 64, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$IloscGraczy4 = GUICtrlCreateRadio("4 graczy", 16, 80, 113, 17)
$ImieGracz1 = GUICtrlCreateInput("", 16, 112, 121, 21)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, 0, "Imiê gracza 1")
$ImieGracz2 = GUICtrlCreateInput("", 16, 136, 121, 21)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, 0, "Imiê gracza 2")
$ImieGracz3 = GUICtrlCreateInput("", 16, 160, 121, 21)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, 0, "Imiê gracza 3")
GUICtrlSetState(-1, $GUI_DISABLE)
$ImieGracz4 = GUICtrlCreateInput("", 16, 184, 121, 21)
GUICtrlSendMsg(-1, $EM_SETCUEBANNER, 0, "Imiê gracza 4")
GUICtrlSetState(-1, $GUI_DISABLE)
$Options = GUICtrlCreateButton("Opcje", 16, 216, 59, 25)
$Stworz = GUICtrlCreateButton("Stwórz", 80, 216, 59, 25)
$Anuluj = GUICtrlCreateButton("Anuluj", 32, 246, 93, 25)
#EndRegion

#Region
$Opcje = GUICreate("Opcje", 162, 200, -1, -1, $WS_CLIPSIBLINGS, -1, $MainGUI)
GUICtrlCreateLabel("Ilosc bomb na gracza: ", 16, 20, 111, 17)
$Bomby = GUICtrlCreateInput("1", 16, 40, 129, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlCreateLabel("Max punktów bez kontraktu:", 16, 72, 139, 17)
$BezKontraktu = GUICtrlCreateInput("800", 16, 96, 129, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
$Zamknij = GUICtrlCreateButton("Zamknij", 24, 128, 115, 25)
#EndRegion

#Region
$Rozdania = GUICreate("", 450, 352, 20, -1, $WS_CLIPSIBLINGS, -1, $MainGUI)
$Odejmij = GUICtrlCreateCheckbox("Odejmuj", 353, 98)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("Teraz karty rozdaje: ", 24, 20, 100, 17)
$OsobaRozdajaca = GUICtrlCreateInput("", 128, 16, 121, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("Kontrakt", 24, 48, 225, 129)
$KontraktGracz1 = GUICtrlCreateRadio("---", 40, 72, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$KontraktGracz2 = GUICtrlCreateRadio("---", 40, 96, 113, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$KontraktGracz3 = GUICtrlCreateRadio("---", 40, 120, 113, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$KontraktGracz4 = GUICtrlCreateRadio("---", 40, 144, 113, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Kontrakt = GUICtrlCreateCombo("100", 156, 90, 75, 25, $CBS_DROPDOWNLIST)
For $i = 110 To 360 Step 10
	GUICtrlSetData($Kontrakt, $i, "100")
Next
GUICtrlSetState(-1, $GUI_DISABLE)
$Button1 = GUICtrlCreateButton("ZatwierdŸ", 156, 120, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Karty", 264, 16, 161, 121)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button2 = GUICtrlCreateButton("Walet", 280, 40, 59, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button4 = GUICtrlCreateButton("Król", 280, 68, 59, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button5 = GUICtrlCreateButton("10", 353, 68, 59, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button6 = GUICtrlCreateButton("As", 280, 96, 59, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button3 = GUICtrlCreateButton("Dama", 353, 40, 59, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Meldunki", 264, 144, 161, 153)
$Button7 = GUICtrlCreateButton("40", 288, 168, 51, 50)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button8 = GUICtrlCreateButton("60", 352, 168, 50, 50)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button9 = GUICtrlCreateButton("80", 288, 232, 50, 50)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button10 = GUICtrlCreateButton("100", 352, 232, 50, 50)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$PunktyGracz1 = GUICtrlCreateRadio("---", 24, 192, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$PunktyGracz2 = GUICtrlCreateRadio("---", 24, 216, 113, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$PunktyGracz3 = GUICtrlCreateRadio("---", 24, 240, 113, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$PunktyGracz4 = GUICtrlCreateRadio("---", 24, 264, 113, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button11 = GUICtrlCreateButton("Bomba", 136, 192, 75, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button12 = GUICtrlCreateButton("Bomba", 136, 216, 75, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button13 = GUICtrlCreateButton("Bomba", 136, 240, 75, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Button14 = GUICtrlCreateButton("Bomba", 136, 264, 75, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$Punkty1 = GUICtrlCreateLabel("0", 216, 193, 40, 17)
$Punkty2 = GUICtrlCreateLabel("0", 216, 217, 40, 17)
$Punkty3 = GUICtrlCreateLabel("0", 216, 241, 40, 17)
$Punkty4 = GUICtrlCreateLabel("0", 216, 265, 40, 17)
$Button15 = GUICtrlCreateButton("Podlicz punkty", 24, 288, 187, 25)
GUICtrlSetState(-1, $GUI_DISABLE)

$gry = IniReadSectionNames($config)
If $gry[0] > 1 Then
	For $gra = 2 To $gry[0]
		GUICtrlCreateListViewItem($gry[$gra] & "|" & IniRead($config, $gry[$gra], $gry[$gra], "0"), $ZapisaneGry)
	Next
EndIf

While 1
	Local $Gracze

	If _IsChecked($IloscGraczy2) And $Gracze <> 2 Then
		GUICtrlSetData($ImieGracz3, "")
		GUICtrlSetData($ImieGracz4, "")
		GUICtrlSetState($ImieGracz3, $GUI_DISABLE)
		GUICtrlSetState($ImieGracz4, $GUI_DISABLE)
		$Gracze = 2
	EndIf
	If _IsChecked($IloscGraczy3) And $Gracze <> 3 Then
		GUICtrlSetData($ImieGracz4, "")
		GUICtrlSetState($ImieGracz3, $GUI_ENABLE)
		GUICtrlSetState($ImieGracz4, $GUI_DISABLE)
		$Gracze = 3
	EndIf
	If _IsChecked($IloscGraczy4) And $Gracze <> 4 Then
		GUICtrlSetState($ImieGracz3, $GUI_ENABLE)
		GUICtrlSetState($ImieGracz4, $GUI_ENABLE)
		$Gracze = 4
	EndIf
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			$e = MsgBox(4, "Wyjœcie", "Jesteœ pewien, ¿e chcesz wy³¹czyæ program?")
			If $e <> 7 Then Exit
		Case $New_Game
			GUICtrlSetData($NazwaGry, "")
			GUICtrlSetData($ImieGracz1, "")
			GUICtrlSetData($ImieGracz2, "")
			GUICtrlSetData($ImieGracz3, "")
			GUICtrlSetData($ImieGracz4, "")
			GUICtrlSetData($BezKontraktu, "800")
			GUICtrlSetData($Bomby, "1")
			GUICtrlSetState($IloscGraczy2, $GUI_CHECKED)
			GUISetState(@SW_SHOW, $NewGame)
		Case $Anuluj
			GUISetState(@SW_HIDE, $NewGame)
		Case $Options
			GUISetState(@SW_SHOW, $Opcje)
		Case $Zamknij
			GUISetState(@SW_HIDE, $Opcje)
		Case $Stworz
			$OK = True
			If $Gracze = 2 Then
				If GUICtrlRead($ImieGracz1) = "" Then $OK = False
				If GUICtrlRead($ImieGracz2) = "" Then $OK = False
				_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
				_GUICtrlListView_SetColumn($wyniki, 2, "", 0)
				For $i = 0 To 1
					_GUICtrlListView_SetColumn($wyniki, $i, "Gracz " & $i + 1, 126)
				Next
			EndIf
			If $Gracze = 3 Then
				_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
				For $i = 0 To 2
					_GUICtrlListView_SetColumn($wyniki, $i, "Gracz " & $i + 1, 84)
				Next
				If GUICtrlRead($ImieGracz1) = "" Then $OK = False
				If GUICtrlRead($ImieGracz2) = "" Then $OK = False
				If GUICtrlRead($ImieGracz3) = "" Then $OK = False
			EndIf
			If $Gracze = 4 Then
				For $i = 0 To 3
					_GUICtrlListView_SetColumn($wyniki, $i, "Gracz " & $i + 1, 63)
				Next
				If GUICtrlRead($ImieGracz1) = "" Then $OK = False
				If GUICtrlRead($ImieGracz2) = "" Then $OK = False
				If GUICtrlRead($ImieGracz3) = "" Then $OK = False
				If GUICtrlRead($ImieGracz4) = "" Then $OK = False
			EndIf
			If GUICtrlRead($NazwaGry) = "" Then $OK = False
			If $OK Then
				Local $l
				$Count = IniRead($config, "INFO", "count", "0")
				$RozdaniaCount = 0
				$Limit = GUICtrlRead($BezKontraktu)
				Rozdanie()
				_GUICtrlListView_DeleteAllItems($wyniki)
				For $i = 1 To IniRead($Session, "INFO", "Gracze", "0")
					$l = $l & "0|"
					IniWrite($Session, "0", "gr" & $i, Eval("p" & $i))
				Next
				GUICtrlCreateListViewItem($l, $wyniki)
				$Count += 1
				IniWrite($config, "INFO", "count", $Count)
				IniWrite($config, $Count, $Count, GUICtrlRead($NazwaGry))
				$gry = IniReadSectionNames($config)
				_GUICtrlListView_DeleteAllItems($ZapisaneGry)
				If $gry[0] > 1 Then
					For $gra = 2 To $gry[0]
						GUICtrlCreateListViewItem($gry[$gra] & "|" & IniRead($config, $gry[$gra], $gry[$gra], "0"), $ZapisaneGry)
					Next
				EndIf
			Else
				MsgBox(16, "B³¹d", "Nie podano wszystkich informacji!")
			EndIf
		Case $Button1
			$Pula = GUICtrlRead($Kontrakt)
			GUICtrlSetState($KontraktGracz1, $GUI_DISABLE)
			GUICtrlSetState($KontraktGracz2, $GUI_DISABLE)
			GUICtrlSetState($KontraktGracz3, $GUI_DISABLE)
			GUICtrlSetState($KontraktGracz4, $GUI_DISABLE)
			GUICtrlSetState($Kontrakt, $GUI_DISABLE)
			GUICtrlSetState($Button1, $GUI_DISABLE)
			For $i = 2 To 10
				GUICtrlSetState(Eval("Button" & $i), $GUI_ENABLE)
			Next
			If _IsChecked($KontraktGracz1) And IniRead($Session, "INFO", "BombyGr1", "0") <> IniRead($Session, "INFO", "LimitBomb", "0") Then GUICtrlSetState($Button11, $GUI_ENABLE)
			If _IsChecked($KontraktGracz2) And IniRead($Session, "INFO", "BombyGr2", "0") <> IniRead($Session, "INFO", "LimitBomb", "0") Then GUICtrlSetState($Button12, $GUI_ENABLE)
			If _IsChecked($KontraktGracz3) And IniRead($Session, "INFO", "BombyGr3", "0") <> IniRead($Session, "INFO", "LimitBomb", "0") Then GUICtrlSetState($Button13, $GUI_ENABLE)
			If _IsChecked($KontraktGracz4) And IniRead($Session, "INFO", "BombyGr4", "0") <> IniRead($Session, "INFO", "LimitBomb", "0") Then GUICtrlSetState($Button14, $GUI_ENABLE)
			GUICtrlSetState($Button15, $GUI_ENABLE)
			GUICtrlSetState($Odejmij, $GUI_ENABLE)
			For $i = 1 To IniRead($Session, "INFO", "Gracze", "0")
				GUICtrlSetState(Eval("PunktyGracz" & $i), $GUI_ENABLE)
			Next
		Case $Button2
			Add(2)
		Case $Button3
			Add(3)
		Case $Button4
			Add(4)
		Case $Button5
			Add(10)
		Case $Button6
			Add(11)
		Case $Button7
			Add(40)
		Case $Button8
			Add(60)
		Case $Button9
			Add(80)
		Case $Button10
			Add(100)
		Case $Button15
			If _IsChecked($KontraktGracz1) Then
				$pp1 = GUICtrlRead($Punkty1) - Mod(GUICtrlRead($Punkty1), 10)
				If $pp1 >= GUICtrlRead($Kontrakt) Then $p1 += GUICtrlRead($Kontrakt)
				If $pp1 < $Pula Then
					$p1 -= $Pula
				EndIf
				If $pp1 >= GUICtrlRead($Kontrakt) Then
					$pp1 = "+" & GUICtrlRead($Kontrakt)
				Else
					$pp1 = "-" & GUICtrlRead($Kontrakt)
				EndIf
			EndIf
			If _IsChecked($KontraktGracz2) Then
				$pp2 = GUICtrlRead($Punkty2) - Mod(GUICtrlRead($Punkty2), 10)
				If $pp2 >= GUICtrlRead($Kontrakt) Then $p2 += GUICtrlRead($Kontrakt)
				If $pp2 < GUICtrlRead($Kontrakt) Then
					$p2 -= GUICtrlRead($Kontrakt)
				EndIf
				If $pp2 >= GUICtrlRead($Kontrakt) Then
					$pp2 = "+" & GUICtrlRead($Kontrakt)
				Else
					$pp2 = "-" & GUICtrlRead($Kontrakt)
				EndIf
			EndIf
			If _IsChecked($KontraktGracz3) Then
				$pp3 = GUICtrlRead($Punkty3) - Mod(GUICtrlRead($Punkty3), 10)
				If $pp3 >= GUICtrlRead($Kontrakt) Then $p3 += GUICtrlRead($Kontrakt)
				If $pp3 < GUICtrlRead($Kontrakt) Then
					$p3 -= GUICtrlRead($Kontrakt)
				EndIf
				If $pp3 >= GUICtrlRead($Kontrakt) Then
					$pp3 = "+" & GUICtrlRead($Kontrakt)
				Else
					$pp3 = "-" & GUICtrlRead($Kontrakt)
				EndIf
			EndIf
			If _IsChecked($KontraktGracz4) Then
				$pp4 = GUICtrlRead($Punkty4) - Mod(GUICtrlRead($Punkty4), 10)
				If $pp4 >= GUICtrlRead($Kontrakt) Then $p4 += GUICtrlRead($Kontrakt)
				If $pp4 < GUICtrlRead($Kontrakt) Then
					$p4 -= GUICtrlRead($Kontrakt)
				EndIf
				If $pp4 >= GUICtrlRead($Kontrakt) Then
					$pp4 = "+" & GUICtrlRead($Kontrakt)
				Else
					$pp4 = "-" & GUICtrlRead($Kontrakt)
				EndIf
			EndIf
			If Not _IsChecked($KontraktGracz1) And $p1 < IniRead($Session, "INFO", "LimitPkt", 800) Then
				If Mod(GUICtrlRead($Punkty1), 10) >= 6 Then $pp1 = GUICtrlRead($Punkty1) + (10 - Mod(GUICtrlRead($Punkty1), 10))
				If Mod(GUICtrlRead($Punkty1), 10) <= 5 Then $pp1 = GUICtrlRead($Punkty1) - Mod(GUICtrlRead($Punkty1), 10)
				$p1 += $pp1
				$pp1 = "+" & $pp1
			ElseIf (Not _IsChecked($KontraktGracz1) And GUICtrlRead($Punkty1) = "0") Or (Not _IsChecked($KontraktGracz1) And $p1 >= IniRead($Session, "INFO", "LimitPkt", 800)) Then
				$pp1 = "+0"
			EndIf
			If Not _IsChecked($KontraktGracz2) And $p2 < IniRead($Session, "INFO", "LimitPkt", 800) Then
				If Mod(GUICtrlRead($Punkty2), 10) >= 6 Then $pp2 = GUICtrlRead($Punkty2) + (10 - Mod(GUICtrlRead($Punkty2), 10))
				If Mod(GUICtrlRead($Punkty2), 10) <= 5 Then $pp2 = GUICtrlRead($Punkty2) - Mod(GUICtrlRead($Punkty2), 10)
				$p2 += $pp2
				$pp2 = "+" & $pp2
			ElseIf (Not _IsChecked($KontraktGracz2) And GUICtrlRead($Punkty2) = "0") Or (Not _IsChecked($KontraktGracz2) And $p2 >= IniRead($Session, "INFO", "LimitPkt", 800)) Then
				$pp2 = "+0"
			EndIf
			If Not _IsChecked($KontraktGracz3) And IniRead($Session, "INFO", "Gracze", "0") >= 3 And $p3 < IniRead($Session, "INFO", "LimitPkt", 800) Then
				If Mod(GUICtrlRead($Punkty3), 10) >= 6 Then $pp3 = GUICtrlRead($Punkty3) + (10 - Mod(GUICtrlRead($Punkty3), 10))
				If Mod(GUICtrlRead($Punkty3), 10) <= 5 Then $pp3 = GUICtrlRead($Punkty3) - Mod(GUICtrlRead($Punkty3), 10)
				$p3 += $pp3
				$pp3 = "+" & $pp3
			ElseIf (Not _IsChecked($KontraktGracz3) And GUICtrlRead($Punkty3) = "0") Or (Not _IsChecked($KontraktGracz3) And $p3 >= IniRead($Session, "INFO", "LimitPkt", 800)) Then
				$pp3 = "+0"
			EndIf
			If Not _IsChecked($KontraktGracz4) And IniRead($Session, "INFO", "Gracze", "0") >= 4 And $p4 < IniRead($Session, "INFO", "LimitPkt", 800) Then
				If Mod(GUICtrlRead($Punkty4), 10) >= 6 Then $pp4 = GUICtrlRead($Punkty4) + (10 - Mod(GUICtrlRead($Punkty4), 10))
				If Mod(GUICtrlRead($Punkty4), 10) <= 5 Then $pp4 = GUICtrlRead($Punkty4) - Mod(GUICtrlRead($Punkty4), 10)
				$p4 += $pp4
				$pp4 = "+" & $pp4
			ElseIf (Not _IsChecked($KontraktGracz4) And GUICtrlRead($Punkty4) = "0") Or (Not _IsChecked($KontraktGracz4) And $p4 >= IniRead($Session, "INFO", "LimitPkt", 800)) Then
				$pp4 = "+0"
			EndIf
			;If GUICtrlRead($Punkty1) = 0 And Not _IsChecked($KontraktGracz1) Then $pp1 = "+0"
			;If GUICtrlRead($Punkty2) = 0 And Not _IsChecked($KontraktGracz2) Then $pp2 = "+0"
			;If GUICtrlRead($Punkty3) = 0 And Not _IsChecked($KontraktGracz3) Then $pp3 = "+0"
			;If GUICtrlRead($Punkty4) = 0 And Not _IsChecked($KontraktGracz4) Then $pp4 = "+0"
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")|" & $p4 & " (" & $pp4 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 2 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")", $wyniki)
			Rozdanie1()
		Case $Button11
			$p = 120 / (IniRead($Session, "INFO", "Gracze", "0") - 1)
			$bombyGr1 = IniRead($Session, "INFO", "BombyGr1", "0")
			$bombyGr1 += 1
			IniWrite($Session, "INFO", "BombyGr1", $bombyGr1)
			If IniRead($Session, "INFO", "Gracze", "0") = 2 Then
				$p2 += $p
			EndIf
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then
				$p2 += $p
				$p3 += $p
			EndIf
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then
				$p2 += $p
				$p3 += $p
				$p4 += $p
			EndIf
			$pp1 = 0
			$pp2 = "+" & $p
			$pp3 = "+" & $p
			$pp4 = "+" & $p
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")|" & $p4 & " (" & $pp4 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 2 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")", $wyniki)
			Rozdanie1()
		Case $Button12
			$p = 120 / (IniRead($Session, "INFO", "Gracze", "0") - 1)
			$bombyGr2 = IniRead($Session, "INFO", "BombyGr2", "0")
			$bombyGr2 += 1
			IniWrite($Session, "INFO", "BombyGr2", $bombyGr2)
			If IniRead($Session, "INFO", "Gracze", "0") = 2 Then
				$p1 += $p
			EndIf
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then
				$p1 += $p
				$p3 += $p
			EndIf
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then
				$p1 += $p
				$p3 += $p
				$p4 += $p
			EndIf
			$pp1 = "+" & $p
			$pp2 = 0
			$pp3 = "+" & $p
			$pp4 = "+" & $p
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")|" & $p4 & " (" & $pp4 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 2 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")", $wyniki)
			Rozdanie1()
		Case $Button13
			$p = 120 / (IniRead($Session, "INFO", "Gracze", "0") - 1)
			$bombyGr3 = IniRead($Session, "INFO", "BombyGr3", "0")
			$bombyGr3 += 1
			IniWrite($Session, "INFO", "BombyGr3", $bombyGr3)
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then
				$p1 += $p
				$p2 += $p
			EndIf
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then
				$p1 += $p
				$p2 += $p
				$p4 += $p
			EndIf
			$pp1 = "+" & $p
			$pp2 = "+" & $p
			$pp3 = 0
			$pp4 = "+" & $p
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")|" & $p4 & " (" & $pp4 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 2 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")", $wyniki)
			Rozdanie1()
		Case $Button14
			$p = 120 / (IniRead($Session, "INFO", "Gracze", "0") - 1)
			$bombyGr4 = IniRead($Session, "INFO", "BombyGr4", "0")
			$bombyGr4 += 1
			IniWrite($Session, "INFO", "BombyGr4", $bombyGr4)
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then
				$p1 += $p
				$p2 += $p
				$p3 += $p
			EndIf
			$pp1 = "+" & $p
			$pp2 = "+" & $p
			$pp3 = "+" & $p
			$pp4 = 0
			If IniRead($Session, "INFO", "Gracze", "0") = 4 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")|" & $p4 & " (" & $pp4 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 3 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")|" & $p3 & " (" & $pp3 & ")", $wyniki)
			If IniRead($Session, "INFO", "Gracze", "0") = 2 Then GUICtrlCreateListViewItem($p1 & " (" & $pp1 & ")|" & $p2 & " (" & $pp2 & ")", $wyniki)
			Rozdanie1()
		Case $Load_Game
			GUISetState(@SW_SHOW, $Load)
		Case $NieWczytaj
			GUISetState(@SW_HIDE, $Load)
		Case $Usun
			If GUICtrlRead($ZapisaneGry) Then
				$a = GUICtrlRead(GUICtrlRead($ZapisaneGry))
				$b = StringSplit($a, "|")
				$Delete = StringSplit($Session, "\")
				$Delete1 = StringSplit($Delete[3], ".")
				$Del = $Delete1[1]
				$Del += 1
				If $b[1] = $Del Then
					GUISetState(@SW_HIDE, $Rozdania)
					_GUICtrlListView_DeleteAllItems($wyniki)
					For $i = 0 To 3
						_GUICtrlListView_SetColumn($wyniki, $i, "Gracz " & $i + 1, 63)
					Next
					GUICtrlSetState($wyniki, $GUI_DISABLE)
				EndIf
				IniDelete($config, $b[1])
				FileDelete("C:\Tysiac\" & $b[1] - 1 & ".ini")
				GUICtrlDelete(GUICtrlRead($ZapisaneGry))
			EndIf
		Case $Wczytaj
			If GUICtrlRead($ZapisaneGry) Then
				$a = GUICtrlRead(GUICtrlRead($ZapisaneGry))
				$b = StringSplit($a, "|")
				Load()
			EndIf
	EndSwitch
WEnd

Func Load()
	Local $aDel[4] = [0, 1, 2, 3]
	_ArrayDelete($Gracz, $aDel)
	$Session = "C:\Tysiac\" & $b[1] - 1 & ".ini"
	$tura = IniReadSectionNames($Session)
	_GUICtrlListView_DeleteAllItems($wyniki)
	GUICtrlSetState($wyniki, $GUI_ENABLE)
	If $tura[0] > 1 Then
		Local $c
		For $rozd = 2 To $tura[0]
			$c = ""
			For $i = 1 To IniRead($Session, "INFO", "Gracze", "0")
				$c = $c & IniRead($Session, $tura[$rozd], "gr" & $i, "B³¹d!") & "|"
			Next
			GUICtrlCreateListViewItem($c, $wyniki)
		Next
	EndIf
	GUISetState(@SW_HIDE, $Load)
	GUISetState(@SW_SHOW, $Rozdania)
	WinSetTitle($Rozdania, "", "Rozgrywka [" & IniRead($Session, "INFO", "Nazwa", "") & "]")
	$RozdaniaCount = IniRead($Session, "INFO", "Rozdania", "0")
	$Rozdajacy = IniRead($Session, "INFO", "rozdaje", "0")
	$Rozdajacy = Mod($Rozdajacy, IniRead($Session, "INFO", "Gracze", "0"))
	$BezKontraktu = IniRead($Session, "INFO", "LimitPkt", "800")
	$Gracze = IniRead($Session, "INFO", "Gracze", "0")
	IniWrite($Session, "INFO", "Rozdaje", $Rozdajacy)
	For $i = 2 To 15
		GUICtrlSetState(Eval("Button" & $i), $GUI_DISABLE)
	Next
	GUICtrlSetState($Odejmij, $GUI_DISABLE)
	GUICtrlSetState($Button1, $GUI_ENABLE)
	Dim $Gracz[IniRead($Session, "INFO", "Gracze", "0")]
	For $i = 1 To IniRead($Session, "INFO", "Gracze", "0")
		$Gracz[$i - 1] = IniRead($Session, "INFO", "Gracz" & $i, "0")
		Assign("p" & $i, IniRead($Session, "INFO", "PunktyGr" & $i, "0"))
	Next
	For $i = 1 To 4
		GUICtrlSetState(Eval("PunktyGracz" & $i), $GUI_DISABLE)
		GUICtrlSetData(Eval("Punkty" & $i), "0")
	Next
	GUISetState(@SW_HIDE, $Opcje)
	GUISetState(@SW_HIDE, $NewGame)
	GUISetState(@SW_SHOW, $Rozdania)
	GUICtrlSetData($PunktyGracz1, $Gracz[0])
	GUICtrlSetData($PunktyGracz2, $Gracz[1])
	GUICtrlSetState($wyniki, $GUI_ENABLE)
	GUICtrlSetState($Button1, $GUI_ENABLE)
	GUICtrlSetState($KontraktGracz1, $GUI_ENABLE)
	GUICtrlSetData($KontraktGracz1, $Gracz[0])
	GUICtrlSetState($KontraktGracz2, $GUI_ENABLE)
	GUICtrlSetData($KontraktGracz2, $Gracz[1])
	GUICtrlSetState($KontraktGracz2, $GUI_ENABLE)
	If $Gracze >= 3 Then
		GUICtrlSetState($KontraktGracz3, $GUI_ENABLE)
		GUICtrlSetData($KontraktGracz3, $Gracz[2])
		GUICtrlSetData($PunktyGracz3, $Gracz[2])
	EndIf
	If $Gracze >= 4 Then
		GUICtrlSetState($KontraktGracz4, $GUI_ENABLE)
		GUICtrlSetData($KontraktGracz4, $Gracz[3])
		GUICtrlSetData($PunktyGracz4, $Gracz[3])
	EndIf
	If IniRead($Session, "INFO", "Gracze", "0") = 2 Then
		_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
		_GUICtrlListView_SetColumn($wyniki, 2, "", 0)
		For $i = 0 To 1
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 126)
		Next
	EndIf
	If IniRead($Session, "INFO", "Gracze", "0") = 3 Then
		_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
		For $i = 0 To 2
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 84)
		Next
	EndIf
	If IniRead($Session, "INFO", "Gracze", "0") = 4 Then
		For $i = 0 To 3
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 63)
		Next
	EndIf
	GUICtrlSetState($Kontrakt, $GUI_ENABLE)
	GUICtrlSetData($OsobaRozdajaca, $Gracz[IniRead($Session, "INFO", "Rozdaje", "1")])
	$Rozdajacy += 1
EndFunc   ;==>Load

Func Add($Pkt)
	If _IsChecked($Odejmij) Then $Pkt *= -1
	If _IsChecked($PunktyGracz1) Then
		GUICtrlSetData($Punkty1, GUICtrlRead($Punkty1) + $Pkt)
	EndIf
	If _IsChecked($PunktyGracz2) Then
		GUICtrlSetData($Punkty2, GUICtrlRead($Punkty2) + $Pkt)
	EndIf
	If _IsChecked($PunktyGracz3) Then
		GUICtrlSetData($Punkty3, GUICtrlRead($Punkty3) + $Pkt)
	EndIf
	If _IsChecked($PunktyGracz4) Then
		GUICtrlSetData($Punkty4, GUICtrlRead($Punkty4) + $Pkt)
	EndIf
EndFunc   ;==>Add

Func Rozdanie1()
	If $p1 >= 1000 Then
		$Win = "Brawo! Wygra³:" & @CRLF & @CRLF
		If $p1 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz1", "Nikt") & @CRLF
		If $p2 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz2", "Nikt") & @CRLF
		If $p3 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz3", "Nikt") & @CRLF
		If $p4 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz4", "Nikt") & @CRLF
		$Win = $Win & @CRLF & "Gratulacje!"
		GUISetState(@SW_HIDE, $Rozdania)
		MsgBox(64, "Zwyciêstwo!", $Win)
		FileDelete($Session)
		$Delete = StringSplit($Session, "\")
		$Delete1 = StringSplit($Delete[3], ".")
		$Del = $Delete1[1]
		$Del += 1
		IniDelete($config, $Del)
		$gry = IniReadSectionNames($config)
		_GUICtrlListView_DeleteAllItems($ZapisaneGry)
		If $gry[0] > 1 Then
			For $gra = 2 To $gry[0]
				GUICtrlCreateListViewItem($gry[$gra] & "|" & IniRead($config, $gry[$gra], $gry[$gra], "0"), $ZapisaneGry)
			Next
		EndIf
		Return
	EndIf
	If $p2 >= 1000 Then
		$Win = "Brawo! Wygra³:" & @CRLF & @CRLF
		If $p1 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz1", "Nikt") & @CRLF
		If $p2 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz2", "Nikt") & @CRLF
		If $p3 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz3", "Nikt") & @CRLF
		If $p4 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz4", "Nikt") & @CRLF
		$Win = $Win & @CRLF & "Gratulacje!"
		GUISetState(@SW_HIDE, $Rozdania)
		MsgBox(64, "Zwyciêstwo!", $Win)
		FileDelete($Session)
		$Delete = StringSplit($Session, "\")
		$Delete1 = StringSplit($Delete[3], ".")
		$Del = $Delete1[1]
		$Del += 1
		IniDelete($config, $Del)
		$gry = IniReadSectionNames($config)
		_GUICtrlListView_DeleteAllItems($ZapisaneGry)
		If $gry[0] > 1 Then
			For $gra = 2 To $gry[0]
				GUICtrlCreateListViewItem($gry[$gra] & "|" & IniRead($config, $gry[$gra], $gry[$gra], "0"), $ZapisaneGry)
			Next
		EndIf
		Return
	EndIf
	If $p3 >= 1000 Then
		$Win = "Brawo! Wygra³:" & @CRLF & @CRLF
		If $p1 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz1", "Nikt") & @CRLF
		If $p2 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz2", "Nikt") & @CRLF
		If $p3 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz3", "Nikt") & @CRLF
		If $p4 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz4", "Nikt") & @CRLF
		$Win = $Win & @CRLF & "Gratulacje!"
		GUISetState(@SW_HIDE, $Rozdania)
		MsgBox(64, "Zwyciêstwo!", $Win)
		FileDelete($Session)
		$Delete = StringSplit($Session, "\")
		$Delete1 = StringSplit($Delete[3], ".")
		$Del = $Delete1[1]
		$Del += 1
		IniDelete($config, $Del)
		$gry = IniReadSectionNames($config)
		_GUICtrlListView_DeleteAllItems($ZapisaneGry)
		If $gry[0] > 1 Then
			For $gra = 2 To $gry[0]
				GUICtrlCreateListViewItem($gry[$gra] & "|" & IniRead($config, $gry[$gra], $gry[$gra], "0"), $ZapisaneGry)
			Next
		EndIf
		Return
	EndIf
	If $p4 >= 1000 Then
		$Win = "Brawo! Wygra³:" & @CRLF & @CRLF
		If $p1 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz1", "Nikt") & @CRLF
		If $p2 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz2", "Nikt") & @CRLF
		If $p3 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz3", "Nikt") & @CRLF
		If $p4 >= 1000 Then $Win = $Win & IniRead($Session, "INFO", "Gracz4", "Nikt") & @CRLF
		$Win = $Win & @CRLF & "Gratulacje!"
		GUISetState(@SW_HIDE, $Rozdania)
		MsgBox(64, "Zwyciêstwo!", $Win)
		FileDelete($Session)
		$Delete = StringSplit($Session, "\")
		$Delete1 = StringSplit($Delete[3], ".")
		$Del = $Delete1[1]
		$Del += 1
		IniDelete($config, $Del)
		$gry = IniReadSectionNames($config)
		_GUICtrlListView_DeleteAllItems($ZapisaneGry)
		If $gry[0] > 1 Then
			For $gra = 2 To $gry[0]
				GUICtrlCreateListViewItem($gry[$gra] & "|" & IniRead($config, $gry[$gra], $gry[$gra], "0"), $ZapisaneGry)
			Next
		EndIf
		Return
	EndIf
	For $i = 1 To IniRead($Session, "INFO", "Gracze", "0")
		IniWrite($Session, $RozdaniaCount, "gr" & $i, Eval("p" & $i) & " (" & Eval("pp" & $i) & ")")
		IniWrite($Session, "INFO", "PunktyGr" & $i, Eval("p" & $i))
	Next
	$RozdaniaCount += 1
	IniWrite($Session, "INFO", "Rozdania", $RozdaniaCount)
	$Rozdajacy = Mod($Rozdajacy, IniRead($Session, "INFO", "Gracze", "0"))
	IniWrite($Session, "INFO", "Rozdaje", $Rozdajacy)
	GUICtrlSetState($Button1, $GUI_ENABLE)
	For $i = 2 To 15
		GUICtrlSetState(Eval("Button" & $i), $GUI_DISABLE)
	Next
	GUICtrlSetState($Odejmij, $GUI_DISABLE)
	For $i = 1 To 4
		GUICtrlSetState(Eval("PunktyGracz" & $i), $GUI_DISABLE)
		GUICtrlSetData(Eval("Punkty" & $i), "0")
	Next
	GUISetState(@SW_HIDE, $Opcje)
	GUISetState(@SW_HIDE, $NewGame)
	GUISetState(@SW_SHOW, $Rozdania)
	GUICtrlSetData($PunktyGracz1, $Gracz[0])
	GUICtrlSetData($PunktyGracz2, $Gracz[1])
	GUICtrlSetState($wyniki, $GUI_ENABLE)
	GUICtrlSetState($Button1, $GUI_ENABLE)
	GUICtrlSetState($KontraktGracz1, $GUI_ENABLE)
	GUICtrlSetData($KontraktGracz1, $Gracz[0])
	GUICtrlSetState($KontraktGracz2, $GUI_ENABLE)
	GUICtrlSetData($KontraktGracz2, $Gracz[1])
	GUICtrlSetState($KontraktGracz2, $GUI_ENABLE)
	If $Gracze >= 3 Then
		GUICtrlSetState($KontraktGracz3, $GUI_ENABLE)
		GUICtrlSetData($KontraktGracz3, $Gracz[2])
		GUICtrlSetData($PunktyGracz3, $Gracz[2])
	EndIf
	If $Gracze >= 4 Then
		GUICtrlSetState($KontraktGracz4, $GUI_ENABLE)
		GUICtrlSetData($KontraktGracz4, $Gracz[3])
		GUICtrlSetData($PunktyGracz4, $Gracz[3])
	EndIf
	GUICtrlSetState($Kontrakt, $GUI_ENABLE)
	GUICtrlSetData($OsobaRozdajaca, $Gracz[IniRead($Session, "INFO", "Rozdaje", "1")])
	$Rozdajacy += 1
	If IniRead($Session, "INFO", "Gracze", "0") = 2 Then
		_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
		_GUICtrlListView_SetColumn($wyniki, 2, "", 0)
		For $i = 0 To 1
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 126)
		Next
	EndIf
	If IniRead($Session, "INFO", "Gracze", "0") = 3 Then
		_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
		For $i = 0 To 2
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 84)
		Next
	EndIf
	If IniRead($Session, "INFO", "Gracze", "0") = 4 Then
		For $i = 0 To 3
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 63)
		Next
	EndIf
	GUICtrlSetState($Kontrakt, $GUI_ENABLE)
	GUICtrlSetData($OsobaRozdajaca, $Gracz[IniRead($Session, "INFO", "Rozdaje", "1")])
	$Rozdajacy += 1
EndFunc   ;==>Rozdanie1

Func Rozdanie()
	$RozdaniaCount += 1
	$Session = "C:\Tysiac\" & $Count & ".ini"
	$Rozdajacy = IniRead($Session, "INFO", "rozdaje", 0)
	IniWrite($Session, "INFO", "Rozdania", $RozdaniaCount)
	IniWrite($Session, "INFO", "Gracze", $Gracze)
	IniWrite($Session, "INFO", "Nazwa", GUICtrlRead($NazwaGry))
	IniWrite($Session, "INFO", "Rozdaje", "1")
	IniWrite($Session, "INFO", "Rozdanie", "1")
	IniWrite($Session, "INFO", "LimitBomb", GUICtrlRead($Bomby))
	IniWrite($Session, "INFO", "LimitPkt", $Limit)
	For $i = 1 To $Gracze
		IniWrite($Session, "INFO", "Gracz" & $i, GUICtrlRead(Eval("ImieGracz" & $i)))
		IniWrite($Session, "INFO", "BombyGr" & $i, "0")
		IniWrite($Session, "INFO", "PunktyGr" & $i, "0")
	Next
	Dim $Gracz[IniRead($Session, "INFO", "Gracze", "0")]
	For $i = 1 To IniRead($Session, "INFO", "Gracze", "0")
		$Gracz[$i - 1] = IniRead($Session, "INFO", "Gracz" & $i, "0")
		Assign("p" & $i, IniRead($Session, "INFO", "PunktyGr" & $i, "0"))
	Next
	For $i = 1 To IniRead($Session, "INFO", "Gracze", "0")
		_GUICtrlListView_SetColumn($wyniki, $i - 1, $Gracz[$i - 1])
	Next
	GUICtrlSetState($Button1, $GUI_ENABLE)
	For $i = 2 To 15
		GUICtrlSetState(Eval("Button" & $i), $GUI_DISABLE)
	Next
	GUICtrlSetState($Odejmij, $GUI_DISABLE)
	For $i = 1 To 4
		GUICtrlSetState(Eval("PunktyGracz" & $i), $GUI_DISABLE)
		GUICtrlSetData(Eval("Punkty" & $i), "0")
	Next
	GUISetState(@SW_HIDE, $Opcje)
	GUISetState(@SW_HIDE, $NewGame)
	GUISetState(@SW_SHOW, $Rozdania)
	WinSetTitle($Rozdania, "", "Rozgrywka [" & IniRead($Session, "INFO", "Nazwa", "") & "]")
	GUICtrlSetData($PunktyGracz1, $Gracz[0])
	GUICtrlSetData($PunktyGracz2, $Gracz[1])
	GUICtrlSetState($wyniki, $GUI_ENABLE)
	GUICtrlSetState($KontraktGracz1, $GUI_ENABLE)
	GUICtrlSetData($KontraktGracz1, $Gracz[0])
	GUICtrlSetState($KontraktGracz2, $GUI_ENABLE)
	GUICtrlSetData($KontraktGracz2, $Gracz[1])
	GUICtrlSetState($KontraktGracz2, $GUI_ENABLE)
	If $Gracze >= 3 Then
		GUICtrlSetState($KontraktGracz3, $GUI_ENABLE)
		GUICtrlSetData($KontraktGracz3, $Gracz[2])
		GUICtrlSetData($PunktyGracz3, $Gracz[2])
	EndIf
	If $Gracze >= 4 Then
		GUICtrlSetState($KontraktGracz4, $GUI_ENABLE)
		GUICtrlSetData($KontraktGracz4, $Gracz[3])
		GUICtrlSetData($PunktyGracz4, $Gracz[3])
	EndIf
	GUICtrlSetState($Kontrakt, $GUI_ENABLE)
	GUICtrlSetData($OsobaRozdajaca, $Gracz[IniRead($Session, "INFO", "Rozdaje", "1") - 1])
	$Rozdajacy += 1
	If IniRead($Session, "INFO", "Gracze", "0") = 2 Then
		_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
		_GUICtrlListView_SetColumn($wyniki, 2, "", 0)
		For $i = 0 To 1
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 126)
		Next
	EndIf
	If IniRead($Session, "INFO", "Gracze", "0") = 3 Then
		_GUICtrlListView_SetColumn($wyniki, 3, "", 0)
		For $i = 0 To 2
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 84)
		Next
	EndIf
	If IniRead($Session, "INFO", "Gracze", "0") = 4 Then
		For $i = 0 To 3
			_GUICtrlListView_SetColumn($wyniki, $i, IniRead($Session, "INFO", "Gracz" & $i + 1, "0"), 63)
		Next
	EndIf
	GUICtrlSetState($Kontrakt, $GUI_ENABLE)
	GUICtrlSetData($OsobaRozdajaca, $Gracz[IniRead($Session, "INFO", "Rozdaje", "1")])
	$Rozdajacy += 1
EndFunc   ;==>Rozdanie

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked
