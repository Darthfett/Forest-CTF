library FlagManip

module FlagManip

    static trigger enterCapRegionTrig

    trigger pickupFlagTrig
    trigger dropFlagTrig
    //private static sound SND_FLAG_PICKUP_BAD = CreateSound("Sound//Interface//Warning.wav",false,false,false,10,10,"")
    //private static sound SND_FLAG_PICKUP_GOOD = CreateSound("Sound//Interface//Hint.wav",false,false,false,10,10,"")
    //private static sound SND_FLAG_RETURN = CreateSound("Sound//Interface//GoodJob.wav",false,false,false,10,10,"")
    //private static sound SND_FLAG_CAP = CreateSound("Sound//Interface//GameFound.wav",false,false,false,10,10,"")
    
    method onEnterFlagRange takes Flag which returns nothing
        call IssuePointOrder(this.unit,"attack",which.x,which.y)
    endmethod
    
    method operator hasFlag= takes boolean hasFlag returns nothing
        set this.HasFlag = hasFlag
        call SetPlayerAbilityAvailable(this.owner.whichPlayer,'A00O',not hasFlag)
        call SetPlayerAbilityAvailable(this.owner.whichPlayer,'A00H',not hasFlag)
        call SetPlayerAbilityAvailable(this.owner.whichPlayer,'A00J',not hasFlag)
        call SetPlayerAbilityAvailable(this.owner.whichPlayer,'A00A',not hasFlag)
        set this.owner.team.enemyTeam.isInBase = not hasFlag
        if hasFlag then
            call SetUnitMoveSpeed(this.unit,200.)
            set this.owner.team.enemyTeam.carrier = this
            call UnitRemoveAbility(this.unit,'BOwk')
            call UnitRemoveAbility(this.unit,'BHds')
            call UnitRemoveAbility(this.unit,'Bvul')
            if Fragile_enabled then
                call SetPlayerHandicap(this.owner.whichPlayer,0.70)
            endif
        else
            call SetUnitMoveSpeed(this.unit,270.)
            set this.owner.team.enemyTeam.carrier = 0
            if Fragile_enabled then
                call SetPlayerHandicap(this.owner.whichPlayer,1)
            endif
        endif
    endmethod
    
    method operator hasFlag takes nothing returns boolean
        return this.HasFlag
    endmethod
    
    method checkCapture takes nothing returns nothing
        local integer i = 0
        if this.hasFlag == false then
            return
        endif
        if IsUnitIllusion(this.unit) == true then
            return
        endif
        if this.owner.team.isInBase == false then
            call DisplayTextToPlayer(this.owner.whichPlayer,0,0,RED + "You must have the flag in your base in order to score!" + END)
            return
        endif
        //call SetSoundVolume(Unit.SND_FLAG_CAP,127)
        //call StartSound(Unit.SND_FLAG_CAP)
        call Game.finishRound(this.owner.team)
    endmethod
    
    static method enterCapRegionActions takes nothing returns nothing
        local Unit this = Unit[GetTriggerUnit()]
        if GetTriggeringRegion() != this.owner.team.capRegion then
            return
        endif
        call TriggerSleepAction(0)
        call this.checkCapture()
    endmethod
    
    static method flagConditions takes nothing returns boolean
        return (GetManipulatedItem() == Team(0).whichFlag or GetManipulatedItem() == Team(1).whichFlag) and IsUnitIllusion(GetTriggerUnit()) == false
    endmethod
    
    method pickupFlagActions takes nothing returns nothing
        local Flag flag = Flag[GetManipulatedItem()]
        
        if this.owner.team == flag then
            call DisableTrigger(this.dropFlagTrig)
            call SetItemPosition(flag.whichFlag,flag.startX,flag.startY)
            call EnableTrigger(this.dropFlagTrig)
            if flag.isInBase then
                call DisplayTextToPlayer(this.owner.whichPlayer,0,0,RED + "You cannot pick up your own teams flag!" + END)
            else
                call DisplayTextToPlayer(GetLocalPlayer(),0,0,P2CN(this.owner.whichPlayer) + YELLOW + " has returned the flag to " + END + flag.teamNameColored + YELLOW + "'s base." + END)
                set flag.isInBase = true
                call this.checkCapture()
                //call SetSoundVolume(Unit.SND_FLAG_RETURN,127)
                //call StartSound(Unit.SND_FLAG_RETURN)
            endif
        else
            if IsPlayerInForce(GetLocalPlayer(),flag.whichPlayers) then
                ////call SetSoundVolume(Unit.SND_FLAG_PICKUP_BAD,127)
                //call StartSound(Unit.SND_FLAG_PICKUP_BAD)
                call DisplayTextToPlayer(GetLocalPlayer(),0,0,P2CN(this.owner.whichPlayer) + YELLOW + " has taken your flag!!" + END)
            else
                //call SetSoundVolume(Unit.SND_FLAG_PICKUP_GOOD,127)
                //call StartSound(Unit.SND_FLAG_PICKUP_GOOD)
                call DisplayTextToPlayer(GetLocalPlayer(),0,0,P2CN(this.owner.whichPlayer) + YELLOW + " has taken the enemy flag!!" + END)
            endif
            set this.hasFlag = true
        endif
    endmethod
        
    method dropFlagActions takes nothing returns nothing
        set this.owner.enemyTeam.carrier = 0
        call TriggerSleepAction(0)
        set this.owner.enemyTeam.x = GetItemX(this.owner.enemyTeam.whichFlag)
        set this.owner.enemyTeam.y = GetItemY(this.owner.enemyTeam.whichFlag)
        if IsPlayerInForce(GetLocalPlayer(),this.owner.enemyTeam.whichPlayers) then
            call DisplayTextToPlayer(GetLocalPlayer(),0,0,P2CN(this.owner.whichPlayer) + YELLOW + " has dropped your team's flag!!" + END)
        else
            call DisplayTextToPlayer(GetLocalPlayer(),0,0,P2CN(this.owner.whichPlayer) + YELLOW + " has dropped the enemy team's flag!!" + END)
        endif
        call PingMinimapEx(this.owner.enemyTeam.x,this.owner.enemyTeam.y,5,255,0,0,true)
    endmethod
    
    private static method onInit takes nothing returns nothing
        set Unit.enterCapRegionTrig = CreateTrigger()
        call TriggerRegisterEnterRegion(Unit.enterCapRegionTrig,Team(0).capRegion,null)
        call TriggerRegisterEnterRegion(Unit.enterCapRegionTrig,Team(1).capRegion,null)
        call TriggerAddAction(Unit.enterCapRegionTrig,function Unit.enterCapRegionActions)
    endmethod

endmodule

endlibrary