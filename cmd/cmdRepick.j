library Select initializer Init uses UnitType,AI

    globals
        public unit array lastSelected
    endglobals

    private function Conditions takes nothing returns boolean
        return Start and Repick_isRepicking[GetPlayerId(GetTriggerPlayer())] and UnitType[GetUnitTypeId(GetTriggerUnit())].isHero
    endfunction

    private function Actions takes nothing returns nothing
        local AI p = AI[GetTriggerPlayer()]
        local UnitType u = UnitType[GetUnitTypeId(GetTriggerUnit())]
        local integer i = 0
        if lastSelected[p] != u.model then
            set lastSelected[p] = u.model
            if GetLocalPlayer() == p.whichPlayer then
                call ClearTextMessages()
            endif
            call DisplayTextToPlayer(p.whichPlayer,0,0,u.desc[0])
            call DisplayTextToPlayer(p.whichPlayer,0,0,u.desc[1])
            call DisplayTextToPlayer(p.whichPlayer,0,0,u.desc[2])
            call DisplayTextToPlayer(p.whichPlayer,0,0,RED + "Double click this hero to choose it." + END)
        else
            if GetLocalPlayer() == p.whichPlayer then
                call ClearTextMessages()
            endif
            call p.applyRepickCam(false)
            call p.setHero(u)
            set Repick_isRepicking[p] = false
        endif
        call TriggerSleepAction(0.3) 
//non-MUI is intentional: If the player selects again within .3 seconds, it is fine
        set lastSelected[p] = null
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        local integer i = 0
        loop
            exitwhen i >= 12
            call TriggerRegisterPlayerUnitEvent(t,Player(i),EVENT_PLAYER_UNIT_SELECTED,null)
            set i = i + 1
        endloop
        call TriggerAddCondition(t,Filter(function Conditions))
        call TriggerAddAction(t,function Actions)
    endfunction

endlibrary

library Command initializer Init uses AI

globals
    private constant string cmd = "-repick"
endglobals

private function Conditions takes nothing returns boolean
    return StringCase(GetEventPlayerChatString(),false) == cmd and Start
endfunction

private function Actions takes nothing returns nothing
    local AI this = AI[GetTriggerPlayer()]
    if RP_enabled == false then
        call DisplayTextToPlayer(this.whichPlayer,0,0,RED + "The host has disabled repicking." + END)
        return
    endif
    if GetUnitLevel(this.hero.unit) > Repick_maxLvl then
        call DisplayTextToPlayer(this.whichPlayer,0,0,RED + "You may only repick your hero up to level " + I2S(Repick_maxLvl) + END)
        return
    endif
    if this.hero.isAlive == false then
        call DisplayTextToPlayer(this.whichPlayer,0,0,RED + "Your hero has to be alive in order for you to repick your hero." + END)
        return
    endif
    if this.hero.inCombat then
        call DisplayTextToPlayer(this.whichPlayer,0,0,RED + "You cannot repick while in combat." + END)
        return
    endif
    if Repick_isRepicking[this] then
        call this.setHero(this.hero.whichType)
        set Repick_isRepicking[this] = false
        return
    endif
    set Repick_isRepicking[this] = true
    call FogModifierStart(Repick_area[this])
    call this.applyRepickCam(true)
    call UnitDropItemPoint(this.hero.unit,this.enemyTeam.whichFlag,this.hero.x,this.hero.y)
    call ShowUnit(this.hero.unit,false)
    call DisplayTextToPlayer(this.whichPlayer,0,0,YELLOW + "Click on a unit to see its description.  Double click a unit to pick." + END)
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

library Repick initializer Init

globals
    public integer maxLvl = 6
    public boolean array isRepicking
    public fogmodifier array area
    public unit Warrior
    public unit Rogue
    public unit Hunter
    public unit Paladin
    public unit Mage
    public unit Assassin
endglobals

private function Init takes nothing returns nothing
    local integer i = 0
    set Repick_Warrior=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'E003', 3346.9, 6503.6, 188.309)
    set Repick_Rogue=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'E001', 2645.4, 7273.4, 255.000)
    set Repick_Hunter=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'E005', 2903.8, 7291.3, 240.000)
    set Repick_Paladin=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'E000', 3165.6, 7304.1, 225.000)
    set Repick_Mage=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'E004', 3338.5, 7077.1, 205.000)
    set Repick_Assassin=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'E002', 3348.2, 6799.0, 180.000)
    loop
        exitwhen i >= 12
        if AI(i).isPlaying then
            set area[i] = CreateFogModifierRect(Player(i),FOG_OF_WAR_VISIBLE,gg_rct_Pickunits,true,false)
        endif
        set i = i + 1
    endloop
endfunction

endlibrary