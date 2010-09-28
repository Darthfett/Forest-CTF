library stringFind
/*
__________________________________________________________________________________

        stringFind library, created by Darthfett - version 1.1
        http://www.thehelper.net/forums/showthread.php?t=143591
        
                                Requirements
                                
-vJass compiler (such as JASSHelper)
    -If you remove the library and multi-line comment(s), you can make this JASS compatable.

                                Documentation
                                
-All functions are standalone.  Feel free to copy an individual function.

-Credit for this library is not necessary.  Feel free to use it in your map.
If you feel obligated to credit me, I won't object.  I only ask that you do 
not simply copy and paste the library as your own.

                                    API
                            
function ContainsString takes string s, string find, boolean checkCase returns boolean
    returns whether s contains find.  checkCase determines whether case is checked
    
function StartsWith takes string s, string find, boolean checkCase returns boolean
    returns whether s starts with find.  checkCase determines whether case is checked.
    
function EndsWith takes string s, string find, boolean checkCase returns boolean
    returns whether s ends with find.  checkCase determines whether case is checked.
    
function CountInString takes string s, string find, boolean allowOverlap, boolean checkCase returns integer
    returns the number of times 'find' can be found in 's'.  If allowOverlap
    is true, 'aa' can be found in 'aaa' 2 times.  Otherwise, only once.
    checkCase determines whether case is checked
    
function FindFirstOf takes string s, integer start, string find, boolean checkCase returns integer
    returns the index of the first instance of find in s starting from 'start'.
    If 'find' is not found, it will return the length of s.
    checkCase determines whether case is checked
    
function FindString takes string s, string find, boolean checkCase returns integer
    returns the index of the first instance of find in s, starting from 0.
    If 'find' is not found, it will return the length of s.
    checkCase determines whether case is checked
        
    Yes, this is a duplicate of FindFirstOf. It is included, to show an 
    example of how to use FindFirstOf (simply use 0), and for simplifying
    code/syntax.
    
function FindLastOf takes string s, integer end, string find, boolean checkCase returns integer
    returns the index of the last instance of find in s, going back from end.
    If 'find' is not found, it will return 0.
    checkCase determines whether case is checked
    
function FindStringLast takes string s, string find, boolean checkCase returns integer
    returns the index of the last instance of find in s.
    If 'find' is not found, it will return 0.
    checkCase determines whether case is checked

__________________________________________________________________________________
*/ 

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

function StartsWith takes string s, string find, boolean checkCase returns boolean
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    return SubString(s,0,StringLength(find)) == find
endfunction

function EndsWith takes string s, string find, boolean checkCase returns boolean
    local integer sLen = StringLength(s)
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    return SubString(s,sLen - StringLength(find),sLen) == find
endfunction   

function CountInString takes string s, string find, boolean allowOverlap, boolean checkCase returns integer
    local integer i = 0
    local integer findLen = StringLength(find)
    local integer sLen = StringLength(s)
    local integer count = 0
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    loop
        exitwhen i+findLen > sLen
        if SubString(s,i,i+findLen) == find then
            set count = count + 1
            if allowOverlap then
                set i = i + 1
            else
                set i = i + findLen
            endif
        else
            set i = i + 1
        endif
    endloop
    return count
endfunction

function FindFirstOf takes string s, integer start, string find, boolean checkCase returns integer
    local integer sLen = StringLength(s)
    local integer findLen = StringLength(find)
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    loop
        exitwhen start + findLen > sLen
        if SubString(s,start,start+findLen) == find then
            return start
        endif
        set start = start + 1
    endloop
    return sLen
endfunction

function FindString takes string s, string find, boolean checkCase returns integer
    local integer start = 0
    local integer sLen = StringLength(s)
    local integer findLen = StringLength(find)
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    loop
        exitwhen start + findLen > sLen
        if SubString(s,start,start+findLen) == find then
            return start
        endif
        set start = start + 1
    endloop
    return sLen
endfunction

function FindLastOf takes string s, integer end, string find, boolean checkCase returns integer
    local integer findLen = StringLength(find)
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    loop
        exitwhen end - findLen < 0
        if SubString(s,end-findLen,end) == find then
            return end-findLen
        endif
        set end = end - 1
    endloop
    return 0
endfunction

function FindStringLast takes string s, string find, boolean checkCase returns integer
    local integer end = StringLength(s)
    local integer findLen = StringLength(find)
    if not checkCase then
        set s = StringCase(s,false)
        set find = StringCase(find,false)
    endif
    loop
        exitwhen end - findLen < 0
        if SubString(s,end-findLen,end) == find then
            return end-findLen
        endif
        set end = end - 1
    endloop
    return 0
endfunction

endlibrary