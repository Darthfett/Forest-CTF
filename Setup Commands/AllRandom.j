library AR initializer Init uses stringFind

globals
    private constant string cmd = "-ar"
    public boolean enabled = false
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction

private function Actions takes nothing returns nothing
    set AP_enabled = false
    set enabled = true
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Choosing style set to " + END + GREEN + "ar" + END + YELLOW + ", All players will recieve a Random hero." + END)
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