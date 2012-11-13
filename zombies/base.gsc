/*
    File:           base.gsc
    Author:         Cheese
    Last update:    9/10/2012
*/

init()
{
    [[ level.register ]]( "main", ::main );
    [[ level.register ]]( "start_gametype", ::start_gametype );
    
    [[ level.call ]]( "precache", &"^7Players needed until game starts: ^1", "string" );
    
    // globals
    level.bDebug = [[ level.call ]]( "get_server_setting", "debug", 1, "int", 0, 1 );
    level.iTimelimit = [[ level.call ]]( "get_server_setting", "scr_zom_timelimit", 30, "int", 0, 1440 );
    level.iDrawFriend = [[ level.call ]]( "get_server_setting", "scr_drawfriend", 1, "int", 0, 1 );
    level.aHealthQueue = [];
    level.iHealthQueueCurrent = 0;
    level.aSpawnedObjects = [];
    level.bMapEnded = false;
    
    // no better place to put this :>
    setCvar( "g_TeamColor_Allies", "1 0 0" );
    setCvar( "g_TeamColor_Axis", "1 0 1" );
    setCvar( "g_TeamName_Allies", "Zombies" );
    setCvar( "g_TeamName_Axis", "Hunters" );
    
	[[ level.call ]]( "remove_game_objects" );
    
    sSpawnpointName = "mp_teamdeathmatch_spawn";
	aSpawnpoints = getentarray( sSpawnpointName, "classname");

	if ( aSpawnpoints.size > 0 )
	{
		for ( i = 0; i < aSpawnpoints.size; i++ )
			aSpawnpoints[ i ] placeSpawnpoint();
	}
	else
		[[ level.call ]]( "error", "NO " + sSpawnpointName + " SPAWNPOINTS IN MAP" );
		
	setarchive( true );
    
    [[ level.call ]]( "teams_modeltype" );
}

main()
{
    level.iGameFlags = level.iFLAG_GAME_PREGAME;
    
    hPlayersNeeded = newHudElem();
    hPlayersNeeded.x = 320;
    hPlayersNeeded.y = 240;
    hPlayersNeeded.alignx = "center";
    hPlayersNeeded.aligny = "middle";
    hPlayersNeeded.label = &"^7Players needed until game starts: ^1";
    hPlayersNeeded.fontscale = 0.75;
    
    while ( 1 )
    {
        aPlayers = [[ level.call ]]( "get_good_players" );
        if ( aPlayers.size > 2 )
            break;
            
        hPlayersNeeded setValue( 3 - aPlayers.size );
            
        wait 0.05;
    }
    
    hPlayersNeeded setValue( 0 );
    hPlayersNeeded fadeOverTime( 2 );
    hPlayersNeeded.alpha = 0;
    
    wait 2;
    
    hPlayersNeeded destroy();
    hWarmUp = newHudElem();
    hWarmUp.x = 320;
    hWarmUp.y = 240;
    hWarmUp.alignX = "center";
    hWarmUp.alignY = "middle";
    hWarmUp.font = "bigfixed";
    hWarmUp.label = &"^7Game starts in: ^2";
    hWarmUp setTimer( 45 );
    hWarmUp.color = ( 1, 1, 1 );
    hWarmUp.alpha = 0;
    hWarmUp fadeOverTime( 2 );
    hWarmUp.alpha = 1;
    
    wait 36;
    
    hWarmUp moveOverTime( 10 );
    hWarmUp.y = 10;
    
    wait 6;
    
    hWarmUp fadeOverTime( 4 );
    hWarmUp.alpha = 0;
    
    wait 4;
    
    hWarmUp destroy();
    
    
    [[ level.call ]]( "pick_zombie" );
    
    wait 2;
	level.starttime = getTime();
    level.gamestarted = true;
    
    level.iGameFlags = level.iFLAG_GAME_STARTED;
    
    thread game_logic();
	
	if ( level.timelimit > 0 )
	{
		level.clock = newHudElem();
		level.clock.x = 320;
		level.clock.y = 10;
		level.clock.alignX = "center";
		level.clock.alignY = "middle";
		level.clock.font = "bigfixed";
		level.clock setTimer(level.timelimit * 60);
        level.clock.color = ( 0, 1, 0 );
	}
	
	for ( ;; )
	{
		check_time_limit();
		wait 1;
	}
}

// basically, i don't use this at all
// it's merely here so the "game code" has someplace to go
start_gametype( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
}

game_logic()
{
}

end_map( sWinner )
{
    // stops the menu_handler() thread on clients
	level notify( "intermission" );
    
    level.iGameFlags = level.iFLAG_GAME_OVER;
	
	if ( winner == "zombies" )
    {
        [[ level.call ]]( "print", "Zombies win!", true );
    }
    else if ( winner == "hunters" )
    {
        [[ level.call ]]( "print", "Hunters win!", true );
    }
	  
    // mapvote here
    [[ level.call ]]( "map_vote" );
    
    level.iGameFlags |= level.iFLAG_GAME_INTERMISSION;
    
    aPlayers = getentarray( "player", "classname" );
	for ( i = 0; i < aPlayers.size; i++ )
	{
		ePlayer = aPlayers[ i] ;
		ePlayer closeMenu();
		ePlayer setClientCvar( "g_scriptMainMenu", "main" );
		ePlayer setClientCvar( "cg_objectiveText", "SILLY TEXT HERE" );
		ePlayer [[ level.call ]]( "spawn_intermission" );
	}

	wait 10;
	exitLevel(false);
}

check_time_limit()
{
	if ( level.iTimelimit <= 0 )
		return;
	
	iTimePassed = ( getTime() - level.iStartTime ) / 1000;
	iTimePassed = iTimePassed / 60.0;
	
	if ( iTimePassed < level.iTimelimit )
		return;
	
	if ( level.iGameFlags & level.iFLAG_GAME_OVER )
        return;

    end_map( "hunters" );
}