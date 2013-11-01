/*****************************************************************************
  IME����p �֐��Q (IME.ahk)

    �O���[�o���ϐ� : �Ȃ�
    �e�֐��̈ˑ��� : �Ȃ�(�K�v�֐������؏o���ăR�s�y�ł��g���܂�)

    AutoHotkey:     v1.0.46�ȍ~
    Language:       apanease
    Platform:       Win9x/NT
    Author:         eamat.      http://www6.atwiki.p/eamat/pub/MyScript/
*****************************************************************************
����
    2008.07.11 v1.0.47�ȍ~�� �֐����C�u�����X�N���v�g�Ή��p�Ƀt�@�C������ύX
    2008.12.10 �R�����g�C��
    2009.07.03 IME_GetConverting() �ǉ� 
               Last Found Window���L���ɂȂ�Ȃ����C���A���B
    2009.12.03 
      �EIME ��ԃ`�F�b�N GUIThreadInfo ���p�� ���ꍞ��
       �iIE��G��8���ł�IME��Ԃ�����悤�Ɂj
        http://blechmusik.xrea.p/resources/keyboard_layout/Dvorak/inc/IME.ahk
      �EGoogle���{����̓� ��������
        ���̓��[�h �y�� �ϊ����[�h�͎��Ȃ����ۂ�
        IME_GET/SET() �� IME_GetConverting()�͗L��
*/

;---------------------------------------------------------------------------
;  �ėp�֐� (�����ǂ�IME�ł�������͂�)

;-----------------------------------------------------------
; IME�̏�Ԃ̎擾
;   WinTitle="A"    �Ώ�Window
;   �߂�l          1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Int, 0)      ;lParam  : 0
}

;-----------------------------------------------------------
; IME�̏�Ԃ��Z�b�g
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    �Ώ�Window
;   �߂�l          0:���� / 0�ȊO:���s
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, SetSts) ;lParam  : 0 or 1
}

;===========================================================================
; IME ���̓��[�h (�ǂ� IME�ł����ʂ��ۂ�)
;   DEC  HEX    BIN
;     0 (0x00  0000 0000) ����    ���p��
;     3 (0x03  0000 0011)         ����
;     8 (0x08  0000 1000)         �S�p��
;     9 (0x09  0000 1001)         �Ђ炪��
;    11 (0x0B  0000 1011)         �S�J�^�J�i
;    16 (0x10  0001 0000) ���[�}�����p��
;    19 (0x13  0001 0011)         ����
;    24 (0x18  0001 1000)         �S�p��
;    25 (0x19  0001 1001)         �Ђ炪��
;    27 (0x1B  0001 1011)         �S�J�^�J�i

;  �� �n��ƌ���̃I�v�V���� - [�ڍ�] - �ڍאݒ�
;     - �ڍׂȃe�L�X�g�T�[�r�X�̃T�|�[�g���v���O�����̂��ׂĂɊg������
;    �� ON�ɂȂ��Ă�ƒl�����Ȃ��͗l 
;    (Google���{����̓��͂�����ON�ɂ��Ȃ��ƑʖڂȂ̂Œl�����Ȃ����ۂ�)

;-------------------------------------------------------
; IME ���̓��[�h�擾
;   WinTitle="A"    �Ώ�Window
;   �߂�l          ���̓��[�h
;--------------------------------------------------------
IME_GetConvMode(WinTitle="A")   {
    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x001   ;wParam  : IMC_GETCONVERSIONMODE
          ,  Int, 0)      ;lParam  : 0
}

;-------------------------------------------------------
; IME ���̓��[�h�Z�b�g
;   ConvMode        ���̓��[�h
;   WinTitle="A"    �Ώ�Window
;   �߂�l          0:���� / 0�ȊO:���s
;--------------------------------------------------------
IME_SetConvMode(ConvMode,WinTitle="A")   {
    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
          , UInt, 0x0283      ;Message : WM_IME_CONTROL
          ,  Int, 0x002       ;wParam  : IMC_SETCONVERSIONMODE
          ,  Int, ConvMode)   ;lParam  : CONVERSIONMODE
}

;===========================================================================
; IME �ϊ����[�h (ATOK��ver.16�Œ����A�o�[�W�����ő����Ⴄ����)

;   MS-IME  0:���ϊ� / 1:�l��/�n��                    / 8:���    /16:�b�����t
;   ATOK�n  0:�Œ�   / 1:������              / 4:���� / 8:�A����
;   WXG              / 1:������  / 2:���ϊ�  / 4:���� / 8:�A����
;   SKK�n            / 1:�m�[�}�� (���̃��[�h�͑��݂��Ȃ��H)
;   Google��                                          / 8:�m�[�}��
;------------------------------------------------------------------
; IME �ϊ����[�h�擾
;   WinTitle="A"    �Ώ�Window
;   �߂�l MS-IME  0:���ϊ� 1:�l��/�n��               8:���    16:�b�����t
;          ATOK�n  0:�Œ�   1:������           4:���� 8:�A����
;          WXG4             1:������  2:���ϊ� 4:���� 8:�A����
;------------------------------------------------------------------
IME_GetSentenceMode(WinTitle="A")   {
    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x003   ;wParam  : IMC_GETSENTENCEMODE
          ,  Int, 0)      ;lParam  : 0
}

;----------------------------------------------------------------
; IME �ϊ����[�h�Z�b�g
;   SentenceMode
;       MS-IME  0:���ϊ� 1:�l��/�n��               8:���    16:�b�����t
;       ATOK�n  0:�Œ�   1:������           4:���� 8:�A����
;       WXG              1:������  2:���ϊ� 4:���� 8:�A����
;   WinTitle="A"    �Ώ�Window
;   �߂�l          0:���� / 0�ȊO:���s
;-----------------------------------------------------------------
IME_SetSentenceMode(SentenceMode,WinTitle="A")  {
    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
          , UInt, 0x0283          ;Message : WM_IME_CONTROL
          ,  Int, 0x004           ;wParam  : IMC_SETSENTENCEMODE
          ,  Int, SentenceMode)   ;lParam  : SentenceMode
}


;---------------------------------------------------------------------------
;  IME�̎�ނ�I�Ԃ�������Ȃ��֐�

;==========================================================================
;  IME �������͂̏�Ԃ�Ԃ�
;  (�p�N���� : http://sites.google.com/site/agkh6mze/scripts#TOC-IME- )
;    �W���Ή�IME : ATOK�n / MS-IME2002 2007 / WXG / SKKIME
;    ���̑���IME�� ���͑�/�ϊ�����ǉ��w�肷�邱�ƂőΉ��\
;
;       WinTitle="A"   �Ώ�Window
;       ConvCls=""     ���͑��̃N���X�� (���K�\���\�L)
;       CandCls=""     ��⑋�̃N���X�� (���K�\���\�L)
;       �߂�l      1 : �������͒� or �ϊ���
;                   2 : �ϊ���⑋���o�Ă���
;                   0 : ���̑��̏��
;
;   �� MS-Office�n�� ���͑��̃N���X�� �𐳂����擾����ɂ�IME�̃V�[�����X�\����
;      OFF�ɂ���K�v������
;      �I�v�V����-�ҏW�Ɠ��{�����-�ҏW���̕�����𕶏��ɑ}�����[�h�œ��͂���
;      �̃`�F�b�N���O��
;==========================================================================
IME_GetConverting(WinTitle="A",ConvCls="",CandCls="") {

    ;IME���� ���͑�/��⑋Class�ꗗ ("|" ��؂�œK���ɑ����Ă���OK)
    ConvCls .= (ConvCls ? "|" : "")                 ;--- ���͑� ---
            .  "ATOK\d+CompStr"                     ; ATOK�n
            .  "|imepstcnv\d+"                     ; MS-IME�n
            .  "|WXGIMEConv"                        ; WXG
            .  "|SKKIME\d+\.*\d+UCompStr"           ; SKKIME Unicode
            .  "|MSCTFIME Composition"              ; Google���{�����

    CandCls .= (CandCls ? "|" : "")                 ;--- ��⑋ ---
            .  "ATOK\d+Cand"                        ; ATOK�n
            .  "|imepstCandList\d+|imepstcand\d+" ; MS-IME 2002(8.1)XP�t��
            .  "|mscandui\d+\.candidate"            ; MS Office IME-2007
            .  "|WXGIMECand"                        ; WXG
            .  "|SKKIME\d+\.*\d+UCand"              ; SKKIME Unicode
   CandGCls := "GoogleapaneseInputCandidateWindow" ;Google���{�����

    VarSetCapacity(stGTI, 48, 0)
    NumPut(48, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)

    WinGet, pid, PID,% "ahk_id " hwndFocus
    tmm:=A_TitleMatchMode
    SetTitleMatchMode, RegEx
    ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
        :  WinExist("ahk_class " . CandGCls                 ) ? 2
        :  WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
        :  0
    SetTitleMatchMode, %tmm%
    return ret
}


;-----------------------------------------------------------
; �g�p���̃L�[�{�[�h�z��̎擾
;-----------------------------------------------------------
Get_Keyboard_Layout()  {
	SetFormat, Integer, H
	hwnd := WinExist("A")
	return DllCall("GetKeyboardLayout"
			        , "Uint", dllCall("GetWindowThreadProcessId", "Uint", hwnd)
			        , "Uint")
}

Get_languege_id(hKL) {
	SetFormat, Integer, H
	return mod(hKL, 0x10000)
}


Get_primary_language_identifier(local_identifier){
	SetFormat, Integer, H
	return mod(local_identifier, 0x100)
}

Get_sublanguage_identifier(local_identifier){
	SetFormat, Integer, H
	return Floor(local_identifier / 0x100)
}

Get_languege_name() {
	locale_id := Get_languege_id(Get_Keyboard_Layout())

	if (5 = StrLen(locale_id)){
		StringRight, locale_id, locale_id, 3
		locale_id := "0x0" . locale_id
	}
	
	;; ���P�[�� ID (LCID) �̈ꗗ
	;; http://msdn.microsoft.com/a-p/library/ie/cc392381.aspx
	
	;; Language Identifier Constants and Strings
	;; http://msdn.microsoft.com/en-us/library/windows/desktop/dd318693(v=vs.85).aspx
	
	;; [AHK 1.1.02.00 U32] Error: Expression too long
	;; http://www.autohotkey.com/forum/topic75335.html

	return    (locale_id = "0x0436") ? "af"
			;; : (locale_id = "0x041C") ? "sq"
			;; : (locale_id = "0x3801") ? "ar-ae"
			;; : (locale_id = "0x3C01") ? "ar-bh"
			;; : (locale_id = "0x1401") ? "ar-dz"
			;; : (locale_id = "0x0C01") ? "ar-eg"
			;; : (locale_id = "0x0801") ? "ar-iq"
			;; : (locale_id = "0x2C01") ? "ar-o"
			;; : (locale_id = "0x3401") ? "ar-kw"
			;; : (locale_id = "0x3001") ? "ar-lb"
			;; : (locale_id = "0x1001") ? "ar-ly"
			;; : (locale_id = "0x1801") ? "ar-ma"
			;; : (locale_id = "0x2001") ? "ar-om"
			;; : (locale_id = "0x4001") ? "ar-qa"
			;; : (locale_id = "0x0401") ? "ar-sa"
			;; : (locale_id = "0x2801") ? "ar-sy"
			;; : (locale_id = "0x1C01") ? "ar-tn"
			;; : (locale_id = "0x2401") ? "ar-ye"
			;; : (locale_id = "0x042D") ? "eu"
			;; : (locale_id = "0x0423") ? "be"
			;; : (locale_id = "0x0402") ? "bg"
			;; : (locale_id = "0x0403") ? "ca"
			: (locale_id = "0x0804") ? "zh-cn"
			: (locale_id = "0x0C04") ? "zh-hk"
			: (locale_id = "0x1004") ? "zh-sg"
			: (locale_id = "0x0404") ? "zh-tw"
			;; : (locale_id = "0x041A") ? "hr"
			;; : (locale_id = "0x0405") ? "cs"
			;; : (locale_id = "0x0406") ? "da"
			;; : (locale_id = "0x0413") ? "nl"
			;; : (locale_id = "0x0813") ? "nl-be"
			;; : (locale_id = "0x0C09") ? "en-au"
			;; : (locale_id = "0x2809") ? "en-bz"
			;; : (locale_id = "0x1009") ? "en-ca"
			;; : (locale_id = "0x1809") ? "en-ie"
			;; : (locale_id = "0x2009") ? "en-m"
			;; : (locale_id = "0x1409") ? "en-nz"
			;; : (locale_id = "0x1C09") ? "en-za"
			;; : (locale_id = "0x2C09") ? "en-tt"
			;; : (locale_id = "0x0809") ? "en-gb"
			;; : (locale_id = "0x0409") ? "en-us"
			;; : (locale_id = "0x0425") ? "et"
			;; : (locale_id = "0x0429") ? "fa"
			;; : (locale_id = "0x040B") ? "fi"
			;; : (locale_id = "0x0438") ? "fo"
			;; : (locale_id = "0x040C") ? "fr"
			;; : (locale_id = "0x080C") ? "fr-be"
			;; : (locale_id = "0x0C0C") ? "fr-ca"
			;; : (locale_id = "0x140C") ? "fr-lu"
			;; : (locale_id = "0x100C") ? "fr-ch"
			;; : (locale_id = "0x043C") ? "gd"
			;; : (locale_id = "0x0407") ? "de"
			;; : (locale_id = "0x0C07") ? "de-at"
			;; : (locale_id = "0x1407") ? "de-li"
			;; : (locale_id = "0x1007") ? "de-lu"
			;; : (locale_id = "0x0807") ? "de-ch"
			;; : (locale_id = "0x0408") ? "el"
			;; : (locale_id = "0x040D") ? "he"
			;; : (locale_id = "0x0439") ? "hi"
			;; : (locale_id = "0x040E") ? "hu"
			;; : (locale_id = "0x040F") ? "is"
			;; : (locale_id = "0x0421") ? "in"
			;; : (locale_id = "0x0410") ? "it"
			;; : (locale_id = "0x0810") ? "it-ch"
			: (locale_id = "0x0411") ? "a"
			;; : (locale_id = "0x0412") ? "ko"
			;; : (locale_id = "0x0426") ? "lv"
			;; : (locale_id = "0x0427") ? "lt"
			;; : (locale_id = "0x042F") ? "mk"
			;; : (locale_id = "0x043E") ? "ms"
			;; : (locale_id = "0x043A") ? "mt"
			;; : (locale_id = "0x0414") ? "no"
			;; : (locale_id = "0x0415") ? "pl"
			;; : (locale_id = "0x0816") ? "pt"
			;; : (locale_id = "0x0416") ? "pt-br"
			;; : (locale_id = "0x0417") ? "rm"
			;; : (locale_id = "0x0418") ? "ro"
			;; : (locale_id = "0x0818") ? "ro-mo"
			;; : (locale_id = "0x0419") ? "ru"
			;; : (locale_id = "0x0819") ? "ru-mo"
			;; : (locale_id = "0x0C1A") ? "sr"
			;; : (locale_id = "0x0432") ? "tn"
			;; : (locale_id = "0x0424") ? "sl"
			;; : (locale_id = "0x041B") ? "sk"
			;; : (locale_id = "0x042E") ? "sb"
			;; : (locale_id = "0x040A") ? "es"
			;; : (locale_id = "0x2C0A") ? "es-ar"
			;; : (locale_id = "0x400A") ? "es-bo"
			;; : (locale_id = "0x340A") ? "es-cl"
			;; : (locale_id = "0x240A") ? "es-co"
			;; : (locale_id = "0x140A") ? "es-cr"
			;; : (locale_id = "0x1C0A") ? "es-do"
			;; : (locale_id = "0x300A") ? "es-ec"
			;; : (locale_id = "0x100A") ? "es-gt"
			;; : (locale_id = "0x480A") ? "es-hn"
			;; : (locale_id = "0x080A") ? "es-mx"
			;; : (locale_id = "0x4C0A") ? "es-ni"
			;; : (locale_id = "0x180A") ? "es-pa"
			;; : (locale_id = "0x280A") ? "es-pe"
			;; : (locale_id = "0x500A") ? "es-pr"
			;; : (locale_id = "0x3C0A") ? "es-py"
			;; : (locale_id = "0x440A") ? "es-sv"
			;; : (locale_id = "0x380A") ? "es-uy"
			;; : (locale_id = "0x200A") ? "es-ve"
			;; : (locale_id = "0x0430") ? "sx"
			;; : (locale_id = "0x041D") ? "sv"
			;; : (locale_id = "0x081D") ? "sv-fi"
			;; : (locale_id = "0x041E") ? "th"
			;; : (locale_id = "0x041F") ? "tr"
			;; : (locale_id = "0x0431") ? "ts"
			;; : (locale_id = "0x0422") ? "uk"
			;; : (locale_id = "0x0420") ? "ur"
			;; : (locale_id = "0x042A") ? "vi"
			;; : (locale_id = "0x0434") ? "xh"
			;; : (locale_id = "0x043D") ? "i"
			;; : (locale_id = "0x0435") ? "zu"
			: "unknown"
}

Get_ime_file(){
	;; ImmGetIMEFileName �֐�
	;; http://msdn.microsoft.com/a-p/library/cc448001.aspx
	SubKey := Get_reg_Keyboard_Layouts()
	RegRead, ime_file_name, HKEY_LOCAL_MACHINE, %SubKey%, Ime File
	return ime_file_name
}

Get_Layout_Text(){
	SubKey := Get_reg_Keyboard_Layouts()
	RegRead, layout_text, HKEY_LOCAL_MACHINE, %SubKey%, Layout Text
	return layout_text
}

Get_reg_Keyboard_Layouts(){
	hKL := RegExReplace(Get_Keyboard_Layout(), "0x", "")
	return "System\CurrentControlSet\control\keyboard layouts\" . hKL ;"
}
