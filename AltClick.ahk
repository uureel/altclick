#SingleInstance Force
#InputLevel 1

; --- Configuration ---
SetCapsLockState("Off")
SetStoreCapsLockMode(false)

; --- Global State ---
global g_IsActive := true
global g_AltComboFired := false
global g_ToolTipGUI := false

; =================================================================================
; Core Logic: LAlt acts as LButton unless a key combo is triggered
; =================================================================================

#HotIf g_IsActive

; --- Case 1: Plain LAlt -> LButton ---
LAlt::
{
    g_AltComboFired := false
    Send "{LButton Down}"
}
LAlt Up::
{
    if (!g_AltComboFired)
        Send "{LButton Up}"
}

; --- Case 2: Ctrl + LAlt -> Ctrl + LButton ---
^LAlt::
{
    g_AltComboFired := false
    Send "{Ctrl Down}{LButton Down}"
}
^LAlt Up::
{
    if (!g_AltComboFired)
        Send "{LButton Up}{Ctrl Up}"
}

; --- Case 3: Shift + LAlt -> Shift + LButton ---
+LAlt::
{
    g_AltComboFired := false
    Send "{Shift Down}{LButton Down}"
}
+LAlt Up::
{
    if (!g_AltComboFired)
        Send "{LButton Up}{Shift Up}"
}

; --- Case 4: Ctrl + Shift + LAlt -> Ctrl + Shift + LButton ---
^+LAlt::
{
    g_AltComboFired := false
    Send "{Ctrl Down}{Shift Down}{LButton Down}"
}
^+LAlt Up::
{
    if (!g_AltComboFired)
        Send "{LButton Up}{Shift Up}{Ctrl Up}"
}

#HotIf ; End g_IsActive context

; =================================================================================
; Alt+Key Combo Handling
; =================================================================================

#HotIf GetKeyState("LAlt", "P") && g_IsActive

HandleAltCombo(key)
{
    g_AltComboFired := true

    ; Step 1: Release the mouse button without altering modifier key states.
    Send "{Blind}{LButton Up}"

    ; Step 2: Build the full, correct key combo string to send.
    ; This ensures that even with other modifiers held (Ctrl/Shift), the correct
    ; Alt+Key combo is sent.
    local finalSend := "{Blind}"
    if GetKeyState("Control", "P")
        finalSend .= "^"
    if GetKeyState("Shift", "P")
        finalSend .= "+"
    
    finalSend .= "!" ; Explicitly add the Alt modifier.
    finalSend .= key  ; Add the key itself.
    
    ; Step 3: Send the final command.
    Send finalSend
}

; --- Hotkey Definitions ---
*a::HandleAltCombo("a")
*b::HandleAltCombo("b")
*c::HandleAltCombo("c")
*d::HandleAltCombo("d")
*e::HandleAltCombo("e")
*f::HandleAltCombo("f")
*g::HandleAltCombo("g")
*h::HandleAltCombo("h")
*i::HandleAltCombo("i")
*j::HandleAltCombo("j")
*k::HandleAltCombo("k")
*l::HandleAltCombo("l")
*m::HandleAltCombo("m")
*n::HandleAltCombo("n")
*o::HandleAltCombo("o")
*p::HandleAltCombo("p")
*q::HandleAltCombo("q")
*r::HandleAltCombo("r")
*s::HandleAltCombo("s")
*t::HandleAltCombo("t")
*u::HandleAltCombo("u")
*v::HandleAltCombo("v")
*w::HandleAltCombo("w")
*x::HandleAltCombo("x")
*y::HandleAltCombo("y")
*z::HandleAltCombo("z")
*1::HandleAltCombo("1")
*2::HandleAltCombo("2")
*3::HandleAltCombo("3")
*4::HandleAltCombo("4")
*5::HandleAltCombo("5")
*6::HandleAltCombo("6")
*7::HandleAltCombo("7")
*8::HandleAltCombo("8")
*9::HandleAltCombo("9")
*0::HandleAltCombo("0")
*`::HandleAltCombo("``")
*-::HandleAltCombo("-")
*=::HandleAltCombo("=")
*[::HandleAltCombo("[")
*]::HandleAltCombo("]")
*\::HandleAltCombo("\")
*;::HandleAltCombo(";")
*'::HandleAltCombo("'")
*,::HandleAltCombo(",")
*.::HandleAltCombo(".")
*/::HandleAltCombo("/")
*Backspace::HandleAltCombo("{Backspace}")
*SC00C::HandleAltCombo("{NumpadSub}")
*Space::HandleAltCombo("{Space}")
*Tab::HandleAltCombo("{Tab}")
*Enter::HandleAltCombo("{Enter}")
*Esc::HandleAltCombo("{Esc}")
*Up::HandleAltCombo("{Up}")
*Down::HandleAltCombo("{Down}")
*Left::HandleAltCombo("{Left}")
*Right::HandleAltCombo("{Right}")
*F1::HandleAltCombo("{F1}")
*F2::HandleAltCombo("{F2}")
*F3::HandleAltCombo("{F3}")
*F4::HandleAltCombo("{F4}")
*F5::HandleAltCombo("{F5}")
*F6::HandleAltCombo("{F6}")
*F7::HandleAltCombo("{F7}")
*F8::HandleAltCombo("{F8}")
*F9::HandleAltCombo("{F9}")
*F10::HandleAltCombo("{F10}")
*F11::HandleAltCombo("{F11}")
*F12::HandleAltCombo("{F12}")

#HotIf ; End context-sensitive hotkeys

; =================================================================================
; Script Toggle and UI
; =================================================================================

*CapsLock::ToggleActiveState()

ToggleActiveState()
{
    global g_IsActive
    g_IsActive := !g_IsActive
    ShowTooltip(g_IsActive ? "AltClick   ON" : "AltClick   off")
}

ShowTooltip(text)
{
    global g_ToolTipGUI
    if IsObject(g_ToolTipGUI)
        g_ToolTipGUI.Destroy()

    g_ToolTipGUI := Gui("+AlwaysOnTop -Caption +ToolWindow", "Tooltip")
    g_ToolTipGUI.BackColor := "Black"
    g_ToolTipGUI.SetFont("s14 cWhite", "Segoe UI")
    g_ToolTipGUI.Add("Text", "xm ym w180 Center", text)
    g_ToolTipGUI.Show("NoActivate AutoSize x" (A_ScreenWidth // 2 - 90) " y60")
    SetTimer HideTooltip, -1000
}

HideTooltip()
{
    global g_ToolTipGUI
    if IsObject(g_ToolTipGUI) {
        g_ToolTipGUI.Destroy()
        g_ToolTipGUI := ""
    }
}
