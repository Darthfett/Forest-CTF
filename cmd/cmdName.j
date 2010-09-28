library cmdName initializer Init uses Event,stringFilter,stringFind,stringColor
/*
__________________________________________________________________________________

        cmdName library, created by Darthfett - version 1.0
        http://www.thehelper.net/forums/showthread.php?t=144463
        
                                Requirements
                                
-vJass compiler (such as JASSHelper, this version compiled for version 0.A.2.7)
    
+stringFind library - http://www.thehelper.net/forums/showthread.php?t=143591

+stringFilter library - http://www.thehelper.net/forums/showthread.php?t=143589

+Event library (this version compiled for version 1.04) - http://www.thehelper.net/forums/showthread.php?t=126846 

                                Documentation

-Credit for this library is not necessary.  Feel free to use it in your map.
If you feel obligated to credit me, I won't object.  I only ask that you do 
not simply copy and paste the library as your own.

                                    API

<CONFIG>
    
private constant string cmd
    Set this string to the command to be used to change a player's name.
    Using a space at the end will require a space in-between the command
    and the selected name.
    
private constant string creator
    Set this string to your in-game name, to prevent other players from using your name in-game.
        
private constant string ATTEMPT_SELECT_CREATORS_NAME
    This will be displayed to the player when he attempts to select the map creator's name.
    
<END CONFIG>
    
string In-Game Command "-name "
    This command (by default) allows a player to change color by typing "-name " followed
    by a name, such as "Darthfett" or "BillyJoeBob"
    
    Due to restrictions in the game, the max length of a player's name is 26.

Event EVENT_PLAYER_CHANGES_NAME
    This Event is fired just before a player changes name.
    Invalid name commands will not trigger this Event.
    
global string PlayerSelectedName
    OR
function GetPlayerSelectedName takes nothing returns string
    When a player selects a name, just before he changes name, the
    EVENT_PLAYER_CHANGES_NAME Event is fired.  You can refer to the name
    selected by the player with this function
        
global player PlayerSelectingName
    OR
function GetPlayerSelectingName takes nothing returns player
    When a player selects a name, just before he changes name, the
    EVENT_PLAYER_CHANGES_NAME Event is fired.  You can refer to the player
    selecting a new name with this function
    
public boolean ENABLED <cmdName_ENABLED>
    Set this to true/false to enable/disable the in-game command.
    
__________________________________________________________________________________
*/

globals
    //CONFIG
        private constant string cmd = "-name "
        private constant string creator = "Darthfett"   
        
        private constant string ATTEMPT_SELECT_CREATORS_NAME = RED + "Invalid name.  You cannot select the name of the map creator." + END
    //END CONFIG
    
    public boolean ENABLED = true
        
    Event EVENT_PLAYER_CHANGES_NAME
    string PlayerSelectedName
    player PlayerSelectingName
    
    private player creatorPlayer = null
endglobals

function GetPlayerSelectedName takes nothing returns string
    return PlayerSelectedName
endfunction

function GetPlayerSelectingName takes nothing returns player
    return PlayerSelectingName
endfunction

private function Conditions takes nothing returns boolean
    return StartsWith(GetEventPlayerChatString(),cmd,false) and ENABLED
endfunction

private function Actions takes nothing returns nothing
    set PlayerSelectedName = Strip(SubString(GetEventPlayerChatString(),StringLength(cmd),StringLength(GetEventPlayerChatString())))
    set PlayerSelectingName = GetTriggerPlayer()
    if StringCase(PlayerSelectedName,false) == StringCase(creator,false) and PlayerSelectingName != creatorPlayer then
        call DisplayTextToPlayer(PlayerSelectingName,0,0,ATTEMPT_SELECT_CREATORS_NAME)
        return
    endif
    call EVENT_PLAYER_CHANGES_NAME.fire()
    call SetPlayerName(PlayerSelectingName,PlayerSelectedName)
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
    set EVENT_PLAYER_CHANGES_NAME = Event.create()
    set i = 0
    loop
        exitwhen i >= 12
        if StringCase(GetPlayerName(Player(i)),false) == StringCase(creator,false) then
            set creatorPlayer = Player(i)
        endif
        set i = i + 1
    endloop
endfunction

endlibrary