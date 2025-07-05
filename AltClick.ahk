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

*LAlt::
{
    g_AltComboFired := false
    Send "{LButton Down}"
}

*LAlt Up::
{
    if (!g_AltComboFired)
        Send "{LButton Up}"
}

#HotIf ; End g_IsActive context

; =================================================================================
; Alt+Key Combo Handling
; This entire section is ONLY active when LAlt is physically held AND g_IsActive is true.
; This is the correct way to control context.
; =================================================================================

#HotIf GetKeyState("LAlt", "P") && g_IsActive

HandleAltCombo(key)
{
    Send "{LButton Up}"
    g_AltComboFired := true

    local isCtrlHeld := GetKeyState("Control", "P")
    local isShiftHeld := GetKeyState("Shift", "P")

    local finalSend := ""
    if (isCtrlHeld)
        finalSend .= "^"
    if (isShiftHeld)
        finalSend .= "+"
    finalSend .= "!"
    finalSend .= "{" key "}"

    Send finalSend

    if (isCtrlHeld)
        Send "{Control Down}"
    if (isShiftHeld)
        Send "{Shift Down}"
}

; --- Explicit Hotkey Definitions ---
; This is verbose, but it is the ONLY way to ensure hotkeys respect #HotIf.
; The "*" prefix allows firing with modifiers. The "~" prefix is REMOVED to prevent double-sends.
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
*q::HandlealtCombo("q")
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
*SC00C::HandleAltCombo("-") ; NumpadSub also uses "-"
*SC00D::HandleAltCombo("=") ; =
*SC01A::HandleAltCombo("[") ; [
*SC01B::HandleAltCombo("]") ; ]
*SC02B::HandleAltCombo("\") ; \
*SC027::HandleAltCombo(";") ; ;
*SC028::HandleAltCombo("'") ; '
*SC033::HandleAltCombo(",") ; ,
*SC034::HandleAltCombo(".") ; .
*SC035::HandleAltCombo("/") ; /
*Space::HandleAltCombo("Space")
*Tab::HandleAltCombo("Tab")
*Enter::HandleAltCombo("Enter")
*Esc::HandleAltCombo("Esc")
*Up::HandleAltCombo("Up")
*Down::HandleAltCombo("Down")
*Left::HandleAltCombo("Left")
*Right::HandleAltCombo("Right")
*F1::HandleAltCombo("F1")
*F2::HandleAltCombo("F2")
*F3::HandleAltCombo("F3")
*F4::HandleAltCombo("F4")
*F5::HandleAltCombo("F5")
*F6::HandleAltCombo("F6")
*F7::HandleAltCombo("F7")
*F8::HandleAltCombo("F8")
*F9::HandleAltCombo("F9")
*F10::HandleAltCombo("F10")
*F11::HandleAltCombo("F11")
*F12::HandleAltCombo("F12")

#HotIf ; End context-sensitive hotkeys

; =================================================================================
; Script Toggle and UI (This is always active)
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
