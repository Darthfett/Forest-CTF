library Fragile initializer Init uses stringFind

globals
    private constant string cmd = "-fragile"
    public boolean enabled = false
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction

private function Actions takes nothing returns nothing
    local string switch = "Enabled"
    local string switch2 = ", the flag carrier will be weaker."
    local string colorswitch = GREEN
    if enabled then
        set enabled = false
        set switch = "Disabled"
        set switch2 = ", the flag carrier will have normal hitpoints."
        set colorswitch = DARKGREY
    else
        set enabled = true
    endif
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Fragile mode has been " + END + colorswitch + switch + END + YELLOW + switch2 + END)
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