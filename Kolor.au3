#include <GUIconstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include<Misc.au3>
#NoTrayIcon

Opt("WinTitleMatchMode", 4)
Opt("WinWaitDelay", 0)
Opt("GUIonEventMode",1)

;~ Global $SRCCOPY = 0x00CC0020
Global $leave = 0
Global $Paused=0
$MouseModifier = 1
$PressedTime = 1

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{INS}", "_copyHEX")

$MyhWnd = WinGetHandle("classname=tooltips_class32")

GUICreate("Pixel Color", 180, 410,0, 0, -1, $WS_EX_TOPMOST)
GUISetOnEvent($GUI_EVENT_CLOSE,"_exit")

GUICtrlCreateGroup(" Pozycja myszy ", 10, 10, 160, 50)
GUICtrlCreateLabel("X:", 25, 33, 15, 15)
$MousePosX=GUICtrlCreateInput("", 40, 30, 40, 20, $ES_READONLY)
GUICtrlCreateLabel("Y:", 90, 33, 15, 15)
$MousePosY=GUICtrlCreateInput("", 105, 30, 40, 20, $ES_READONLY)

GUICtrlCreateGroup(" Kod koloru ", 10, 70, 160, 110)
GUICtrlCreateLabel("Dziesiêtny:", 25, 93, 50, 15)
$PixelColor=GUICtrlCreateInput("", 80, 90, 70, 20, $ES_READONLY)
GUICtrlCreateLabel("Hex:", 25, 123, 50, 15)
$hexColor=GUICtrlCreateInput("", 80, 120, 70, 20,$ES_READONLY)
GUICtrlCreateLabel("Kolor:", 25, 153, 50, 15)
$MostrarColor=GUICtrlCreateLabel("", 80, 150, 70, 20,$ES_READONLY)

GUICtrlCreateGroup(" Opcje specjalne ", 10, 190, 160, 145)
$RB_Full = GUICtrlCreateRadio("Pe³ny Ekran", 25, 210, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$RB_Window = GUICtrlCreateRadio("Aktywne Okno", 25, 230, 100, 20)
$Mag= GUICtrlCreateCheckbox("Powiêkszenie", 25, 250, 100, 20)
GUICtrlSetState(-1,$GUI_DISABLE)
$Solid= GUICtrlCreateRadio("Celownik prosty", 35, 270, 100, 20)
$Inver= GUICtrlCreateRadio("Celownik negatyw", 35, 290, 120, 20)
$KeyBMouse= GUICtrlCreateCheckbox("Sterowanie klawiatur¹", 25, 310, 140, 20)

$Ayuda=GUICtrlCreateButton("Pomoc",10,345,77)
GUICtrlSetOnEvent(-1,"Ayuda")
$Saltar=GUICtrlCreateButton("Wpisz pozycjê",92,345,77)
GUICtrlSetOnEvent(-1,"Saltar")

GUICtrlCreateLabel("PAUSE: Zablokuj/Odblokuj program", 0, 380 ,180,15,$SS_CENTER)
GUICtrlSetColor(-1,0x00808080)
GUICtrlCreateLabel("INS: Kopiuj kod hex do schowka", 0, 395 ,180,15,$SS_CENTER)
GUICtrlSetColor(-1,0x00808080)


GUISetState()
data()

Func data()

    While 1
	   Sleep(50)
	   Opt("WinTitleMatchMode",4)
	   If (_IsPressed(25) + _IsPressed(26) + _IsPressed(27) + _IsPressed(28)) = 0 Then
	   _ResetSpeed()
	   EndIf
	   $msg=GUIGetMsg()
	   Select
		  Case $msg=$GUI_EVENT_CLOSE
			 Exit
	   EndSelect

	   If GUICtrlRead($KeyBMouse)=$GUI_CHECKED Then
		  MouseKeyb()
	   Else
		  MouseKeybNO()
	   EndIf

	   If GUICtrlRead($Mag)=$GUI_CHECKED Then
		  GUICtrlSetState($RB_Window,$GUI_DISABLE)
		  GUICtrlSetState($Solid,$GUI_ENABLE)
		  GUICtrlSetState($Inver,$GUI_ENABLE)
		  GUICtrlSetState($RB_Full,$GUI_CHECKED)
		  WinSetState($MyhWnd,"",@SW_SHOW)
		  MAG()

	   Else
		  GUICtrlSetState($Solid,$GUI_DISABLE+$GUI_UNCHECKED)
		  GUICtrlSetState($Inver,$GUI_DISABLE+$GUI_UNCHECKED)
		  GUICtrlSetState($RB_Window,$GUI_ENABLE)
		  WinSetState($MyhWnd,"",@SW_HIDE)
	   EndIf
	   If GUICtrlRead($RB_Full) = $GUI_CHECKED Then
		  Opt("MouseCoordMode", 1)
		  Opt("PixelCoordMode", 1)
		  $pos=MouseGetPos()
		  $color=PixelGetColor($pos[0],$pos[1])
		  GUICtrlSetData($MousePosX, $pos[0])
		  GUICtrlSetData($MousePosY, $pos[1])
		  GUICtrlSetData($PixelColor,$color)
		  $HEX6=StringRight(Hex($color),6)
		  GUICtrlSetData($hexColor,"0x"&$HEX6)
		  GUICtrlSetBkColor($MostrarColor,"0x"&Hex($color))
	   Else
		  Opt("MouseCoordMode", 0)
		  Opt("PixelCoordMode", 0)
		  Opt("WinTitleMatchMode",1)
		  $win = WinGetPos("")
		  $pos=MouseGetPos()
		  If $pos[0] >= 0 And $pos[0] <= $win[2] and $pos[1] >= 0 And $pos[1] <= $win[3] Then
			 $color=PixelGetColor($pos[0],$pos[1])
			 GUICtrlSetData($MousePosX, $pos[0])
			 GUICtrlSetData($MousePosY, $pos[1])
			 GUICtrlSetData($PixelColor,$color)
			 $HEX6=StringRight(Hex($color),6)
			 GUICtrlSetData($hexColor,"0x"&$HEX6)
			 GUICtrlSetBkColor($MostrarColor,"0x"&Hex($color))
		  Else
			 GUICtrlSetData($MousePosX, "----")
			 GUICtrlSetData($MousePosY, "----")
			 GUICtrlSetData($PixelColor,"")
			 GUICtrlSetData($hexColor,"")
		  EndIf
	   EndIf
    WEnd
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
	   sleep(10)
	   $msg=GUIGetMsg()
	   Select
		  Case $msg=$GUI_EVENT_CLOSE
			 Exit
	   EndSelect
    WEnd
EndFunc

Func MAG()
  $MyHDC = DLLCall("user32.dll","int","GetDC","hwnd",$MyhWnd)
  If @error Then Return
  $DeskHDC = DLLCall("user32.dll","int","GetDC","hwnd",0)
  If Not @error Then
	$xy = MouseGetPos()
	If Not @error Then
	   $l = $xy[0]-10
	   $t = $xy[1]-10
	   DLLCall("gdi32.dll","int","StretchBlt","int",$MyHDC[0],"int",0,"int",0,"int",100,"int",100,"int",$DeskHDC[0],"int",$l,"int",$t,"int",20,"int",20,"long",$SRCCOPY)
	   If $xy[0]<(@DesktopWidth-120) then
		  $XArea= $xy[0] + 20
	   Else
		  $XArea= $xy[0] - 120
	   EndIf
	   If $xy[1]<(@DesktopHeight-120) then
		  $YArea= $xy[1] + 20
	   Else
		  $YArea= $xy[1] - 120
	   EndIf
	   WinMove($myhwnd, "",$XArea,$YArea , 100, 100)
	   If GUICtrlRead($Solid)=$GUI_CHECKED Then
		  CrossHairsSOLID($MyHDC[0])
	   EndIf
	   If  GUICtrlRead($Inver)=$GUI_CHECKED Then
		  CrossHairsINV($MyHDC[0])
	   EndIf
	EndIf
	DLLCall("user32.dll","int","ReleaseDC","int",$DeskHDC[0],"hwnd",0)
  EndIf
  DLLCall("user32.dll","int","ReleaseDC","int",$MyHDC[0],"hwnd",$MyhWnd)
EndFunc

Func Ayuda()
    MsgBox(0,"Pomoc","*U¿yj przybli¿enia dla wiêkszej precyzji." & @CRLF & "" & @CRLF & "*U¿yj opcji 'Steruj klawiatur¹' dla wiêkszej precyzji." & @CRLF & "   -Trzymanie wciœniêtych klawiszy strza³ek zwiêksza prêdkoœæ przemieszczania siê kursora." & @CRLF & "   -Shift+'klawisz strza³ki' zwiêksza szybkoœæ przemieszczania siê kursora." & @CRLF & "" & @CRLF & "*U¿yj opcji 'Wpisz pozycjê' aby przenieœæ kursor na odpowiedni piksel." & @CRLF & @CR&"*Wciœnij klawisz PAUSE aby zablokowaæ lub odblokowaæ program." & @CRLF & "" & @CRLF &"*Wciœinij klawisz INSERT aby skopiowac kod HEX do schowka.")
EndFunc

Func Saltar()
    Do
    $SaltarCord=InputBox("Wpisz pozycjê","Wpisz pozycjê piksela, do którego chcesz przenieœæ kursor."&@CRLF&"Przyk³ad: 123,420",MouseGetPos(0)&","&MouseGetPos(1),"",150,150)
    $CoordsM=StringSplit($SaltarCord,",")
    Until @error OR ($CoordsM[1]<=@DesktopWidth AND $CoordsM[2]<=@DesktopHeight)
    if not @error Then
	   BlockInput(1)
	   MouseMove($CoordsM[1],$CoordsM[2])
	   BlockInput(0)
    EndIf
EndFunc

Func MouseKeyb()

HotKeySet("+{UP}", "_UpArrow")
HotKeySet("{UP}", "_UpArrow")
HotKeySet("+{DOWN}", "_DownArrow")
HotKeySet("{DOWN}", "_DownArrow")
HotKeySet("+{LEFT}", "_LeftArrow")
HotKeySet("{LEFT}", "_LeftArrow")
HotKeySet("+{RIGHT}", "_RightArrow")
HotKeySet("{RIGHT}", "_RightArrow")
EndFunc

Func MouseKeybNO()
HotKeySet("+{UP}")
HotKeySet("{UP}")
HotKeySet("+{DOWN}")
HotKeySet("{DOWN}")
HotKeySet("+{LEFT}")
HotKeySet("+{LEFT}")
HotKeySet("{LEFT}")
HotKeySet("+{RIGHT}")
HotKeySet("{RIGHT}")
EndFunc

Func nada()
EndFunc

Func _copyHEX()
    ClipPut(Guictrlread($hexColor))
EndFunc;==>_ShowInfo

Func _UpArrow()
    Local $MousePos = MouseGetPos()
    If _IsPressed(10) Then
	   $i = 10
    Else
	   $i = 1
    EndIf

    If $MousePos[1] > 0 Then
	   _BoostMouseSpeed()
	   MouseMove($MousePos[0], $MousePos[1] - ($MouseModifier * $i), 1)
    EndIf
EndFunc;==>_UpArrow

Func _DownArrow()
    If _IsPressed(10) Then
	   $i = 10
    Else
	   $i = 1
    EndIf

    Local $MousePos = MouseGetPos()
    If $MousePos[1] < @DesktopHeight Then
	   _BoostMouseSpeed()
	   MouseMove($MousePos[0], $MousePos[1] + ($MouseModifier * $i),1)
    EndIf
EndFunc;==>_DownArrow

Func _LeftArrow()
    If _IsPressed(10) Then
	   $i = 10
    Else
	   $i = 1
    EndIf

    Local $MousePos = MouseGetPos()
    If $MousePos[0] > 0 Then
	   _BoostMouseSpeed()
	   MouseMove($MousePos[0] - ($MouseModifier * $i), $MousePos[1],1)
    EndIf
EndFunc;==>_LeftArrow

Func _RightArrow()
    If _IsPressed(10) Then
	   $i = 10
    Else
	   $i = 1
    EndIf

    Local $MousePos = MouseGetPos()
    If $MousePos[0] < @DesktopWidth Then
	   _BoostMouseSpeed()
	   MouseMove($MousePos[0] + ($MouseModifier * $i), $MousePos[1],1)
    EndIf
EndFunc;==>_RightArrow

Func _BoostMouseSpeed()
	   If IsInt($PressedTime / 10) Then
		  $MouseModifier = $MouseModifier + 1
		  $PressedTime = $PressedTime + 1
	   Else
		  $PressedTime = $PressedTime + 1
	   EndIf
EndFunc

Func _ResetSpeed()
    $MouseModifier = 1
    $PressedTime = 1
EndFunc;==>_ResetSpeed

Func CrossHairsSOLID(ByRef $hdc)
    Local $hPen, $hPenOld
    $hPen = DllCall("gdi32.dll","hwnd","CreatePen","int",0,"int",5,"int",0x555555)
    $hPenOld = DllCall("gdi32.dll","hwnd","SelectObject","int",$hdc,"hwnd",$hPen[0])
    DLLCall("gdi32.dll","int","MoveToEx","int",$hdc,"int",52,"int",0,"ptr",0)
    DLLCall("gdi32.dll","int","LineTo","int",$hdc,"int",52,"int",46)
    DLLCall("gdi32.dll","int","MoveToEx","int",$hdc,"int",52,"int",58,"ptr",0)
    DLLCall("gdi32.dll","int","LineTo","int",$hdc,"int",52,"int",100)
    DLLCall("gdi32.dll","int","MoveToEx","int",$hdc,"int",0,"int",52,"ptr",0)
    DLLCall("gdi32.dll","int","LineTo","int",$hdc,"int",46,"int",52)
    DLLCall("gdi32.dll","int","MoveToEx","int",$hdc,"int",58,"int",52,"ptr",0)
    DLLCall("gdi32.dll","int","LineTo","int",$hdc,"int",100,"int",52)
    DllCall("gdi32.dll","hwnd","SelectObject","int",$hdc,"hwnd",$hPenOld[0])
    DllCall("gdi32.dll","int","DeleteObject","hwnd",$hPen[0])
EndFunc

Func CrossHairsINV(ByRef $hdc)
;~   Local CONST $NOTSRCCOPY = 0x3300087
    DLLCall("gdi32.dll","int","BitBlt","int",$hdc,"int",50,"int",0,"int",5,"int",49,"int",$hdc,"int",50,"int",0,"int",$NOTSRCCOPY)
    DLLCall("gdi32.dll","int","BitBlt","int",$hdc,"int",50,"int",56,"int",5,"int",49,"int",$hdc,"int",50,"int",56,"int",$NOTSRCCOPY)
    DLLCall("gdi32.dll","int","BitBlt","int",$hdc,"int",0,"int",50,"int",49,"int",5,"int",$hdc,"int",0,"int",50,"int",$NOTSRCCOPY)
    DLLCall("gdi32.dll","int","BitBlt","int",$hdc,"int",56,"int",50,"int",44,"int",5,"int",$hdc,"int",56,"int",50,"int",$NOTSRCCOPY)
EndFunc

Func _exit()
    Exit
EndFunc