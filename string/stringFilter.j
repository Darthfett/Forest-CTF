library stringFilter
/*
__________________________________________________________________________________

        stringFilter library, created by Darthfett - version 1.0
        http://www.thehelper.net/forums/showthread.php?t=143589
        
                                Requirements
                                
-vJass compiler (such as JASSHelper)
    -If you remove the library and multi-line comment(s), you can make this JASS compatable.

                                Documentation
                                
-All functions are standalone.  Feel free to copy an individual function.

-Credit for this library is not necessary.  Feel free to use it in your map.
If you feel obligated to credit me, I won't object.  I only ask that you do 
not simply copy and paste the library as your own.

                                    API

function ReplaceString takes string s, string find, string replace, checkCase returns string
    searches through the entirety of s, looking for find.  If it finds 'find', it 
    replaces 'find' in the string with 'replace'.
    checkCase determines whether case is checked
    
function Strip takes string s returns string
    Removes all leading and trailing spaces from the string
    
function LStrip takes string s returns string
    Removes all leading spaces from the string
    
function RStrip takes string s returns string
    Removes all trailing spaces from the string
    
function StripMeta takes string s, boolean strip returns string
    searches through the entirety of s, looking for (!@#$%...) values. The boolean 
    'strip' determines if these values are stripped from the string, or if
    all characters other than these are stripped.
    Using Strip as false will strip AlphaNumeric characters.
    
function StripNumeric takes string s, boolean strip returns string
    searches through the entirety of s, looking for (0-9) values. The boolean 
    'strip' determines if these values are stripped from the string, or if
    all characters other than these are stripped.
    Using strip as false will strip AlphaMeta Characters
    
function StripAlpha takes string s, boolean strip returns string
    searches through the entirety of s, looking for (a-z,A-Z) values. The boolean 
    'strip' determines if these values are stripped from the string, or if
    all characters other than these are stripped.
    Using strip as false will Strip MetaNumeric Characters
    
function StripUpper takes string str, boolean strip returns string
    searches through the entirety of str, looking for (A-Z) values. The boolean 
    'strip' determines if these values are stripped from the string, or if
    all characters other than these are stripped.
    Using Strip as false will strip Lowercase Characters
__________________________________________________________________________________
*/

function ReplaceString takes string s, string find, string replace, boolean checkCase returns string
    local integer i = 0
    local string c
    local integer sLen = StringLength(s)
    local integer findLen = StringLength(find)
    local string str = ""
    if find == "" or find == null then
        return s //prevent infinite loop
    endif
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    loop
        exitwhen i + findLen > sLen
        set c = SubString(s,i,i+findLen)
        if c == find then
            set str = str + replace
            set i = i + findLen
        else
            set str = str + SubString(s,i,i+1)
            set i = i + 1
        endif
    endloop
    return str + SubString(s,i,sLen)
endfunction

function Strip takes string s returns string
    local integer i = 0
    local integer start = 0
    local integer end = StringLength(s)
    loop
        exitwhen i == end or SubString(s,i,i+1) != " "
        set i = i + 1
    endloop
    set start = i
    set i = end
    loop
        exitwhen i == start or SubString(s,i-1,i) != " "
        set i = i - 1
    endloop
    return SubString(s,start,i)
endfunction

function LStrip takes string s returns string
    local integer i = 0
    local integer start = 0
    loop
        exitwhen SubString(s,i,i+1) != " "
        set i = i + 1
    endloop
    return SubString(s,i,StringLength(s))
endfunction

function RStrip takes string s returns string
    local integer end = StringLength(s)
    local integer i = end
    loop
        exitwhen i == 0 or SubString(s,i-1,i) != " "
        set i = i + 1
    endloop
    return SubString(s,0,i)
endfunction

function StripMeta takes string s, boolean strip returns string
    local integer i = 0
    local string str = ""
    local string c
    loop
        set c = SubString(s,i,i+1)   
        exitwhen c == ""
        if strip then
            if I2S(S2I(c)) == c or StringCase(c,true) != StringCase(c,false) then
                set str = str + c
            endif
        elseif I2S(S2I(c)) != c and StringCase(c,true) == StringCase(c,false) then
            set str = str + c
        endif
        set i = i + 1
    endloop
    return str
endfunction

function StripNumeric takes string s, boolean strip returns string
    local integer i = 0
    local string str = ""
    local string c
    loop
        set c = SubString(s,i,i+1)
        exitwhen c == ""
        if strip then
            if I2S(S2I(c)) != c then
                set str = str + c
            endif
        elseif I2S(S2I(c)) == c then
            set str = str + c
        endif
        set i = i + 1
    endloop
    return str
endfunction

function StripAlpha takes string s, boolean strip returns string
    local integer i = 0
    local string str = ""
    local string c
    loop
        set c = SubString(s,i,i+1)
        exitwhen c == ""
        if strip then
            if StringCase(c,true) == StringCase(c,false) then
                set str = str + c
            endif
        elseif StringCase(c,true) != StringCase(c,false) then
            set str = str + c
        endif
        set i = i + 1
    endloop
    return str
endfunction

function StripUpper takes string str, boolean strip returns string
    local integer i = 0
    local string s = ""
    local string c
    loop
        set c = SubString(str,i,i+1)
        exitwhen c == ""
        if strip then
            if StringCase(c,false) == c then
                set s = s + c
            endif
        elseif StringCase(c,true) == c then
            set s = s + c
        endif
        set i = i + 1
    endloop
    return s
endfunction

endlibrary