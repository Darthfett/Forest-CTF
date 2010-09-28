library RP initializer Init uses stringFind

globals
    private constant string cmd = "-repick"
    public boolean enabled = true
    public integer maxLvl = 6
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction

private function Actions takes nothing returns nothing
   if enabled then
        set enabled = false
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Repick has been " + END + DARKGREY + "disabled" + END + YELLOW + ", players will not be able to repick their heroes." + END)
    else
        set enabled = true
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Repick has been " + END + GREEN + "enabled" + END + YELLOW + ", players will be able to repick their heroes up to level 5." + END)
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