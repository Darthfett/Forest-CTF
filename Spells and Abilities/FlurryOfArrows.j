library FlurryOfArrows uses AIDS,Data

private struct Data

    private static integer AID = 'A018'
    private static integer UID = 'E005'
    private static integer BID_SILENCE = 'BNsi'
    private static integer AID_DUMMY = 'A017'
    private static integer UID_DUMMY = 'n005'
    private static string OID_DUMMY = "clusterrockets"
    private static string SFX_PATH = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
    private static string SND_PATH = "Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.wav"
    private static real RADIUS = 200.
    private static Data tempData
    private static unit temp
    
    private method getDamage takes nothing returns real
        return 20. + 10. * .level
    endmethod
    private static group g
    private unit c
    private unit t
    private sound sound
    private unit dummy
    private player player
    private integer level
    
    private method onDestroy takes nothing returns nothing
        call StopSound(.sound,false,true)
    endmethod
    
    private static method create takes unit c, unit t returns Data
        local Data d = Data.allocate()
        set d.c = c
        set d.t = t
        set d.player = GetOwningPlayer(c)
        set d.level = GetUnitAbilityLevel(d.c,Data.AID)
        if d.sound == null then
            set d.sound = CreateSound(Data.SND_PATH,false,true,false,10,10,null)
            call SetSoundVolume(d.sound,127)
        endif
        return d
    endmethod
    
    private static method Callback takes nothing returns boolean
        if IsUnitEnemy(GetFilterUnit(),Data.tempData.player) then
            call UnitDamageTarget(Data.tempData.c,GetFilterUnit(),Data.tempData.getDamage(),false,true,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
        endif
        return false
    endmethod
    
    private static method Conditions takes nothing returns boolean
        set Data.temp = GetAttacker()
        return GetUnitAbilityLevel(Data.temp,Data.AID) > 0 and GetUnitTypeId(Data.temp) == Data.UID and GetUnitAbilityLevel(Data.temp,Data.BID_SILENCE) == 0
    endmethod
    
    private static method Actions takes nothing returns nothing
        local Data d = Data.create(Data.temp,GetTriggerUnit())
        local real cx = GetUnitX(d.c)
        local real cy = GetUnitY(d.c)
        local real tx = GetUnitX(d.t)
        local real ty = GetUnitY(d.t)
        local real dx
        local real dy
        local real castx
        local real casty
        local real ang = 0
        call AttachSoundToUnit(d.sound,d.c)
        call StartSound(d.sound)
        call DestroyEffect(AddSpecialEffect(Data.SFX_PATH,cx,cy))
        loop
            exitwhen ang > 315. * bj_DEGTORAD
            set dx = cx + 8. * Cos(ang)
            set dy = cy + 8. * Sin(ang)
            set castx = tx + 100. * Cos(ang)
            set casty = ty + 100. * Sin(ang)
            set d.dummy = CreateUnit(d.player,Data.UID_DUMMY,dx,dy,ang)
            call SetUnitAbilityLevel(d.dummy,Data.AID_DUMMY,GetUnitAbilityLevel(d.c,Data.AID))
            call UnitApplyTimedLife(d.dummy,'BTLF',2.)
            call IssuePointOrder(d.dummy,Data.OID_DUMMY,castx,casty)
            set ang = ang + 45. * bj_DEGTORAD
        endloop
        set Data.tempData = d
        call GroupEnumUnitsInRange(Data.g,tx,ty,Data.RADIUS,Filter(function Data.Callback))
        call d.destroy()
    endmethod
    
    private static method onInit takes nothing returns nothing
        local trigger t = CreateTrigger()
        set Data.g = CreateGroup()
        call TriggerRegisterAnyUnitEventBJ(t,EVENT_PLAYER_UNIT_ATTACKED)
        call TriggerAddCondition(t,Condition(function Data.Conditions))
        call TriggerAddAction(t,function Data.Actions)
    endmethod

endstruct
endlibrary