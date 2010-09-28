library Orders

    globals
        private real tempX
        private real tempY
        private integer tempInt
        private real tempReal1
        private real tempReal2
    endglobals

    module Orders
        
        method getOrders takes nothing returns nothing
        endmethod
        
        method sendOrders takes nothing returns nothing
        endmethod
        
        method runOrders takes nothing returns nothing
            call Debug.PlaceHolder("run Orders: " + I2S(this))
/*            local real heroX = this.hero.x
            local real heroY = this.hero.y
            local real newX
            local real newY
            local Waypoint wp = this.curRect
            if this.objective == 0 then //camp
                set tempReal1 = GetRandomReal(0,300)
                set tempReal2 = GetRandomReal(0,2 * bj_PI)
                set newX = this.team.x + tempReal1 * Cos(tempReal2)
                set newY = this.team.y + tempReal1 * Sin(tempReal2)
            elseif this.objective == 1 then //forward
                if this.sideok then
                    set this.tarRect = wp.getRandomAdjacent(this.team.teamNumber)
                else
                    set this.tarRect = wp.getRandomForward(this.team.teamNumber)                
                endif
                set newX = this.tarRect.x
                set newY = this.tarRect.y
            elseif this.objective == 2 then //protect
                set tempX = this.team.carrier.x
                set tempY = this.team.carrier.y
                set tempReal1 = GetRandomReal(0,300)
                set tempReal2 = GetRandomReal(0,2 * bj_PI)
                set newX = tempX + tempReal1 * Cos(tempReal2)
                set newY = tempY + tempReal1 * Sin(tempReal2)
            elseif this.objective == 3 then //retrieve
                set tempX = this.enemyTeam.carrier.x
                set tempY = this.enemyTeam.carrier.y
                set tempReal1 = GetRandomReal(0,300)
                set tempReal2 = GetRandomReal(0,2 * bj_PI)
                set newX = tempX + tempReal1 * Cos(tempReal2)
                set newY = tempY + tempReal1 * Sin(tempReal2)
            elseif this.objective == 4 then  //rush
                set this.tarRect = wp.getRandomForward(this.team.teamNumber)
                set newX = this.tarRect.x
                set newY = this.tarRect.y
            elseif this.objective == 5 then //return
                set newX = this.team.x
                set newY = this.team.y
            elseif this.objective == 6 then //retrieve
                set newX = this.enemyTeam.x
                set newY = this.enemyTeam.y
            elseif this.objective == 7 then //return/retrieve closest
                set tempReal1 = (this.enemyTeam.x - heroX) * (this.enemyTeam.x - heroX) + (this.enemyTeam.y - heroY) * (this.enemyTeam.y - heroY)
                set tempReal2 = (this.team.x - heroX) * (this.team.x - heroX) + (this.team.y - heroY) * (this.team.y - heroY)
                
                if tempReal1 > tempReal2 then
                    set newX = this.team.x
                    set newY = this.team.y
                else
                    set newX = this.enemyTeam.x
                    set newY = this.enemyTeam.y
                endif
            else //invalid
                debug call BJDebugMsg("Invalid objective: " + I2CN(this) + ", " + I2S(this.objective))
            endif
            call IssuePointOrder(this.hero.unit,"attack",newX,newY)*/
        endmethod
        
        static method RegisterWorldEvent takes nothing returns nothing
            local integer i = 0
            loop
                exitwhen i>= 12
                if AI(i).isEnabled then
                    call Debug.PlaceHolder("World Event, run orders for: " + I2S(i))
                endif
                set i = i + 1
            endloop
        endmethod

    endmodule

endlibrary