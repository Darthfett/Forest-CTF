library HandleCounter initializer Init

globals
    private leaderboard handleBoard
endglobals

private function Callback takes nothing returns nothing
        local integer i = 1
        local integer id
        local integer idmax = 0
        local location array P
        loop
                exitwhen i > 100
                set P[i] = Location(0,0)
                set id = GetHandleId(P[i])
                if id>idmax then
                        set idmax =id
                endif
                set i = i + 1
        endloop
        loop
                set i = i - 1
                exitwhen i < 1
                call RemoveLocation(P[i])
                set P[i] = null
        endloop
        call LeaderboardSetItemValue(handleBoard,0,idmax-0x100000-100)
endfunction

private function Actions takes nothing returns nothing
        set handleBoard = CreateLeaderboard()
        call LeaderboardSetLabel(handleBoard, "Handle Counter")
        call PlayerSetLeaderboard(GetLocalPlayer(),handleBoard)
        call LeaderboardDisplay(handleBoard,true)
        call LeaderboardAddItem(handleBoard,"Handles",0,Player(0))
        call LeaderboardSetSizeByItemCount(handleBoard,1)
        call Callback()
        call TimerStart(GetExpiredTimer(),0.2,true,function Callback)
endfunction

//===========================================================================
function Init takes nothing returns nothing
        call TimerStart(CreateTimer(),.01,false,function Actions)
endfunction

endlibrary