library Balance initializer Init uses stringFind

globals
    private constant string cmd = "-balance"
    public boolean enabled = true
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction        

private function Actions takes nothing returns nothing
    if enabled then
        set enabled = false
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Balance has been " + END + DARKGREY + "disabled" + END + YELLOW + ", leaving players will not be replaced by a bot." + END)
    else
        set enabled = true
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Balance has been " + END + GREEN + "enabled" + END + YELLOW + ", leaving players will be replaced by a bot." + END)
    endif
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