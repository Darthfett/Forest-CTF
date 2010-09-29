library Skip initializer Init uses Game, stringFilter

globals
    private constant string cmd = "-skip"
endglobals

private function Conditions takes nothing returns boolean
    return CommandSetup and (GetTriggerPlayer() == Game.host) and RStrip(StringCase(GetEventPlayerChatString(),false)) == cmd
endfunction

private function Actions takes nothing returns nothing
    call TimerStart(CreateTimer(),0,false,function Game.skip)
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