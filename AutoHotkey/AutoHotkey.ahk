;;;;;;;;;;;;;;;;;;;; README ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SharpKeys should be used to map:
;;     Caps Lock -> Escape
;;     Right Alt -> F13
;; SharpKeys website: https://www.randyrants.com/category/sharpkeys/
;; SharpKeys source: https://github.com/randyrants/sharpkeys
;;
;; These are the Croatian letters: čČ ćĆ šŠ đĐ žŽ
;;
;; vkDC keyboard code is backslash (US keyboard) or ž (Cro keyboard)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mapKey(mappedKey, originalKey) {
	if (GetKeyState("Alt") || GetKeyState("Ctrl") || GetKeyState("Shift"))
		SendInput {Blind}{%originalKey%}
	else
		SendInput {Blind}%mappedKey%
}

mapSpecialLetter(lowerCase, upperCase) {
	if (GetKeyState("Shift"))
		SendInput {Blind}%upperCase%
	else
		SendInput {Blind}%lowerCase%
}

;; if keyboard has small enter this might be helpful
vkDC::Enter ;; ž => enter

;; remap arrows - more left position on keyboard
F13 & k::SendInput {Blind}{Left}
F13 & o::SendInput {Blind}{Up}
F13 & l::SendInput {Blind}{Down}
F13 & `;::SendInput {Blind}{Right}
F13 & i::SendInput {Blind}{Home}
F13 & p::SendInput {Blind}{End}

;; remap arrows - more right position on keyboard
;;F13 & l::SendInput {Blind}{Left}
;;F13 & p::SendInput {Blind}{Up}
;;F13 & `;::SendInput {Blind}{Down}
;;F13 & '::SendInput {Blind}{Right}
;;F13 & o::SendInput {Blind}{Home}
;;F13 & [::SendInput {Blind}{End}

F13 & ,::SendInput {Blind}{PgUp}
F13 & .::SendInput {Blind}{PgDn}

F13 & q::mapKey("\", "q")
F13 & w::mapKey("|", "w")
F13 & v::mapKey("@", "v")
F13 & f::mapKey("[", "f")
F13 & g::mapKey("]", "g")
F13 & b::mapKey("{{}", "b")
F13 & n::mapKey("{}}", "n")

;;F13 & e::mapKey("{Enter}", "e")
;;F13 & c::mapKey("{Backspace}", "c")

F13 & d::mapKey("{Delete}", "d")
F13 & r::mapKey("{AppsKey}", "r")

F13 & a::mapKey("{End}{Enter}", "a") ;; insert in next line
F13 & j::mapKey("{Down}{Home}+{Up}+{End}{Space}", "j") ;; join lines
F13 & t::mapKey("^{Backspace}", "t") ;; delete last word (ctrl-backspace)

F13 & z::mapSpecialLetter("ž", "Ž")
F13 & c::mapSpecialLetter("ć", "Ć")
F13 & x::mapSpecialLetter("č", "Č")
F13 & s::mapSpecialLetter("š", "Š")
F13 & y::mapSpecialLetter("đ", "Đ")

F13 & 1::SendInput {Blind}{F1}
F13 & 2::SendInput {Blind}{F2}
F13 & 3::SendInput {Blind}{F3}
F13 & 4::SendInput {Blind}{F4}
F13 & 5::SendInput {Blind}{F5}
F13 & 6::SendInput {Blind}{F6}
F13 & 7::SendInput {Blind}{F7}
F13 & 8::SendInput {Blind}{F8}
F13 & 9::SendInput {Blind}{F9}
F13 & 0::SendInput {Blind}{F10}

F13 & F10::SendInput {Blind}{vkADsc120} ;;mute
F13 & F11::SendInput {Blind}{Volume_Down}
F13 & F12::SendInput {Blind}{Volume_Up}

;;;;;;;;;;;;; Misc directives ;;;;;;;;;;;;;;;;
;;#InstallKeybdHook
;;#UseHook
;;#NoEnv
;;SendMode Input
