library stringPlayer initializer Init uses stringFilter,stringFind,stringColor
/*
__________________________________________________________________________________

        stringPlayer library, created by Darthfett - version 1.1
        http://www.thehelper.net/forums/showthread.php?t=143590
        
                                Requirements
                                
-vJass compiler (such as JASSHelper, this version compiled for version 0.A.2.7)
                          
+stringFilter library - http://www.thehelper.net/forums/showthread.php?t=143589

                                Documentation
                                
-NONE of these functions are standalone.  They require the globals block, 
the Init function, and the listed string Libraries

-Credit for this library is not necessary.  Feel free to use it in your map.
If you feel obligated to credit me, I won't object.  I only ask that you do 
not simply copy and paste the library as your own.

-These functions make use of the vJass hook and will work with systems that
change players' names and playercolors.

                                    API

<CONFIG>

private constant boolean DISPLAY_ERRORS = false
    Set to true/false to enable/disable error messages.
    
<END CONFIG>
                                    
string array playerColorStr
    Contains the hex color code of each player (sorted by PlayerId)
    (Example: "|cffff0303" for Player Red
    
string array playerNames
    Contains the physical names of each player (sorted by PlayerId)
    (Example: "Player 2" for Player 2)

string array playerNamesColored
    Contains the colored physical names of each player (sorted by PlayerId)
    (Example: "|cff0042ffPlayer 2|r" for Player 2)
    (Example: playerColorStr + playerName + END)

playercolor array playerColor
    Contains the playercolor of each player (sorted by PlayerId)
    (Example: ConvertPlayerColor(0) for Player Red)
    (Example: PLAYER_COLOR_RED for Player Red)
    
string array playerColors
    Contains the color in default order from "red" to "brown".
    Note that this is not synchronized with each player's color.
    
force array colorForces
    Contains the forces of all players of each color.
    (Example: colorForces[0] contains all players of the color 
        PLAYER_COLOR_RED/ConvertPlayerColor(0))

function P2HS takes player p returns string
    Player to Hex String returns the hex string (color code) of the player p.
    (Example: "|cffff0303" for Red)
    
function I2HS takes integer i returns string
    Integer to Hex String returns the hex color code of the player indexed by i.
    (Example: "|cffff0303" for Player 0, Red)
    
function P2CN takes player p returns string
    Player to Colored Name returns the name of player p in his respective hex color.
    (Example: "|cffff0303Player 1|r" for Player 0, Red)

function I2CN takes integer i returns string
    Integer to Colored Name returns the name of the player indexed by i in his
    respective player Color.
    (Example: "|cffff0303Player 1|r" for Player 0, Red)
    
function C2PC takes string s returns playercolor
    Color to playercolor converts a color (e.g. "red") into
    his respective playercolor.
    
function S2P takes string s returns player
    String to Player converts s from a string into a player.
    Works for a player referred to by his color (e.g. "grey"), his number
    (Example: "1" for Player(2)), by his name (e.g. "Player 1" is Player(0)),
    or by a substring of his name.
    (Example: "yer 1" in a game with "Player 1" would refer to him)
    
    This function is NOT case sensitive, and "plAYer" will work the same as 
    "Player", just as "yeLLOw" will work the same as "yellow".
    
    Invalid input will result in the output being Player(12) in debug mode,
    or null while not in debug mode.
    
function S2F takes string s returns force
    String to Force converts s from a string into a force.
    Works for players referred to by their color (e.g. "grey"), his number
    (Example: "1" for Player(2)), by their name (e.g. "Player 1" is Player(0)),
    or by a substring of his name
    (Example: "yer 1" in a game with "Player 1" would refer to him)
    
    This function is NOT case sensitive, and "plAYer" will work the same as 
    "Player", just as "yeLLOw" will work the same as "yellow".
    
    Invalid input will result in the output being Player(12) in debug mode,
    or null while not in debug mode.
    
function S2PI takes string s returns integer
    String to Player Id converts s from a string into a player number.
    Works for a player referred to by his color (e.g. "grey"), his number 
    (Example: "1" for Player(2)), by his name (e.g. "Player 1" is 0), or by a
    substring of his name
    (Example: "yer 1" in a game with "Player 1" would refer to him)
    
    This function is NOT case sensitive, and "plAYer" will work the same as 
    "Player", just as "yeLLOw" will work the same as "yellow".
    
    Invalid input will result in the output being '12'.

private constant integer MAX_NAME_LENGTH = 26
    Do NOT change this.  The max length of any player's name is 26 characters.
    This is an internal engine limitation, not this system's limitation.
__________________________________________________________________________________
*/

globals    
    //CONFIG
    private constant boolean DISPLAY_ERRORS = false
    //END CONFIG
    
    string array playerColorStr
    string array playerNames
    string array playerNamesColored
    
    playercolor array playerColor
    force array colorForces
    string array playerColors
    
    
    private constant string C2PC_errorMsg = "ERROR: stringPlayer - function C2PC: Invalid color"
    private constant string S2P_errorMsg = "ERROR: stringPlayer - function S2P: Invalid player string"
    private constant string S2F_errorMsg = "ERROR: stringPlayer - function S2F: Invalid player string"
    private constant string S2PI_errorMsg = "ERROR: stringPlayer - function S2PI: Invalid player string"
    
    private constant integer MAX_NAME_LENGTH = 26
    private hashtable playerTable
    private force tempForce
    private string array tempPlayerColorStr
    private boolean isEmpty
    private player last
endglobals

private function DebugMsg takes string s returns nothing
    if DISPLAY_ERRORS then
        debug call BJDebugMsg(s)
    endif
endfunction

private function CopyForceCallback takes nothing returns nothing
    call ForceAddPlayer(tempForce,GetEnumPlayer())
endfunction

private function CopyForce takes force f returns force
    set tempForce = CreateForce()
    call ForForce(f,function CopyForceCallback)
    return tempForce
endfunction

private function IsForceEmptyCallback takes nothing returns nothing
    set isEmpty = false
endfunction

private function IsForceEmpty takes force f returns boolean
    set isEmpty = true
    call ForForce(f,function IsForceEmptyCallback)
    return isEmpty
endfunction

private function PlayingPlayerInForceCallback takes nothing returns nothing
    if last == null or GetPlayerSlotState(GetEnumPlayer()) == PLAYER_SLOT_STATE_PLAYING then
        set last = GetEnumPlayer()
    endif
endfunction

private function PlayingPlayerInForce takes force f returns player
    set last = null
    call ForForce(f,function PlayingPlayerInForceCallback)
    return last
endfunction
    
private function onColorChange takes player whichPlayer, playercolor color returns nothing
    local integer id = GetHandleId(playerColor[GetPlayerId(whichPlayer)])
    call ForceRemovePlayer(colorForces[id],whichPlayer)
    set id = GetHandleId(color)
    call ForceAddPlayer(colorForces[id],whichPlayer)
    set playerColor[GetPlayerId(whichPlayer)] = color
endfunction

private function onNameChange takes player whichPlayer, string name returns nothing
    local integer i = GetPlayerId(whichPlayer)
    local integer childKey = StringHash(playerNames[i])
    if name == "" then
        set name = "Player " + I2S(i+1)
    endif
    if StringLength(name) > MAX_NAME_LENGTH then
        set name = SubString(name,0,MAX_NAME_LENGTH)
    endif
    set tempForce = LoadForceHandle(playerTable,0,childKey)
    call ForceRemovePlayer(tempForce,whichPlayer)
    if IsForceEmpty(tempForce) then
        call RemoveSavedHandle(playerTable,0,childKey)
        call DestroyForce(tempForce)
    endif
    
    set childKey = StringHash(name)
    if HaveSavedHandle(playerTable,0,childKey) then
        call ForceAddPlayer(LoadForceHandle(playerTable,0,childKey),whichPlayer)
    else
        set tempForce = CreateForce()
        call ForceAddPlayer(tempForce,whichPlayer)
        call SaveForceHandle(playerTable,0,childKey,tempForce)
    endif
    set playerNames[i] = name
    set playerNamesColored[i] = playerColorStr[i] + playerNames[i] + END
    set tempForce = null
endfunction

hook SetPlayerColor onColorChange
hook SetPlayerName onNameChange

function P2HS takes player p returns string
    return playerColorStr[GetPlayerId(p)]
endfunction

function I2HS takes integer i returns string
    return playerColorStr[i]
endfunction

function P2CN takes player p returns string
    return playerNamesColored[GetPlayerId(p)]
endfunction

function I2CN takes integer i returns string
    return playerNamesColored[i]
endfunction

function C2PC takes string s returns playercolor
    local integer i = 0
    loop
        exitwhen i >= 12
        if s == playerColors[i] then
            return ConvertPlayerColor(i)
        endif
        set i = i + 1
    endloop
    debug call DebugMsg(C2PC_errorMsg)
    return null
endfunction

function S2P takes string s returns player
    local integer i
    set s = StripMeta(s,true)
    
    set i = StringHash(s)    
    if HaveSavedHandle(playerTable,0,i) then
        return PlayingPlayerInForce(LoadForceHandle(playerTable,0,i))
    endif
    
    if HaveSavedInteger(playerTable,1,i) then
        return PlayingPlayerInForce(colorForces[LoadInteger(playerTable,1,i)])
    endif
    
    set i = S2I(s)
    if I2S(i) == s and i >= 1 and i <= 12 then
        return Player(i-1)
    endif
    
    set i = 0
    loop
        exitwhen i >= 12
        if ContainsString(playerNames[i],s,false) then
            return Player(i)
        endif
        set i = i + 1
    endloop
    debug call DebugMsg(S2P_errorMsg)
    debug return Player(12)
    return null
endfunction

function S2F takes string s returns force
    local integer i
    set s = StripMeta(s,true)
    
    set i = StringHash(s)    
    if HaveSavedHandle(playerTable,0,i) then
        return CopyForce(LoadForceHandle(playerTable,0,i))
    endif
    
    if HaveSavedInteger(playerTable,1,i) then
        return CopyForce(colorForces[LoadInteger(playerTable,1,i)])
    endif
    
    set tempForce = CreateForce()    
    set i = S2I(s)
    if I2S(i) == s and i >= 1 and i <= 12 then
        call ForceAddPlayer(tempForce,Player(i-1))
        return tempForce
    endif
    
    set i = 0
    loop
        exitwhen i >= 12
        if ContainsString(playerNames[i],s,false) then
            call ForceAddPlayer(tempForce,Player(i))
        endif
        set i = i + 1
    endloop
    debug if IsForceEmpty(tempForce) then
        debug call DebugMsg(S2F_errorMsg)
    debug endif
    return tempForce
endfunction

function S2PI takes string s returns integer
    local integer i
    set s = StripMeta(s,true)
    
    set i = StringHash(s)    
    if HaveSavedHandle(playerTable,0,i) then
        return GetPlayerId(PlayingPlayerInForce(LoadForceHandle(playerTable,0,i)))
    endif
    
    if HaveSavedHandle(playerTable,1,i) then
        return GetPlayerId(PlayingPlayerInForce(colorForces[LoadInteger(playerTable,1,i)]))
    endif
    
    set i = S2I(s)
    if I2S(i) == s and i >= 1 and i <= 12 then
        return i-1
    endif
    
    set i = 0
    loop
        exitwhen i >= 12
        if ContainsString(playerNames[i],s,false) then
            return i
        endif
        set i = i + 1
    endloop
    debug call DebugMsg(S2PI_errorMsg)
    return 12
endfunction

private function Init takes nothing returns nothing
    local integer i = 0
    local player p
    local force f

    set playerTable = InitHashtable()
    
    set playerColors[0] = "red"
    set playerColors[1] = "blue"
    set playerColors[2] = "teal"
    set playerColors[3] = "purple"
    set playerColors[4] = "yellow"
    set playerColors[5] = "orange"
    set playerColors[6] = "green"
    set playerColors[7] = "pink"
    set playerColors[8] = "grey"
    set playerColors[9] = "lightblue"
    set playerColors[10] = "darkgreen"
    set playerColors[11] = "brown"
    
    set tempPlayerColorStr[0] = "|cffff0303"
    set tempPlayerColorStr[1] = "|cff0042ff"
    set tempPlayerColorStr[2] = "|cff1ce6b9"
    set tempPlayerColorStr[3] = "|cff540081"
    set tempPlayerColorStr[4] = "|cfffffc01"
    set tempPlayerColorStr[5] = "|cfffeba0e"
    set tempPlayerColorStr[6] = "|cff20c000"
    set tempPlayerColorStr[7] = "|cffr55bb0"
    set tempPlayerColorStr[8] = "|cff959697"
    set tempPlayerColorStr[9] = "|cff7ebff1"
    set tempPlayerColorStr[10] = "|cff107246"
    set tempPlayerColorStr[11] = "|cff4e2a04"
    
    loop
        exitwhen i >= 12
        set colorForces[i] = CreateForce()
        call SaveInteger(playerTable,1,StringHash(playerColors[i]),i)
        set i = i + 1
    endloop
        
    set i = 0
    loop
        exitwhen i >= 12
        set p = Player(i)
        
        set playerColor[i] = GetPlayerColor(p)
        set playerNames[i] = GetPlayerName(p)
        set playerNamesColored[i] = playerColorStr[i] + playerNames[i] + END
        set playerColorStr[i] = tempPlayerColorStr[GetHandleId(playerColor[i])]
        
        call ForceAddPlayer(colorForces[GetHandleId(playerColor[i])],p)
        
        set f = CreateForce()
        call ForceAddPlayer(f,p)
        call SaveForceHandle(playerTable,0,StringHash(playerNames[i]),f)
        set i = i + 1
    endloop
endfunction

endlibrary
/*
__________________________________________________________________________________
*/
library_once stringFind
    function ContainsString takes string s, string find, boolean checkCase returns boolean
        local integer i = 0
        local integer findLen = StringLength(find)
        local integer sLen = StringLength(s)
        if not checkCase then
            set s = StringCase(s,false)
            set find = StringCase(find,false)
        endif
        loop
            exitwhen i+findLen > sLen
            if SubString(s,i,i+findLen) == find then
                return true
            endif
            set i = i + 1
        endloop
        return false
    endfunction
endlibrary

library_once stringColor
    globals
        constant string END =        "|r"
        
        constant string RED =         "|cffff0000"
    endglobals
endlibrary