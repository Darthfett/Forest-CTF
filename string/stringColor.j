library stringColor
/*
__________________________________________________________________________________

        stringColor library, created by Darthfett - version 1.1
        http://www.thehelper.net/forums/showthread.php?t=143593
            
                                Requirements
                                
-vJass compiler (such as JASSHelper)

                                Documentation
                                
-All globals are standalone.  Feel free to copy an individual global.

-Credit for this library is not necessary.  Feel free to use it in your map.
If you feel obligated to credit me, I won't object.  I only ask that you do 
not simply copy and paste the library as your own.

-The library isn't really needed. You can get by simply by copying and pasting
the globals block. You don't need to require the library
in order to use this either, but 'using' the library gives more logical errors
to the user if they do not have it in their map.

                                  Purpose

The purpose of this library is to give you an idea of how to use string 
constants and colors effectively in display text.  It is not a complete list
and neither will it ever be.  Instead, it is simply a list made to be added to.

                                    API

This library provides a few hex color strings to use to color displayed text.

constant string END = "|r"
    This string is used to end the color coded string.
    (Example: RED + "This is Red" + END + ", and this is white.")
    
constant string LIGHTYELLOW ... DARKGRAY
    These strings are used to color text that will be displayed
    on the average WC3 background. They were chosen to be easier to read.
    (Example: call BJDebugMsg(Yellow + "Don't kill " + END + RED + "THAT!" + END)
    
constant string P_RED ... P_BROWN
    These strings are used to color something in a player's colored text.
    (Example: call BJDebugMsg(P_RED + GetPlayerName(Player(0)) + END + ": HI gUyz!")

__________________________________________________________________________________
*/

globals
    constant string END =        "|r"
    
    //=========================
    constant string LIGHTYELLOW = "|cffffff00"
    constant string YELLOW =      "|cffffcc00"
    constant string GREEN =       "|cff00ff00"
    constant string BLUE =        "|cff0000ff"
    constant string RED =         "|cffff0000"
    constant string BROWN =       "|cffcc9933"
    constant string ORANGE =      "|cffff6400"
    constant string DARKGREEN =   "|cff009600"
    constant string AQUA =        DARKGREEN
    constant string DARKBLUE =    "|cff000096"
    constant string DARKRED =     "|cff960000"
    constant string DARKTEAL =    "|cff009696"
    constant string DARKCYAN =    DARKTEAL
    constant string DARKORANGE =  "|cffc86400"
    constant string DARKGRAY =    "|cff666666"
    
    constant string P_RED       = "|cffff0303"
    constant string P_BLUE      = "|cff0042ff"
    constant string P_TEAL      = "|cff1ce6b9"
    constant string P_PURPLE    = "|cff540081"
    constant string P_YELLOW    = "|cfffffc01" 
    constant string P_ORANGE    = "|cfffeba0e"
    constant string P_GREEN     = "|cff20c000"
    constant string P_PINK      = "|cffr55bb0"
    constant string P_GRAY      = "|cff959697"
    constant string P_LIGHTBLUE = "|cff7ebff1"
    constant string P_DARKGREEN = "|cff107246"
    constant string P_BROWN     = "|cff4e2a04"
    
    //=========================
    constant string DARKGREY =    DARKGRAY
endglobals

endlibrary