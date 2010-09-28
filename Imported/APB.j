library APB initializer Init

//These ObjectMerger commands will create walkable pathing blockers.

///! external ObjectMerger w3b YTpb YTwb bnam "Pathing Blocker (Walkable)" bwal 1 bptx "PathTextures\2x2Unbuildable.tga"
///! external ObjectMerger w3b YTpc YTwc bnam "Pathing Blocker (Walkable) (Large)" bwal 1 bptx "PathTextures\4x4Unbuildable.tga"

//Save the map with this, close the map, and open it again. Add one more / to the //!'s before
//the ObjectMerger calls after reopening the map.

globals
    private constant integer UNWALKABLE = 'YTpb'
    private constant integer UNWALKABLE_LARGE = 'YTpc'
    private constant integer UNFLYABLE = 'YTab'
    private constant integer UNFLYABLE_LARGE = 'YTac'
    private constant integer NO_MOVEMENT = 'YTfb'
    private constant integer NO_MOVEMENT_LARGE = 'YTfc'
    private constant integer WALKABLE = 'YTwb'
    private constant integer WALKABLE_LARGE = 'YTwc'
endglobals

private function Replace takes nothing returns boolean
    local destructable d = GetFilterDestructable()
    local integer i = GetDestructableTypeId(d)
    local real x
    local real y
    if i == UNWALKABLE then
        call SetTerrainPathable(GetWidgetX(d), GetWidgetY(d), PATHING_TYPE_WALKABILITY, false)
        call RemoveDestructable(d)
    elseif i == UNWALKABLE_LARGE then
        set x = GetWidgetX(d)
        set y = GetWidgetY(d)
        call SetTerrainPathable(x + 16, y + 16, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x - 16, y - 16, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x + 16, y - 16, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x - 16, y + 16, PATHING_TYPE_WALKABILITY, false)
        call RemoveDestructable(d)
    elseif i == UNFLYABLE then
        call SetTerrainPathable(GetWidgetX(d), GetWidgetY(d), PATHING_TYPE_FLYABILITY, false)
        call RemoveDestructable(d)
    elseif i == UNFLYABLE_LARGE then
        set x = GetWidgetX(d)
        set y = GetWidgetY(d)
        call SetTerrainPathable(x + 16, y + 16, PATHING_TYPE_FLYABILITY, false)
        call SetTerrainPathable(x - 16, y - 16, PATHING_TYPE_FLYABILITY, false)
        call SetTerrainPathable(x + 16, y - 16, PATHING_TYPE_FLYABILITY, false)
        call SetTerrainPathable(x - 16, y + 16, PATHING_TYPE_FLYABILITY, false)
        call RemoveDestructable(d)
    elseif i == WALKABLE then
        call SetTerrainPathable(GetWidgetX(d), GetWidgetY(d), PATHING_TYPE_WALKABILITY, true)
        call RemoveDestructable(d)
    elseif i == WALKABLE_LARGE then
        set x = GetWidgetX(d)
        set y = GetWidgetY(d)
        call SetTerrainPathable(x + 16, y + 16, PATHING_TYPE_WALKABILITY, true)
        call SetTerrainPathable(x - 16, y - 16, PATHING_TYPE_WALKABILITY, true)
        call SetTerrainPathable(x + 16, y - 16, PATHING_TYPE_WALKABILITY, true)
        call SetTerrainPathable(x - 16, y + 16, PATHING_TYPE_WALKABILITY, true)
        call RemoveDestructable(d)
    elseif i == NO_MOVEMENT then
        set x = GetWidgetX(d)
        set y = GetWidgetY(d)
        call SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x, y, PATHING_TYPE_FLYABILITY, false)
        call RemoveDestructable(d)
    elseif i == NO_MOVEMENT_LARGE then
        set x = GetWidgetX(d)
        set y = GetWidgetY(d)
        call SetTerrainPathable(x + 16, y + 16, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x - 16, y - 16, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x + 16, y - 16, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x - 16, y + 16, PATHING_TYPE_WALKABILITY, false)
        call SetTerrainPathable(x + 16, y + 16, PATHING_TYPE_FLYABILITY, false)
        call SetTerrainPathable(x - 16, y - 16, PATHING_TYPE_FLYABILITY, false)
        call SetTerrainPathable(x + 16, y - 16, PATHING_TYPE_FLYABILITY, false)
        call SetTerrainPathable(x - 16, y + 16, PATHING_TYPE_FLYABILITY, false)
        call RemoveDestructable(d)
    endif
    set d = null
    return false
endfunction

private function Init takes nothing returns nothing
    local rect r = GetWorldBounds()
    call EnumDestructablesInRect(r, Filter(function Replace), null)
    call DestroyBoolExpr(Filter(function Replace))
    call RemoveRect(r)
    set r = null
endfunction

endlibrary

