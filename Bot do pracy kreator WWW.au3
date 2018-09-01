#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Aha-Soft-Standard-Portfolio-Receptionist.ico
#AutoIt3Wrapper_Res_Fileversion=1.0.1
#AutoIt3Wrapper_Res_LegalCopyright=Styœ Mateusz
#AutoIt3Wrapper_Res_Language=1045
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <AutoItConstants.au3>
#include <Color.au3>
#include <File.au3>
#include <ScreenCapture.au3>
#include <EditConstants.au3>


HotKeySet("{F3}", "Koniec")
HotKeySet("{F4}", "exi")
HotKeySet("{F5}", "PrzelaczCichy")
HotKeySet("{F6}", "PrzelaczAuto")
HotKeySet("{F11}", "Pomoc")
HotKeySet("{F7}", "PoprzedniKrok")
HotKeySet("{F8}", "NastepnyKrok")

Global $NazwaFirmy, $Adres1, $Adres2, $Nip, $Telefon, $Email, $LinkMapy
Global $ToolTip_DodatkowaInformacja
Global $Tekst[2], $Obraz[2], $Mapa[2], $Formularz[2]

Global $Postep = 0
Global $IloscKrokow = 190
Global $Cichy = 0, $Auto = 0, $AutoInfo = "AUTO OFF", $OsFizyczna = 0
Global $DirMap = ""
Global $IleMap

;---------------------------Tekst------Obraz------Mapa-----Formularz------------
Global $WspolrzedneNor = [[40, 192], [40, 262], [40, 536], [40, 733]]
Global $WspolrzednePro = [[40, 192], [40, 262], [40, 601], [40, 936]]
;---------------------------Tekst------Obraz------Mapa-----Formularz------------

StworzGUI()
Func StworzGUI()
	Global $GUI_Main = GUICreate("Kreator Stron WWW - Styœ Mateusz", 401, 209, 479, 453)
	Global $GUI_Button_Help = GUICtrlCreateButton("?", 374, 7, 19, 19)
	Global $GUI_Label_NazwaFirmy = GUICtrlCreateLabel("Nazwa Firmy:", 8, 8, 67, 17)
	Global $GUI_Input_NazwaFirmy = GUICtrlCreateInput("", 80, 8, 292, 17)
	Global $GUI_Label_PierwszaLiniaAdresu = GUICtrlCreateLabel("Pierwsza linia adresu:", 8, 32, 105, 17)
	Global $GUI_Input_PierwszaLiniaAdresu = GUICtrlCreateInput("", 120, 32, 273, 17)
	Global $GUI_Label_DrugaLiniaAdresu = GUICtrlCreateLabel("Druga linia adresu:", 8, 56, 92, 17)
	Global $GUI_Input_DrugaLiniaAdresu = GUICtrlCreateInput("", 104, 56, 289, 17)
	Global $GUI_Label_Nip = GUICtrlCreateLabel("NIP:", 8, 80, 25, 17)
	Global $GUI_Input_Nip = GUICtrlCreateInput("", 40, 80, 353, 17)
	Global $GUI_Label_Telefon = GUICtrlCreateLabel("Telefon:", 8, 104, 43, 17)
	Global $GUI_Input_Telefon = GUICtrlCreateInput("", 56, 104, 337, 17)
	Global $GUI_Label_Email = GUICtrlCreateLabel("E-mail:", 8, 128, 35, 17)
	Global $GUI_Input_Email = GUICtrlCreateInput("", 48, 128, 345, 17)
	Global $GUI_Label_DirMap = GUICtrlCreateLabel("Mapy:", 8, 152)
	Global $GUI_Input_DirMap = GUICtrlCreateInput("", 48, 152, 271, 17, -1, -1)
	Global $GUI_Button_DirMap = GUICtrlCreateButton("Przegl¹daj...", 324, 151, 69, 19)
	GUICtrlSetStyle($GUI_Input_DirMap, $ES_READONLY)
	Global $GUI_Checkbox_KreatorWWWPro = GUICtrlCreateCheckbox("KreatorWWW PRO", 8, 178)
	Global $GUI_Checkbox_OsFizyczna = GUICtrlCreateCheckbox("Os. Fizyczna", 124, 178)
	Global $GUI_Button_Start = GUICtrlCreateButton("Start", 208, 176, 89, 25)
	Global $GUI_Button_Wyczysc = GUICtrlCreateButton("Wyczyœæ", 304, 176, 89, 25)
	GUISetState(@SW_SHOW)
EndFunc   ;==>StworzGUI

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $GUI_Button_Help
			Pomoc()
		Case $GUI_Button_Wyczysc
			WyczyscDane()
		Case $GUI_Button_Start
			ZaladujDane()
			PokolorujBrakujace()
			ZweryfikujDane()
		Case $GUI_Button_DirMap
			UstawDirMap()
		Case $GUI_Checkbox_OsFizyczna
			PrzelaczOsFizyczna()
	EndSwitch
WEnd

Func UstawDirMap()
	$DirMap = FileSelectFolder("Wybierz folder z mapami", $DirMap)
	GUICtrlSetData($GUI_Input_DirMap, $DirMap)
EndFunc

Func PrzelaczOsFizyczna()
	If GUICtrlRead($GUI_Checkbox_OsFizyczna) <> 4 Then
		$OsFizyczna = 1
		GUICtrlSetStyle($GUI_Input_Nip, $WS_DISABLED)
		GUICtrlSetData($GUI_Input_Nip, "")
	Else
		$OsFizyczna = 0
		GUICtrlSetStyle($GUI_Input_Nip, "")
	EndIf
EndFunc

Func Pomoc()
	MsgBox(64, "Pomoc", "F1 - Wykonaj nastêpny krok" & @CRLF & _
						"F2 - Powtórz krok" & @CRLF & _
						"F3 - Zakoñcz aktualn¹ stronê" & @CRLF & _
						"F4 - Wy³¹cz program" & @CRLF & _
						"F5 - Prze³¹cz tryb cichy" & @CRLF & _
						"F6 - Prze³¹cz tryb auto" & @CRLF & _
						"F7 - Poprzedni krok" & @CRLF & _
						"F8 - Nastêpny krok" & @CRLF & _
						"F11 - Pomoc" & @CRLF & _
						@CRLF & _
						"Pomoc mo¿esz uruchomiæ w ka¿dej chwili." & @CRLF & _
						@CRLF & _
						"Wykona³ Styœ Mateusz")
EndFunc

Func WyczyscDane()
	GUICtrlSetData($GUI_Input_NazwaFirmy, "")
	GUICtrlSetData($GUI_Input_PierwszaLiniaAdresu, "")
	GUICtrlSetData($GUI_Input_DrugaLiniaAdresu, "")
	GUICtrlSetData($GUI_Input_Nip, "")
	GUICtrlSetData($GUI_Input_Telefon, "")
	GUICtrlSetData($GUI_Input_Email, "")
EndFunc   ;==>WyczyscDane

Func ZaladujDane()
	$NazwaFirmy = GUICtrlRead($GUI_Input_NazwaFirmy)
	$Adres1 = GUICtrlRead($GUI_Input_PierwszaLiniaAdresu)
	$Adres2 = GUICtrlRead($GUI_Input_DrugaLiniaAdresu)
	$Nip = GUICtrlRead($GUI_Input_Nip)
	$Telefon = GUICtrlRead($GUI_Input_Telefon)
	$Email = GUICtrlRead($GUI_Input_Email)

	If GUICtrlRead($GUI_Checkbox_KreatorWWWPro) = 4 Then
		$Tekst[0] = $WspolrzedneNor[0][0]
		$Tekst[1] = $WspolrzedneNor[0][1]
		$Obraz[0] = $WspolrzedneNor[1][0]
		$Obraz[1] = $WspolrzedneNor[1][1]
		$Mapa[0] = $WspolrzedneNor[2][0]
		$Mapa[1] = $WspolrzedneNor[2][1]
		$Formularz[0] = $WspolrzedneNor[3][0]
		$Formularz[1] = $WspolrzedneNor[3][1]
	Else
		$Tekst[0] = $WspolrzednePro[0][0]
		$Tekst[1] = $WspolrzednePro[0][1]
		$Obraz[0] = $WspolrzednePro[1][0]
		$Obraz[1] = $WspolrzednePro[1][1]
		$Mapa[0] = $WspolrzednePro[2][0]
		$Mapa[1] = $WspolrzednePro[2][1]
		$Formularz[0] = $WspolrzednePro[3][0]
		$Formularz[1] = $WspolrzednePro[3][1]
	EndIf
EndFunc   ;==>ZaladujDane

Func ZweryfikujDane()
	If $OsFizyczna Then
		If $NazwaFirmy = "" Or $Adres1 = "" Or $Adres2 = "" Or $Telefon = "" Or $Email = "" Or $DirMap = "" Then
			MsgBox(16, "Brak danych", "Wype³nij wszystkie pola!")
			Return
		EndIf
	Else
		If $NazwaFirmy = "" Or $Adres1 = "" Or $Adres2 = "" Or $Nip = "" Or $Telefon = "" Or $Email = "" Or $DirMap = "" Then
			MsgBox(16, "Brak danych", "Wype³nij wszystkie pola!")
			Return
		EndIf
	EndIf
	$Postep = 0
	Dzialanie()
EndFunc   ;==>ZweryfikujDane

Func Dzialanie()
	GUISetState(@SW_HIDE, $GUI_Main)
	If $Postep = $IloscKrokow Then Koniec()
	PowiadomienieGotowy()
	HotKeySet("{F1}", "Kontynuacja")
	If $Postep >= 2 Then HotKeySet("{F2}", "PoprzedniaFunkcja")
EndFunc

Func Koniec()
	MsgBox(64, "Koniec", "Strona internetowa zosta³a ukoñczona!", 3)
	$Auto = 0
	$AutoInfo = "AUTO OFF"
	WyczyscDane()
	ToolTip("")
	HotKeySet("{F1}")
	HotKeySet("{F2}")
	GUISetState(@SW_SHOW, $GUI_Main)
EndFunc

Func PrzelaczCichy()
	If $Cichy = 0 Then
		$Cichy = 1
		ToolTip("")
	Else
		$Cichy = 0
		PowiadomienieGotowy()
	EndIf
EndFunc

Func PrzelaczAuto()
	If $Auto = 0 Then
		$Auto = 1
		$AutoInfo = "AUTO ON"
		PowiadomienieGotowy()
	Else
		$Auto = 0
		$AutoInfo = "AUTO OFF"
		PowiadomienieGotowy()
	EndIf
EndFunc

Func PoprzedniaFunkcja()
	HotKeySet("{F1}")
	HotKeySet("{F2}")
	PowiadomieniePracuje()
	$ToolTip_DodatkowaInformacja = ""
	Call("F" & $Postep)
	Dzialanie()
EndFunc

Func PokolorujBrakujace()
	GUICtrlSetColor($GUI_Label_NazwaFirmy, 0x000000)
	GUICtrlSetColor($GUI_Label_PierwszaLiniaAdresu, 0x000000)
	GUICtrlSetColor($GUI_Label_DrugaLiniaAdresu, 0x000000)
	GUICtrlSetColor($GUI_Label_Nip, 0x000000)
	GUICtrlSetColor($GUI_Label_Telefon, 0x000000)
	GUICtrlSetColor($GUI_Label_Email, 0x000000)
	GUICtrlSetColor($GUI_Label_DirMap, 0x000000)

	If Not $NazwaFirmy Then GUICtrlSetColor($GUI_Label_NazwaFirmy, 0xFF0000)
	If Not $Adres1 Then GUICtrlSetColor($GUI_Label_PierwszaLiniaAdresu, 0xFF0000)
	If Not $Adres2 Then GUICtrlSetColor($GUI_Label_DrugaLiniaAdresu, 0xFF0000)
	If Not $Nip And Not $OsFizyczna Then GUICtrlSetColor($GUI_Label_Nip, 0xFF0000)
	If Not $Telefon Then GUICtrlSetColor($GUI_Label_Telefon, 0xFF0000)
	If Not $Email Then GUICtrlSetColor($GUI_Label_Email, 0xFF0000)
	If Not $DirMap Then GUICtrlSetColor($GUI_Label_DirMap, 0xFF0000)
EndFunc   ;==>PokolorujBrakujace

Func PowiadomienieGotowy()
	If Not $ToolTip_DodatkowaInformacja and not $Cichy Then
		ToolTip("[" & $AutoInfo & "][" & $Postep & "/" & $IloscKrokow & "] F1 - Kontynuuj", 0, 0)
	Else
		If Not $Cichy Then ToolTip("[" & $AutoInfo & "][" & $Postep & "/" & $IloscKrokow & "] " & $ToolTip_DodatkowaInformacja & " i kontynuuj." & @CRLF & "F1 - Kontynuuj", 0, 0)
	EndIf
EndFunc   ;==>PowiadomienieGotowy

Func PowiadomieniePracuje()
	If not $Cichy Then ToolTip("Czekaj, pracujê.", 0, 0)
EndFunc   ;==>PowiadomieniePracuje

Func Kontynuacja()
	HotKeySet("{F1}")
	HotKeySet("{F2}")
	PowiadomieniePracuje()
	$ToolTip_DodatkowaInformacja = ""
	$Postep += 1
	Call("F" & $Postep)
	Dzialanie()
EndFunc

Func PoprzedniKrok()
	$Postep -= 1
	PowiadomienieGotowy()
EndFunc

Func NastepnyKrok()
	$postep += 1
	PowiadomienieGotowy()
EndFunc

Func exi()
	Exit
EndFunc

Func _ColorMatch($iColor1, $iColor2, $ShadeVariation = 0)
   Return Abs(_ColorGetRed($iColor1) - _ColorGetRed($iColor2)) <= $ShadeVariation And _
         Abs(_ColorGetGreen($iColor1) - _ColorGetGreen($iColor2)) <= $ShadeVariation And _
         Abs(_ColorGetBlue($iColor1) - _ColorGetBlue($iColor2)) <= $ShadeVariation
EndFunc   ;==>_ColorMatch

Func CzekajNaKolor($Kolor, $x, $y)
	If $Auto Then
		While 1
			If _ColorMatch(PixelGetColor($x, $y), $Kolor) Then ExitLoop
			If Not $Auto Then ExitLoop
			Sleep(200)
		WEnd
		If $Auto Then Kontynuacja()
	EndIf
EndFunc

Func F1()
	MouseClick("left", 1691, 125)
	If $Auto Then
		$i = 0
		While 1
			If Int(PixelGetColor(1545, 203)) = Int(Dec(323232)) Then ExitLoop
			Sleep(200)
			$i += 1
			If $i >= 25 Then ExitLoop
		WEnd
		Kontynuacja()
	EndIf
EndFunc

Func F2()
	MouseClick("Left", 245, 125)
	CzekajNaKolor(0xFFFFFF, 279, 243)
EndFunc   ;==>F1

Func F3()
	MouseClickDrag("left", 310, 260, 310, 755)
	CzekajNaKolor(0xFF5200, 74, 304)
EndFunc   ;==>F1

Func F4()
	MouseClick("left", 263, 964)
	CzekajNaKolor(0xCC4A0D, 1541, 338)
EndFunc

Func F5()
	MouseClick("left", 1544, 338)
	CzekajNaKolor(0xD6D6D6, 1183, 400)
EndFunc

Func F6()
	MouseClick("left", 1097, 316)
	CzekajNaKolor(0x2D3648, 689, 198)
EndFunc

Func F7()
	MouseClick("left", 1626, 124)
	CzekajNaKolor(0xECECEC, 1163, 627)
EndFunc

Func F8()
	MouseClick("left", 1151, 638)
	If $Auto Then
		While 1
			If _ColorMatch(PixelGetColor(219, 508), 0x959595) Then ExitLoop
			Sleep(200)
		WEnd
	EndIf
	CzekajNaKolor(0xFFFFFF, 280, 502)
EndFunc

Func F9()
	MouseClick("left", 165, 124)
	CzekajNaKolor(0xFFFFFF, 47, 555)
EndFunc

Func F10()
	MouseClick("left", 130, 398)
	CzekajNaKolor(0xE0E0E0, 286, 580)
EndFunc

Func F11()
	MouseClick("left", 140, 308)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send($NazwaFirmy)
	CzekajNaKolor(0xFF5722, 283, 580)
EndFunc

Func F12()
	MouseClick("left", 252, 575)
	CzekajNaKolor(0xE0E0E0, 282, 578)
EndFunc

Func F13()
	MouseClick("left", 205, 125)
	CzekajNaKolor(0xC0C0C0, 223, 244)
EndFunc

Func F14()
	MouseClick("left", 76, 339)
	CzekajNaKolor(0xA9A9AB, 42, 809)
EndFunc

Func F15()
	MouseClick("left", 71, 805)
	CzekajNaKolor(0xECECEC, 1111, 642)
EndFunc

Func F16()
	MouseClick("left", 1080, 640, 1)
	CzekajNaKolor(0xC0C0C0, 184, 243)
EndFunc

Func F17()
	MouseClick("left", 55, 292, 1)
	If $Auto Then
	While 1
		If _ColorMatch(PixelGetColor(1226, 655), 0xECECEC) Then MouseClick("left", 1226, 655)
		If _ColorMatch(PixelGetColor(276, 908), 0xE0E0E0) Then Kontynuacja()
		Sleep(200)
	WEnd
	EndIf
EndFunc

Func F18()
	MouseClick("left", 74, 806)
	CzekajNaKolor(0xECECEC, 1114, 640)
EndFunc

Func F19()
	MouseClick("left", 1087, 642)
	CzekajNaKolor(0xC0C0C0, 226, 240)
EndFunc

Func F20()
	MouseClick("left", 66, 244)
	CzekajNaKolor(0xE0E0E0, 252, 838)
EndFunc

Func F21()
	If $Auto Then Sleep(300)
	MouseClick("left", 82, 274)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("O firmie")
	CzekajNaKolor(0xFF5722, 274, 837)
EndFunc

Func F22()
	MouseClick("left", 249, 825)
	CzekajNaKolor(0xC0C0C0, 206, 243)
EndFunc

Func F23()
	MouseClick("left", 245, 125)
	CzekajNaKolor(0x9EC0FF, 206, 243)
EndFunc

Func F24()
	MouseClick("left", 128, 478)
	CzekajNaKolor(0xEEEEEE, 207, 479)
EndFunc

Func F25()
	MouseClickDrag("left", 302, 553, 302, 373)
	CzekajNaKolor(0xFFFFFF, 152, 521)
EndFunc

Func F26()
	MouseClick("left", 60, 520)
	CzekajNaKolor(0xFFFFFF, 60, 520)
EndFunc

Func F27()
	MouseClick("left", 230, 633)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("18")
	CzekajNaKolor(0xFF5200, 34, 637)
EndFunc

Func F28()
	MouseClick("left", 98, 694)
	CzekajNaKolor(0x000000, 241, 924)
EndFunc

Func F29()
	MouseClick("left", 121, 884)
	CzekajNaKolor(0xFFFFFF, 96, 695)
EndFunc

Func F30()
	MouseClick("left", 245, 125)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F31()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F32()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F33()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F34()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F35()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F36()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F37()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F38()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F39()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F40()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F41()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F42()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F43()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F44()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F45()
	MouseMove(1889, 251)
	CzekajNaKolor(0x558B2F, 1878, 309)
EndFunc

Func F46()
	MouseClick("left", 1890, 277)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F47()
	MouseMove(1906, 429)
	CzekajNaKolor(0x558B2F, 1895, 491)
EndFunc

Func F48()
	MouseClick("left", 1906, 456)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F49()
	MouseMove(1906, 429)
	CzekajNaKolor(0x558B2F, 1895, 491)
EndFunc

Func F50()
	MouseClick("left", 1906, 456)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F51()
	MouseMove(1906, 429)
	CzekajNaKolor(0x558B2F, 1895, 491)
EndFunc

Func F52()
	MouseClick("left", 1906, 456)
	CzekajNaKolor(0x424242, 65, 319)
EndFunc

Func F53()
	MouseClickDrag("left", 386, 178, 1336, 181)
	CzekajNaKolor(0xE64A19, 1895, 204)
EndFunc

Func F54()
	MouseMove(92, 198)
	MouseMove(92, 233)
	MouseClick("left", 122, 235)
	CzekajNaKolor(0xE64A19, 1897, 255)
EndFunc

Func F55()
	MouseClick("Left", 1906, 167)
	CzekajNaKolor(0xFAFAFA, 1837, 267)
EndFunc

Func F56()
	MouseClick("Left", 1675, 183)
	CzekajNaKolor(0x2D3648, 1828, 288)
EndFunc

Func F57()
	MouseClick("Left", 1834, 284)
	CzekajNaKolor(0x000000, 1814, 516)
EndFunc

Func F58()
	MouseClick("Left", 1703, 491)
	CzekajNaKolor(0xF5F5F5, 1820, 284)
EndFunc

Func F59()
	MouseClick("Left", 1736, 181)
	CzekajNaKolor(0xFE6820, 1622, 281)
EndFunc

Func F60()
	MouseClick("Left", 1617, 276)
	CzekajNaKolor(0xFAFAFA, 1622, 281)
EndFunc

Func F61()
	MouseClick("Left", 1571, 194)
	CzekajNaKolor(0xFE6820, 1612, 338)
EndFunc

Func F62()
	MouseClick("Left", 1612, 300)
	CzekajNaKolor(0xFE6820, 1612, 300)
EndFunc

Func F63()
	Send("{end}")
	CzekajNaKolor(0xFF5200, 1658, 499)
EndFunc

Func F64()
	MouseClick("Left", 1840, 429)
	CzekajNaKolor(0xEEEEEE, 1813, 427)
EndFunc

Func F65()
	MouseClick("Left", 1735, 576)
	CzekajNaKolor(0xFAFAFA, 1813, 427)
EndFunc

Func F66()
	MouseClick("Left", 1808, 491)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("32")
	CzekajNaKolor(0xFF5200, 1734, 497)
EndFunc

Func F67()
	MouseClick("Left", 1732, 210)
	CzekajNaKolor(0xFF5200, 1652, 334)
EndFunc

Func F68()
	MouseClick("Left", 1743, 333)
	CzekajNaKolor(0xFF5200, 1743, 333)
EndFunc

Func F69()
	MouseClick("Left", 1788, 209)
	CzekajNaKolor(0xFF5200, 1634, 480)
EndFunc

Func F70()
	MouseClick("Left", 1817, 473)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("0")
	CzekajNaKolor(0xFAFAFA, 1604, 481)
EndFunc

Func F71()
	MouseClick("Left", 1570, 246)
	CzekajNaKolor(0xFFFFFF, 1614, 261)
EndFunc

Func F72()
	MouseClick("Left", 1840, 431)
	CzekajNaKolor(0xEEEEEE, 1840, 431)
EndFunc

Func F73()
	MouseClick("Left", 1735, 577)
	CzekajNaKolor(0xFAFAFA, 1809, 431)
EndFunc

Func F74()
	MouseClick("Left", 1808, 492)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("15")
	CzekajNaKolor(0xFF5200, 1641, 499)
EndFunc

Func F75()
	MouseClick("Left", 1813, 554)
	Sleep(100)
	Send("{end}")
	CzekajNaKolor(0x000000, 1808, 480)
EndFunc

Func F76()
	MouseClick("Left", 1808, 479)
	CzekajNaKolor(0x000000, 1794, 479)
EndFunc

Func F77()
	MouseClick("Left", 1813, 601)
	Sleep(100)
	Send("{end}")
	CzekajNaKolor(0x000000, 1807, 526)
EndFunc

Func F78()
	MouseClick("Left", 1782, 442)
	CzekajNaKolor(0xFF5722, 1813, 298)
EndFunc

Func F79()
	MouseClick("Left", 1813, 649)
	CzekajNaKolor(0xFF5722, 1813, 647)
EndFunc

Func F80()
	MouseClick("Left", 1732, 260)
	CzekajNaKolor(0xFF5200, 1834, 383)
EndFunc

Func F81()
	MouseClick("Left", 1743, 383)
	CzekajNaKolor(0xFF5200, 1743, 383)
EndFunc

Func F82()
	MouseClick("Left", 1788, 258)
	CzekajNaKolor(0xFF5200, 1646, 606)
EndFunc

Func F83()
	MouseClick("Left", 1817, 598)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("0")
	CzekajNaKolor(0xFAFAFA, 1604, 605)
EndFunc

Func F84()
	MouseClick("Left", 995, 391)
	CzekajNaKolor(0xCC4A0D, 418, 426)
EndFunc

Func F85()
	MouseClick("Left", 414, 427)
	CzekajNaKolor(0x919193, 1495, 380)
EndFunc

Func F86()
	MouseClick("Left", 1419, 424)
	CzekajNaKolor(0xFFFFFF, 1643, 334)
EndFunc

Func F87()
	MouseClick("Left", 1905, 299)
	CzekajNaKolor(0x558B2F, 1830, 305)
EndFunc

Func F88()
	MouseClick("Left", 1838, 468)
	$ToolTip_DodatkowaInformacja = "Wybierz rêcznie T£O"
	MsgBox(64, "Dzia³anie rêczne", "Wybierz rêcznie T£O.", 2)
EndFunc

Func F89()
	MouseClick("Left", 1677, 312)
	CzekajNaKolor(0xFFFFFF, 1677, 312)
EndFunc

Func F90()
	MouseClick("Left", 1813, 475)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("100")
	Sleep(300)
	MouseClick("Left", 1812, 549)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("255")
	Sleep(300)
	CzekajNaKolor(0xFF5200, 1676, 558)
EndFunc

Func F91()
	MouseClickDrag("Left", $Tekst[0], $Tekst[1], 514, 417)
	CzekajNaKolor(0xE64A19, 1541, 427)
EndFunc

Func F92()
	MouseClickDrag("Left", $Obraz[0], $Obraz[1], 1598, 412)
	CzekajNaKolor(0x558B2F, 1895, 306)
EndFunc

Func F93()
	MouseClickDrag("Left", 1380, 473, 990, 504)
	CzekajNaKolor(0x00BFFF, 991, 499)
EndFunc

Func F94()
	MouseClick("Left", 554, 419)
	CzekajNaKolor(0xFFFFFF, 595, 370)
EndFunc

Func F95()
	MouseClick("Left", 674, 370)
	Sleep(150)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep(100)
	Sleep(100)
	Send("O nas{enter}")
	Sleep(100)
	Sleep(100)
	Send("{BACKSPACE}{ENTER}")
	Sleep(100)
	Send("Witamy na naszej stronie internetowej i zapraszamy do zapoznania siê z udostêpnionymi informacjami. W przypadku pytañ zachêcamy do kontaktu bezpoœredniego lub pozostawienia wiadomoœci e-mail. Pozdrawiamy serdecznie!")
	CzekajNaKolor(0xDDDDDD, 663, 366)
EndFunc

Func F96()
	MouseClick("Left", 972, 474)
	CzekajNaKolor(0xE64A19, 1229, 489)
EndFunc

Func F97()
	MouseClick("Left", 1234, 642)
	$ToolTip_DodatkowaInformacja = "Wybierz rêcznie PRZEZROCZYSTE T£O"
	MsgBox(64, "Dzia³anie rêczne", "Wybierz rêcznie PRZEZROCZYSTE T£O.", 2)
EndFunc

Func F98()
	MouseClick("Left", 1075, 486)
	CzekajNaKolor(0xFFFFFF, 1074, 487)
EndFunc

Func F99()
	MouseClick("Left", 1220, 603)
	Sleep(300)
	Send("^a")
	Send("^a")
	Sleep(100)
	Send("25")
	MouseClick("Left", 1220, 678)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("190")
	MouseClick("Left", 1220, 751)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("25")
	MouseClick("Left", 1220, 825)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("25")
	CzekajNaKolor(0xFF5200, 1013, 834)
EndFunc

Func F100()
	MouseClick("Left", 1132, 524)
	Sleep(100)
	MouseClick("Left", 1132, 487)
	Sleep(100)
	MouseClick("Left", 1135, 485)
	CzekajNaKolor(0xF9D2C5, 1127, 486)
EndFunc

Func F101()
	MouseClick("Left", 1230, 589)
	CzekajNaKolor(0x000000, 1209, 821)
EndFunc

Func F102()
	MouseClick("Left", 1102, 819)
	CzekajNaKolor(0xEEEEEE, 1214, 593)
EndFunc

Func F103()
	MouseWheel("down", 4)
	CzekajNaKolor(0xFF5200, 1007, 729)
EndFunc

Func F104()
	MouseClick("Left", 1208, 795)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("7")
	CzekajNaKolor(0xFF5200, 1014, 803)
EndFunc

Func F105()
	MouseClick("Left", 1543, 532)
	CzekajNaKolor(0xE64A19, 1565, 534)
EndFunc

Func F106()
	MouseClick("Left", 1819, 547)
	CzekajNaKolor(0xF9D2C5, 1813, 545)
EndFunc

Func F107()
	MouseClick("Left", 1785, 649)
	CzekajNaKolor(0x000000, 1779, 879)
EndFunc

Func F108()
	MouseClick("Left", 1672, 880)
	CzekajNaKolor(0xEEEEEE, 1786, 648)
EndFunc

Func F109()
	MouseWheel("down", 4)
	CzekajNaKolor(0xFF5200, 1577, 741)
EndFunc

Func F110()
	MouseClick("Left", 1778, 806)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("7")
	CzekajNaKolor(0xFF5200, 1585, 814)
EndFunc

Func F111()
	MouseClick("Left", 204, 125)
	CzekajNaKolor(0xC0C0C0, 204, 243)
EndFunc

Func F112()
	MouseClick("Left", 61, 243)
	CzekajNaKolor(0xE0E0E0, 238, 840)
EndFunc

Func F113()
	MouseClick("Left", 85, 687)
	CzekajNaKolor(0xECECEC, 1224, 656)
EndFunc

Func F114()
	MouseClick("Left", 1196, 649)
	CzekajNaKolor(0xE0E0E0, 255, 910)
EndFunc

Func F115()
	MouseClick("Left", 115, 272)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("Dane firmowe")
	CzekajNaKolor(0xFF5722, 271, 907)
EndFunc

Func F116()
	MouseClick("Left", 249, 895)
	CzekajNaKolor(0xC0C0C0, 252, 294)
EndFunc

Func F117()
	MouseClick("Left", 127, 244)
	CzekajNaKolor(0xECECEC, 1229, 650)
EndFunc

Func F118()
	MouseClick("Left", 1196, 649)
	CzekajNaKolor(0xE0E0E0, 258, 840)
EndFunc

Func F119()
	MouseClick("Left", 1277, 545)
	$ToolTip_DodatkowaInformacja = "Wybierz rêcznie OBRAZEK"
	MsgBox(64, "Dzia³anie rêczne", "Wybierz rêcznie OBRAZEK.", 2)
EndFunc

Func F120()
	MouseClick("Left", 1030, 246)
	CzekajNaKolor(0xECECEC, 1227, 651)
EndFunc

Func F121()
	MouseClick("Left", 1196, 649)
	CzekajNaKolor(0xF5F5F5, 1672, 226)
EndFunc

Func F122()
	If $Auto Then Sleep(1000)
	MouseClick("Left", 751, 531)
	CzekajNaKolor(0xFFFFFF, 596, 372)
EndFunc

Func F123()
	Send("^a")
	Sleep(100)
	Send("{BACKSPACE}")
	CzekajNaKolor(0xFFFFFF, 595, 368)
EndFunc

Func F124()
	MouseClick("Left", 674, 371)
	Sleep(100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep(100)
	Send("^b")
	Sleep(100)
	Send("Dane Firmowe")
	Sleep(100)
	Send("{ENTER}")
	Sleep(100)
	Send("{BACKSPACE}{ENTER}")
	Sleep(100)
	Send("^b")
	Sleep(100)
	Send($NazwaFirmy)
	Sleep(100)
	Send("{ENTER}")
	Sleep(100)
	Send("{BACKSPACE}{ENTER}")
	Sleep(100)
	Send("^b")
	Sleep(100)
	Send("Adres:")
	Sleep(100)
	Send("+{ENTER}")
	Sleep(100)
	Send("^b")
	Sleep(100)
	Send($Adres1)
	Send("+{ENTER}")
	Send($Adres2)
	Send("{ENTER}")
	Sleep(100)
	Send("^b")
	Sleep(100)
	If Not $OsFizyczna Then Send("NIP: ")
	If $OsFizyczna Then Send("E-Mail: ")
	Send("^b")
	Sleep(100)
	If Not $OsFizyczna Then Send($Nip)
	If $OsFizyczna Then Send($Email)
	Send("+{ENTER}")
	Send("^b")
	Sleep(100)
	Send("Telefon: ")
	Send("^b")
	Sleep(100)
	Send($Telefon)
	CzekajNaKolor(0xDDDDDD, 662, 365)
EndFunc

Func F125()
	MouseClick("Left", 973, 610)
	CzekajNaKolor(0xE64A19, 996, 613)
EndFunc

Func F126()
	MouseClick("Left", 1074, 625)
	CzekajNaKolor(0xFFFFFF, 1074, 625)
EndFunc

Func F127()
	MouseClick("Left", 1219, 817)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("145")
	CzekajNaKolor(0xFF5200, 1049, 819)
EndFunc

Func F128()
	MouseClick("Left", 1276, 550)
	$ToolTip_DodatkowaInformacja = "Wybierz rêcznie OBRAZEK"
	MsgBox(64, "Dzia³anie rêczne", "Wybierz rêcznie OBRAZEK.", 2)
EndFunc

Func F129()
	MouseClick("Left", 205, 127)
	CzekajNaKolor(0xC0C0C0, 239, 299)
EndFunc

Func F130()
	MouseClick("Left", 96, 292)
	CzekajNaKolor(0xE0E0E0, 266, 909)
EndFunc

Func F131()
	MouseClick("Left", 93, 758)
	CzekajNaKolor(0xECECEC, 1229, 659)
EndFunc

Func F132()
	MouseClick("Left", 1197, 651)
	CzekajNaKolor(0xE0E0E0, 253, 908)
EndFunc

Func F133()
	If $Auto Then Sleep(5000)
	MouseClick("Left", 106, 272)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("Lokalizacja")
	CzekajNaKolor(0xFF5722, 260, 908)
EndFunc

Func F134()
	MouseClick("Left", 251, 894)
	CzekajNaKolor(0xC0C0C0, 249, 348)
EndFunc

Func F135()
	MouseMove(1004, 456)
	Sleep(100)
	MouseMove(1006, 375)
	CzekajNaKolor(0x0288D1, 1024, 371)
EndFunc

Func F136()
	MouseClick("Left", 1035, 373)
	CzekajNaKolor(0x558B2F, 1879, 307)
EndFunc

Func F137()
	MouseMove(1542, 591)
	CzekajNaKolor(0xE64A19, 1551, 614)
EndFunc

Func F138()
	MouseClick("Left", 1542, 616)
	CzekajNaKolor(0x558B2F, 1894, 306)
EndFunc

Func F139()
	MouseClickDrag("Left", $Mapa[0], $Mapa[1], 788, 416)
	CzekajNaKolor(0xE64A19, 1531, 610)
EndFunc

Func F140()
	MouseClick("Left", 1543, 604)
	CzekajNaKolor(0xE64A19, 1564, 599)
EndFunc

Func F141()
	MouseClick("Left", 1664, 733)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send($Adres1 & " " & $Adres2)
	Sleep(1000)
	Send("{Backspace}")
	Sleep(3000)
	Send(StringRight($Adres2, 1))
	Sleep(3000)
	CzekajNaKolor(0xFAFAFA, 1769, 669)
EndFunc

Func F142()
	MouseClick("Left", 1788, 803)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("450")
	CzekajNaKolor(0xFF5200, 1658, 808)
EndFunc

Func F143()
	MouseClick("Left", 1888, 299)
	CzekajNaKolor(0x558B2F, 1848, 309)
EndFunc

Func F144()
	MouseClick("Left", 1660, 311)
	CzekajNaKolor(0xFFFFFF, 1662, 312)
EndFunc

Func F145()
	MouseClick("Left", 1789, 549)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("181")
	CzekajNaKolor(0xFF5200, 1637, 554)
EndFunc

Func F146()
	Send("^t")
	If $Auto Then Kontynuacja()
EndFunc

Func F147()
	If $Auto Then Sleep(1500)
	Send("maps.google.com{ENTER}")
	If $Auto Then Kontynuacja()
EndFunc

Func F148()
	If $Auto Then Sleep(10000)
	Send($Adres1 & " " & $Adres2 & "{ENTER}")
	If $Auto Then Kontynuacja()
EndFunc

Func F149()
	If $Auto Then Sleep(5000)
	MouseClick("Left", 258, 50)
	Sleep(200)
	Send("^a")
	Sleep(200)
	Send("^c")
	$LinkMapy = ClipGet()
	If $Auto Then Kontynuacja()
EndFunc

Func F150()
	If $Auto Then Sleep(2000)
	Send("^w")
	CzekajNaKolor(0xF2DEDE, 1521, 423)
EndFunc

Func F151()
	MouseClick("Left", 1795, 126)
	$ToolTip_DodatkowaInformacja = "Zrób zdjêcie mapy, zamknij opublikowan¹ stronê i wróæ do kreatora"
	If not $Auto Then MsgBox(64, "Dzia³anie rêczne", "Zrób zdjêcie mapy, zamknij opublikawan¹ stronê i wróæ do kreatora.", 2)
	CzekajNaKolor(0x666666, 1501, 721)
EndFunc

Func F152()
	If $Auto Then
		Sleep(1500)
		For $i = 1 to 7
			MouseClick("left", 1501, 721)
			Sleep(550)
		Next
		Sleep(5000)
		$IleMap = _FileListToArray($DirMap, "mapka*", 1)
		Local $BIT = _ScreenCapture_Capture("", 395, 338, 1524, 787, False)
		_ScreenCapture_SaveImage($DirMap & "/mapka" & $IleMap[0]+1 & ".png", $BIT)
		Sleep(2000)
		Send("^w")
		While 1
			If _ColorMatch(PixelGetColor(1205, 137), 0x363636) Then ExitLoop
			Sleep(200)
		WEnd
	EndIf
	MouseMove(1543, 654)
	CzekajNaKolor(0xE64A19, 1551, 686)
EndFunc

Func F153()
	MouseClick("Left", 1543, 678)
	CzekajNaKolor(0xFFFFFF, 1543, 678)
EndFunc

Func F154()
	MouseClickDrag("Left", $Obraz[0], $Obraz[1], 890, 419)
	CzekajNaKolor(0xE64A19, 1532, 593)
EndFunc

Func F155()
	MouseClick("Left", 1542, 589)
	CzekajNaKolor(0xE64A19, 1563, 588)
EndFunc

Func F156()
	MouseClick("Left", 1785, 710)
	If Not $Auto Then $ToolTip_DodatkowaInformacja = "Wybierz rêcznie OBRAZ MAPY"
	If Not $Auto Then  MsgBox(64, "Dzia³anie rêczne", "Wybierz rêcznie OBRAZ MAPY", 2)
	If $Auto Then $ToolTip_DodatkowaInformacja = "Wybierz rêcznie OBRAZ MAPY, mapa nazywa siê 'mapka" & $IleMap[0]+1 & "'"
	If $Auto Then MsgBox(64, "Dzia³anie rêczne", "Wybierz rêcznie OBRAZ MAPY, mapa nazywa siê 'mapka" & $IleMap[0]+1 & "'", 2)
EndFunc

Func F157()
	MouseClick("Left", 1604, 971)
	Sleep(100)
	Send($LinkMapy)
	If $Auto Then
		Sleep(2000)
		Kontynuacja()
	EndIf
EndFunc

Func F158()
	MouseClick("Left", 1816, 634)
	Sleep(100)
	MouseClick("Left", 1819, 604)
	CzekajNaKolor(0xF9D2C5, 1813, 601)
EndFunc

Func F159()
	MouseClick("Left", 1785, 703)
	CzekajNaKolor(0x000000, 1782, 936)
EndFunc

Func F160()
	MouseClick("Left", 1672, 936)
	Sleep(100)
	MouseWheel("down", 4)
	CzekajNaKolor(0xFAFAFA, 1679, 758)
EndFunc

Func F161()
	MouseClick("Left", 1780, 863)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("7")
	CzekajNaKolor(0xFF5200, 1586, 871)
EndFunc

Func F162()
	MouseClick("Left", 205, 126)
	CzekajNaKolor(0xC0C0C0, 197, 341)
EndFunc

Func F163()
	MouseClick("Left", 84, 342)
	CzekajNaKolor(0xE0E0E0, 249, 909)
EndFunc

Func F164()
	MouseClick("Left", 82, 758)
	CzekajNaKolor(0xECECEC, 1227, 656)
EndFunc

Func F165()
	MouseClick("Left", 1197, 652)
	CzekajNaKolor(0xFFFFFF, 241, 760)
EndFunc

Func F166()
	If $Auto Then Sleep(5000)
	MouseClick("Left", 87, 274)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("Kontakt")
	CzekajNaKolor(0xFF5722, 256, 906)
EndFunc

Func F167()
	MouseClick("Left", 251, 894)
	CzekajNaKolor(0xC0C0C0, 198, 382)
EndFunc

Func F168()
	MouseClick("Left", 284, 188)
	CzekajNaKolor(0x424242, 61, 255)
EndFunc

Func F169()
	MouseClickDrag("Left", $Tekst[0], $Tekst[1], 1631, 549)
	CzekajNaKolor(0x558B2F, 1879, 307)
EndFunc

Func F170()
	MouseClickDrag("Left", 1372, 523, 1001, 523)
	CzekajNaKolor(0x00BFFF, 1000, 523)
EndFunc

Func F171()
	MouseClick("Left", 980, 514)
	CzekajNaKolor(0xE64A19, 1003, 516)
EndFunc

Func F172()
	MouseClick("Left", 1223, 635)
	$ToolTip_DodatkowaInformacja = "Wybierz rêcznie OBRAZ"
	MsgBox(64, "Dzia³anie rêczne", "Wybierz rêcznie OBRAZ.", 2)
EndFunc

Func F173()
	MouseClick("Left", 1143, 896)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("{BACKSPACE}")
	CzekajNaKolor(0xFAFAFA, 1127, 894)
EndFunc

Func F174()
	MouseClick("Left", 1168, 420)
	CzekajNaKolor(0xFFFFFF, 1167, 368)
EndFunc

Func F175()
	MouseClick("Left", 1261, 337)
	Sleep(100)
	MouseClick("Left", 1245, 371)
	Sleep(100)
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	Sleep(100)
	Send("Formularz Kontaktowy")
	CzekajNaKolor(0xDDDDDD, 1233, 370)
EndFunc

Func F176()
 	MouseClickDrag("Left", $Formularz[0], $Formularz[1], 1271, 493)
	CzekajNaKolor(0xE64A19, 1532, 732)
EndFunc

Func F177()
	MouseClick("Left", 1543, 727)
	CzekajNaKolor(0xE64A19, 1565, 726)
EndFunc

Func F178()
	MouseClick("Left", 1659, 854)
	Sleep(100)
	Send($Email)
	CzekajNaKolor(0xE64A19, 1552, 672)
EndFunc

Func F179()
	MouseClick("left", 1543, 678)
	CzekajNaKolor(0xEB6E47, 1533, 686)
EndFunc

Func F180()
	MouseClick("left", 1543, 678)
	CzekajNaKolor(0xE64A19, 1565, 684)
EndFunc

Func F181()
	MouseClick("left", 1702, 807)
	CzekajNaKolor(0x3F51B5, 1729, 821)
EndFunc

Func F182()
	If $Auto Then Sleep(1000)
	Send("{TAB}{TAB}{TAB}")
	Sleep(100)
	Send("{SPACE}")
	Sleep(100)
	MouseWheel("down", 2)
	CzekajNaKolor(0xE64A19, 1552, 608)
EndFunc

Func F183()
	MouseClick("left", 1543, 604)
	CzekajNaKolor(0xEB6E47, 1534, 610)
EndFunc

Func F184()
	MouseClick("left", 1543, 604)
	CzekajNaKolor(0xE64A19, 1569, 603)
EndFunc

Func F185()
	MouseClick("left", 1783, 1008)
	Sleep(100)
	MouseWheel("down", 3)
	CzekajNaKolor(0x000000, 1780, 933)
EndFunc

Func F186()
	MouseClick("left", 1780, 933)
	CzekajNaKolor(0x000000, 1784, 704)
EndFunc

Func F187()
	MouseClick("Left", 1888, 300)
	CzekajNaKolor(0x558B2F, 1825, 315)
EndFunc

Func F188()
	MouseClick("Left", 1660, 312)
	CzekajNaKolor(0xFFFFFF, 1660, 312)
EndFunc

Func F189()
	MouseClick("Left", 1787, 550)
	Sleep(100)
	Send("^a")
	Sleep(100)
	Send("255")
	CzekajNaKolor(0xFF5200, 1658, 554)
EndFunc

Func F190()
	MouseClick("Left", 1797, 123)
EndFunc