;M.Wolff 2023
#persistent
#include <XInput>
onexit("XInput_Term")
global xbuttwnd,obuttwnd,tributtwnd,squarebuttwnd
XInput_Init()
gui,BG:New,-dpiscale -caption +toolwindow +hwndbghwnd +lastfound 
;gui,LIGHT:New,-dpiscale +parentBG -caption +toolwindow +hwndlighthwnd +lastfound

;DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",lighthwnd,"uint",&rect0)
gui,BG:add,pic,+hwndLightpicwnd x0 y0 ,C:\Users\ninj\Desktop11\New folder\lightall.png
gui,BG:add,pic,+hwndbgpicwnd x0 y0,C:\Users\ninj\Desktop11\New folder\bg.png

VarSetCapacity(rect0,16,0xff)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",lighthwnd,"uint",&rect0)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",bghwnd,"uint",&rect0)
winhide,ahk_id %Lightpicwnd%
gui,show,na hide
gui,bg:add,pic,+hwndxbuttwnd +backgroundtrans x369 y154,C:\Users\ninj\Desktop11\New folder\xbutt.png
gui,bg:add,pic,+hwndobuttwnd +backgroundtrans x403 y117,C:\Users\ninj\Desktop11\New folder\obutt.png
gui,bg:add,pic,+hwndtributtwnd +backgroundtrans x365 y83,C:\Users\ninj\Desktop11\New folder\tributt.png
gui,bg:add,pic,+hwndsquarebuttwnd +backgroundtrans x328 y117,C:\Users\ninj\Desktop11\New folder\squarebutt.png
gui,bg:show,na,hide
winanimate(bghwnd,"activate center",2000)
dllcall("AnimateWindow","uint",bghwnd,"uint",300,"uint",0x60002)

loop,5 {
sleep 1000 
winshow,ahk_id %Lightpicwnd%
sleep 1000
winhide,ahk_id %Lightpicwnd%
}
;}
;loop,parse,% "tri,o,x,square,select,start,ps",`, 
;{
;gui,%a_loopfield% : new,-dpiscale -caption +toolwindow +hwnd%a_loopfield%hwnd  +e0x80028
;
;pic:="C:\Users\ninj\Desktop11\New folder\" . a_loopfield . "butt.png"
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
anus:= (a_loopfield . "buttwnd")
winhide,% "ahk_id " %anus%
}
settimer,timer_xboxpad,100
return,
 
timer_xboxpad:
tooltip:= BUttons:= ""
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
  ((wButtons:= State.wButtons) &0x0001? BUttons.= " DPAD UP ")
  ((wButtons:= State.wButtons) &0x0002? BUttons.= " DPAD DOWN ")
  ((wButtons:= State.wButtons) &0x0004? BUttons.= " DPAD LEFT ")
  ((wButtons:= State.wButtons) &0x0008? BUttons.= " DPAD RIGHT ")
  ((wButtons:= State.wButtons) &0x0010? BUttons.= " SELECT ")
  ((wButtons:= State.wButtons) &0x0020? BUttons.= " START ")
  ((wButtons:= State.wButtons) &0x0040? BUttons.= " LEFT ANALOG BUTT ")
  ((wButtons:= State.wButtons) &0x0080? BUttons.= " RIGHT ANALOG BUTT ")
  ((wButtons:= State.wButtons) &0x0100? BUttons.= "   LEFT TRIGGER 1 `n")
  ((wButtons:= State.wButtons) &0x0200? BUttons.= "   RIGHT TRIGGER 1 `n")
  ((wButtons:= State.wButtons) &0x1000? (BUttons.= " x ", butt("x",1),xon:=true) : xon? (butt("x",0),xon:=false))
  ((wButtons:= State.wButtons) &0x2000? (BUttons.= " ø ", butt("o",1),oon:=true) : oon? (butt("o",0),oon:=false))
  ((wButtons:= State.wButtons) &0x4000? (BUttons.= chr(32) . chr(214) . chr(32),butt("square",1),squareon:=true) : squareon? (butt("square",0),squareon:=false))
  ((wButtons:= State.wButtons) &0x8000? (BUttons.= " ^ ", butt("tri",1),trion:=true) : trion? (butt("tri",0),trion:=false))
  if tooltip || BUttons {
		tooltip,%  tooltip (w:= Buttons? "`n " . BUttons : "") . (RawHexButtsVisible? (wb:=(wButtons!=0)? "`n`nRaw: " . Format("{:#x}",wBUttons) : "") : "")
		settimer,tt_ff,-500
	}
} return,

butt(buttname="",onoff:=1) {
global
bn:=(buttname . "buttwnd")
if(onoff ="1")
	winshow,% "ahk_id " %bn%
else,winhide,% "ahk_id " %bn%

}

tt_ff:
tooltip,% ""
return,