library SimError initializer Init
// small modification of Vexorians SimError
// only replaced udg_SimError with SimErrorSound so I don't have to use udg_'s
globals
    private sound SimErrorSound
endglobals

function SimError takes player ForPlayer, string msg returns nothing
    if (GetLocalPlayer() == ForPlayer) then
        call ClearTextMessages()
        call DisplayTimedTextToPlayer( ForPlayer, 0.52, -1.00, 2.00, "|cffffcc00"+msg+"|r" )
        call StartSound( SimErrorSound )
    endif
endfunction

private function Init takes nothing returns nothing
    set SimErrorSound=CreateSoundFromLabel( "InterfaceError",false,false,false,10,10)
endfunction

endlibrary
