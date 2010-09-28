library Normal initializer Init uses stringFind

globals
    private constant string cmd = "-normal"
    public boolean enabled = true
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction

private function Actions takes nothing returns nothing
    set Power_enabled = false
    set enabled = true
    set RP_maxLvl = 6
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Game mode set to " + END + GREEN + "Normal Mode" + END + YELLOW + "." + END)
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