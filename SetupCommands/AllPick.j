library AP initializer Init uses stringFind

globals
    private constant string cmd = "-ap"
    public boolean enabled = true
endglobals

public function Start takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i >= 12
        if AI(i).isPlaying then
            call FogModifierStart(Repick_area[i])
            call AI(i).applyRepickCam(true)
            set Repick_isRepicking[i] = true
        endif
        set i = i + 1
    endloop
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Click a unit to see its description.  Double click to pick." + END)
endfunction

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction

private function Actions takes nothing returns nothing
    set AR_enabled = false
    set enabled = true
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Choosing style set to " + END + GREEN + "ap" + END + YELLOW + ", All players may Pick their heroes." + END)
endfunction

private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i >= 12
        call TriggerRegisterPlayerChatEvent(t,Player(i),"",false)
        set i = i + 1
    endloop
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
endfunction

endlibrary