library Data

    globals        
        private hashtable hash
        private integer tempData
        private dymet tempDymet
        private key TIMERS
        private key TRIGGERS
        private key HANDLES
        private key DYMET
    endglobals
    
    private struct DATA
        private static method onInit takes nothing returns nothing
            set hash = InitHashtable() //In an empty struct for auto-initialization
        endmethod
    endstruct
    
    function SetData takes handle h, integer data returns nothing
        call SaveInteger(hash,HANDLES,GetHandleId(h),data)
    endfunction
    
    function GetData takes handle h returns integer
        return LoadInteger(hash,HANDLES,GetHandleId(h))
    endfunction
    
    function interface dymet takes integer this returns nothing
    
    //function implementsStruct takes Struct this returns nothing
    //call this.destroy()
    
    //call TriggerAddMethodAction(Struct(4),CreateTrigger(),dymet.implementsStruct)
    
    private function TriggerAddMethodActionCB takes nothing returns nothing
        call dymet(LoadInteger(hash,DYMET,GetHandleId(GetTriggeringTrigger()))).evaluate(LoadInteger(hash,TRIGGERS,GetHandleId(GetTriggeringTrigger())))
    endfunction
    
    function TriggerAddMethodAction takes integer data, trigger t, dymet which returns nothing
        //Limited to one per trig
        call SaveInteger(hash,TRIGGERS,GetHandleId(t),data)
        call SaveInteger(hash,DYMET,GetHandleId(t),which)
        call TriggerAddAction(t,function TriggerAddMethodActionCB)
    endfunction
    
    //struct Unit
    ////! runtextmacro AIDS()
    //method onDeath takes nothing returns nothing
    //  call RemoveUnit(this.unit)
    
    //call TriggerAddMethodAction(Unit[someUnit],CreateTrigger(),Unit.onDeath)
    
    private function StartTimerCB takes nothing returns nothing
        call dymet(LoadInteger(hash,DYMET,GetHandleId(GetExpiredTimer()))).evaluate(LoadInteger(hash,TIMERS,GetHandleId(GetExpiredTimer())))
    endfunction
    
    function StartTimer takes integer data, timer t, real timeout, boolean periodic, dymet handlerFunc returns nothing
        call SaveInteger(hash,TIMERS,GetHandleId(t),data)
        call SaveInteger(hash,DYMET,GetHandleId(t),handlerFunc)
        call TimerStart(t,timeout,periodic,function StartTimerCB)
    endfunction
    
    //struct Test
    //method something takes nothing returns nothing
        //call this.destroy()
    //endmethod
    
    //call StartTimer(5,CreateTimer(),20,false,Test.somethin
    
    private function ForEachInGroupCB takes nothing returns nothing
        call tempDymet.evaluate(tempData)
    endfunction
    
    function ForEachInGroup takes integer data, group whichGroup, dymet handlerFunc returns nothing
        set tempData = data
        set tempDymet = handlerFunc
        call ForGroup(whichGroup,function ForEachInGroupCB)
    endfunction
    
    //struct Data
    //method something takes nothing returns nothing
        //call SetUnitAbilityLevel(GetEnumUnit(),this.abilcode,this.level)
    //endmethod
    
    //call ForEachInGroup(this,this.someGroup,Data.something)

endlibrary