;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;
#InstallKeybdHook
#UseHook

; Ripped from http://www49.atwiki.jp/ntemacs/pages/20.html
; Thanks a lot!
SetKeyDelay 0

#include IME.ahk

LWin::LCtrl
AppsKey::Rwin

; LShift & CapsLock::return

BS::\
+BS::|
\::BS
|::BS

IME_toggle()
{
  if IME_GET()
    IME_SET(0)
  Else
    IME_SET(1)

  return 0
}

^j::IME_toggle()

; *LShift::Send {Shift}

; <^j::IME_SET(1)
; >^j::IME_SET(0)

;    16 (0x10  0001 0000) ローマ字半英数
;    19 (0x13  0001 0011)         半ｶﾅ
;    24 (0x18  0001 1000)         全英数
;    25 (0x19  0001 1001)         ひらがな
;    27 (0x1B  0001 1011)         全カタカナ

kanji()
{
  IME_SET(1)
  IME_SetConvMode(25) ; hiragana
  return 1
}

roman()
{
  IME_SET(1)
  IME_SetConvMode(16) ; roman
  return 0
}

; Requires AutoHotkey v1.1.26+, and the keyboard hook must be installed.
SendSuppressedKeyUp(key) {
    DllCall("keybd_event"
        , "char", GetKeyVK(key)
        , "char", GetKeySC(key)
        , "uint", KEYEVENTF_KEYUP := 0x2
        , "uptr", KEY_BLOCK_THIS := 0xFFC3D450)
}

; ; Disable Alt+key shortcuts for the IME.
; ~LAlt::SendSuppressedKeyUp("LAlt")

; ; Test hotkey:
; !CapsLock::MsgBox % A_ThisHotkey

; ; Remap CapsLock to LCtrl in a way compatible with IME.
; *CapsLock::
;     Send {Blind}{LCtrl Down}
;     SendSuppressedKeyUp("LCtrl")
;     return

; *CapsLock up::
;     Send {Blind}{LCtrl Up}
;     return

; SetCapsLockState, AlwaysOff
RAlt::roman()
RCtrl::kanji()

#If Not WinActive("ahk_class ConsoleWindowClass") and Not WinActive("ahk_class VMwareUnityHostWndClass") and Not WinActive("ahk_class Vim") and Not WinActive("ahk_class PuTTY")

delete_char()
{
  Send {Del}
  global is_pre_spc = 0
  Return
}
delete_backward_char()
{
  Send {BS}
  global is_pre_spc = 0
  Return
}
kill_line()
{
  Send {ShiftDown}{END}{SHIFTUP}
  SetKeyDelay -1
  ; Sleep 50 ;[ms] this value depends on your environment
  Send ^x
  global is_pre_spc = 0
  Return
}
open_line()
{
  Send {END}{Enter}{Up}
  global is_pre_spc = 0
  Return
}
quit()
{
  Send {ESC}
  global is_pre_spc = 0
  Return
}
newline()
{
  Send {Enter}
  global is_pre_spc = 0
  Return
}
indent_for_tab_command()
{
  Send {Tab}
  global is_pre_spc = 0
  Return
}
newline_and_indent()
{
  Send {Enter}{Tab}
  global is_pre_spc = 0
  Return
}
isearch_forward()
{
  Send ^f
  global is_pre_spc = 0
  Return
}
isearch_backward()
{
  Send ^f
  global is_pre_spc = 0
  Return
}
kill_region()
{
  Send ^x
  global is_pre_spc = 0
  Return
}
kill_ring_save()
{
  Send ^c
  global is_pre_spc = 0
  Return
}
yank()
{
  Send ^v
  global is_pre_spc = 0
  Return
}
undo()
{
  Send ^z
  global is_pre_spc = 0
  Return
}
find_file()
{
  Send ^o
  global is_pre_x = 0
  Return
}
save_buffer()
{
  Send, ^s
  global is_pre_x = 0
  Return
}
kill_emacs()
{
  Send !{F4}
  global is_pre_x = 0
  Return
}
move_beginning_of_line()
{
  Send {HOME}
  Return
}

move_end_of_line()
{
  Send {END}
  Return
}
previous_line()
{
  Send {Up}
  Return
}
next_line()
{
  Send {Down}
  Return
}
forward_char()
{
  Send {Right}
  Return
}
backward_char()
{
  Send {Left}
  Return
}
scroll_up()
{
  Send {PgUp}
  Return
}
scroll_down()
{
  Send {PgDn}
  Return
}

<^f::forward_char()
<^d::delete_char()
<^h::delete_backward_char()
<^k::kill_line()
; <^o:: open_line()
<^g::quit()
; <^j:: newline_and_indent()
<^m::newline()
; <^i:: indent_for_tab_command()
; <^s:: isearch_forward()
; <^r:: isearch_backward()
; <^w:: kill_region()
; !w:: kill_ring_save()
<^y::yank()
; <^/:: undo()
<^z::undo()
<^a::move_beginning_of_line()
<^e::move_end_of_line()
<^p::previous_line()
<^n::next_line()
<^b::backward_char()
RCtrl & Down:: scroll_down()
RCtrl & Up:: scroll_up()
<^x:: kill_region()
<^+f:: isearch_forward()
Enter::Send {Enter}

; ; This should be replaced by whatever your native language is. See 
; ; http msdn.microsoft.com /en-us/library/dd318693%28v=vs.85%29.aspx  Broken Link for safety
; ; for the language identifiers list.
; ; ja := DllCall("LoadKeyboardLayout", "Str", "00000411", "Int", 1)
; ja := DllCall("LoadKeyboardLayout", "Str", "00000409", "Int", 1)
; global currHkl := ja

; *CapsLock::
;   w := DllCall("GetForegroundWindow")
;   pid := DllCall("GetWindowThreadProcessId", "UInt", w, "Ptr", 0)
;   hkl := DllCall("GetKeyboardLayout", "UInt", pid)
;   if (hkl <> ja)
;   {
;       currHkl := hkl
;   }
;   PostMessage 0x50, 0, %ja%,, A
;   SetKeyDelay -1
;   Send {Blind}{LCtrl DownR}
;   return

; *CapsLock Up::
;   SetKeyDelay -1
;   Send {Blind}{LCtrl Up}
;   if (currHkl <> ja)
;   {
;       PostMessage 0x50, 0, %currHkl%,, A
;       currHkl := ja
;   }
;   return
