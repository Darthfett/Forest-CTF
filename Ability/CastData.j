library CastData
    
    struct Target
        Unit unit
        real x
        real y
        
        static method UnitCreate takes Unit target returns Target
            local Target this = Target.allocate()
            set this.unit = target
            set this.x = target.x
            set this.y = target.y
            return this
        endmethod
        
        static method PointCreate takes real x, real y returns Target
            local Target this = Target.allocate()
            set this.x = x
            set this.y = y
            return this
        endmethod
        
    endstruct
    
    globals
        key TARGET_TYPE_UNIT
        key TARGET_TYPE_POINT
        key TARGET_TYPE_NONE
    endglobals

    struct CastData
        Unit caster
        integer targetType //Use TARGET keys
        Ability whichAbility
        Target target
        
        static method PointCreate takes Unit caster, real x, real y, Ability whichAbility returns CastData
            local CastData this = CastData.allocate()
            set this.caster = caster
            set this.target = Target.PointCreate(x,y)
            set this.whichAbility = whichAbility
            set this.targetType = TARGET_TYPE_POINT
            return this
        endmethod
        
        static method UnitCreate takes Unit caster, Unit target, Ability whichAbility returns CastData
            local CastData this = CastData.allocate()
            set this.caster = caster
            set this.target = Target.UnitCreate(target)
            set this.whichAbility = whichAbility
            set this.targetType = TARGET_TYPE_UNIT
            return this
        endmethod
    
        method toString takes nothing returns string
            if this.targetType == TARGET_TYPE_UNIT then
                return this.whichAbility.toString() + " on " + this.target.unit.name
            elseif this.targetType == TARGET_TYPE_POINT then
                return this.whichAbility.toString() + " at " + R2S(this.target.x) + "," + R2S(this.target.y)
            elseif this.targetType == TARGET_TYPE_NONE then
                return this.whichAbility.toString() + " (no target) at " + R2S(this.caster.x) + "," + R2S(this.caster.y)
            endif
            return this.whichAbility.toString() + " (Invalid Target)"
        endmethod
        
    endstruct
    
endlibrary