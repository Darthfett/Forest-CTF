library EnvMethods

    module EnvMethods
        /*
        
        These methods are run whenever a Unit does something.  Specifically, this is used for when bot-controlled
        Units might need to determine a new course of action.
        
        */
        
        static stub method onEnterFlagRange takes Unit this, Flag which returns nothing
            call BJDebugMsg(this.name + " came in range of " + which.toString())
            call this.onEnterFlagRange(which)
        endmethod
    
        static stub method onDetect takes Unit this, Unit detected returns nothing
            call BJDebugMsg(this.name + " detected " + detected.name)
            call this.attack(detected)
        endmethod
        
        static stub method onDamage takes Unit this, Unit damager returns nothing
            call BJDebugMsg(damager.name + " damaged " + this.name)
            call this.attack(damager)
        endmethod
        
        static stub method onCast takes Unit this, Unit caster, CastData data returns nothing
            call BJDebugMsg(caster.name + " cast " + data.toString() + " near " + this.name)
        endmethod
        
        static stub method onLoseSight takes Unit this, Unit leaver, string reason returns nothing
            call BJDebugMsg(this.name + " onLoseSight " + leaver.name + " - " + reason)
        endmethod
        
        static stub method onRevive takes Unit this, string reason returns nothing
            call BJDebugMsg(this.name + " revive - " + reason)
        endmethod
        
        static stub method onFlagPickup takes Unit this, Unit carrier, Flag whichFlag returns nothing
            call BJDebugMsg(carrier.name + " picked up flag " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onFlagDrop takes Unit this, Unit carrier, Flag whichFlag returns nothing
            call BJDebugMsg(carrier.name + " dropped flag " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onFlagPass takes Unit this, Unit preCarrier, Unit postCarrier, Flag whichFlag returns nothing
            call BJDebugMsg(preCarrier.name + " passed " + whichFlag.toString() + " to " + postCarrier.name + " near " + this.name)
        endmethod
        
        static stub method onFlagReturn takes Unit this, Unit returner, Flag whichFlag returns nothing
            call BJDebugMsg(returner.name + " returned " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onDeath takes Unit this, Unit dieUnit returns nothing
            call BJDebugMsg(dieUnit.name + " died near " + this.name)
        endmethod
    endmodule
    
endlibrary