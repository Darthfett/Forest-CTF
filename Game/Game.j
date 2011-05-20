library Game uses AIDS,Data,stringFind,stringPlayer,Powerups

globals
    boolean Start = false
    boolean CommandSetup = false
    private sound SND_CAP = CreateSound("Sound\\Interface\\ClanInvitation.wav",false,false,false,10,10,"")
endglobals

struct Game

/* Consider this the main entry point into the game.  Contains basic information about the game, such as the host,
creator, and some generic functions for starting rounds.
*/

    implement Powerups

    static string creatorName = "Darthfett"
    static player creator = null

    static player host = null        
    
    static method pause takes boolean pause returns nothing
        /*
        
        Pauses/Unpauses the game (Units cannot move, are invulnerable)
        TODO: Make this pause all non-hero units as well as heroes.
        
        */
        
        local integer i = 0
        local AI this
        loop
            exitwhen i >= 12
            set this = AI(i)
            set this.hero.paused = pause
            set this.hero.invulnerable = pause
            set i = i + 1
        endloop
    endmethod
    
    private static method removeSummonsFilter takes nothing returns boolean
        /*
        
        Returns true if the GetFilterUnit() is not a hero.  This is assumed to mean it is a summon!
        
        */
        
        local Unit this = Unit[GetFilterUnit()]
        if not this.whichType.isHero and integer(this.owner) < 12 then
            call RemoveUnit(this.unit)
        endif
        return false
    endmethod
    
    static method removeSummons takes nothing returns nothing
        /*
        
        Removes all units that are players' summons or results of power-ups.'
        
        */
    
        call GroupEnumUnitsInRect(ENUM_GROUP,bj_mapInitialPlayableArea,Filter(function Game.removeSummonsFilter))
    endmethod
    
    static method resetFlags takes nothing returns nothing
        /*
        
        Flags are reset (moved back to their origin)

        */
        
        call Flag(0).reset.evaluate()
        call Flag(1).reset.evaluate()
    endmethod
    
    static method startNextRound takes Team winningTeam returns nothing
        /*
        
        The round is reset, with players' heros' mana/cooldowns/hp, summons, and flags all reset.
        
        */
        
        local integer i = 0
        call DestroyTimer(GetExpiredTimer())
        
        call FogMaskEnable(true)
        call FogEnable(true)
        
        loop
            exitwhen i >= 12
            call AI(i).reset.evaluate()
            set i = i + 1
        endloop
        call Game.removeSummons()
        call Game.pause(false)
        call winningTeam.capture.evaluate()
        call Game.resetFlags()
    endmethod
    
    static method finishRound takes Team winningTeam returns nothing
        /*
        
        When a Team captures the flag, the round is reset, after a short victory display.
        
        */
    
        set winningTeam.enemyTeam.carrier.owner.caps = winningTeam.enemyTeam.carrier.owner.caps + 1
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,P2CN(winningTeam.enemyTeam.carrier.owner.whichPlayer) + YELLOW + " has scored for " + END + winningTeam.teamNameColored)
        call Game.pause(true)
        call FogMaskEnable(false)
        call FogEnable(false)
        call PanCameraTo(winningTeam.enemyTeam.carrier.x,winningTeam.enemyTeam.carrier.y)
        call StartTimer(winningTeam,CreateTimer(),5,false,Game.startNextRound)
    endmethod
    
    static method getHost takes nothing returns player
        /*
        
        Gets the host of the game and stores him in a global variable for later access.
        
        */
        
        local gamecache g = InitGameCache("Map.w3v")
        call StoreInteger(g, "Map", "Host", GetPlayerId(GetLocalPlayer ())+1)
        call TriggerSyncStart()
        call SyncStoredInteger(g, "Map", "Host" )
        call TriggerSyncReady()
        set Game.host = Player( GetStoredInteger(g, "Map", "Host" )-1)
        call FlushGameCache(g )
        set g = null
        return Game.host
    endmethod
    
    private static method getCreator takes nothing returns nothing
        /*
        
        If Darthfett is playing, set the global creator player to him.
        
        */
    
        local integer i = 0
        loop
            exitwhen i >= 12
            if StringCase(GetPlayerName(Player(i)),false) == StringCase(Game.creatorName,false) then
                set Game.creator = Player(i)
                return
            endif
            set i = i + 1
        endloop
    endmethod
    
    private static method startAI takes nothing returns nothing
        /*
        
        The bots are started here.
        
        */
    
        local integer i = 0
        call DestroyTimer(GetExpiredTimer())
        loop
            exitwhen i >= 12
            if AI(i).isEnabled then
                // UNIMPLEMENTED: Start the AI
                call BJDebugMsg("Start AI: " + I2S(i))
            endif
            set i = i + 1
        endloop
        call ClearTextMessages()
    endmethod
    
    private static method setupOptions takes nothing returns nothing
        /*
        
        Options selected during setup are actually run, and the game starts players' hero choosing.'
        
        */
    
        local integer i = 0
        call TimerStart(CreateTimer(),0,false,function Game.spawnPowerups)
        if Power_enabled then
            loop
                exitwhen i >= 12
                call SetPlayerState(Player(i),PLAYER_STATE_GOLD_GATHERED,50)
                set i = i + 1
            endloop
            set i = 0
        endif
        if Balance_enabled then
            call Team.balance.evaluate()
        endif
        if AP_enabled then
            call AP_Start()
            loop
                exitwhen i >= 12
                if AI(i).isEnabled then //Bots get a random hero
                    call AI(i).setHero.evaluate(UnitType.getRandomHero())
                endif
                set i = i + 1
            endloop
        else
            loop
                exitwhen i >= 12
                if not AI(i).isEmpty then //All players get a random hero
                    call AI(i).setHero.evaluate(UnitType.getRandomHero())
                endif
                set i = i + 1
            endloop
        endif
    endmethod
        
    private static method start takes nothing returns nothing
        /*
        
        Ending the options selection period gets rid of the black mask, sets up the options, and starts the bots after
        5 seconds.
        
        */
    
        call AbortCinematicFadeBJ()
        call CinematicFadeCommonBJ(0,0,0,2,"ReplaceableTextures\\CameraMasks\\Black_mask.blp",0, 100)
        call FinishCinematicFadeAfterBJ(2)
        call SetTimeOfDayScale(2.5)
        
        set Start = true
        set CommandSetup = false
        call Game.setupOptions()
        call TimerStart(GetExpiredTimer(),5,false,function Game.startAI)
    endmethod
    
    private static method warn takes nothing returns nothing
        /*
        
        If the host doesn't type -skip before the setup period is over, the game will automatically'
        warn players of the game start.
        
        */
    
        if Start then
            call PauseTimer(GetExpiredTimer())
            call DestroyTimer(GetExpiredTimer())
            return
        endif
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,10,RED + "THE GAME IS ABOUT TO BEGIN!" + END)
        call TimerStart(GetExpiredTimer(),2,false,function Game.start)
    endmethod

    static method skip takes nothing returns nothing
        /*
        
        When the host types the -skip command, this function ends the setup period, and warns players of the game start
        
        */
    
        set CommandSetup = false
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,10,RED + "THE GAME IS ABOUT TO BEGIN!" + END)
        call TimerStart(GetExpiredTimer(),2,false,function Game.start)
    endmethod
    
    private static method setup takes nothing returns nothing
    
        /*
        
        Here, we set up some extremely basic stuff that should be done regardless of game-type (such as bounty).
        
        */
    
        local integer i = 0
        loop
            exitwhen i >= 12
            call SetPlayerState(Player(i),PLAYER_STATE_GIVES_BOUNTY,1)
            call SetPlayerHandicapXP(Player(i),1.5)
            set i = i + 1
        endloop
    endmethod
    
    private static method initCategories takes nothing returns nothing
    
        /*
        
        Here, we initialize the Teams, Players (including bots), and Units.  This is done during the options selection.
        
        */
    
        call Team.init.execute()
        call AI.init.execute()
    endmethod
        
    private static method selectOptions takes nothing returns nothing
        /*
        
        Here, the HOST is given a large selection of options to change the gameplay.
        UNIMPLEMENTED: Repeat these options as necessary (perhaps with a -help command)
        TODO: Remove many of the stupid options (Power/Normal mode, rounds, repick)
        TODO: Make a better interface for switching players from team to team, and changing basic game options.
        
        */
    
        set CommandSetup = true
        call ClearTextMessages()
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,YELLOW + "The game will start in 90 seconds. Take this time to select game options." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,BLUE + "-teamselect" + END + YELLOW + " - Enables/Disables players from selecting their team." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,BLUE + "-teamlock" + END + YELLOW + " - Enables/Disables the ability for players to switch teams in-game." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,BLUE + "-huba" + END + YELLOW + " - Enables/Disables autobalancing human players at the beginning/end of rounds." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,BLUE + "-botba" + END + YELLOW + " - Enables/Disables autobalancing teams using bots." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,BLUE + "-balance" + END + YELLOW + " - Enables/Disables the ability for teams to be uneven." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,GREEN + "-normal" + END + YELLOW + " (default) - Switches the game mode to Normal mode." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,GREEN + "-power" + END + YELLOW + " - Switches the game mode to Power mode." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,RED + "-ap" + END + YELLOW + " (default) - All players can choose their hero." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,RED + "-ar" + END + YELLOW + " - All players are given random heroes." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,DARKTEAL + "-rounds " + END + RED + "#" + END + YELLOW + " - sets the number of rounds to " + END + RED + "#" + END + YELLOW + " (default is 3)." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,ORANGE + "-repick" + END + YELLOW + " - Enables/Disables Hero Repick." + END)
        call DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,90,"-skip" + YELLOW + " - Starts the game with the current options." + END)
        call Game.initCategories()
        call Game.setup()
        call TimerStart(GetExpiredTimer(),90,false,function Game.warn)
    endmethod

    private static method loadCredits takes nothing returns nothing
        /*
        
        Here, the credits play with a Black Mask enabled.  This is to allow people with slower computers to load the
        currently large amount of destructables/doodads.
        
        */
    
        call DestroyTimer(GetExpiredTimer())
        //Mask, Credits
        call SetCineFilterTexture("ReplaceableTextures\\CameraMasks\\Black_mask.blp")
        call SetCineFilterBlendMode(BLEND_MODE_NONE)
        call SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
        call SetCineFilterStartUV(0,0,1,1)
        call SetCineFilterEndUV(0,0,1,1)
        call SetCineFilterStartColor(255,255,255,0)
        call SetCineFilterEndColor(0,0,0,255)
        call SetCineFilterDuration(0)
        call DisplayCineFilter(true)
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,"This map was created by: Darthfett")
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,"Terrain by Smith_S9")
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,"=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
        call DisplayTextToPlayer(GetLocalPlayer(),0,0,"The host can select options in 5 seconds...")
        call TimerStart(CreateTimer(),5,false,function Game.selectOptions)
    endmethod
        
    private static method onInit takes nothing returns nothing
        /*
        
        Main Entry point into the game.  Sets up the HOST, CREATOR, and starts the game rolling.
        
        */
        call Game.getCreator()
        call Game.getHost()
        set ENUM_GROUP = CreateGroup()
        call TimerStart(CreateTimer(),0,false,function Game.loadCredits)
    endmethod
    
endstruct

endlibrary