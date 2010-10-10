library InitWaypoins

    module InitWaypoints
        /*
        
        Separated for readability, this initializes all the Waypoints with their adjacent Waypoints in each direction
        
        */
    
        static method onInit takes nothing returns nothing
            set Waypoint.Z[0] = Waypoint.create(gg_rct_NW_Main)
            set Waypoint.Z[1] = Waypoint.create(gg_rct_NW_Main_Top)
            set Waypoint.Z[2] = Waypoint.create(gg_rct_SE_Main)
            set Waypoint.Z[3] = Waypoint.create(gg_rct_SE_Main_Bot)
            set Waypoint.Z[4] = Waypoint.create(gg_rct_NW_SmDelt_Main)
            set Waypoint.Z[5] = Waypoint.create(gg_rct_NW_Nat_Bridge_Loop_W)
            set Waypoint.Z[6] = Waypoint.create(gg_rct_N_Fire)
            set Waypoint.Z[7] = Waypoint.create(gg_rct_N_Br_Bridge)
            set Waypoint.Z[8] = Waypoint.create(gg_rct_SE_Loop_W)
            set Waypoint.Z[9] = Waypoint.create(gg_rct_SE_Left_Split)
            set Waypoint.Z[10] = Waypoint.create(gg_rct_SE_Right_Split)
            set Waypoint.Z[11] = Waypoint.create(gg_rct_SE_Loop_E)
            set Waypoint.Z[12] = Waypoint.create(gg_rct_Mid_Delta)
            set Waypoint.Z[13] = Waypoint.create(gg_rct_Mid_Bridge_Delta_Tree)
            set Waypoint.Z[14] = Waypoint.create(gg_rct_Mid_Bridge_Tree)
            set Waypoint.Z[15] = Waypoint.create(gg_rct_Mid_SmDelt_Bridge_Tree)
            set Waypoint.Z[16] = Waypoint.create(gg_rct_W_Bridges_Tree)
            set Waypoint.Z[17] = Waypoint.create(gg_rct_W_Bridges)
            set Waypoint.Z[18] = Waypoint.create(gg_rct_SW_Shop)
            set Waypoint.Z[19] = Waypoint.create(gg_rct_S_Tree)
            set Waypoint.Z[20] = Waypoint.create(gg_rct_W_Tree)
            set Waypoint.Z[21] = Waypoint.create(gg_rct_E_Tree)
            set Waypoint.Z[22] = Waypoint.create(gg_rct_N_Bridge_Delta)
            set Waypoint.Z[23] = Waypoint.create(gg_rct_N_Side2Loop)
            set Waypoint.Z[24] = Waypoint.create(gg_rct_N_Shop)
            
            
        //Structs have been attached.  Now, NW, SE rects need to be set
        //01
            //NW
                call Waypoint.Z[0].add(0,gg_rct_NW_Flag)
                set Waypoint.Z[0].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[0].add(1,gg_rct_NW_SmDelt_Main)
                call Waypoint.Z[0].add(1,gg_rct_N_Side2Loop)
                set Waypoint.Z[0].adjacent[1].nonLooping = 0
        //02
            //NW
                call Waypoint.Z[1].add(0,gg_rct_NW_Flag)
                set Waypoint.Z[1].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[1].add(1,gg_rct_NW_Main)
                call Waypoint.Z[1].add(1,gg_rct_N_Fire)
                call Waypoint.Z[1].add(1,gg_rct_NW_Nat_Bridge_Loop_W)
                set Waypoint.Z[1].adjacent[1].nonLooping = 3
        //03
            //NW
                call Waypoint.Z[2].add(0,gg_rct_SE_Right_Split)
                call Waypoint.Z[2].add(0,gg_rct_SE_Left_Split)
                set Waypoint.Z[2].adjacent[0].nonLooping = 0
            //SE
                call Waypoint.Z[2].add(1,gg_rct_SE_Flag)
                set Waypoint.Z[2].adjacent[1].nonLooping = 1
        //04
            //NW
                call Waypoint.Z[3].add(0,gg_rct_SE_Main)
                call Waypoint.Z[3].add(0,gg_rct_SE_Loop_E)
                call Waypoint.Z[3].add(0,gg_rct_SE_Loop_W)
                set Waypoint.Z[3].adjacent[0].nonLooping = 3
            //SE
                call Waypoint.Z[3].add(1,gg_rct_SE_Flag)
                set Waypoint.Z[3].adjacent[1].nonLooping = 1
        //05
            //NW
                call Waypoint.Z[4].add(0,gg_rct_NW_Nat_Bridge_Loop_W)
                call Waypoint.Z[4].add(0,gg_rct_NW_Main)
                set Waypoint.Z[4].adjacent[0].nonLooping = 2
            //SE
                call Waypoint.Z[4].add(1,gg_rct_Mid_SmDelt_Bridge_Tree)
                set Waypoint.Z[4].adjacent[1].nonLooping = 1
        //06
            //NW
                call Waypoint.Z[5].add(0,gg_rct_NW_Main_Top)
                call Waypoint.Z[5].add(0,gg_rct_NW_SmDelt_Main)
                set Waypoint.Z[5].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[5].add(1,gg_rct_W_Bridges)
                call Waypoint.Z[5].add(1,gg_rct_NW_SmDelt_Main)
                set Waypoint.Z[5].adjacent[1].nonLooping = 1
        //07
            //NW
                call Waypoint.Z[6].add(0,gg_rct_NW_Main_Top)
                call Waypoint.Z[6].add(0,gg_rct_N_Side2Loop)
                set Waypoint.Z[6].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[6].add(1,gg_rct_N_Br_Bridge)
                call Waypoint.Z[6].add(1,gg_rct_N_Side2Loop)
                set Waypoint.Z[6].adjacent[1].nonLooping = 1
        //08
            //NW
                call Waypoint.Z[7].add(0,gg_rct_N_Fire)
                call Waypoint.Z[7].add(0,gg_rct_N_Shop)
                set Waypoint.Z[7].adjacent[0].nonLooping = 2
            //SE
                call Waypoint.Z[7].add(1,gg_rct_SE_Loop_E)
                call Waypoint.Z[7].add(1,gg_rct_Mid_Delta)
                set Waypoint.Z[7].adjacent[1].nonLooping = 2
        //09
            //NW
                call Waypoint.Z[8].add(0,gg_rct_SE_Left_Split)
                call Waypoint.Z[8].add(0,gg_rct_S_Tree)
                set Waypoint.Z[8].adjacent[0].nonLooping = 2
            //SE
                call Waypoint.Z[8].add(1,gg_rct_SE_Main_Bot)
                call Waypoint.Z[8].add(1,gg_rct_SE_Left_Split)
                set Waypoint.Z[8].adjacent[1].nonLooping = 1
        //10
            //NW
                call Waypoint.Z[9].add(0,gg_rct_E_Tree)
                call Waypoint.Z[9].add(0,gg_rct_SE_Main)
                set Waypoint.Z[9].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[9].add(1,gg_rct_SE_Main)
                call Waypoint.Z[9].add(1,gg_rct_SE_Loop_W)
                set Waypoint.Z[9].adjacent[1].nonLooping = 1
        //11
            //NW
                call Waypoint.Z[10].add(0,gg_rct_Mid_Delta)
                call Waypoint.Z[10].add(0,gg_rct_SE_Loop_E)
                set Waypoint.Z[10].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[10].add(1,gg_rct_SE_Main)
                call Waypoint.Z[10].add(1,gg_rct_SE_Loop_E)
                set Waypoint.Z[10].adjacent[1].nonLooping = 1
        //12
            //NW
                call Waypoint.Z[11].add(0,gg_rct_N_Br_Bridge)
                call Waypoint.Z[11].add(0,gg_rct_SE_Right_Split)
                set Waypoint.Z[11].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[11].add(1,gg_rct_SE_Main_Bot)
                call Waypoint.Z[11].add(1,gg_rct_SE_Right_Split)
                set Waypoint.Z[11].adjacent[1].nonLooping = 1
        //13
            //NW
                call Waypoint.Z[12].add(0,gg_rct_N_Bridge_Delta)
                call Waypoint.Z[12].add(0,gg_rct_N_Br_Bridge)
                set Waypoint.Z[12].adjacent[0].nonLooping = 2
            //SE
                call Waypoint.Z[12].add(1,gg_rct_SE_Right_Split)
                call Waypoint.Z[12].add(1,gg_rct_Mid_Bridge_Delta_Tree)
                set Waypoint.Z[12].adjacent[1].nonLooping = 2
        //14
            //NW
                call Waypoint.Z[13].add(0,gg_rct_Mid_Delta)
                call Waypoint.Z[13].add(0,gg_rct_Mid_Bridge_Tree)
                call Waypoint.Z[13].add(0,gg_rct_Mid_SmDelt_Bridge_Tree)
                set Waypoint.Z[13].adjacent[0].nonLooping = 3
            //SE
                call Waypoint.Z[13].add(1,gg_rct_E_Tree)
                call Waypoint.Z[13].add(1,gg_rct_S_Tree)
                set Waypoint.Z[13].adjacent[1].nonLooping = 2
        //15
            //NW
                call Waypoint.Z[14].add(0,gg_rct_N_Bridge_Delta)
                call Waypoint.Z[14].add(0,gg_rct_Mid_SmDelt_Bridge_Tree)
                set Waypoint.Z[14].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[14].add(1,gg_rct_Mid_Bridge_Delta_Tree)
                call Waypoint.Z[14].add(1,gg_rct_Mid_SmDelt_Bridge_Tree)
                set Waypoint.Z[14].adjacent[1].nonLooping = 1
        //16
            //NW
                call Waypoint.Z[15].add(0,gg_rct_NW_SmDelt_Main)
                call Waypoint.Z[15].add(0,gg_rct_Mid_Bridge_Tree)
                set Waypoint.Z[15].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[15].add(1,gg_rct_W_Bridges_Tree)
                call Waypoint.Z[15].add(1,gg_rct_Mid_Bridge_Delta_Tree)
                call Waypoint.Z[15].add(1,gg_rct_W_Bridges_Tree)
                set Waypoint.Z[15].adjacent[1].nonLooping = 2
        //17
            //NW
                call Waypoint.Z[16].add(0,gg_rct_W_Bridges)
                call Waypoint.Z[16].add(0,gg_rct_Mid_SmDelt_Bridge_Tree)
                set Waypoint.Z[16].adjacent[0].nonLooping = 2
            //SE
                call Waypoint.Z[16].add(1,gg_rct_S_Tree)
                call Waypoint.Z[16].add(1,gg_rct_W_Tree)
                set Waypoint.Z[16].adjacent[1].nonLooping = 2
        //18
            //NW
                call Waypoint.Z[17].add(0,gg_rct_NW_Nat_Bridge_Loop_W)
                set Waypoint.Z[17].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[17].add(1,gg_rct_W_Bridges_Tree)
                call Waypoint.Z[17].add(1,gg_rct_SW_Shop)
                set Waypoint.Z[17].adjacent[1].nonLooping = 2
        //19
            //NW
                call Waypoint.Z[18].add(0,gg_rct_W_Bridges)
                call Waypoint.Z[18].add(0,gg_rct_W_Tree)
                set Waypoint.Z[18].adjacent[0].nonLooping = 2
            //SE
                call Waypoint.Z[18].add(1,gg_rct_S_Tree)
                set Waypoint.Z[18].adjacent[1].nonLooping = 1
        //20
            //NW
                call Waypoint.Z[19].add(0,gg_rct_W_Bridges_Tree)
                call Waypoint.Z[19].add(0,gg_rct_W_Tree)
                call Waypoint.Z[19].add(0,gg_rct_Mid_Bridge_Delta_Tree)
                call Waypoint.Z[19].add(0,gg_rct_SW_Shop)
                set Waypoint.Z[19].adjacent[0].nonLooping = 4
            //SE
                call Waypoint.Z[19].add(1,gg_rct_SE_Loop_W)
                set Waypoint.Z[19].adjacent[1].nonLooping = 1
        //21
            //NW
                call Waypoint.Z[20].add(0,gg_rct_W_Bridges_Tree)
                call Waypoint.Z[20].add(0,gg_rct_Mid_Bridge_Delta_Tree)
                set Waypoint.Z[20].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[20].add(1,gg_rct_S_Tree)
                call Waypoint.Z[20].add(1,gg_rct_SW_Shop)
                set Waypoint.Z[20].adjacent[1].nonLooping = 1
        //22
            //NW
                call Waypoint.Z[21].add(0,gg_rct_Mid_Bridge_Delta_Tree)
                call Waypoint.Z[21].add(0,gg_rct_W_Bridges_Tree)
                set Waypoint.Z[21].adjacent[0].nonLooping = 2
            //SE
                call Waypoint.Z[21].add(1,gg_rct_SE_Left_Split)
                set Waypoint.Z[21].adjacent[1].nonLooping = 1
        //23
            //NW
                call Waypoint.Z[22].add(0,gg_rct_N_Side2Loop)
                set Waypoint.Z[22].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[22].add(1,gg_rct_Mid_Delta)
                call Waypoint.Z[22].add(1,gg_rct_Mid_Bridge_Tree)
                set Waypoint.Z[22].adjacent[1].nonLooping = 2
        //24
            //NW
                call Waypoint.Z[23].add(0,gg_rct_NW_Main)
                call Waypoint.Z[23].add(0,gg_rct_N_Fire)
                set Waypoint.Z[23].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[23].add(1,gg_rct_N_Bridge_Delta)
                call Waypoint.Z[23].add(1,gg_rct_N_Fire)
                set Waypoint.Z[23].adjacent[1].nonLooping = 1
        //25
            //NW
                call Waypoint.Z[24].add(0,gg_rct_N_Fire)
                set Waypoint.Z[24].adjacent[0].nonLooping = 1
            //SE
                call Waypoint.Z[24].add(1,gg_rct_N_Br_Bridge)
                set Waypoint.Z[24].adjacent[1].nonLooping = 1
        endmethod
    
    endmodule

endlibrary