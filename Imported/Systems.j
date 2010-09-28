library Systems initializer onInit

//===========================================================================================

globals
    private region reg
    private boolean b
endglobals

//===========================================================================================

function IsUnitInRect takes unit whichUnit, rect whichRect returns boolean
    call RegionAddRect(reg,whichRect)
    set b = IsUnitInRegion(reg,whichUnit)
    call RegionClearRect(reg,whichRect)
    return b
endfunction

//===========================================================================================

function DistanceBetweenXY takes real x1, real y1, real x2, real y2 returns real
    return SquareRoot((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
endfunction

//===========================================================================================
//===========================================================================================
//===========================================================================================
//===========================================================================================
//===========================================================================================
//===========================================================================================

private function onInit takes nothing returns nothing
    set reg = CreateRegion()
endfunction

endlibrary