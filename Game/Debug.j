library Debug

    struct Debug
        static method PlaceHolder takes string s returns nothing
            call BJDebugMsg(GREEN + s + END)
        endmethod
    endstruct
    
endlibrary