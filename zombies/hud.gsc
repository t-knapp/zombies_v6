/*
    File:           hud.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/

init()
{
    [[ level.register ]]( "player_hud", ::player_hud );
    [[ level.register ]]( "hud_remove", ::hud_remove );
    [[ level.register ]]( "run_hud", ::run_hud, level.iFLAG_THREAD );
    [[ level.register ]]( "manage_spectate", ::manage_spectate );
    
    [[ level.call ]]( "precache", &"^1Zombies Killed^7: ", "string" );
    [[ level.call ]]( "precache", &"^1Hunters Killed^7: ", "string" );
    [[ level.call ]]( "precache", &"^1Zombie Damage^7: ", "string" );
    [[ level.call ]]( "precache", &"^1Hunter Damage^7: ", "string" );
    [[ level.call ]]( "precache", &"^1Headshots^7: ", "string" );
    [[ level.call ]]( "precache", &"^1Bashes^7: ", "string" );
    [[ level.call ]]( "precache", &"k", "string" );
    
    [[ level.call ]]( "precache", &"^2Class^7: ", "string" );
    [[ level.call ]]( "precache", &"Claymores: ", "string" );
    [[ level.call ]]( "precache", &"Heal points: ", "string" );
    [[ level.call ]]( "precache", &"Infections healed: ", "string" );
    [[ level.call ]]( "precache", &"Fires put out: ", "string" );
    [[ level.call ]]( "precache", &"Ammo points: ", "string" );
    [[ level.call ]]( "precache", &"Bullets given out: ", "string" );
    [[ level.call ]]( "precache", &"^3Spectating is not allowed.", "string" );
}

player_hud()
{   
    self.hud = [];
    
    self addTextHud( "zombieskilled", 630, 25, "right", "middle", 1, 0.8, 10, &"^1Zombies Killed^7: " );
	self addTextHud( "hunterskilled", 630, 40, "right", "middle", 1, 0.8, 10, &"^1Hunters Killed^7: " );
	self addTextHud( "zombiedamage", 630, 55, "right", "middle", 1, 0.8, 10, &"^1Zombie Damage^7: " );
    self addTextHud( "zombiedamagek", 637, 55, "right", "middle", 1, 0.8, 10, &"k" );
	self addTextHud( "hunterdamage", 630, 70, "right", "middle", 1, 0.8, 10, &"^1Hunter Damage^7: " );
    self addTextHud( "hunterdamagek", 637, 70, "right", "middle", 1, 0.8, 10, &"k" );
	self addTextHud( "headshots", 630, 85, "right", "middle", 1, 0.8, 10, &"^1Headshots^7: " );
    self addTextHud( "bashes", 630, 100, "right", "middle", 1, 0.8, 10, &"^1Bashes^7: " );
    
    self addTextHud( "health", 567, 465, "center", "middle", 1, 0.8, 10, &"" );
    self addTextHud( "class", 630, 415, "right", "middle", 1, 1, 10, &"^2Class^7: " );
    
    if ( self.class == "sniper" )
        self addTextHud( "claymores", 630, 400, "right", "middle", 1, 1, 10, &"Claymores: " );
    else if ( self.class == "medic" )
    {
        self addTextHud( "healpoints", 630, 400, "right", "middle", 1, 1, 10, &"Heal points: " );
        self addTextHud( "infections", 630, 385, "right", "middle", 1, 1, 10, &"Infections healed: " );
        self addTextHud( "fires", 630, 370, "right", "middle", 1, 1, 10, &"Fires put out: " );
    }
    else if ( self.class == "support" )
    {
        self addTextHud( "ammopoints", 630, 400, "right", "middle", 1, 1, 10, &"Ammo points: " );
        self addTextHud( "ammoout", 630, 385, "right", "middle", 1, 1, 10, &"Bullets given out: " );
        self addTextHud( "ammooutk", 638, 385, "right", "middle", 1, 1, 10, &"k" );
    }
    
    self thread run_hud();
}

hud_remove()
{   
    if ( isDefined( self.hud[ "zombieskilled" ] ) )         self.hud[ "zombieskilled" ] destroy();
    if ( isDefined( self.hud[ "hunterskilled" ] ) )         self.hud[ "hunterskilled" ] destroy();
    if ( isDefined( self.hud[ "zombiedamage" ] ) )          self.hud[ "zombiedamage" ] destroy();
    if ( isDefined( self.hud[ "zombiedamagek" ] ) )         self.hud[ "zombiedamagek" ] destroy();
    if ( isDefined( self.hud[ "hunterdamage" ] ) )          self.hud[ "hunterdamage" ] destroy();
    if ( isDefined( self.hud[ "hunterdamagek" ] ) )         self.hud[ "hunterdamagek" ] destroy();
    if ( isDefined( self.hud[ "headshots" ] ) )             self.hud[ "headshots" ] destroy();
    if ( isDefined( self.hud[ "bashes" ] ) )                self.hud[ "bashes" ] destroy();
    
    if ( isDefined( self.hud[ "health" ] ) )                self.hud[ "health" ] destroy();
    if ( isDefined( self.hud[ "class" ] ) )                 self.hud[ "class" ] destroy();
    if ( isDefined( self.hud[ "claymores" ] ) )             self.hud[ "claymores" ] destroy();
    if ( isDefined( self.hud[ "healpoints" ] ) )            self.hud[ "healpoints" ] destroy();
    if ( isDefined( self.hud[ "infections" ] ) )            self.hud[ "infections" ] destroy();
    if ( isDefined( self.hud[ "fires" ] ) )                 self.hud[ "fires" ] destroy();
    if ( isDefined( self.hud[ "ammopoints" ] ) )            self.hud[ "ammopoints" ] destroy();
    if ( isDefined( self.hud[ "ammoout" ] ) )               self.hud[ "ammoout" ] destroy();
    if ( isDefined( self.hud[ "ammooutk" ] ) )              self.hud[ "ammooutk" ] destroy();
    
    if ( isDefined( self.spechud ) )                        self.spechud destroy();
    if ( isDefined( self.spechudtext ) )                    self.spechudtext destroy();
    
    if ( isDefined( self.poisonhud ) )                      self.poisonhud destroy();
}

run_hud()
{   
    if ( self.pers[ "team" ] == "axis" )
        class = [[ level.call ]]( "get_class_information", self.class, "hunters" );
    else
        class = [[ level.call ]]( "get_class_information", self.class, "zombies" );
        
    self.hud[ "class" ] setText( class.lName );
    
    while ( isAlive( self ) )
    {
        self.hud[ "zombieskilled" ] setValue( self.stats[ "totalZombiesKilled" ] + self.stats[ "zombiesKilled" ] );
        self.hud[ "hunterskilled" ] setValue( self.stats[ "totalHuntersKilled" ] + self.stats[ "huntersKilled" ] );
        self.hud[ "zombiedamage" ] setValue( (float)(self.stats[ "totalZombieDamageDealt" ] + self.stats[ "zombieDamageDealt" ])/1000 );
        self.hud[ "hunterdamage" ] setValue( (float)(self.stats[ "totalHunterDamageDealt" ] + self.stats[ "hunterDamageDealt" ])/1000 );
        self.hud[ "headshots" ] setValue( self.stats[ "totalHeadshotKills" ] + self.stats[ "headshotKills" ] );
        self.hud[ "bashes" ] setValue( self.stats[ "totalMeleeKills" ] + self.stats[ "meleeKills" ] );
        
        self.hud[ "health" ] setValue( self.health );
        
        if ( self.class == "sniper" )
            self.hud[ "claymores" ] setValue( self.claymores );
        else if ( self.class == "medic" )
        {
            self.hud[ "healpoints" ] setValue( self.stats[ "totalHealPoints" ] + self.stats[ "healPoints" ] );
            self.hud[ "infections" ] setValue( self.stats[ "totalInfectionsHealed" ] + self.stats[ "infectionsHealed" ] );
            self.hud[ "fires" ] setValue( self.stats[ "totalFiresPutOut" ] + self.stats[ "firesPutOut" ] );
        }
        else if ( self.class == "support" )
        {
            self.hud[ "ammopoints" ] setValue( self.stats[ "totalAmmoPoints" ] + self.stats[ "ammoPoints" ] );
            self.hud[ "ammoout" ] setValue( (float)(self.stats[ "totalAmmoGivenOut" ] + self.stats[ "ammoGivenOut" ])/1000 );
        }
        
        wait 0.1;
    }
}

addTextHud( name, x, y, alignX, alignY, alpha, fontScale, sort, label )
{
	self.hud[ name ] = newClientHudElem( self );
	self.hud[ name ].x = x;
	self.hud[ name ].y = y;
	self.hud[ name ].alignX = alignX;
	self.hud[ name ].alignY = alignY;
	self.hud[ name ].alpha = alpha;
	self.hud[ name ].fontScale = fontScale;
	self.hud[ name ].sort = sort;
	self.hud[ name ].label = label;
}

manage_spectate()
{
    if ( isDefined( self.spechud ) )                        self.spechud destroy();
    if ( isDefined( self.spechudtext ) )                    self.spechudtext destroy();
    
    if ( getCvar( "zom_antispec" ) == "1" && ( level.iGameFlags & level.iFLAG_GAME_OVER ) == 0 )
	{
		self.spechud = newClientHudElem( self );
		self.spechud.sort = -2;
		self.spechud.x = 0;
		self.spechud.y = 0;
		self.spechud setShader( "black", 640, 480 );
		self.spechud.alpha = 1;
		self.spechud.archived = false;
		
		self.spechudtext = newClientHudElem( self );
		self.spechudtext.sort = -1;
		self.spechudtext.x = 320;
		self.spechudtext.y = 220;
		self.spechudtext.alignx = "center";
		self.spechudtext.aligny = "middle";
		self.spechudtext setText( &"^3Spectating is not allowed." );
		self.spechudtext.alpha = 1;
		self.spechudtext.archived = false;
	}
}
