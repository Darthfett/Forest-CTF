library AI uses Game,Team,stringPlayer

globals
    private AI tempAI
endglobals

struct AI

    implement Orders

    //Definition
    player whichPlayer           //The AI-Player co-person
    boolean isPlaying = false    //False if not player controlled
    boolean isEnabled = false    //True if AI controlled
    boolean isEmpty = true       //False if controlled by anything
    
    boolean localThis            //true for GetLocalPlayer() == whichPlayer
    
    //SuperStructs
    Team team                    //This player's Flag/Team Data
    Team enemyTeam               //Enemy Team's Flag/Team Data
    
    //AI Player/System Data
    
    //AI Bot Data
    Unit hero                    //Hero controlled by the AI
    
    //Camera
    boolean repickCameraApplied
    static camerasetup repickCamera

    integer objective            //Current objective of the bot
    integer priority             //Priority of the objective
    //boolean sideok
    group units                  //Units that are currently controlled
    boolean hasFlag              //Is Carrying the enemy flag
    Waypoint tarRect                 //RR rect current waypoint heading
    Waypoint curRect                 //RR rect last waypoint entered
    real tarX                    //Center of tarRect (for ordering purposes)
    real tarY                    //Center of tarRect (for ordering purposes)
    real curX                    //Center of curRect (for ordering purposes)
    real curY                    //Center of curRect (for ordering purposes)
    
    
    //Player Data
    integer caps                 //Total number of times capped the flag
    integer kills                //Total number of kills
    integer deaths               //Total number of deaths
    
    private method applyRepickCamCallback takes nothing returns nothing
        if this.repickCameraApplied == false then
            call PauseTimer(GetExpiredTimer())
            call DestroyTimer(GetExpiredTimer())
            return
        endif
        if this.localThis then
            call CameraSetupApplyForceDuration(AI.repickCamera,true,0)
        endif
    endmethod
    
    method applyRepickCam takes boolean apply returns nothing
        set this.repickCameraApplied = apply
        call StartTimer(this,CreateTimer(),0.05,true,AI.applyRepickCamCallback)
    endmethod            
    
    method reset takes nothing returns nothing
        if not this.isEmpty then
            set this.hero.x = this.team.reviveX
            set this.hero.y = this.team.reviveY
            call UnitResetCooldown(this.hero.unit)
            set this.hero.life = this.hero.maxLife
            set this.hero.mana = this.hero.maxMana
            if this.localThis then
                call PanCameraTo(this.team.reviveX,this.team.reviveY)
                call SelectUnit(this.hero.unit,true)
            endif
        endif
    endmethod

    method setHero takes UnitType whichType returns nothing
        local integer j = 0
        local Unit u
        local Unit uo = this.hero
        local real x
        local real y
        local group g = CreateGroup()
        local unit fog
        local string str
        call GroupEnumUnitsOfPlayer(g,this.whichPlayer,null)
        call GroupRemoveUnit(this.units,uo.unit)
        call GroupRemoveUnit(this.team.whichHeroes,uo.unit)
        if whichType != this.hero.whichType then
            if uo != 0 then 
                set x = uo.x
                set y = uo.y
            else
                set x = this.team.reviveX
                set y = this.team.reviveY
            endif
            set fog = CreateUnit(this.whichPlayer,whichType.whichType,x,y,0)
            set u = Unit[fog]
            set this.hero = u
            if uo != 0 then //As long as the old unit exists..
                set str = " has changed heroes to the "
                call SetHeroXP(u.unit,GetHeroXP(uo.unit),false)
                set u.mana = u.mana * 0.01 * (u.mana / u.maxMana * 100)
                set u.life = u.life * 0.01 * (u.life / u.maxLife * 100)
                loop
                    exitwhen j >= 6
                    call UnitAddItem(u.unit,UnitItemInSlot(uo.unit,j))
                    set j = j + 1
                endloop
                loop
                    set fog = FirstOfGroup(g)
                    exitwhen fog == null
                    if fog != u.unit and GetUnitTypeId(fog) != 'n002' then
                        call GroupRemoveUnit(g,fog)
                        call RemoveUnit(fog)
                    endif
                endloop
            else
                if not AP_enabled then
                    set str = " got the "
                else
                    set str = " has chosen the "
                endif
                if Power_enabled then
                    call SetHeroLevel(u.unit,5,false)
                endif
            endif
        else
            set str = " has decided to stick with the "
            call ShowUnit(uo.unit,true)
            set x = uo.x
            set y = uo.y
            set u = uo
        endif
        call FogModifierStop(Repick_area[this])
        if (GetLocalPlayer() == this.whichPlayer) then
            call ResetToGameCamera(0)
            call PanCameraToTimed(x,y,0)
            call ClearSelection()
            call SelectUnit(u.unit,true)
        endif
        if IsPlayerInForce(GetLocalPlayer(),this.team.whichPlayers) then
            call DisplayTextToPlayer(GetLocalPlayer(),0,0,I2CN(this) + YELLOW + str + END + RED + whichType.desc[0] + END)
        endif
        set this.hero = u
        call TriggerRegisterUnitInRange(this.hero.enterRangeTrig,this.hero.unit,1500,null)
        set tempAI = this
        call GroupAddUnit(this.units,u.unit)
        call GroupAddUnit(this.team.whichHeroes,u.unit)
        call DestroyGroup(g)
        set g = null
    endmethod

    static method operator[] takes player p returns AI
        return AI(GetPlayerId(p))
    endmethod
    
    private static method removeUnits takes nothing returns nothing
        call RemoveUnit(GetEnumUnit())
    endmethod

    static method onLeaveActions takes nothing returns nothing
        local AI this = AI[GetTriggerPlayer()]
        set this.isPlaying = false
        if Balance_enabled then
            set this.isEnabled = true
        else
            set this.isEmpty = true
            if this.hero.hasFlag then
                call Flag(this.team).reset()
                call SetItemPosition(this.enemyTeam.whichFlag,this.hero.x,this.hero.y)
            endif
            call ForGroup(this.units,function AI.removeUnits)
        endif
    endmethod
    
    static method setup takes player p, Team whichTeam returns AI
        local AI ai = AI(GetPlayerId(p))
        
        set ai.team = whichTeam
        set ai.enemyTeam = whichTeam.enemyTeam
        set ai.whichPlayer = p
        set ai.hero = 0 
        
        if GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING then
            set ai.isPlaying = true
            set ai.isEnabled = false
            set ai.isEmpty = false
            call ForceAddPlayer(ai.team.whichPlayers,p)
            set ai.team.playerCount = ai.team.playerCount + 1
        elseif GetPlayerController(p) == MAP_CONTROL_COMPUTER then
            set ai.isPlaying = false
            set ai.isEnabled = true
            set ai.isEmpty = false
            call ForceAddPlayer(ai.team.whichPlayers,p)
            set ai.team.playerCount = ai.team.playerCount + 1
        else
            set ai.isPlaying = false
            set ai.isEnabled = false
            set ai.isEmpty = true
        endif
        if GetLocalPlayer() == ai.whichPlayer then
            set ai.localThis = true
        else
            set ai.localThis = false
        endif
        
        set ai.objective = 0
        set ai.priority = 0
        set ai.units = CreateGroup()
        set ai.hasFlag = false
        
        set ai.caps = 0
        set ai.kills = 0
        set ai.deaths = 0
        
        
        return ai
    endmethod
    
    static method init takes nothing returns nothing
        local integer i = 0
        
        local trigger t = CreateTrigger()
        loop
            exitwhen i >= 12
            call TriggerRegisterPlayerEvent(t,Player(i),EVENT_PLAYER_LEAVE)
            set i = i + 1
        endloop
        call TriggerAddAction(t,function AI.onLeaveActions)
        
        set i = 0
        loop
            exitwhen i >= 12
            call AI.setup(Player(i),Team((i+2) - ((i+2) / 2) * 2)) //Creating AI array
    //Add 2, 2 (Player 0 + 2) Mod 2 puts Player 1 in Team 0, 3 mod 2 puts player 2 in Team 1, and so forth.
            set i = i + 1
        endloop
        set AI.repickCamera = gg_cam_Pick
        loop
            exitwhen i >= 15
            set AI(i).whichPlayer = Player(i)
            set i = i + 1
        endloop
    endmethod
endstruct

endlibrary