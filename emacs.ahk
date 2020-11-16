;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;
#InstallKeybdHook
#UseHook

; Ripped from http://www49.atwiki.jp/ntemacs/pages/20.html
; Thanks a lot!
SetKeyDelay 0


#include IME.ahk

; <^j::IME_SET(1)
; >^j::IME_SET(0)

;    16 (0x10  0001 0000) ローマ字半英数
;    19 (0x13  0001 0011)         半ｶﾅ
;    24 (0x18  0001 1000)         全英数
;    25 (0x19  0001 1001)         ひらがな
;    27 (0x1B  0001 1011)         全カタカナ

press_right_alt()
{
  if (IME_GET() = 1) {
    conv = IME_GetConvMode()
    return (conv = 16) ? 25 ; roman -> hiragana(kanji)
      : (conv = 19) ? 27    ; hankaku kana -> zenkaku katakana
      : (conv = 24) ? 19    ; zenkaku roman -> hankaku kana
      : (conv = 25) ? 16    ; hiragana(kanji) -> roman
      : (conv = 27) ? 24    ; zenkaku katakana -> zenkaku roman
      : 16
  } else {
    IME_SET(1)
    return 25
  }
}

press_right_alt_win()
{
  if (IME_GET() = 1) {
    conv = IME_GetConvMode()
    return (conv = 16) ? 27 ; roman -> zenkaku katakana
      : (conv = 19) ? 16    ; hankaku kana -> roman
      : (conv = 24) ? 16    ; zenkaku roman -> roman
      : (conv = 25) ? 16    ; hiragana(kanji) -> roman
      : (conv = 27) ? 16    ; zenkaku katakana -> roman
      : 16
  } else {
    IME_SET(1)
    return 25
  }
}

LCtrl::CapsLock
CapsLock::LCtrl
<!::IME_SetConvMode(press_right_alt())
<#<!::IME_SetConvMode(press_right_alt_win())

get_key_locale()
{
  return Get_languege_id(Get_Keyboard_Layout())
}

+!:: Send get_key_locale()

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
  Sleep 50 ;[ms] this value depends on your environment
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
  global
  if is_pre_spc
    Send +{HOME}
  Else
    Send {HOME}
  Return
}
move_end_of_line()
{
  global
  if is_pre_spc
    Send +{END}
  Else
    Send {END}
  Return
}
previous_line()
{
  global
  if is_pre_spc
    Send +{Up}
  Else
    Send {Up}
  Return
}
next_line()
{
  global
  if is_pre_spc
    Send +{Down}
  Else
    Send {Down}
  Return
}
forward_char()
{
  global
  if is_pre_spc
    Send +{Right}
  Else
    Send {Right}
  Return
}
backward_char()
{
  global
  if is_pre_spc
    Send +{Left}
  Else
    Send {Left}
  Return
}
scroll_up()
{
  global
  if is_pre_spc
    Send +{PgUp}
  Else
    Send {PgUp}
  Return
}
scroll_down()
{
  global
  if is_pre_spc
    Send +{PgDn}
  Else
    Send {PgDn}
  Return
}

<^f:: forward_char()
<^d:: delete_char()
<^h:: delete_backward_char()
<^k:: kill_line()
; <^o:: open_line()
<^g:: quit()
; <^j:: newline_and_indent()
<^m:: newline()
; <^i:: indent_for_tab_command()
; <^s:: isearch_forward()
; <^r:: isearch_backward()
; <^w:: kill_region()
; !w:: kill_ring_save()
<^y:: yank()
; <^/:: undo()
<^z:: undo()
<^a:: move_beginning_of_line()
<^e:: move_end_of_line()
<^p:: previous_line()
<^n:: next_line()
<^b:: backward_char()
;<^v:: scroll_down()
!v:: scroll_up()
<^x:: kill_region()
<^+f:: isearch_forward()

