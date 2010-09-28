library cmdColor initializer Init uses stringPlayer,Event,stringFilter,stringFind,stringColor
/*
__________________________________________________________________________________

        cmdColor library, created by Darthfett - version 1.0
        http://www.thehelper.net/forums/showthread.php?t=144462
        
                                Requirements
                                
-vJass compiler (such as JASSHelper, this version compiled for version 0.A.2.7)
                     
+stringPlayer library - http://www.thehelper.net/forums/showthread.php?t=143590
    +stringFilter library - http://www.thehelper.net/forums/showthread.php?t=143589
    
+stringFind library - http://www.thehelper.net/forums/showthread.php?t=143591

+Event library (this version compiled for version 1.04) - http://www.thehelper.net/forums/showthread.php?t=126846 

                                Documentation

-Credit for this library is not necessary.  Feel free to use it in your map.
If you feel obligated to credit me, I won't object.  I only ask that you do 
not simply copy and paste the library as your own.

                                    API

<CONFIG>
    
private constant string cmd
    Set this string to the command to be used to change a player's color.
    Using a space at the end will require a space in-between the command
    and the selected color.
        
private constant string ATTEMPT_SELECT_INVALID_COLOR
    This will be displayed to the player when he attempts to select an invalid color.
    
<END CONFIG>
    
string In-Game Command "-color "
    This command (by default) allows a player to change color by typing "-color " followed
    by a color, such as "red" or "dark green"

Event EVENT_PLAYER_CHANGES_COLOR
    This Event is fired just before a player changes color.
    Invalid color commands will not trigger this Event.
    
global playercolor PlayerSelectedColor
    OR
function GetPlayerSelectedColor takes nothing returns playercolor
    When a player selects a color, just before he changes color, the
    EVENT_PLAYER_CHANGES_COLOR Event is fired.  You can refer to the playercolor
    selected by the player with this function
        
global player PlayerSelectingColor
    OR
function GetPlayerSelectingColor takes nothing returns player
    When a player selects a color, just before he changes color, the
    EVENT_PLAYER_CHANGES_COLOR Event is fired.  You can refer to the player
    selecting a new playercolor with this function
    
public boolean ENABLED <cmdColor_ENABLED>
    Set this to true/false to enable/disable the in-game command.
__________________________________________________________________________________
*/

globals
    //CONFIG
        private constant string cmd = "-color "
        
        private constant string ATTEMPT_SELECT_INVALID_COLOR = RED + "Invalid color." + END
    //END CONFIG
    
    public boolean ENABLED = true
    
    Event EVENT_PLAYER_CHANGES_COLOR
    playercolor PlayerSelectedColor
    player PlayerSelectingColor
endglobals

function GetPlayerSelectedColor takes nothing returns playercolor
    return PlayerSelectedColor
endfunction

function GetPlayerSelectingColor takes nothing returns player
    return PlayerSelectingColor
endfunction

private function Conditions takes nothing returns boolean
    return StartsWith(GetEventPlayerChatString(),cmd,false) and ENABLED
endfunction

private function Actions takes nothing returns nothing
    local string s = StripAlpha(StringCase(SubString(GetEventPlayerChatString(),StringLength(cmd),StringLength(GetEventPlayerChatString())),false),false)
    set PlayerSelectedColor = C2PC(s)
    if PlayerSelectedColor != null then
        set PlayerSelectingColor = GetTriggerPlayer()
        call EVENT_PLAYER_CHANGES_COLOR.fire()
        call SetPlayerColor(PlayerSelectingColor,PlayerSelectedColor)
    else
        call DisplayTextToPlayer(GetTriggerPlayer(),0,0,ATTEMPT_SELECT_INVALID_COLOR)
    endif
endfunction

private function Init takes nothing returns nothing
    local trigger t = CreateTrigger()
    local integer i = 0
    loop
        exitwhen i >= 12
        call TriggerRegisterPlayerChatEvent(t,Player(i),"",false)
        set i = i + 1
    endloop
    call TriggerAddCondition(t,Condition(function Conditions))
    call TriggerAddAction(t,function Actions)
    set EVENT_PLAYER_CHANGES_COLOR = Event.create()
endfunction

endlibrary