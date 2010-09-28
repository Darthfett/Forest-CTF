library Rounds initializer Init uses stringFilter,stringFind

globals
    private constant string cmd = "-rounds "
    public integer num = 3
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and ContainsString(StringCase(GetEventPlayerChatString(),false),cmd,false)
endfunction

private function Actions takes nothing returns nothing
    local integer i = FindString(GetEventPlayerChatString(),cmd,false) + StringLength(cmd)
    local integer j = S2I(StripNumeric(SubString(GetEventPlayerChatString(),i,FindFirstOf(GetEventPlayerChatString(),i," ",false)),false))
    if j >= 1 and j <= 8 then
        set num = j
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,YELLOW + "Number of Rounds set to " + END + GREEN + I2S(num) + END + YELLOW + "." + END)
    else
        call DisplayTextToPlayer(GetTriggerPlayer(),0,0,RED + "Invalid Number of Rounds, valid amounts range from 1 to 8." + END)
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