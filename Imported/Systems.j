library Systems initializer onInit
    /*
    
    A few useful snippet functions
    
    */

    //===========================================================================================

    globals
        private region reg
        private boolean b
    endglobals

    //===========================================================================================

    function IsUnitInRect takes unit whichUnit, rect whichRect returns boolean
        //Efficient way to determine if a unit is in the given rect
        call RegionAddRect(reg,whichRect)
        set b = IsUnitInRegion(reg,whichUnit)
        call RegionClearRect(reg,whichRect)
        return b
    endfunction

    //===========================================================================================

    function DistanceBetweenXY takes real x1, real y1, real x2, real y2 returns real
        //Returns distance between two (x,y) points
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