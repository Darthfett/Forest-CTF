library stringType
/*
__________________________________________________________________________________

        stringType library, created by Darthfett - version 1.1
        http://www.thehelper.net/forums/showthread.php?t=143592
        
                                Requirements
                                
-vJass compiler (such as JASSHelper)
    -If you remove the library and multi-line comment(s), you can make this JASS compatable.

                                Documentation
                                
-All functions are standalone.  Feel free to copy an individual function.

-Credit for this library is not necessary.  Feel free to use it in your map.
If you feel obligated to credit me, I won't object.  I only ask that you do 
not simply copy and paste the library as your own.

                                    API

function IsInt takes string s returns boolean
    returns whether a string is a numeric integer.
    (Not necessarily within integer bounds)
    
function IsReal takes string s returns boolean
    returns whether a string a numeric real.
    (Not necessarily within real bounds)
    
function IsLetter takes string s returns boolean
    returns whether the specified character is a letter (a-z,A-Z).
    
function IsLetters takes string s returns boolean
    returns whether the specified string contains only letters (a-z,A-Z).
    
function IsMeta takes string s returns boolean
    returns whether the specified character is a metacharacter (!@#$%^...)
    
function IsMetas takes string s returns boolean
    returns whether the specified string contains only metacharacters (!@#$%...)
__________________________________________________________________________________
*/

function IsInt takes string s returns boolean
    local integer i = 0
    local integer j
    local string c
    if I2S(S2I(s)) == s then
        return true
    endif
    loop
        set c = SubString(s,i,i+8)
        exitwhen c == ""
        if I2S(S2I(c)) != c then
            set j = i + 8
            loop
                exitwhen j == i
                set c = SubString(s,j-1,j)
                if I2S(S2I(c)) != c then
                    return false
                endif
                set j = j - 1
            endloop
        endif
        set i = i + 1
    endloop
    return true
endfunction

function IsReal takes string s returns boolean
    local integer i = 0
    local integer k = 0
    local string c
    if R2S(S2R(s)) == s then
        return true
    endif
    loop
        set c = SubString(s,i,i+1)
        exitwhen c == ""
        if c == "." then
            set k = k + 1
            if k > 1 then
                return false
            endif
        elseif I2S(S2I(c)) != c then
            return false
        endif
        set i = i + 1
    endloop
    return true
endfunction
            
function IsNumeric takes string s returns boolean
    local integer i = 0
    local string c
    loop
        set c = SubString(s, i, i + 8)
        exitwhen c == ""
        if I2S(S2I(c)) != c then
            return false
        endif
        set i = i + 8
    endloop
    return true
endfunction    

function IsLetter takes string s returns boolean
    return StringCase(s,true) != StringCase(s,false)
endfunction

function IsLetters takes string s returns boolean
    local integer i = 0
    local string str
    loop
        set str = SubString(s, i, i + 1)
        exitwhen str == ""
        if StringCase(s,true) == StringCase(s,false) then
            return false
        endif
        set i = i + 1
    endloop
    return true
endfunction

function IsMeta takes string s returns boolean
    return I2S(S2I(s)) != s and StringCase(s,true) == StringCase(s,false)
endfunction

function IsMetas takes string s returns boolean
    local integer i = 0
    local string str
    if StringCase(s,true) != StringCase(s,false) then
        return false
    endif
    loop
        set str = SubString(s, i, i + 8)
        exitwhen str == ""
        if I2S(S2I(str)) != str then
            return false
        endif
        set i = i + 8
    endloop
    return true
endfunction

endlibrary