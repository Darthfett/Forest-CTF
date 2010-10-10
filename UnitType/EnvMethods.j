library EnvMethods

    module EnvMethods
        /*
        
        These methods are run whenever a Unit does something.  Specifically, this is used for when bot-controlled
        Units might need to determine a new course of action.
        
        */
        
        static stub method onEnterFlagRange takes Unit this, Flag which returns nothing
            /*
            
            For when a unit comes within range of a Flag
            
            */
            
            call BJDebugMsg(this.name + " came in range of " + which.toString())
            call this.onEnterFlagRange(which)
        endmethod
    
        static stub method onDetect takes Unit this, Unit detected returns nothing
            /*
            
            For when a Unit 'detects' an enemy Unit (comes within sight range, and is visible, or becomes visible while
            in sight range).
            
            */
            
            call BJDebugMsg(this.name + " detected " + detected.name)
            call this.attack(detected)
        endmethod
        
        static stub method onDamage takes Unit this, Unit damager returns nothing
            /*
            
            For when a Unit takes damage (from another Unit, specifically)
            
            */
            
            call BJDebugMsg(damager.name + " damaged " + this.name)
            call this.attack(damager)
        endmethod
        
        static stub method onCast takes Unit this, Unit caster, CastData data returns nothing
            /*
            
            For when a Unit casts a spell near this Unit
            
            */
            
            call BJDebugMsg(caster.name + " cast " + data.toString() + " near " + this.name)
        endmethod
        
        static stub method onLoseSight takes Unit this, Unit leaver, string reason returns nothing
            /*
            
            For when this Unit loses visibility of an enemy Unit (goes invisible, goes around some trees, etc)
            
            */
            
            call BJDebugMsg(this.name + " onLoseSight " + leaver.name + " - " + reason)
        endmethod
        
        static stub method onRevive takes Unit this, string reason returns nothing
            /*
            
            For when a Unit is revived.
            
            */
            
            call BJDebugMsg(this.name + " revive - " + reason)
        endmethod
        
        static stub method onFlagPickup takes Unit this, Unit carrier, Flag whichFlag returns nothing
            /*
            
            For when a Unit picks up the Flag near this Unit (either enemy or friend)
            
            */
            
            call BJDebugMsg(carrier.name + " picked up flag " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onFlagDrop takes Unit this, Unit carrier, Flag whichFlag returns nothing
            /*
            
            For when a Unit drops the Flag near this Unit (either enemy or friend)
            
            */
            
            call BJDebugMsg(carrier.name + " dropped flag " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onFlagPass takes Unit this, Unit preCarrier, Unit postCarrier, Flag whichFlag returns nothing
            /*
            
            For when a Unit passes the Flag to another near this Unit (either Unit could be this Unit, or a nearby Unit)
            
            */
            
            call BJDebugMsg(preCarrier.name + " passed " + whichFlag.toString() + " to " + postCarrier.name + " near " + this.name)
        endmethod
        
        static stub method onFlagReturn takes Unit this, Unit returner, Flag whichFlag returns nothing
            /*
            
            For when a Unit returns the Flag near this Unit
            
            */
            
            call BJDebugMsg(returner.name + " returned " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onDeath takes Unit this, Unit dieUnit returns nothing
            /*
            
            For when a Unit dies near this Unit (either enemy or friend)
            
            */
            
            call BJDebugMsg(dieUnit.name + " died near " + this.name)
        endmethod
    endmodule
    
endlibrary