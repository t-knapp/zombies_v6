/*
    File:           stats.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/

init()
{
    [[ level.register ]]( "get_stats", ::get_stats );
    
    [[ level.call ]]( "precache", &"^3Retrieving stats...", "string" );
}

get_stats()
{
    if ( getCvar( "skipstats" ) == "1" )
    {
        self.isRegistered = true;
        return;
    }
    
    self.isRegistered = false;
    self.locale = "english";
    
    self.stats = [];
    self.stats[ "totalDistanceMoved" ] = 0;
    self.stats[ "totalZombieKills" ] = 0;
    self.stats[ "totalHunterKills" ] = 0;
    self.stats[ "totalTimesSurvived" ] = 0;
    self.stats[ "totalZombieDamageDealt" ] = 0;
    self.stats[ "totalHunterDamageDealt" ] = 0;
    self.stats[ "totalGrenadeKills" ] = 0;
    self.stats[ "totalPistolKills" ] = 0;
    self.stats[ "totalHeadshots" ] = 0;
    self.stats[ "totalBashes" ] = 0;
    self.stats[ "totalShotsFired" ] = 0;
    self.stats[ "totalShotsHit" ] = 0;
    
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
		if ( data[ i ] == "distanceMoved" ) 		self.stats[ "totalDistanceMoved" ] =        (int)data[ i + 1 ];
		if ( data[ i ] == "zombiesKilled" )			self.stats[ "totalZombieKills" ] =          (int)data[ i + 1 ];
		if ( data[ i ] == "huntersKilled" )			self.stats[ "totalHunterKills" ] =          (int)data[ i + 1 ];
		if ( data[ i ] == "timesSurvived" )			self.stats[ "totalTimesSurvived" ] =        (int)data[ i + 1 ];
		if ( data[ i ] == "zombieDamageDealt" )		self.stats[ "totalZombieDamageDealt" ] =    (int)data[ i + 1 ];
        if ( data[ i ] == "hunterDamageDealt" )		self.stats[ "totalHunterDamageDealt" ] =    (int)data[ i + 1 ];
		if ( data[ i ] == "grenadeKills" )			self.stats[ "totalGrenadeKills" ] =         (int)data[ i + 1 ];
		if ( data[ i ] == "pistolKills" )			self.stats[ "totalPistolKills" ] =          (int)data[ i + 1 ];
		if ( data[ i ] == "headshots" )				self.stats[ "totalHeadshots" ] =            (int)data[ i + 1 ];
		if ( data[ i ] == "bashes" )				self.stats[ "totalBashes" ] =               (int)data[ i + 1 ];
        if ( data[ i ] == "shotsFired" )            self.stats[ "totalShotsFired" ] =           (int)data[ i + 1 ];
        if ( data[ i ] == "shotsHit" )              self.stats[ "totalShotsHit" ] =             (int)data[ i + 1 ];
        if ( data[ i ] == "locale" )                self.locale =                               (string)data[ i + 1 ];
	}
		
	self.isRegistered = true;
    
    //myachievements = [[ level.socket.getHandler ]]( achievementstring );
	
	self.statshud destroy();
	self.black destroy();
}