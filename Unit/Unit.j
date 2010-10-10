library Unit uses Game,Team,AI,UnitType,Data,FlagManip,Detection,Combat,Damage,Death,Level

struct Unit extends array
    //! runtextmacro AIDS()
    
    implement Movement
    implement FlagManip
    implement Detection
    implement Combat
    implement Damage
    implement Death
    implement Level
    
    static Unit tempUnit
    
    UnitType whichType
    AI owner
    
    private boolean Invulnerable
    private boolean Paused
    private boolean HasFlag
    
    method operator < takes Unit compare returns boolean
        /*
        
        Used for the AI, in calculating whether a Unit is "probably" going to win in a fight.
        
        */
        
        return ((this.life / this.maxLife) + 5) * 2 + ((this.mana / this.maxMana) + 5) * 0.5 < ((compare.life / compare.maxLife) + 5) * 2 + ((compare.mana / compare.maxMana) + 5) * 0.5
    endmethod
    
    method operator name takes nothing returns string
        //Gets the Unit's name
        return GetUnitName(this.unit)
    endmethod
    
    method operator x takes nothing returns real
        //Gets the Unit's x-position
        return GetUnitX(this.unit)
    endmethod
    
    method operator x= takes real x returns nothing
        //Sets the Unit's x-position
        call SetUnitX(this.unit,x)
    endmethod
    
    method operator y takes nothing returns real
        //Gets the Unit's y-position
        return GetUnitY(this.unit)
    endmethod
    
    method operator y= takes real y returns nothing
        //Sets the Unit's y-position
        call SetUnitY(this.unit,y)
    endmethod
    
    method operator maxMana takes nothing returns real
        //Gets the Unit's max Mana
        return GetUnitState(this.unit,UNIT_STATE_MAX_MANA)
    endmethod
    
    method operator mana takes nothing returns real
        //Gets the Unit's current Mana
        return GetUnitState(this.unit,UNIT_STATE_MANA)
    endmethod
    
    method operator manaPercent takes nothing returns real
        //Gets the Unit's % Mana
        return this.mana / this.maxMana
    endmethod
    
    method operator maxLife takes nothing returns real
        //Gets the Unit's max Life
        return GetUnitState(this.unit,UNIT_STATE_MAX_LIFE)
    endmethod
    
    method operator life takes nothing returns real
        //Gets the Unit's current Life
        return GetWidgetLife(this.unit)
    endmethod
    
    method operator lifePercent takes nothing returns real
        //Gets the Unit's % Life
        return this.life / this.maxLife
    endmethod
    
    method operator mana= takes real mana returns nothing
        //Sets the Unit's Mana
        call SetUnitState(this.unit,UNIT_STATE_MANA,mana)
    endmethod
    
    method operator life= takes real life returns nothing
        //Sets the Unit's Life
        call SetWidgetLife(this.unit,life)
    endmethod
    
    method operator invulnerable= takes boolean flag returns nothing
        //Sets the Unit (Un)invulnerable
        set this.Invulnerable = flag
        call SetUnitInvulnerable(this.unit,flag)
    endmethod
    
    method operator invulnerable takes nothing returns boolean
        //Returns whether the Unit is invulnerable
        return this.Invulnerable
    endmethod
    
    method operator paused= takes boolean flag returns nothing
        //Sets the Unit (not) paused
        set this.Paused = flag
        call PauseUnit(this.unit,flag)
    endmethod
    
    method operator paused takes nothing returns boolean
        //Returns whether the Unit is paused
        return this.Paused
    endmethod
    
    method operator facing takes nothing returns real
        //Gets the Unit's facing (in Radians)
        return GetUnitFacing(this.unit)
    endmethod
    
    method operator facing= takes real facing returns nothing
        //Sets the Unit's facing
        call SetUnitFacing(this.unit,facing)
    endmethod
    
//====================================================================
    
    method AIDS_onDestroy takes nothing returns nothing
        /*
        
        Cleans up the Unit's data when it is removed
        
        */
        
        call this.friendly.destroy()
        call this.threats.destroy()
        call DestroyTrigger(this.enterRangeTrig)
        call PauseTimer(this.enterRangeTimer)
        call DestroyTimer(this.enterRangeTimer)
        call DestroyTrigger(this.takeDamageTrig)
        call DestroyTrigger(this.castSpellTrig)
        call PauseTimer(this.combatTimer)
        call DestroyTimer(this.combatTimer)
        
        set this.enterRangeTrig = null
        set this.enterRangeTimer = null
        
        set this.takeDamageTrig = null
        set this.castSpellTrig = null
        set this.combatTimer = null
    endmethod        
        
    method AIDS_onCreate takes nothing returns nothing
        /*
        
        Sets up the Unit's data when it is created
        
        */
        
        set this.whichType = UnitType[GetUnitTypeId(this.unit)]
        set this.owner = AI[GetOwningPlayer(this.unit)]
        
        set this.friendly = Group.create() //Nearby friendly units
        set this.threats = Group.create() //Nearby enemy units
        
        set this.enterRangeTrig = CreateTrigger()
        set this.enterRangeTimer = CreateTimer()
        call TriggerRegisterUnitInRange(this.enterRangeTrig,this.unit,Unit.ENTER_RANGE_MIN_DISTANCE,null)
        call TriggerAddMethodAction(this,this.enterRangeTrig,Unit.enterRange)

        set this.castSpellTrig = CreateTrigger()
        set this.combatTimer = CreateTimer()
        call TriggerRegisterUnitEvent(this.takeDamageTrig,this.unit,EVENT_UNIT_DAMAGED)
        call TriggerAddMethodAction(this,this.takeDamageTrig,Unit.takeDamageActions)
        
        call TriggerRegisterUnitEvent(this.castSpellTrig,this.unit,EVENT_UNIT_SPELL_EFFECT)
        call TriggerAddMethodAction(this,this.castSpellTrig,Unit.onCastActions)
        set this.inCombat = false
        
        set this.isAlive = true
        set this.Invulnerable = false
        set this.Paused = false
        
        set this.HasFlag = false
        
        if this.whichType.isHero then
            //Heroes have a few extra capabilities
            set this.level = 0
            call this.gainLevelActions()
            set this.gainLevelTrig = CreateTrigger()
            call TriggerRegisterUnitEvent(this.gainLevelTrig,this.unit,EVENT_UNIT_HERO_LEVEL)
            call TriggerAddMethodAction(this,this.gainLevelTrig,Unit.gainLevelActions)
            
            set this.pickupFlagTrig = CreateTrigger()
            call TriggerRegisterUnitEvent(this.pickupFlagTrig,this.unit,EVENT_UNIT_PICKUP_ITEM)
            call TriggerAddCondition(this.pickupFlagTrig,Condition(function Unit.flagConditions))
            call TriggerAddMethodAction(this,this.pickupFlagTrig,Unit.pickupFlagActions)
            
            set this.dropFlagTrig = CreateTrigger()
            call TriggerRegisterUnitEvent(this.dropFlagTrig,this.unit,EVENT_UNIT_DROP_ITEM)
            call TriggerAddCondition(this.dropFlagTrig,Condition(function Unit.flagConditions))
            call TriggerAddMethodAction(this,this.dropFlagTrig,Unit.dropFlagActions)
            
            if this.owner.hero == 0 then
                //TODO: Figure out if this comparison makes sense
                set this.reviveTimer = CreateTimer()
                set this.reviveDialog = CreateTimerDialog(this.reviveTimer)
                call TimerDialogSetTitle(this.reviveDialog,P2CN(this.owner.whichPlayer) + " in:")
            endif
        endif
    endmethod
    
endstruct

endlibrary