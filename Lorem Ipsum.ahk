; Lorem ipsum app
; Author: Frankie Bagnardi
; Author Site: http://aboutscript.com/
; Tested on AutoHotkey_L 1.1.05.00 Unicode 32-bit
; Forked by Robert Mark Bram

#Include <cursor>
#include <sublorem>

BS_Flat := 0x8000

Gui, Font, Italic, Serif
Gui, Font,, Times New Roman Italic
Gui, Font, s24 cAAAAAA
Gui, Color, 222222
Gui, Add, Text,, Lorem ipsum generator

MaxLength := StrLen(SubLorem(1))
; Find initial starting position as a random number
Random, StartPos, 1, MaxLength - 2
; Now find index of next period.
rawSubLorem := SubLorem(1)
Needle = .
StringGetPos, StartPos, rawSubLorem, %Needle%, ,StartPos
if (StartPos = -1) {
   StartPos := 1
} else {
   StartPos := StartPos + 3
}

Gui, Add, Slider, ToolTip NoTicks Range5-%MaxLength% AltSubmit vSlidePos gUpdateSlide, 120

GuiControlGet, SlidePos, Pos
CopyX := SlidePosX
CopyW := SlidePosW // 2  - 10
PasteX := SlidePosX + SlidePosW - CopyW

Gui, Font, s18
Gui, Font,, Arial
Gui, Font,, Palatino Linotype
Gui, Add, Button, BackgroundTrans Section gCopy x%CopyX% w%CopyW% Default,&Copy
Gui, Add, Button,  BackgroundTrans ys wp gPasteTo x%PasteX% w%CopyW%, Paste To

Gui, Font, Italic, Serif
Gui, Font,, Lucida Console Italic
Gui, Font, s12 cAAAAAA
Gui, Color, 222222
Gui, Add, Text, w%SlidePosW% r30 xm vPreview

Gui, +ToolWindow
Gui, Show
OnExit, ExitSub

Gosub UpdateSlide

return

UpdateSlide:
GuiControlGet, SlidePos
LINE_WIDTH := 42 ; Characters
LINE_HEIGHT := 19

Lines := SlidePos // LINE_WIDTH + 2
Height := Lines  * LINE_HEIGHT

GuiControl, Move, Preview, h%Height%
GuiControl,, Preview, % SubLorem(StartPos, SlidePos)
Gui, Show, AutoSize
return

Copy:
Clipboard := SubLorem(StartPos, SlidePos)
ExitApp

PasteTo:
Gui, Hide
SetSystemCursor("IDC_CROSS")
Hotkey, ~LButton, PasteLocation
Hotkey, $Esc, ExitSub
return

PasteLocation:
; Wait up to 1/4 of  a second for the control to gain focus
; We store data in the clipboard while we're waiting to not waste time.
StartTime := A_TickCount
BackUpClip := ClipboardAll
GuiControlGet, SlidePos
Clipboard := SubLorem(StartPos, SlidePos)

; Now we wait up to 250 seconds, subtracting any time spent saving
; data to the clipboard
Sleep % 250 - (A_TickCount  - StartTime)

; Paste the clipboard
Send ^v

; Restore the previous clipboard state
Clipboard := BackUpClipboard
ExitApp
return

ExitSub:
RestoreCursors()
ExitApp

GuiEscape:
GuiClose:
ButtonClose:
   Gui Destroy
ExitApp
Return  ; All of the above labels will do this.


