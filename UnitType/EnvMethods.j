library EnvMethods

    module EnvMethods
        static stub method onEnterFlagRange takes Unit this, Flag which returns nothing
            call Debug.PlaceHolder(this.name + " came in range of " + which.toString())
            call this.onEnterFlagRange(which)
        endmethod
    
        static stub method onDetect takes Unit this, Unit detected returns nothing
            call Debug.PlaceHolder(this.name + " detected " + detected.name)
            call this.attack(detected)
        endmethod
        
        static stub method onDamage takes Unit this, Unit damager returns nothing
            call Debug.PlaceHolder(damager.name + " damaged " + this.name)
            call this.attack(damager)
        endmethod
        
        static stub method onCast takes Unit this, Unit caster, CastData data returns nothing
            call Debug.PlaceHolder(caster.name + " cast " + data.toString() + " near " + this.name)
        endmethod
        
        static stub method onLoseSight takes Unit this, Unit leaver, string reason returns nothing
            call Debug.PlaceHolder(this.name + " onLoseSight " + leaver.name + " - " + reason)
        endmethod
        
        static stub method onRevive takes Unit this, string reason returns nothing
            call Debug.PlaceHolder(this.name + " revive - " + reason)
        endmethod
        
        static stub method onFlagPickup takes Unit this, Unit carrier, Flag whichFlag returns nothing
            call Debug.PlaceHolder(carrier.name + " picked up flag " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onFlagDrop takes Unit this, Unit carrier, Flag whichFlag returns nothing
            call Debug.PlaceHolder(carrier.name + " dropped flag " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onFlagPass takes Unit this, Unit preCarrier, Unit postCarrier, Flag whichFlag returns nothing
            call Debug.PlaceHolder(preCarrier.name + " passed " + whichFlag.toString() + " to " + postCarrier.name + " near " + this.name)
        endmethod
        
        static stub method onFlagReturn takes Unit this, Unit returner, Flag whichFlag returns nothing
            call Debug.PlaceHolder(returner.name + " returned " + whichFlag.toString() + " near " + this.name)
        endmethod
        
        static stub method onDeath takes Unit this, Unit dieUnit returns nothing
            call Debug.PlaceHolder(dieUnit.name + " died near " + this.name)
        endmethod
    endmodule
    
endlibrary