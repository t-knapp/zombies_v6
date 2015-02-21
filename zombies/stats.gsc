/*
    File:           stats.gsc
    Author:         Cheese
                    Nuke (adjustments)
    Last update:    13/02/2015
*/

init()
{
    [[ level.register ]]( "get_stats", ::get_stats );
    [[ level.register ]]( "update_stats", ::update_stats, level.iFLAG_THREAD );
    [[ level.register ]]( "save_stats", ::save_stats, level.iFLAG_THREAD, level.iPRIORITY_HIGH );
    
    [[ level.call ]]( "precache", &"^3Retrieving stats...", "string" );
    [[ level.call ]]( "precache", &"^3This is taking longer than usual...", "string" );
}

get_stats()
{
    self.stats = [];

    // major stats - totals
    self.stats[ "totalZombiesKilled" ]     = 0;
    self.stats[ "totalHuntersKilled" ]     = 0;
    self.stats[ "totalTimesSurvived" ]     = 0;
    self.stats[ "totalZombieDamageDealt" ] = 0;
    self.stats[ "totalHunterDamageDealt" ] = 0;
    self.stats[ "totalPistolKills" ]       = 0;
    self.stats[ "totalClaymoreKills" ]     = 0;
    self.stats[ "totalSentryKills" ]       = 0;
    self.stats[ "totalHeadshotKills" ]     = 0;
    self.stats[ "totalMeleeKills" ]        = 0;
    self.stats[ "totalHealPoints" ]        = 0;
    self.stats[ "totalInfectionsHealed" ]  = 0;
    self.stats[ "totalFiresPutOut" ]       = 0;
    self.stats[ "totalAmmoPoints" ]        = 0;
    self.stats[ "totalAmmoGivenOut" ]      = 0;

    // major stats - this round
    self.stats[ "zombiesKilled" ]     = 0;
    self.stats[ "huntersKilled" ]     = 0;
    self.stats[ "timesSurvived" ]     = 0;
    self.stats[ "zombieDamageDealt" ] = 0;
    self.stats[ "hunterDamageDealt" ] = 0;
    self.stats[ "pistolKills" ]       = 0;
    self.stats[ "claymoreKills" ]     = 0;
    self.stats[ "sentryKills" ]       = 0;
    self.stats[ "headshotKills" ]     = 0;
    self.stats[ "meleeKills" ]        = 0;
    self.stats[ "healPoints" ]        = 0;
    self.stats[ "infectionsHealed" ]  = 0;
    self.stats[ "firesPutOut" ]       = 0;
    self.stats[ "ammoPoints" ]        = 0;
    self.stats[ "ammoGivenOut" ]      = 0;
    
    // weapon stats
    self.stats[ "weapon_ppsh_mp" ]          = 0;
    self.stats[ "weapon_panzerfaust_mp" ]   = 0;
    self.stats[ "weapon_mp40_mp" ]          = 0;
    self.stats[ "weapon_kar98k_sniper_mp" ] = 0;
    self.stats[ "weapon_mp44_mp" ]          = 0;
    self.stats[ "weapon_thompson_mp" ]      = 0;
    self.stats[ "weapon_m1garand_mp" ]      = 0;
    self.stats[ "weapon_fg42_mp" ]          = 0;
    self.stats[ "weapon_bar_mp" ]           = 0;
    self.stats[ "weapon_colt_mp" ]          = 0;
    self.stats[ "weapon_luger_mp" ]         = 0;
    
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
    
    self.statshud2 = newClientHudElem( self );
    self.statshud2.x = 320;
    self.statshud2.y = 260;
    self.statshud2.alignx = "center";
    self.statshud2.aligny = "middle";
    self.statshud2 setText( &"^3This is taking longer than usual..." );
    self.statshud2.fontscale = 1.5;
    self.statshud2.alpha = 0;
    self.statshud2.sort = 9021;
    
    self.isRegistered = false;

    //TODO: separate method
    //Get zomid from user
    sZomid = undefined;
    userinfo = self getuserinfo(self getEntityNumber());
    /*
     * \key0\value0
     * \key1\value1
     */
    aUserInfoParts = [[ level.call ]]( "strtok", userinfo, "\\" );
    for ( i = 0; i < aUserInfoParts.size; i++ ) {
      if( aUserInfoParts[i] == "zomid" ){
         sZomid = aUserInfoParts[i+1];
         //TODO: break; and i = aUserInfoParts.size does not work? zomid is set to part at index 0. Why?
      }
    }
    //TODO: Check if zomid is valid
    //self iprintln( "zomid: " + sZomid );

    
    
    //Load stats from mysql
    lConnection = mysql_get_connection(); //Gets connection initialized with config cvars

    lQuery = mysql_query(lConnection, "SELECT * FROM `zombies`.`stats` WHERE `zomid` = '" + sZomid + "' ORDER BY `time` DESC LIMIT 1;"); //works

    lResult = mysql_store_result(lConnection); //works

    lNumRows = mysql_num_rows(lResult);
    if( lNumRows == 0 ){
        //no stats for zomid found. assuming player is not registered

        //cleanup memory
        mysql_free_result(lResult);

        //not registered, so quit here 
        self.statshud destroy();
        self.statshud2 destroy();
        self.black destroy();
        return;
    }
    
    lNumFields = mysql_num_fields(lResult); //works

    lRow = mysql_fetch_row(lResult); //works, only one row exists since limit 1
    for( i = 0; i < lNumFields; i++ ){
        //get fieldname
        lField = mysql_fetch_field(lResult);

        //assign values
        if ( lField == "zombiesKilled" )         self.stats[ "totalZombiesKilled" ]          = (int)lRow[ i ];
        if ( lField == "huntersKilled" )         self.stats[ "totalHuntersKilled" ]          = (int)lRow[ i ];
        if ( lField == "timesSurvived" )         self.stats[ "totalTimesSurvived" ]          = (int)lRow[ i ];
        if ( lField == "zombieDamageDealt" )     self.stats[ "totalZombieDamageDealt" ]      = (int)lRow[ i ];
        if ( lField == "hunterDamageDealt" )     self.stats[ "totalHunterDamageDealt" ]      = (int)lRow[ i ];
        if ( lField == "pistolKills" )           self.stats[ "totalPistolKills" ]            = (int)lRow[ i ];
        if ( lField == "claymoreKills" )         self.stats[ "totalClaymoreKills" ]          = (int)lRow[ i ];
        if ( lField == "sentryKills" )           self.stats[ "totalSentryKills" ]            = (int)lRow[ i ];
        if ( lField == "headshotKills" )         self.stats[ "totalHeadshotKills" ]          = (int)lRow[ i ];
        if ( lField == "meleeKills" )            self.stats[ "totalMeleeKills" ]             = (int)lRow[ i ];
        if ( lField == "healPoints" )            self.stats[ "totalHealPoints" ]             = (int)lRow[ i ];
        if ( lField == "infectionsHealed" )      self.stats[ "totalInfectionsHealed" ]       = (int)lRow[ i ];
        if ( lField == "firesPutOut" )           self.stats[ "totalFiresPutOut" ]            = (int)lRow[ i ];
        //if ( data[ i ] == "ammoPoints" )            self.stats[ "totalAmmoPoints" ]             = (int)data[ i + 1 ];
        //if ( data[ i ] == "ammoGivenOut" )          self.stats[ "totalAmmoGivenOut" ]           = (int)data[ i + 1 ];
        if ( lField == "ppsh_mp" )               self.stats[ "weapon_ppsh_mp" ]              = (int)lRow[ i ];
        if ( lField == "panzerfaust_mp" )        self.stats[ "weapon_panzerfaust_mp" ]       = (int)lRow[ i ];
        if ( lField == "mp40_mp" )               self.stats[ "weapon_mp40_mp" ]              = (int)lRow[ i ];
        if ( lField == "kar98k_sniper_mp" )      self.stats[ "weapon_kar98k_sniper_mp" ]     = (int)lRow[ i ];
        if ( lField == "mp44_mp" )               self.stats[ "weapon_mp44_mp" ]              = (int)lRow[ i ];
        if ( lField == "thompson_mp" )           self.stats[ "weapon_thompson_mp" ]          = (int)lRow[ i ];
        if ( lField == "m1garand_mp" )           self.stats[ "weapon_m1garand_mp" ]          = (int)lRow[ i ];
        if ( lField == "fg42_mp" )               self.stats[ "weapon_fg42_mp" ]              = (int)lRow[ i ];
        if ( lField == "bar_mp" )                self.stats[ "weapon_bar_mp" ]               = (int)lRow[ i ];
        if ( lField == "colt_mp" )               self.stats[ "weapon_colt_mp" ]              = (int)lRow[ i ];
        if ( lField == "luger_mp" )              self.stats[ "weapon_luger_mp" ]             = (int)lRow[ i ];
    }

    mysql_free_result(lResult); //works

    self.isRegistered = true;

    self.statshud destroy();
    self.statshud2 destroy();
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
    
    //Axis   = hunters
    //Allies = zombies
    
    // melee/headshot kills
    if ( sMeansOfDeath == "MOD_MELEE" )
        eAttacker.stats[ "meleeKills" ]++;
    else if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
        eAttacker.stats[ "headshotKills" ]++;
        
    // team-specific checks
    if ( eAttacker.pers[ "team" ] == "axis" )
    {
        if ( player.pers[ "team" ] == "allies" ){
            eAttacker.stats[ "zombiesKilled" ]++;
	}
            
        if ( isDefined( eAttacker.stats[ "weapon_" + sWeapon ] ) )
            eAttacker.stats[ "weapon_" + sWeapon ]++;
            
        if ( sWeapon == "mg42_bipod_stand_mp" )
            eAttacker.stats[ "sentryKills" ]++;
    }
    else if ( eAttacker.pers[ "team" ] == "allies" )
    {
        //this is always false b.c. if player dies, he immediately changes pers to allies (zombies)
        //Workaround: assume when pers is allies, this player was a hunter before.
        //Another assumption: If player dies (this function is called if he dies) and 
        //attacker is allies (zombie) then, increase attackers score.
        //if ( player.pers[ "team" ] == "axis" ){ 
        eAttacker.stats[ "huntersKilled" ]++;
        //}
    }
}

save_stats()
{
    if ( !self.isRegistered )
        return;
        
    self iprintln( "saving stats..." );
    
    //TODO: separate method
    //Get zomid from user
    sZomid = undefined;
    userinfo = self getuserinfo(self getEntityNumber());
    /*
     * \key0\value0
     * \key1\value1
     */
    aUserInfoParts = [[ level.call ]]( "strtok", userinfo, "\\" );
    for ( i = 0; i < aUserInfoParts.size; i++ ) {
      if( aUserInfoParts[i] == "zomid" ){
         sZomid = aUserInfoParts[i+1];
         //TODO: break; and i = aUserInfoParts.size does not work? zomid is set to part at index 0. Why?
      }
    }
    
    // add up our totals
    self.stats[ "totalZombiesKilled" ]     += self.stats[ "zombiesKilled" ];
    self.stats[ "totalHuntersKilled" ]     += self.stats[ "huntersKilled" ];
    self.stats[ "totalTimesSurvived" ]     += self.stats[ "timesSurvived" ];
    self.stats[ "totalZombieDamageDealt" ] += self.stats[ "zombieDamageDealt" ];
    self.stats[ "totalHunterDamageDealt" ] += self.stats[ "hunterDamageDealt" ];
    self.stats[ "totalPistolKills" ]       += self.stats[ "pistolKills" ];
    self.stats[ "totalClaymoreKills" ]     += self.stats[ "claymoreKills" ];
    self.stats[ "totalSentryKills" ]       += self.stats[ "sentryKills" ];
    self.stats[ "totalHeadshotKills" ]     += self.stats[ "headshotKills" ];
    self.stats[ "totalMeleeKills" ]        += self.stats[ "meleeKills" ];
    self.stats[ "totalHealPoints" ]        += self.stats[ "healPoints" ];
    self.stats[ "totalInfectionsHealed" ]  += self.stats[ "infectionsHealed" ];
    self.stats[ "totalFiresPutOut" ]       += self.stats[ "firesPutOut" ];
    //self.stats[ "totalAmmoPoints" ] += self.stats[ "ammoPoints" ];
    //self.stats[ "totalAmmoGivenOut" ] += self.stats[ "ammoGivenOut" ];
    
    //Calculate points	
    points = 0;
    points += self.stats[ "totalZombieDamageDealt" ];
    points += self.stats[ "totalHunterDamageDealt" ];
    points += (self.stats[ "totalZombiesKilled" ] * 10);
    points += (self.stats[ "totalHuntersKilled" ] * 50);
    //points += self.stats[ "totalAmmoPoints" ];
    //points += self.stats[ "totalAmmoGivenOut" ];
    
    //Header
    queryColl = "INSERT INTO `zombies`.`stats` (";
    queryVals = "VALUES (";
    
    //Static fields
    queryColl += "`zomid`, ";
    queryVals += "'" + sZomid + "', ";
    
    queryColl += "`time`, ";
    queryVals += "NOW(), ";
    
    queryColl += "`name`, ";
    queryVals += "'" + self.name + "', ";

    //Add map
    queryColl += "`map`, ";
    queryVals += "'" + level.sMapName + "', ";

    //Game fields
    queryColl += "`zombiesKilled`, ";
    queryVals += "'" + self.stats[ "totalZombiesKilled" ] + "', ";
    
    queryColl += "`huntersKilled`, ";
    queryVals += "'" + self.stats[ "totalHuntersKilled" ] + "', ";
    
    queryColl += "`timesSurvived`, "; 
    queryVals += "'" + self.stats[ "totalTimesSurvived" ] + "', ";
    
    queryColl += "`zombieDamageDealt`, "; 
    queryVals += "'" + self.stats[ "totalZombieDamageDealt" ] + "', ";
    
    queryColl += "`hunterDamageDealt`, ";
    queryVals += "'" + self.stats[ "totalHunterDamageDealt" ] + "', ";
    
    queryColl += "`pistolKills`, ";
    queryVals += "'" + self.stats[ "totalPistolKills" ] + "', ";
    
    queryColl += "`claymoreKills`, ";
    queryVals += "'" + self.stats[ "totalClaymoreKills" ] + "', ";
    
    queryColl += "`sentryKills`, ";
    queryVals += "'" + self.stats[ "totalSentryKills" ] + "', ";
    
    queryColl += "`headshotKills`, ";
    queryVals += "'" + self.stats[ "totalHeadshotKills" ] + "', ";
    
    queryColl += "`meleeKills`, ";
    queryVals += "'" + self.stats[ "totalMeleeKills" ] + "', ";
    
    queryColl += "`healPoints`, ";
    queryVals += "'" + self.stats[ "totalHealPoints" ] + "', ";
    
    queryColl += "`infectionsHealed`, ";
    queryVals += "'" + self.stats[ "totalInfectionsHealed" ] + "', ";
    
    queryColl += "`firesPutOut`, ";
    queryVals += "'" + self.stats[ "totalFiresPutOut" ] + "', ";
    
    //infostring += "|ammoPoints|" + self.stats[ "totalAmmoPoints" ];
    //infostring += "|ammoGivenOut|" + self.stats[ "totalAmmoGivenOut" ];

    queryColl += "`ppsh_mp`, ";
    queryVals += "'" + self.stats[ "weapon_ppsh_mp" ] + "', ";
    
    queryColl += "`panzerfaust_mp`, ";
    queryVals += "'" + self.stats[ "weapon_panzerfaust_mp" ] + "', ";
    
    queryColl += "`mp40_mp`, ";
    queryVals += "'" + self.stats[ "weapon_mp40_mp" ] + "', ";
    
    queryColl += "`kar98k_sniper_mp`, ";
    queryVals += "'" + self.stats[ "weapon_kar98k_sniper_mp" ] + "', ";
    
    queryColl += "`mp44_mp`, ";
    queryVals += "'" + self.stats[ "weapon_mp44_mp" ] + "', ";
    
    queryColl += "`thompson_mp`, ";
    queryVals += "'" + self.stats[ "weapon_thompson_mp" ] + "', ";
    
    queryColl += "`m1garand_mp`, ";
    queryVals += "'" + self.stats[ "weapon_m1garand_mp" ] + "', ";
    
    queryColl += "`fg42_mp`, ";
    queryVals += "'" + self.stats[ "weapon_fg42_mp" ] + "', ";
    
    queryColl += "`bar_mp`, ";
    queryVals += "'" + self.stats[ "weapon_bar_mp" ] + "', ";
    
    queryColl += "`colt_mp`, ";
    queryVals += "'" + self.stats[ "weapon_colt_mp" ] + "', ";
    
    queryColl += "`luger_mp`, ";
    queryVals += "'" + self.stats[ "weapon_luger_mp" ] + "', ";
    
    queryColl += "`points`) "; //Mind the end
    queryVals += "'" + points + "');"; //Mind the end
    
    queryColl += queryVals;
    
    //printconsole( queryColl );
    
    //Save to MySQL
    lConnection = mysql_get_connection(); //Gets connection initialized with config cvars

    lQuery = mysql_query( lConnection, queryColl ); //works
    
    if(lQuery == 0){
      self iprintln( "Stats saved." );
    } else {
      self iprintln( "Saving stats ^1failed^7." );
    }
}
