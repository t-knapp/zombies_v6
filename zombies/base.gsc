/*
    File:           base.gsc
    Author:         Cheese
    Last update:    11/19/2012
*/

init()
{
    [[ level.register ]]( "main", ::main );
    [[ level.register ]]( "start_gametype", ::start_gametype );
    [[ level.register ]]( "rotate_if_empty", ::rotate_if_empty, level.iFLAG_THREAD );
    [[ level.register ]]( "game_logic", ::game_logic, level.iFLAG_THREAD );
    [[ level.register ]]( "end_map", ::end_map, level.iFLAG_THREAD );
    
    [[ level.call ]]( "precache", &"^7Players needed until game starts: ^1", "string" );
    
    // globals
    level.bDebug = [[ level.call ]]( "get_server_setting", "debug", 1, "int", 0, 1 );
    level.iTimelimit = [[ level.call ]]( "get_server_setting", "scr_zom_timelimit", 30, "int", 0, 1440 );
    level.iDrawFriend = [[ level.call ]]( "get_server_setting", "scr_drawfriend", 1, "int", 0, 1 );
    level.aHealthQueue = [];
    level.iHealthQueueCurrent = 0;
    level.aSpawnedObjects = [];
    level.bFirstZombie = false;
    level.claymores = 0;
    level.gametype = "zom";
    
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
    
    [[ level.call ]]( "rotate_if_empty" );
    
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
    
    level notify( "stop_rotate_if_empty" );
    
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
    level.gamestarted = true;
    
    level.iGameFlags = level.iFLAG_GAME_STARTED;
    
    wait 2;
	level.iStartTime = getTime();
    
    [[ level.call ]]( "game_logic" );
	
	if ( level.iTimeLimit > 0 )
	{
		level.clock = newHudElem();
		level.clock.x = 320;
		level.clock.y = 10;
		level.clock.alignX = "center";
		level.clock.alignY = "middle";
		level.clock.font = "bigfixed";
		level.clock setTimer(level.iTimeLimit * 60);
        level.clock.color = ( 0, 1, 0 );
	}
	
	for ( ;; )
	{
		check_time_limit();
		wait 1;
	}
}

rotate_if_empty()
{
	level endon( "stop_rotate_if_empty" );
	
	time = 0;
	
	while ( time < 1200 )
	{
		time++;
		wait 1;
	}
	
	exitLevel( false );
}

// basically, i don't use this at all
// it's merely here so the "game code" has someplace to go
start_gametype( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
}

game_logic()
{
    level endon( "intermission" );
    
    while ( 1 )
    {
        // returns all players, including ones who do not have a sessionstate of 'playing'
        aPlayers = [[ level.call ]]( "get_good_players", true );
        
        aZombies =[];
        aHunters = [];
        
        for ( i = 0; i < aPlayers.size; i++ )
        {
            if ( aPlayers[ i ].pers[ "team" ] == "allies" )
                aZombies[ aZombies.size ] = aPlayers[ i ];
            else if ( aPlayers[ i ].pers[ "team" ] == "axis" )
                aHunters[ aHunters.size ] = aPlayers[ i ];
        }
        
        // have all the zombies left? pick a new one
        if ( aZombies.size == 0 && aHunters.size > 0 )
        {
            [[ level.call ]]( "pick_zombie" );
            wait 1;
        }
        
        // only one zombie? give them a health bonus!
        if ( aZombies.size == 1 && !level.bFirstZombie )
            level.bFirstZombie = true;
        if ( aZombies.size > 1 && level.bFirstZombie )
            level.bFirstZombie = false;
        
        // only one hunter left? last hunter time!
        
        // have all the hunters died?
        if ( aHunters.size == 0 && aZombies.size > 0 )
        {
            [[ level.call ]]( "end_map", "zombies" );
            break;
        }
        
        wait 1;
    }
}

end_map( sWinner )
{
    // stops the menu_handler() thread on clients
	level notify( "intermission" );
    
    level.clock destroy();
    
    level.iGameFlags = level.iFLAG_GAME_OVER;

    aPlayers = getentarray( "player", "classname" );
    if ( sWinner == "zombies" )
	{
        [[ level.call ]]( "print", "^1Zombies win!", true );
        
        wait 2;
        
		for ( i = 0; i < aPlayers.size; i++ )
		{
			ePlayer = aPlayers[ i ];
			ePlayer closeMenu();
			ePlayer setClientCvar( "g_scriptMainMenu", "main" );
			ePlayer [[ level.call ]]( "gamecam", level.lastKiller getEntityNumber(), 2 );
		}
		
		wait 4.5;
		
		[[ level.call ]]( "slowmo", 3.5 );
	}
    else if ( sWinner == "hunters" )
    {
        [[ level.call ]]( "print", "^6Hunters win!", true );
        
        for ( i = 0; i < aPlayers.size; i++ )
        {
            ePlayer = aPlayers[ i ];
            ePlayer.stats[ "timesSurvived" ]++;
        }
        
        wait 2;
    }
    
    for ( i = 0; i < aPlayers.size; i++ )
	{
		aPlayers[ i ] [[ level.call ]]( "gamecam_remove" );
		
		aPlayers[ i ] [[ level.call ]]( "spawn_spectator" );
		aPlayers[ i ].org = spawn( "script_origin", aPlayers[ i ].origin );
		aPlayers[ i ] linkto( aPlayers[ i ].org );
        aPlayers[ i ] [[ level.call ]]( "save_stats" );
	}
    
    setCullFog( 0, 4000, 0, 0, 0, 5 );
    	  
    // mapvote here
    [[ level.call ]]( "map_vote" );
    
    /*
    
    level.iGameFlags |= level.iFLAG_GAME_INTERMISSION;
    
    aPlayers = getentarray( "player", "classname" );
	for ( i = 0; i < aPlayers.size; i++ )
	{
		ePlayer = aPlayers[ i ];
		ePlayer closeMenu();
		ePlayer setClientCvar( "g_scriptMainMenu", "main" );
		ePlayer setClientCvar( "cg_objectiveText", "SILLY TEXT HERE" );
		ePlayer [[ level.call ]]( "spawn_intermission" );
	}*/

	wait 3;
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

    [[ level.call ]]( "end_map", "hunters" );
}