;M.Wolff 2023
#NoEnv
#Persistent
#Include <XInput>
setControlDelay,-1
SetBatchLines,	-1
SetWinDelay,		-1
SetTitleMatchMode,2
SetTitleMatchMode,Slow
Coordmode,Mouse,Screen
Coordmode,Pixel,Screen
Coordmode,Tooltip,Screen
SetFormat,FloatFast, 3.0
DetectHiddenWindows,On
DetectHiddenText,	On
setbatchlines,-1
gosub,varz
#Include C:\Script\AHK\- _ _ LiB\GDI+_All.ahk
pToken:= Gdip_Startup()

r_pid:= DllCall("GetCurrentProcessId")

r:= b64_2_hbitmap(trayicon64)

menu,tray,icon,% "HBItmap:* " . r 
 
Resdir:= A_scriptdir . "\res\"

, OnMessage(0x201,"WM_LBD") ;handles-> click+drag - to move;

, OnMessage(0x100,"OnWM_KEYDOWN")

onexit,exit

XInput_Init()
gui,BG:New,-dpiscale -caption +toolwindow +hwndbghwnd +lastfound 
;gui,LIGHT:New,-dpiscale +parentBG -caption +toolwindow +hwndlighthwnd +lastfound

;DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",lighthwnd,"uint",&rect0)
gui,BG:add,pic,+hwndLightpicwnd x0 y0 ,% Resdir  "lightall.png"
gui,BG:add,pic,+hwndbgpicwnd x0 y0,% Resdir  "bg.png"

VarSetCapacity(rect0,16,0xff)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",lighthwnd,"uint",&rect0)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",bghwnd,"uint",&rect0)
winhide,ahk_id %Lightpicwnd%
gui,show,na hide
gui,bg:add,pic,+hwndxButtwnd +backgroundtrans x369 y154,% Resdir "xButt.png"
gui,bg:add,pic,+hwndoButtwnd +backgroundtrans x403 y117,% Resdir "oButt.png"
gui,bg:add,pic,+hwndtriButtwnd +backgroundtrans x365 y83,% Resdir "triButt.png"
gui,bg:add,pic,+hwndsquareButtwnd +backgroundtrans x328 y117,% Resdir "squareButt.png"
;gui,led:new,-dpiscale -caption +toolwindow +hwndledhwnd +lastfound +e0x8
gui,bg:add,pic,x210 y63 +hwndledwnd +backgroundtrans,% Resdir "led.png"
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",ledhwnd,"uint",&rect0)

gui,bg:show,na,hide

bg_p:= wingetpos(bghwnd)
winanimate(bghwnd,"activate center",2000)
dllcall("AnimateWindow","uint",bghwnd,"uint",300,"uint",0x60002)
; gui,led:show,% " x" bg_p.x+210 " y" bg_p.y+64 " w27 h27" ;RE2:= DllCall("SetParent","uint",ledhwnd,"uint",bgpicwnd)
win_move(ledhwnd,50 ,100)
loop,5 {
	sleep,400
	winshow,ahk_id %Lightpicwnd%
	sleep,300
	winhide,ahk_id %Lightpicwnd%
}

;}
;loop,parse,% "tri,o,x,square,select,start,ps",`, 
;{
;gui,%a_loopfield% : new,-dpiscale -caption +toolwindow +hwnd%a_loopfield%hwnd  +e0x80028
;
;pic:="% Resdir  " . a_loopfield . "Butt.png"
;;DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",%a_loopfield%hwnd,"uint",&rect0)
;gui,%a_loopfield% : add,pic,+backgroundtrans x0 y0 +hwnd%a_loopfield%hwnd,% pic
;winset,transparent, 220,ahk_id %a_loopfield%hwnd
;gui,%a_loopfield% : show
;sleep 300
;RE2:= DllCall("SetParent","uint",%a_loopfield%hwnd,"uint",bghwnd)
;sleep 300
;
;}
loop,parse,% "x,tri,square,o",`,
{
	4n00s:= (a_loopfield . "Buttwnd")
	winhide,% "ahk_id " %4n00s%
} settimer,timer_xboxpad,100
return,

~esc::
if(winactive("ahk_pid " r_pid))
	exitapp,
else,return,

exit:
menu,tray,noicon ; gosub,XInput_Term
exitapp,

WM_LBD() { ; 0xA1-WM_NCLButtONDOWN
	PostMessage,0xA1,2 ; The same thing as dragging on the TitleBar to move Window.
}

OnWM_KEYDOWN(a,b) {
	if(a=27&&b=65537) ;escape;
		exitapp,
}

timer_xboxpad:
tooltip:= Buttons:= ""
Loop,2 {
  if(!State:= XInput_GetState(A_Index-1)) 
      continue,
  LT_ANALOG:= State.bLeftTrigger,     RT_ANALOG := State.bRightTrigger
  ,  ANALOG_LEFT_X:= State.sThumbLX,    ANALOG_LEFT_Y:= State.sThumbLY
  ,  ANALOG_RIGHT_X:= State.sThumbRX  ,  ANALOG_RIGHT_Y:= State.sThumbRY
  loop,parse,% "LT_ANALOG,RT_ANALOG",`, 
      if((%a_loopfield%)="") {
        settimer,timer_xboxpad,1000 ;Pad discon? Reduce rate.
        return,
      }  else,if((%a_loopfield%)>0)
        tooltip.= chr(32) . chr(32) . chr(32) . a_loopfield . ": " (%a_loopfield%) . chr(32) . chr(32) . chr(32)
  (tooltip ? tooltip.= "`n")
  loop,parse,% "ANALOG_LEFT_X,ANALOG_LEFT_Y",`,
  {
    oldvarnameasstring:=  a_loopfield . "old"
    if((%a_loopfield%)>((%oldvarnameasstring%)+4000))
     ||((%a_loopfield%)<((%oldvarnameasstring%)-4000))
        tooltip.=chr(32) . a_loopfield . ": " . (%a_loopfield%)
        ,ssleep(100)
    (%oldvarnameasstring%):=(%a_loopfield%)
  }  (tooltip ? tooltip.= "`n")
  loop,parse,% "ANALOG_RIGHT_X,ANALOG_RIGHT_Y",`,
  {
      oldvarnameasstring:=  a_loopfield . "old"
        if((%a_loopfield%)>((%oldvarnameasstring%)+4000))
         ||((%a_loopfield%)<((%oldvarnameasstring%)-4000))
          tooltip.=chr(32) . a_loopfield . ": " . (%a_loopfield%)
          ,ssleep(200)
      (%oldvarnameasstring%):=(%a_loopfield%)
  }
  ((wButtons:= State.wButtons) &0x0001? Buttons.= " DPAD UP ")
  ((wButtons:= State.wButtons) &0x0002? Buttons.= " DPAD DOWN ")
  ((wButtons:= State.wButtons) &0x0004? Buttons.= " DPAD LEFT ")
  ((wButtons:= State.wButtons) &0x0008? Buttons.= " DPAD RIGHT ")
  ((wButtons:= State.wButtons) &0x0010? Buttons.= " SELECT ")
  ((wButtons:= State.wButtons) &0x0020? Buttons.= " START ")
  ((wButtons:= State.wButtons) &0x0040? Buttons.= " LEFT ANALOG Butt ")
  ((wButtons:= State.wButtons) &0x0080? Buttons.= " RIGHT ANALOG Butt ")
  ((wButtons:= State.wButtons) &0x0100? Buttons.= "   LEFT TRIGGER 1 `n")
  ((wButtons:= State.wButtons) &0x0200? Buttons.= "   RIGHT TRIGGER 1 `n")
  ((wButtons:= State.wButtons) &0x1000? (Buttons.= " x ", Butt("x",1),xon:=true) : xon? (Butt("x",0),xon:=false))
  ((wButtons:= State.wButtons) &0x2000? (Buttons.= " ø ", Butt("o",1),oon:=true) : oon? (Butt("o",0),oon:=false))
  ((wButtons:= State.wButtons) &0x4000? (Buttons.= chr(32) . chr(214) . chr(32),Butt("square",1),squareon:=true) : squareon? (Butt("square",0),squareon:=false))
  ((wButtons:= State.wButtons) &0x8000? (Buttons.= " ^ ", Butt("tri",1),trion:=true) : trion? (Butt("tri",0),trion:=false))
  if tooltip || Buttons {
		tooltip,%  tooltip (w:= Buttons? "`n " . Buttons : "") . (RawHexButtsVisible? (wb:=(wButtons!=0)? "`n`nRaw: " . Format("{:#x}",wButtons) : "") : "")
		settimer,tt_ff,-500
	}
} return,

Butt(ButtName="",OnOff:=1) {
	global
	bn:=(ButtName . "Buttwnd")
	if(OnOff="1")
		winshow,% "ahk_id " %bn%
	else,winhide,% "ahk_id " %bn%
}

tt_ff:
tooltip,% ""
return,

b64Vars:
global trayicon64:="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"
return,

varz:

global r_pid, Resdir, bghwnd, xButtwnd, oButtwnd, triButtwnd, squareButtwnd

gosub,b64Vars
return,