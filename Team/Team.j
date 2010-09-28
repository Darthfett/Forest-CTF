library Team uses Game,UnitType

struct Team
    item whichFlag
    Team enemyTeam
    integer teamNumber
    
    Unit carrier
    boolean isInBase
    real x
    real y
    real startX
    real startY
    real capX
    real capY
    region capRegion
    
    string teamName
    string teamNameColored
    
    real reviveX
    real reviveY
    
    integer score = 0
    
    force whichPlayers
    group whichHeroes
    integer playerCount
    
//====================================================================
//====================================================================
    
    static method balance takes nothing returns nothing
        local integer i = 0
        local AI ai
        loop
            set ai = AI(i)
            exitwhen ai.team.playerCount == ai.enemyTeam.playerCount
            if ai.isEmpty and ai.team.playerCount < ai.enemyTeam.playerCount then
                call ForceAddPlayer(ai.team.whichPlayers,ai.whichPlayer)
                call ForceAddPlayer(bj_FORCE_ALL_PLAYERS,ai.whichPlayer)
                set ai.team.playerCount = ai.team.playerCount + 1
                set ai.isEmpty = false
                set ai.isEnabled = true
                call ai.setHero.evaluate(UnitType.getRandomHero())
            endif
            set i = i + 1
        endloop
    endmethod
    
    method capture takes nothing returns nothing
        set this.score = this.score + 1
    endmethod
    
    stub method toString takes nothing returns string
        if this == Team(0) then
            return "Team NW"
        else
            return "Team SE"
        endif
    endmethod
    
//====================================================================
//====================================================================
//====================================================================
    
    static method init takes nothing returns nothing
        set Team(0).enemyTeam = Team(1)
        set Team(1).enemyTeam = Team(0)
        
        set Team(0).teamNumber = 0        
        set Team(0).startX = GetRectCenterX(gg_rct_NW_Flag)
        set Team(0).startY = GetRectCenterY(gg_rct_NW_Flag)
        set Team(0).x = GetRectCenterX(gg_rct_NW_Flag)
        set Team(0).y = GetRectCenterY(gg_rct_NW_Flag)
        set Team(0).capX = GetRectCenterX(gg_rct_SE_Flag)
        set Team(0).capY = GetRectCenterX(gg_rct_SE_Flag)
        set Team(0).isInBase = true
        set Team(0).whichFlag = CreateItem('I001',Team(0).startX,Team(0).startY)
        set Team(0).teamName = "Team 1"
        set Team(0).teamNameColored = RED + Team(0).teamName + END
        set Team(0).reviveX = GetRectCenterX(gg_rct_Spawn_N_Revive_1)
        set Team(0).reviveY = GetRectCenterY(gg_rct_Spawn_N_Revive_1)
        set Team(0).whichPlayers = CreateForce()
        set Team(0).whichHeroes = CreateGroup()
        set Team(0).playerCount = 0
        set Team(0).capRegion = CreateRegion()
        call RegionAddRect(Team(0).capRegion,gg_rct_NW_Flag)

        set Team(1).teamNumber = 1
        set Team(1).startX = GetRectCenterX(gg_rct_SE_Flag)
        set Team(1).startY = GetRectCenterY(gg_rct_SE_Flag)
        set Team(1).x = GetRectCenterX(gg_rct_SE_Flag)
        set Team(1).y = GetRectCenterY(gg_rct_SE_Flag)
        set Team(1).capX = GetRectCenterX(gg_rct_NW_Flag)
        set Team(1).capY = GetRectCenterY(gg_rct_NW_Flag)
        set Team(1).isInBase = true
        set Team(1).whichFlag = CreateItem('I000',Team(1).startX,Team(1).startY)
        set Team(1).teamName = "Team 2"
        set Team(1).teamNameColored = BLUE + Team(1).teamName + END
        set Team(1).reviveX = GetRectCenterX(gg_rct_Spawn_N_Revive_2)
        set Team(1).reviveY = GetRectCenterY(gg_rct_Spawn_N_Revive_2)
        set Team(1).whichPlayers = CreateForce()
        set Team(1).whichHeroes = CreateGroup()
        set Team(1).playerCount = 0
        set Team(1).capRegion = CreateRegion()
        call RegionAddRect(Team(1).capRegion,gg_rct_SE_Flag)
    endmethod

endstruct

struct Flag extends Team

    Flag enemyFlag
    
    static method operator [] takes item i returns Flag
        if Flag(0).whichFlag == i then
            return Team(0)
        endif
        return Flag(1)
    endmethod
    
    method reset takes nothing returns nothing
        call SetItemPosition(this.whichFlag,this.startX,this.startY)
        set this.x = this.startX
        set this.y = this.startY
        set this.carrier = 0
        set this.isInBase = true
    endmethod
    
    static method ping takes nothing returns nothing
        local Flag this = Flag(0)
        if Start then
            if this.carrier != null then
                call PingMinimapEx(this.carrier.x,this.carrier.y,3,254,0,0,false)
            else
                call PingMinimapEx(this.x,this.y,3,254,0,0,false)
            endif
            if this.enemyTeam.carrier != null then
                call PingMinimapEx(this.enemyTeam.carrier.x,this.enemyTeam.carrier.y,3,0,0,255,false)
            else
                call PingMinimapEx(this.enemyTeam.x,this.enemyTeam.y,3,0,0,255,false)
            endif
        endif
    endmethod
    
    method toString takes nothing returns string
        if this == Flag(0) then
            return "Flag NW"
        else
            return "Flag SE"
        endif
    endmethod
    
    static method onInit takes nothing returns nothing
        set Flag(0).enemyFlag = Flag(1)
        set Flag(1).enemyFlag = Flag(0)
        call TimerStart(CreateTimer(),10,true,function Flag.ping)
    endmethod
        
endstruct

endlibrary