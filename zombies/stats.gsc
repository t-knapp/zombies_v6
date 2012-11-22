/*
    File:           stats.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/

init()
{
    [[ level.register ]]( "get_stats", ::get_stats );
    [[ level.register ]]( "update_stats", ::update_stats, level.iFLAG_THREAD );
    
    [[ level.call ]]( "precache", &"^3Retrieving stats...", "string" );
}

get_stats()
{  
    self.stats = [];
    
    // major stats - totals
    self.stats[ "totalZombiesKilled" ] = 0;
    self.stats[ "totalHuntersKilled" ] = 0;
    self.stats[ "totalTimesSurvived" ] = 0;
    self.stats[ "totalZombieDamageDealt" ] = 0;
    self.stats[ "totalHunterDamageDealt" ] = 0;
    self.stats[ "totalPistolKills" ] = 0;
    self.stats[ "totalClaymoreKills" ] = 0;
    self.stats[ "totalSentryKills" ] = 0;
    self.stats[ "totalHeadshotKills" ] = 0;
    self.stats[ "totalMeleeKills" ] = 0;
    self.stats[ "totalHealPoints" ] = 0;
    self.stats[ "totalInfectionsHealed" ] = 0;
    self.stats[ "totalFiresPutOut" ] = 0;
    
    // major stats - this round
    self.stats[ "zombiesKilled" ] = 0;
    self.stats[ "huntersKilled" ] = 0;
    self.stats[ "timesSurvived" ] = 0;
    self.stats[ "zombieDamageDealt" ] = 0;
    self.stats[ "hunterDamageDealt" ] = 0;
    self.stats[ "pistolKills" ] = 0;
    self.stats[ "claymoreKills" ] = 0;
    self.stats[ "sentryKills" ] = 0;
    self.stats[ "headshotKills" ] = 0;
    self.stats[ "meleeKills" ] = 0;
    self.stats[ "healPoints" ] = 0;
    self.stats[ "infectionsHealed" ] = 0;
    self.stats[ "firesPutOut" ] = 0;
    
    // weapon stats
    self.stats[ "weapon_ppsh_mp" ] = 0;
    self.stats[ "weapon_panzerfaust_mp" ] = 0;
    self.stats[ "weapon_mp40_mp" ] = 0;
    self.stats[ "weapon_kar98k_sniper_mp" ] = 0;
    self.stats[ "weapon_mp44_mp" ] = 0;
    self.stats[ "weapon_thompson_mp" ] = 0;
    self.stats[ "weapon_m1garand_mp" ] = 0;
    self.stats[ "weapon_fg42_mp" ] = 0;
    self.stats[ "weapon_bar_mp" ] = 0;
    self.stats[ "weapon_colt_mp" ] = 0;
    self.stats[ "weapon_luger_mp" ] = 0;
    
    if ( getCvar( "skipstats" ) == "1" )
    {
        self.isRegistered = true;
        return;
    }
    
    self.black = newClientHudElem( self );
	self.black.x = 0;
	self.black.y = 0;
	self.black setShader( "black", 640, 480 );
	self.black.sort = 9020;
	
	self.statshud = newClientHudElem( self );
	self.statshud.x = 320;
	self.statshud.y = 240;
	self.statshud.alignx = "center";
	self.statshud.aligny = "middle";
	self.statshud setText( &"^3Retrieving stats..." );
	self.statshud.fontscale = 1.5;
	self.statshud.sort = 9021;
    
    self.isRegistered = false;
	
	infostring = "getinfo " + self getEntityNumber();
    achievementstring = "getachievements " + self getEntityNumber();
	mystats = [[ level.call ]]( "socket_get_handler", infostring ); 
	
	data = [[ level.call ]]( "strtok", mystats, "|" );
	if ( data[ 1 ] == "not registered" || data[ 1 ] == "no stats set" || data[ 1 ] == "broked" || data[ 1 ] == "timeout" ) {
		// not registered, stop here
		self.statshud destroy();
		self.black destroy();
		return;
	}
	
	for ( i = 0; i < data.size; i++ ) {
    /*
Zombies.stats = [
    // major stats
    "zombiesKilled",
    "huntersKilled",
    "timesSurvived",
    "zombieDamageDealt",
    "hunterDamageDealt",
    "pistolKills",
    "claymoreKills",
    "sentryKills",
    "headshotKills",
    "meleeKills",
    
    // weapon stats
    "ppsh_mp",
    "panzerfaust_mp",
    "mp40_mp",
    "kar98k_sniper_mp",
    "mp44_mp",
    "thompson_mp",
    "m1garand_mp",
    "fg42_mp",
    "bar_mp",
    "colt_mp",
    "luger_mp"
];
*/       
        if ( data[ i ] == "zombiesKilled" )         self.stats[ "totalZombiesKilled" ]          = (int)data[ i + 1 ];
        if ( data[ i ] == "huntersKilled" )         self.stats[ "totalHuntersKilled" ]          = (int)data[ i + 1 ];
        if ( data[ i ] == "timesSurvived" )         self.stats[ "totalTimesSurvived" ]          = (int)data[ i + 1 ];
        if ( data[ i ] == "zombieDamageDealt" )     self.stats[ "totalZombieDamageDealt" ]      = (int)data[ i + 1 ];
        if ( data[ i ] == "hunterDamageDealt" )     self.stats[ "totalHunterDamageDealt" ]      = (int)data[ i + 1 ];
        if ( data[ i ] == "pistolKills" )           self.stats[ "totalPistolKills" ]            = (int)data[ i + 1 ];
        if ( data[ i ] == "claymoreKills" )         self.stats[ "totalClaymoreKills" ]          = (int)data[ i + 1 ];
        if ( data[ i ] == "sentryKills" )           self.stats[ "totalSentryKills" ]            = (int)data[ i + 1 ];
        if ( data[ i ] == "headshotKills" )         self.stats[ "totalHeadshotKills" ]          = (int)data[ i + 1 ];
        if ( data[ i ] == "meleeKills" )            self.stats[ "totalMeleeKills" ]             = (int)data[ i + 1 ];
        if ( data[ i ] == "healPoints" )            self.stats[ "totalHealPoints" ]             = (int)data[ i + 1 ];
        if ( data[ i ] == "infectionsHealed" )      self.stats[ "totalInfectionsHealed" ]       = (int)data[ i + 1 ];
        if ( data[ i ] == "firesPutOut" )           self.stats[ "totalFiresPutOut" ]            = (int)data[ i + 1 ];
        if ( data[ i ] == "ppsh_mp" )               self.stats[ "weapon_ppsh_mp" ]              = (int)data[ i + 1 ];
        if ( data[ i ] == "panzerfaust_mp" )        self.stats[ "weapon_panzerfaust_mp" ]       = (int)data[ i + 1 ];
        if ( data[ i ] == "mp40_mp" )               self.stats[ "weapon_mp40_mp" ]              = (int)data[ i + 1 ];
        if ( data[ i ] == "kar98k_sniper_mp" )      self.stats[ "weapon_kar98k_sniper_mp" ]     = (int)data[ i + 1 ];
        if ( data[ i ] == "mp44_mp" )               self.stats[ "weapon_mp44_mp" ]              = (int)data[ i + 1 ];
        if ( data[ i ] == "thompson_mp" )           self.stats[ "weapon_thompson_mp" ]          = (int)data[ i + 1 ];
        if ( data[ i ] == "m1garand_mp" )           self.stats[ "weapon_m1garand_mp" ]          = (int)data[ i + 1 ];
        if ( data[ i ] == "fg42_mp" )               self.stats[ "weapon_fg42_mp" ]              = (int)data[ i + 1 ];
        if ( data[ i ] == "bar_mp" )                self.stats[ "weapon_bar_mp" ]               = (int)data[ i + 1 ];
        if ( data[ i ] == "colt_mp" )               self.stats[ "weapon_colt_mp" ]              = (int)data[ i + 1 ];
        if ( data[ i ] == "luger_mp" )              self.stats[ "weapon_luger_mp" ]             = (int)data[ i + 1 ];
	}
		
	self.isRegistered = true;
    
    //myachievements = [[ level.socket.getHandler ]]( achievementstring );
	
	self.statshud destroy();
	self.black destroy();
}

update_stats( player, eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc )
{
    // don't update if the attacker is the world
    if ( !isPlayer( eAttacker ) )
        return;
        
    // don't update if the attacker was themselves
    if ( player == eAttacker )
        return;
        
    // melee/headshot kills
    if ( sMeansOfDeath == "MOD_MELEE" )
        eAttacker.stats[ "meleeKills" ]++;
    else if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
        eAttacker.stats[ "headshotKills" ]++;
        
    // team-specific checks
    if ( eAttacker.pers[ "team" ] == "axis" )
    {
        if ( player.pers[ "team" ] == "allies" )
            eAttacker.stats[ "zombiesKilled" ]++;
            
        if ( isDefined( eAttacker.stats[ "weapon_" + sWeapon ] ) )
            eAttacker.stats[ "weapon_" + sWeapon ]++;
            
        if ( sWeapon == "mg42_bipod_stand_mp" )
            eAttacker.stats[ "sentryKills" ]++;
    }
    else if ( eAttacker.pers[ "team" ] == "allies" )
    {
        if ( player.pers[ "team" ] == "axis" )
            eAttacker.stats[ "huntersKilled" ]++;
    }
}