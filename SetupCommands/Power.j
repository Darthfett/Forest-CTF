library Power initializer Init uses stringFind

globals
    private constant string cmd = "-power"
    public boolean enabled = false
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction

private function Actions takes nothing returns nothing
    set Normal_enabled = false
    set enabled = true
    set RP_maxLvl = 10
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Game mode set to " + END + DARKTEAL + "Power Mode" + END + YELLOW + ", All players will start out at level 5, and with 50 gold." + END)
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