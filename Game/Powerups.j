library Powerups

globals
    private integer POWERUP_TYPE_COUNT = 11
    private integer POWERUP_RECT_COUNT = 14
    integer POWERUP_RESPAWN_TIME = 8
endglobals

module Powerups    
    
    private static integer array powerupTypeZ
    private static rect array powerupRectZ
    private static item array powerupItemZ
    
    private static integer typeTop = POWERUP_TYPE_COUNT
    private static integer rectTop = POWERUP_RECT_COUNT

    static method spawnPowerups takes nothing returns nothing
        local integer rand
        local integer whichType
        local rect whichRect
        local item whichItem
        
        set rand = GetRandomInt(0,thistype.typeTop)
        set whichType = thistype.powerupTypeZ[rand]
        set thistype.powerupTypeZ[rand] = thistype.powerupTypeZ[thistype.typeTop]
        set thistype.powerupTypeZ[thistype.typeTop] = whichType
        
        set rand = GetRandomInt(0,thistype.rectTop)
        set whichRect = thistype.powerupRectZ[rand]
        set thistype.powerupRectZ[rand] = thistype.powerupRectZ[thistype.rectTop]
        set thistype.powerupRectZ[thistype.rectTop] = whichRect
        
        set whichItem = thistype.powerupItemZ[rand]
        set thistype.powerupItemZ[rand] = thistype.powerupItemZ[thistype.rectTop]
        set thistype.powerupItemZ[thistype.rectTop] = whichItem
        
        if whichItem != null then
            call RemoveItem(whichItem)
        endif
        
        set thistype.powerupItemZ[thistype.rectTop] = CreateItem(whichType,GetRectCenterX(whichRect),GetRectCenterY(whichRect))
        
        if thistype.typeTop == 0 then
            set thistype.typeTop = POWERUP_TYPE_COUNT
        else
            set thistype.typeTop = thistype.typeTop - 1
        endif
        
        if thistype.rectTop == 0 then
            set thistype.rectTop = POWERUP_RECT_COUNT
        else
            set thistype.rectTop = thistype.rectTop - 1
        endif
        call TimerStart(GetExpiredTimer(),POWERUP_RESPAWN_TIME,false,function thistype.spawnPowerups)
    endmethod

    private static method onInit takes nothing returns nothing
        set Game.powerupTypeZ[0] = 'I00B'
        set Game.powerupTypeZ[1] = 'I00C'
        set Game.powerupTypeZ[2] = 'I009'
        set Game.powerupTypeZ[3] = 'I00A'
        set Game.powerupTypeZ[4] = 'I00G'
        set Game.powerupTypeZ[5] = 'I00D'
        set Game.powerupTypeZ[6] = 'I00F'
        set Game.powerupTypeZ[7] = 'I00E'
        set Game.powerupTypeZ[8] = 'I00H'
        set Game.powerupTypeZ[9] = 'I00A'
        set Game.powerupTypeZ[10] = 'I00O'
        
        set Game.powerupRectZ[0] = gg_rct_Pwrup01
        set Game.powerupRectZ[1] = gg_rct_Pwrup02
        set Game.powerupRectZ[2] = gg_rct_Pwrup03
        set Game.powerupRectZ[3] = gg_rct_Pwrup04
        set Game.powerupRectZ[4] = gg_rct_Pwrup05
        set Game.powerupRectZ[5] = gg_rct_Pwrup06
        set Game.powerupRectZ[6] = gg_rct_Pwrup07
        set Game.powerupRectZ[7] = gg_rct_Pwrup08
        set Game.powerupRectZ[8] = gg_rct_Pwrup09
        set Game.powerupRectZ[9] = gg_rct_Pwrup10
        set Game.powerupRectZ[10] = gg_rct_Pwrup11
        set Game.powerupRectZ[11] = gg_rct_Pwrup12
        set Game.powerupRectZ[12] = gg_rct_Pwrup13
        set Game.powerupRectZ[13] = gg_rct_Pwrup14
    endmethod

endmodule

endlibrary