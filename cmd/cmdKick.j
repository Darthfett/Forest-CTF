library cmdKick initializer Init uses stringPlayer,Event,stringFilter,stringFind,stringColor
/*
__________________________________________________________________________________

        cmdKick library, created by Darthfett - version 1.0
        http://www.thehelper.net/forums/showthread.php?t=144461
        
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
    Set this string to the command to be used to kick a player.
    Using a space at the end will require a space in-between the command
    and the name of the player.
    
private constant string creator
    Set this string to your in-game name, to prevent the system from kicking you.
    
public boolean ENABLED <cmdKick_ENABLED>
    Set this to true/false to enable/disable the in-game command.
    
private constant string ATTEMPT_KICK_INVALID_PLAYER
    This message is displayed to the kicking player when he types in an invalid string.
    
private constant string ATTEMPT_KICK_PLAYER_NOT_PLAYING
    This message is displayed to the kicking player when he chooses a player that is not playing.
    
private constant string ATTEMPT_KICK_SELF
    This message is displayed to the kicking player when he attempts to kick himself.
    
private constant string ATTEMPT_KICK_CREATOR
    This message is displayed to the kicking player when he attempts to kick the map creator.
    
private constant string ATTEMPT_KICKER_NOT_HOST
    This message is displayed to the kicking player when he attempts to kick and is not the host (or creator).

private function KICK_MESSAGE_ALL_PLAYERS takes player p returns string
    This message is displayed to all players when player p is kicked.

private function KICK_MESSAGE_KICKED_PLAYER takes player p returns string
    This message is displayed to player p when he is kicked.
    
<END CONFIG>
    
string In-Game Command "-kick "
    This command (by default) allows you to kick a player by typing "-kick " followed
    by a reference to a player.  This reference can be anything from:
        -Player Name
        -Player Color
        -Player Number ("1" refers to Player(0))
        -Any SubString of a player's name

Event EVENT_PLAYER_IS_KICKED
    This Event is fired just before a player is kicked from the game.
    Invalid kick commands will not trigger this Event.
        
global player KickedPlayer
    OR
function GetKickedPlayer takes nothing returns player
    When a player is kicked, just before he is booted from the game, the
    EVENT_PLAYER_IS_KICKED Event is fired.  You can refer to the Kicked player
    with this function.
    
global player KickingPlayer
    OR
function GetKickingPlayer takes nothing returns player
    When a player is kicked, just before he is booted from the game, the
    EVENT_PLAYER_IS_KICKED Event is fired.  You can refer to the Kicking player
    with this function.
__________________________________________________________________________________
*/

//CONFIG
globals
    private constant string cmd = "-kick "
    private constant string creator = "Darthfett"
    private player creatorPlayer = null
    
    public boolean ENABLED = true
    
    private constant string ATTEMPT_KICK_INVALID_PLAYER = RED + "Invalid Player" + END
    private constant string ATTEMPT_KICK_PLAYER_NOT_PLAYING = RED + "That player is not playing!" + END
    private constant string ATTEMPT_KICK_SELF = RED + "You cannot kick yourself!" + END
    private constant string ATTEMPT_KICK_CREATOR = RED + "You cannot kick the creator of the map!" + END
    private constant string ATTEMPT_KICKER_NOT_HOST = RED + "Only the host may kick another player." + END
endglobals

private function KICK_MESSAGE_ALL_PLAYERS takes player p returns string
    return P2CN(p) + RED + " has been kicked!" + END
endfunction

private function KICK_MESSAGE_KICKED_PLAYER takes player p returns string
    return RED + "You have been kicked." + END
endfunction
//END CONFIG

globals
    Event EVENT_PLAYER_IS_KICKED
    player KickedPlayer
    player KickingPlayer
    
    private player host
    private string tempStr
endglobals
    

function GetKickedPlayer takes nothing returns player
    return KickedPlayer
endfunction

function GetKickingPlayer takes nothing returns player
    return KickingPlayer
endfunction

private function GetHost takes nothing returns nothing
    local gamecache g = InitGameCache("Map.w3v")
    call StoreInteger ( g, "Map", "Host", GetPlayerId(GetLocalPlayer ())+1)
    call TriggerSyncStart ()
    call SyncStoredInteger ( g, "Map", "Host" )
    call TriggerSyncReady ()
    set host = Player( GetStoredInteger ( g, "Map", "Host" )-1)
    call FlushGameCache( g )
    set g = null
endfunction

private function Conditions takes nothing returns boolean
    local string s = GetEventPlayerChatString()
    local player kicker = GetTriggerPlayer()
    local player tar
    if StartsWith(s,cmd,false) and ENABLED then
        set tar = S2P(Strip(SubString(s,StringLength(cmd),StringLength(s))))
        if tar == null or (DEBUG_MODE and tar == Player(12)) then
            call DisplayTextToPlayer(kicker,0,0,ATTEMPT_KICK_INVALID_PLAYER)
            return false
        endif
        if GetPlayerSlotState(tar) != PLAYER_SLOT_STATE_PLAYING then
            call DisplayTextToPlayer(kicker,0,0,ATTEMPT_KICK_PLAYER_NOT_PLAYING)
            return false
        endif
        if tar == kicker then
            call DisplayTextToPlayer(kicker,0,0,ATTEMPT_KICK_SELF)
            return false
        endif
        if tar == creatorPlayer then
            call DisplayTextToPlayer(kicker,0,0,ATTEMPT_KICK_CREATOR)
            return false
        endif
        if kicker == creatorPlayer then
            set KickedPlayer = tar
            set KickingPlayer = kicker
            return true
        endif
        call GetHost()
        if kicker == host then
            set KickedPlayer = tar
            set KickingPlayer = kicker
            return true
        endif
        call DisplayTextToPlayer(kicker,0,0,ATTEMPT_KICKER_NOT_HOST)
    endif
    return false
endfunction

private function Actions takes nothing returns nothing
    call EVENT_PLAYER_IS_KICKED.fire()
    call RemovePlayer(KickedPlayer,PLAYER_GAME_RESULT_DEFEAT)
    call DisplayTextToPlayer(GetLocalPlayer(),0,0,KICK_MESSAGE_ALL_PLAYERS(KickedPlayer))
    call CustomDefeatDialogBJ(KickedPlayer,KICK_MESSAGE_KICKED_PLAYER(KickedPlayer))
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
    set EVENT_PLAYER_IS_KICKED = Event.create()
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