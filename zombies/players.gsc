/*
    File:           players.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/

init()
{
    [[ level.register ]]( "player_connect", ::player_connect );
    [[ level.register ]]( "player_disconnect", ::player_disconnect );
    [[ level.register ]]( "player_damage", ::player_damage, level.iFLAG_THREAD );
    [[ level.register ]]( "player_killed", ::player_killed );
    [[ level.register ]]( "spawn_player", ::spawn_player, level.iFLAG_THREAD );
    [[ level.register ]]( "spawn_spectator", ::spawn_spectator, level.iFLAG_THREAD );
    [[ level.register ]]( "spawn_intermission", ::spawn_intermission, level.iFLAG_THREAD );
    [[ level.register ]]( "respawn", ::respawn, level.iFLAG_THREAD );
    [[ level.register ]]( "pick_zombie", ::pick_zombie );
    [[ level.register ]]( "make_zombie", ::make_zombie );
    [[ level.register ]]( "drop_health", ::drop_health );
    [[ level.register ]]( "cvar_watcher", ::cvar_watcher );
}

player_connect( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    level notify( "player_connecting", self );
    
    self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill( "begin" );
	self.statusicon = "";
    
    level notify( "player_connected", self );
    
    // remove "box" chars from name that crash linux servers
    self [[ level.call ]]( "name_fix", self.name );
    
    self setClientCvar( "r_fastsky", "1" );
    
    self [[ level.call ]]( "get_stats" );
      
    // force them to the scoreboard if they joined on map change
    if ( level.iGameFlags & level.iFLAG_GAME_INTERMISSION )
    {
        self [[ level.call ]]( "spawn_intermission" );
        return;
    }
    
    [[ level.call ]]( "print", self.name + " connected." );
    
    self setClientCvar("g_scriptMainMenu", game["menu_team"]);
    self setClientCvar("scr_showweapontab", "0");

    if(!isdefined(self.pers["team"]))
        self openMenu(game["menu_team"]);
        
    self [[ level.call ]]( "set_team", "spectator" );
    self [[ level.call ]]( "spawn_spectator" );
    self [[ level.call ]]( "menu_handler" );
    self [[ level.call ]]( "cvar_watcher" );
}

player_disconnect( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{  
}

player_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc )
{
    if ( isPlayer( eAttacker ) && eAttacker != self )
    {
        // pre-damage check for medics
        if ( eAttacker.pers[ "team" ] == "axis" && self.pers[ "team" ] == "axis" && eAttacker.class == "medic" && sMeansOfDeath == "MOD_MELEE" && [[ level.call ]]( "get_weapon_type", sWeapon ) == "grenade" )
        {
            if ( self.health < self.maxhealth - 10 )
                self.health += 10;
        }
        
        // disable friendlyfire and specnades
        if ( eAttacker.pers[ "team" ] == "spectator" || eAttacker.pers[ "team" ] == self.pers[ "team" ] || ( eAttacker.pers[ "team" ] == "allies" && [[ level.call ]]( "get_weapon_type", sWeapon ) == "grenade" ) )
            return;
            
        // spawnprotection
        if ( isDefined( self.spawnprotection ) )
            return;
    }

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
        
    self.lasthittime = gettime();
        
    distanceModifier = 1;
    resistanceModifier = 1;
    splashModifier = 1;   
    
    /*
    if ( sMeansOfDeath == "MOD_FALLING" && self.pers[ "team" ] == "allies" && self.class == "jumper" )
        iDamage = iDamage / 2;
    */
    if ( sMeansOfDeath != "MOD_FALLING" )
    {       
        // specific checks for hunters
        if ( self.pers[ "team" ] == "axis" )
        {
            // 'soldiers' don't take as much damage to explosives
            if ( self.class == "soldier" )
            {
                if ( sWeapon == "panzerfaust_mp" )
                    self.health += iDamage * 1.3;
                
                if ( sMeansOfDeath == "MOD_EXPLOSION_SPLASH" || sMeansOfDeath == "MOD_GRENADE_SPLASH" )
                    resistanceModifier = 0.5;
            }
            
            // did i just get hit by a zombie?
            if ( isPlayer( eAttacker ) && eAttacker.pers[ "team" ] == "allies" )
            {
                // poison zombie?
                if ( eAttacker.class == "poison" && !isDefined( self.ispoisoned ) )
                    self [[ level.call ]]( "be_poisoned", eAttacker );
                else if ( eAttacker.class == "shocker" )
                    self [[ level.call ]]( "be_shocked", eAttacker );
            }
        }
        
        // specific checks for zombais
        if ( self.pers[ "team" ] == "allies" )
        {
            // did i just get hit by a hunter?
            if ( isPlayer( eAttacker ) && eAttacker.pers[ "team" ] == "axis" )
            {
                if ( sMeansOfDeath == "MOD_MELEE" )
                    self shellshock( "default", 1 ); 
                    
                // since melee damage is up close anyways, we'll do the full amount
                if ( sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_EXPLOSION_SPLASH" && sMeansOfDeath != "MOD_GRENADE_SPLASH" && sWeapon != "mg42_bipod_stand_mp" ) 
                {
                    dist = distance( eAttacker.origin, self.origin );
                        
                    maxdist = 1024;
                    distanceModifier = ( (maxdist/2) - dist ) / maxdist + 1;
                    if ( dist > maxdist )
                        distanceModifier = 0.5;
                        
                    distanceModifier += randomFloat( 0.2 );
                }
                
                // no distancemodifier for snipers, also nerf the body shots :)
                if ( eAttacker.class == "sniper" && sWeapon == "kar98k_sniper_mp" )
                {
                    distanceModifier = 1;
                    
                    if ( sHitLoc != "head" && sHitLoc != "neck" && sHitLoc != "helmet" )
                        resistanceModifier = 0.5;
                }
            }
        }
    }
    
    // damage = base * (distance + randomness modifier) * (resistance + vulnerability modifier) * (splash)
    finalDamage = iDamage * distanceModifier * resistanceModifier * splashModifier;

	self finishPlayerDamage( eInflictor, eAttacker, finalDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
}

player_killed( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, o8, o9 )
{
	self endon("spawned");
	
	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";
		
	// send out an obituary message to all clients about the kill
    // only show if we're not on hardcore
    if ( ( level.iGamemode & level.iFLAG_GAMEMODE_HARDCORE ) == 0 )
        obituary(self, eAttacker, sWeapon, sMeansOfDeath);
	
	self.sessionstate = "dead";
	self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.headicon = "";
	self.deaths++;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	eAttackerNum = -1;
	if(isPlayer(eAttacker))
	{
        eAttackerNum = eAttacker getEntityNumber();
        
		if(eAttacker == self) // killed himself
		{
			doKillcam = false;

			eAttacker.score--;
			
			if(isdefined(eAttacker.reflectdamage))
				clientAnnouncement(eAttacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
		}
		else
		{
			doKillcam = true;

			if(self.pers["team"] == eAttacker.pers["team"]) // killed by a friendly
				eAttacker.score--;
			else
			{
				eAttacker.score++;

				teamscore = getTeamScore(eAttacker.pers["team"]);
				teamscore++;
				setTeamScore(eAttacker.pers["team"], teamscore);
			}
		}

		lpattacknum = eAttacker getEntityNumber();
		lpattackname = eAttacker.name;
		lpattackerteam = eAttacker.pers["team"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;
		
		self.score--;

		lpattacknum = -1;
		lpattackname = "";
		lpattackerteam = "world";
	}
                
    // Stop thread if map ended on this death
    if ( level.iGameFlags & level.iFLAG_GAME_OVER )
        return;
        
    if ( isPlayer( eAttacker ) )
        level.lastkiller = eAttacker;
        
    if ( self.pers[ "team" ] == "axis" && ( level.iGameFlags & level.iFLAG_GAME_STARTED ) )
        self [[ level.call ]]( "make_zombie" );
        
	// Make the player drop health
	//self [[ level.call ]]( "drop_health" );

	body = self cloneplayer();

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if(getcvarint("scr_forcerespawn") > 0)
		doKillcam = false;

    if ( !isDefined( self.bSkipRespawn ) && ( level.iGameFlags & level.iFLAG_GAME_OVER ) == 0 )
    {
        if ( doKillcam )
            self [[ level.call ]]( "killcam", eAttackerNum, delay );
        else
            self [[ level.call ]]( "respawn" );
    }
}

spawn_player( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    self.lol = spawn( "script_model", self getorigin() );
    self linkto( self.lol );

	self.sessionteam = self.pers[ "team" ];
    self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.archivetime = 0;
    
    if ( !isDefined( self.class ) )
        self [[ level.call ]]( "classes_main" );
        
    if ( !isDefined( self.class ) )
        return;
        
    if ( self.pers[ "team" ] == "axis" && self.class == "default" )
        self [[ level.call ]]( "classes_hunter_default" );
        
    self notify("spawned");
	self notify("end_respawn");
	self notify( "player_spawned" );
	
	resettimeout();
    
    self.bSkipRespawn = undefined;
    self.pickedFirst = undefined;
	self.sessionstate = "playing";
		
	spawnpointname = "mp_teamdeathmatch_spawn";
	spawnpoint = [[ level.call ]]( "get_spawnpoint_nearteam", getentarray( spawnpointname, "classname" ) );

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		[[ level.call ]]( "error", "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );

	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
    self.lasthittime = 0;
    self.spawnprotection = true;
    
    self detachall();

    self [[ level.call ]]( "classes_loadout" );
	
    if ( self.pers[ "team" ] == "allies" )
    {
        if ( level.bFirstZombie ) 
        {
            self.maxhealth += 1000;
            self.health = self.maxhealth;
        }

        self.voicetype = game[ "allies" ];
        self.headicon = game["headicon_allies"];
        self.headiconteam = "allies";
		self thread explode_from_ground();
    }
    else if ( self.pers[ "team" ] == "axis" )
    {
        self.voicetype = game[ "axis" ];
        self.headicon = game["headicon_axis"];
        self.headiconteam = "axis";
        
        // default nubs :>
        if ( self.class == "default" ) 
        {
            self giveWeapon( self.pers[ "weapon" ] );
            self setSpawnWeapon( self.pers[ "weapon" ] );
            self giveMaxAmmo( self.pers[ "weapon" ] );
            self setWeaponSlotClipAmmo( "primary", 0 );
            
            self [[ level.call ]]( "classes_hunter_default_loadout" );
        }
    }
    
    self.statusicon = "";
    
    self [[ level.call ]]( "model_setup" );
    self [[ level.call ]]( "player_hud" );
    self thread spawnprotection();
}

spawn_spectator( origin, angles, o3, o4, o5, o6, o7, o8, o9 )
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

    self.sessionteam = "spectator";
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.reflectdamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";
	
	if(isdefined(origin) && isdefined(angles))
		self spawn(origin, angles);
	else
	{
        spawnpointname = "mp_teamdeathmatch_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self setClientCvar("cg_objectiveText", &"TDM_ALLIES_KILL_AXIS_PLAYERS");
}

spawn_intermission( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

 	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.reflectdamage = undefined;

	spawnpointname = "mp_teamdeathmatch_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

respawn( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
	if(!isdefined(self.pers["weapon"]))
		return;

    self endon("end_respawn");
	
	if(getcvarint("scr_forcerespawn") > 0)
	{
		self thread waitForceRespawnTime();
		self thread waitRespawnButton();
		self waittill("respawn");
	}
	else
	{
		self thread waitRespawnButton();
		self waittill("respawn");
	}
	
	self [[ level.call ]]( "spawn_player" );
}

waitForceRespawnTime()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait getcvarint("scr_forcerespawn");
	self notify("respawn");
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	self.respawntext = newClientHudElem(self);
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 320;
	self.respawntext.y = 70;
	self.respawntext.archived = false;
	self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while(self useButtonPressed() != true)
		wait .05;
	
	self notify("remove_respawntext");

	self notify("respawn");	
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isdefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}

pick_zombie( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    aGoodPlayers = [[ level.call ]]( "get_good_players" );
    iInt = [[ level.call ]]( "rand", aGoodPlayers.size );
    eGuy = aGoodPlayers[ iInt ];
    
    while ( eGuy.name == getCvar( "lastzom" ) )
    {
        [[ level.call ]]( "print", eGuy.name + "^7 was the zombie last time... picking someone else..." );
        wait 2;
        iInt = [[ level.call ]]( "rand", aGoodPlayers.size );
        eGuy = aGoodPlayers[ iInt ];
    }
    
    [[ level.call ]]( "print", eGuy.name + "^7 was randomly selected to be the zombie!", true );
    eGuy.bSkipRespawn = true;
    eGuy.pickedFirst = true;
    eGuy [[ level.call ]]( "make_zombie" );
    setCvar( "lastzom", eGuy.name );
}

make_zombie( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    self [[ level.call ]]( "set_team", "zombies" );
    self.class = undefined;    
    if ( isDefined( self.bSkipRespawn ) && self.bSkipRespawn )
        self [[ level.call ]]( "spawn_player" );
}

drop_health()
{
	if ( isdefined( level.aHealthQueue[ level.iHealthQueueCurrent ] ) )
		level.aHealthQueue[ level.iHealthQueueCurrent ] [[ level.call ]]( "delete" );
	
	level.aHealthQueue[ level.iHealthQueueCurrent ] = [[ level.call ]]( "spawn", "item_health", self.origin + ( 0, 0, 1 ) );
	level.aHealthQueue[ level.iHealthQueueCurrent ].angles = ( 0, randomint( 360 ), 0 );

	level.iHealthQueueCurrent++;
	
	if ( level.iHealthQueueCurrent >= 16 )
		level.iHealthQueueCurrent = 0;
}

explode_from_ground()
{
    playFx( level._effect[ "zombies_groundexplode" ], self getOrigin() );
    
    self.exp = spawn( "script_model", self getOrigin() );
    self linkto( self.exp );
    
    self.exp movez( -50, 0.05 );
    wait 0.1;
    
    self.exp movez( 52, 0.5 );
    wait 0.5;
    
    self.exp delete();
}

spawnprotection()
{
    self endon( "death" );
    
    self iPrintLn( "^3Spawn protection enabled." );
    
    wait 1;
    
    time = 0;
    
    while ( time < 5 )
    {
        if ( self attackbuttonpressed() || self meleebuttonpressed() )
            break;
            
        time += 0.05;
        wait 0.05;
    }
    
    self.spawnprotection = undefined;
    
    self iPrintLn( "^3Spawn protection disabled." );
}

cvar_watcher()
{
    self endon( "disconnect" );
    
    while ( 1 )
    {
        self setClientCvar( "r_fastsky", "1" );
        self setClientCvar( "r_nv_fogdist_mode", "GL_EYE_RADIAL_NV" );
        self setClientCvar( "r_fog", "1" );
        self setClientCvar( "weapon", "1" );
        
        wait 1;
    }
}