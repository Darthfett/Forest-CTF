library Data

    /*
    
    Darthfett's private Data Attachment functions.
    
    Philosophy:
        * Readability and functionality over efficiency.
    
    */

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
        //Attaches data to a handle
        call SaveInteger(hash,HANDLES,GetHandleId(h),data)
    endfunction
    
    function GetData takes handle h returns integer
        //Gets attached data to given handle
        return LoadInteger(hash,HANDLES,GetHandleId(h))
    endfunction
    
    function interface dymet takes integer this returns nothing
    
    private function TriggerAddMethodActionCB takes nothing returns nothing
        //Runs the given non-static method with the data attached to the trigger.
        call dymet(LoadInteger(hash,DYMET,GetHandleId(GetTriggeringTrigger()))).evaluate(LoadInteger(hash,TRIGGERS,GetHandleId(GetTriggeringTrigger())))
    endfunction
    
    function TriggerAddMethodAction takes integer data, trigger t, dymet which returns nothing
        /*
        
        Attaches data to a trigger, and when the trigger is executed, it runs the method with the data.
        Attachment to triggers (instead of events, which is probably impossible) limits attachment to one data set per trigger.
        
        Example Usage (pseudo code):
            trigger t
            Data data
            
            struct Data
                method onTriggerExecute takes nothing returns nothing
                    //Do stuff with 'this'
                endmethod
            endstruct
            
            call TriggerAddMethodAction(data,t,Data.onTriggerExecute)
        
        */
        
        call SaveInteger(hash,TRIGGERS,GetHandleId(t),data)
        call SaveInteger(hash,DYMET,GetHandleId(t),which)
        call TriggerAddAction(t,function TriggerAddMethodActionCB)
    endfunction
    
    private function StartTimerCB takes nothing returns nothing
        //Runs the given non-static method with the data attached to the timer
        call dymet(LoadInteger(hash,DYMET,GetHandleId(GetExpiredTimer()))).evaluate(LoadInteger(hash,TIMERS,GetHandleId(GetExpiredTimer())))
    endfunction
    
    function StartTimer takes integer data, timer t, real timeout, boolean periodic, dymet handlerFunc returns nothing
        /*
        
        Attaches data to a timer, and when the timer ends, it runs the method with the data.
        Attachment to timers via GetHandleId limits attachment to one data set per timer.
        
        Example Usage (pseudo code):
            struct foo
                method bar takes nothing returns nothing
                    call this.destroy()
                endmethod
            endstruct

        call StartTimer(5,CreateTimer(),20,false,foo.bar)
        
        */
        
        call SaveInteger(hash,TIMERS,GetHandleId(t),data)
        call SaveInteger(hash,DYMET,GetHandleId(t),handlerFunc)
        call TimerStart(t,timeout,periodic,function StartTimerCB)
    endfunction
    
    private function ForEachInGroupCB takes nothing returns nothing
        //Runs the given non-static method with the data globally attached to the group
        call tempDymet.evaluate(tempData)
    endfunction
    
    function ForEachInGroup takes integer data, group whichGroup, dymet handlerFunc returns nothing
        /*
        
        Attaches data to a group, and enumerates through the units with the data.
        Attachment to groups is done via a global variable, making this not work recursively.
        Making this work recursively would be a simple fix, but I am lazy.
        
        Example Usage (pseudo code):
            struct foo
                integer execCount = 0
                group someGroup
                method bar takes nothing returns nothing
                    call RemoveUnit(GetEnumUnit())
                    set this.execCount = this.execCount + 1
                endmethod
            endstruct
            
            call ForEachInGroup(this,this.someGroup,foo.bar)
        
        */
        set tempData = data
        set tempDymet = handlerFunc
        call ForGroup(whichGroup,function ForEachInGroupCB)
    endfunction

endlibrary