library Waypoint

    struct WaypointArray

        /*

        A WaypointArray is essentially a list of Waypoints, or a path.

        */

        integer top = 1
        Waypoint array whichWaypoint[5]
        integer nonLooping

        method add takes rect which returns nothing
            /*

            Adds a Waypoint to the WaypointArray

            */

            set this.whichWaypoint[this.top] = Waypoint[which]
            set this.top = this.top + 1
        endmethod

        method getRandom takes nothing returns Waypoint
            /*

            Returns a random Waypoint in the WaypointArray

            */

            return this.whichWaypoint[GetRandomInt(1,this.top-1)]
        endmethod

        method getRandomNonLooping takes nothing returns Waypoint
            /*

            Returns a random Waypoint in the WaypointArray, that will not lead back to the path the hero just came from.

            */

            return this.whichWaypoint[GetRandomInt(1,this.nonLooping)]
        endmethod

        method getClosestPath takes real x, real y returns Waypoint
            /*

            Returns the closest Waypoint in the list to the given point

            */

            local integer i = 1
            local real tempR
            local real tempX
            local real tempY
            local Waypoint tempW = this.whichWaypoint[0]
            local real dist = ((tempW.x - x) * (tempW.x - x) + (tempW.y - y) * (tempW.y - y))
            local real which1_x = this.whichWaypoint[0].x
            local real which1_y = this.whichWaypoint[0].y
            local real limit
            loop
                exitwhen i >= this.top
                set tempX = this.whichWaypoint[i].x
                set tempY = this.whichWaypoint[i].y
                if tempW == this.whichWaypoint[0] then
                    set limit = ((tempW.x - tempX) * (tempW.x - tempX) + (tempW.y - tempY) * (tempW.y - tempY))
                    if dist < limit then //if the unit is in-between the "which" waypoint, and this Waypoint,
                        set dist = tempR
                        set tempW = this.whichWaypoint[i]
                    endif
                else
                    set tempR = ((tempX - x) * (tempX - x) + (tempY - y) * (tempY - y))
                    if tempR < dist then //if it's closer to this waypoint than the previous one, this is the new closest waypoint
                        set dist = tempR
                        set tempW = this.whichWaypoint[i]
                    endif
                endif
                set i = i + 1
            endloop
            return tempW
        endmethod

        static method create takes Waypoint which returns WaypointArray
            /*

            Creates a new WaypointArray with a given Waypoint.

            */

            local WaypointArray this = WaypointArray.allocate()
            set this.whichWaypoint[0] = which
            return this
        endmethod
    endstruct

    struct Waypoint

        /*

        A Waypoint is one of the static points of pathing that bots will follow in-game.

        */

        implement InitWaypoints

        static Waypoint array Z [25]
        real x
        real y

        rect whichRect
        region whichRegion

        WaypointArray array adjacent[2]

        trigger onEnter

        method IssueOrder takes unit whichUnit, string order returns nothing
            /*

            Orders a unit to do something with a given Waypoint.

            */

            call IssuePointOrder(whichUnit,order,this.x,this.y)
        endmethod

        method getRandomAdjacent takes integer direction returns Waypoint
            /*

            Gets a random Waypoint that is directly nearby to the current

            */

            return this.adjacent[direction].getRandom()
        endmethod

        method getRandomForward takes integer direction returns Waypoint
            /*

            Gets a random adjacent Waypoint that will lead forward towards the given direction

            */

            return this.adjacent[direction].getRandomNonLooping()
        endmethod

        static method operator[] takes rect whichRect returns Waypoint
            /*

            Given a rect, converts it into its corresponding Waypoint

            */

            return Waypoint(GetData(whichRect))
        endmethod

        method add takes integer direction, rect whichRect returns nothing
            /*

            Adds a Waypoint to the WaypointArray to the given direction of adjacent Waypoints

            */

            call this.adjacent[direction].add(whichRect)
        endmethod

        static method Conditions takes nothing returns boolean
            return true
        endmethod

        static method Actions takes nothing returns nothing
            /*

            This is run whenever a Unit enters the given Waypoint.

            */

            local Waypoint this = Waypoint(GetData(GetTriggeringTrigger()))
        endmethod

        method getClosestPath takes real x, real y, integer direction returns Waypoint
            /*

            Gets the closest Waypoint to the given point in the given direction.

            */

            return this.adjacent[direction].getClosestPath(x,y) //Useful to get the closest point to a unit who needs to resume orders
        endmethod

        static method create takes rect whichRect returns Waypoint
            /*

            Sets up basic data on each Waypoint

            */

            local Waypoint this = Waypoint.allocate()
            set this.whichRect = whichRect
            call SetData(whichRect,this)
            set this.whichRegion = CreateRegion()
            call RegionAddRect(this.whichRegion,whichRect)
            set this.onEnter = CreateTrigger()
            call TriggerRegisterEnterRegion(this.onEnter,this.whichRegion,Filter(function Waypoint.Conditions))
            call TriggerAddAction(this.onEnter,function Waypoint.Actions)
            call SetData(this.onEnter,this)
            set this.adjacent[0] = WaypointArray.create(this)
            set this.adjacent[1] = WaypointArray.create(this)
            set this.x = GetRectCenterX(whichRect)
            set this.y = GetRectCenterY(whichRect)
            return this
        endmethod
    endstruct

endlibrary