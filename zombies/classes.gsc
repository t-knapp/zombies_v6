/*
    File:           classes.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/


init()
{
    setCvar( "g_TeamColor_Allies", "1 0 0" );
    setCvar( "g_TeamName_Allies", "Zombies" );
    setCvar( "g_TeamColor_Axis", "1 0 1" );
    setCvar( "g_TeamName_Axis", "Hunters" );
    
    level.classes = [];
    level.classes[ "hunters" ] = [];
    level.classes[ "zombies" ] = [];
    
    [[ level.register ]]( "classes_main", ::selectClass );
    [[ level.register ]]( "classes_loadout", ::loadout );
    [[ level.register ]]( "classes_hunter_default", ::hunterClass_default );
    [[ level.register ]]( "classes_hunter_default_loadout", ::hunterClass_default_loadout );
    [[ level.register ]]( "be_poisoned", ::be_poisoned, level.iFLAG_THREAD );
    [[ level.register ]]( "be_shocked", ::be_shocked, level.iFLAG_THREAD );
    
    [[ level.call ]]( "precache", &"Select A Class", "string" );
    [[ level.call ]]( "precache", &"You are a", "string" );
    [[ level.call ]]( "precache", &"Hunter", "string" );
    [[ level.call ]]( "precache", &"Zombie", "string" );
    [[ level.call ]]( "precache", &"Timeout in: ", "string" );
    [[ level.call ]]( "precache", &"Hold [{+activate}] to get ammo", "string" );
    [[ level.call ]]( "precache", &"Ammo left until depleted: ", "string" );
    [[ level.call ]]( "precache", &"Press [{+attack}] to change selection", "string" );
    [[ level.call ]]( "precache", &"Press [{+activate}] to spawn", "string" );
    
    [[ level.call ]]( "precache", "xmodel/crate_misc1", "model" );
    [[ level.call ]]( "precache", "xmodel/crate_misc_red1", "model" );
    [[ level.call ]]( "precache", "xmodel/crate_misc_green1", "model" );
    [[ level.call ]]( "precache", "xmodel/crate_champagne3", "model" );
    
    //        <team>        <localized>     <string>     <description>                                                   line break|
    addClass( "hunters",    &"Default",     "default",   &"The basic hunter class. You can select any weapon you want.", &"" );
    addClass( "hunters",    &"Scout",       "scout",     &"A recon class, the scout is equipped with a shotgun and a pistol.", &"Health: 125\nMove Speed: 1.3x" );
    addClass( "hunters",    &"Soldier",     "soldier",   &"Panzerfaust and MP40 in hand, this is one class you don't want to mess\nwith.", &"Health: 200\nMove Speed: 1x" );
    addClass( "hunters",    &"Sniper",      "sniper",    &"Sniper stuff.", &"" );
    addClass( "hunters",    &"Support",     "support",   &"", &"" );
    addClass( "hunters",    &"Medic",       "medic",     &"", &"" );
    addClass( "hunters",    &"Engineer",    "engineer",  &"", &"" );
    addClass( "hunters",    &"Heavy",       "heavy",     &"", &"" );
    addClass( "hunters",    &"Random",      "random",   &"Let the game decide a class for you.", &"Will be determined once spawned." );
    
    //        <team>        <localized>     <string>    <description>                                                   line break|
    addClass( "zombies",    &"Default",     "default",  &"The basic zombie class. No perks, just pure death.", &"" );
	addClass( "zombies",    &"Fast",        "fast",     &"Faster than any hunter, this zombie can easily catch up to any one\nwithin reach!", &"Health: 150\nMove Speed: 1.5x" );
	addClass( "zombies",    &"Inferno",     "inferno",  &"A fiery zombie from the depths of hell! This zombie will catch other\nzombies and hunters on fire in a close proximity.", &"Health: 200\nMove Speed: 1.0x" );
	addClass( "zombies",    &"Jumper",      "jumper",   &"Agile to the core, the jumper zombie can get almost anywhere, ready to\npounce unsuspecting prey!", &"Health: 200\nMove Speed: 1.0x" );
	addClass( "zombies",    &"Poison",      "poison",   &"A toxic spill waiting to happen, the poison zombie will infect hunters\nwith a deadly smack.", &"Health: 300\nMove Speed: 0.9x" );
	addClass( "zombies",    &"Shocker",     "shocker",  &"Electrified by lightning, the shocker can easily put a damper on your\nday!", &"Health: 200\nMove Speed: 1.0x" );
	addClass( "zombies",    &"Random",      "random",   &"Let the game decide a class for you.", &"Will be determined once spawned." );
}

addClass( team, lName, sName, lDescription, lPerks ) 
{
	if ( !isDefined( level.classes[ team ] ) )
		return;
		
	[[ level.call ]]( "precache", lName, "string" );
	[[ level.call ]]( "precache", lDescription, "string" );
	[[ level.call ]]( "precache", lPerks, "string" );
		
	this = spawnstruct();
	this.team = team;
	this.lName = lName;
	this.lDescription = lDescription;
	this.lPerks = lPerks;
	this.sNAme = sName;
	
	size = level.classes[ team ].size;
	level.classes[ team ][ size ] = this;
}

selectClassHud( player, x, y, alignx, aligny, sort, alpha, fontscale ) 
{
	if ( !isDefined( player ) )				return;
	if ( !isDefined( x ) ) 					x = 320;
	if ( !isDefined( y ) )					y = 240;
	if ( !isDefined( alignx ) )				alignx = "left";
	if ( !isDefined( aligny ) )				aligny = "top";
	if ( !isDefined( sort ) )				sort = 1;
	if ( !isDefined( alpha ) ) 				alpha = 1;
	if ( !isDefined( fontscale ) )			fontscale = 1;

	temp = newClientHudElem( player );
	temp.x = x;
	temp.y = y;
	temp.alignx = alignx;
	temp.aligny = aligny;
	temp.sort = sort;
	temp.alpha = alpha;
	temp.fontscale = fontscale;
	
	return temp;
}	

selectClassFadeOut( time ) 
{
	self fadeOverTime( time );
	self.alpha = 0;
	
	wait ( time + 0.05 );
	
	self destroy();
}

selectClass()
{
    self endon( "disconnect" );
    self endon( "select class notify stop" );
    
    self.atclassmenu = true;
    
	if ( isDefined( self.chud ) )
		self selectClass_destroy();
    
    self.chud = [];
    
    // left side selector for classes
    self.chud[ "left side select bg" ] = selectClassHud( self, 8, 8, "left", "top", 9000, 1, undefined );
    self.chud[ "left side select bg" ] setShader( "black", 196, 464 );
    self.chud[ "left side select line left" ] = selectClassHud( self, 10, 10, "left", "top", 9001, 0.3, undefined );
    self.chud[ "left side select line left" ] setShader( "white", 2, 460 );
    self.chud[ "left side select line up" ] = selectClassHud( self, 12, 10, "left", "top", 9001, 0.3, undefined );
    self.chud[ "left side select line up" ] setShader( "white", 188, 2 );
    self.chud[ "left side select line right" ] = selectClassHud( self, 200, 10, "left", "top", 9001, 0.3, undefined );
    self.chud[ "left side select line right" ] setShader( "white", 2, 460 );
    self.chud[ "left side select line bot" ] = selectClassHud( self, 12, 468, "left", "top", 9001, 0.3, undefined );
    self.chud[ "left side select line bot" ] setShader( "white", 188, 2 );
    self.chud[ "left side select line divider" ] = selectClassHud( self, 12, 68, "left", "top", 9001, 0.3, undefined );
    self.chud[ "left side select line divider" ] setShader( "white", 188, 2 );
    self.chud[ "left side select text" ] = selectClassHud( self, 104, 24, "center", "top", 9001, 1, 2 );
    self.chud[ "left side select text" ] setText( &"Select A Class" );
    self.chud[ "left side select line divider2" ] = selectClassHud( self, 12, 432, "left", "top", 9001, 0.3, undefined );
    self.chud[ "left side select line divider2" ] setShader( "white", 188, 2 );
    self.chud[ "left side select autoselect" ] = selectClassHud( self, 104, 450, "center", "middle", 9001, 1, 1 );
    self.chud[ "left side select autoselect" ].label = &"Timeout in: ";
    
    // right side info for classes
    self.chud[ "right side info bg" ] = selectClassHud( self, 632, 472, "right", "bottom", 9000, 1, undefined );
    self.chud[ "right side info bg" ] setShader( "black", 424, 220 );
    self.chud[ "right side info line right" ] = selectClassHud( self, 630, 470, "right", "bottom", 9001, 0.3, undefined );
    self.chud[ "right side info line right" ] setShader( "white", 2, 216 );
    self.chud[ "right side info line bot" ] = selectClassHud( self, 628, 470, "right", "bottom", 9001, 0.3, undefined );
    self.chud[ "right side info line bot" ] setShader( "white", 416, 2 );
    self.chud[ "right side info line left" ] = selectClassHud( self, 212, 470, "right", "bottom", 9001, 0.3, undefined );
    self.chud[ "right side info line left" ] setShader( "white", 2, 216 );
    self.chud[ "right side info line up" ] = selectClassHud( self, 628, 256, "right", "bottom", 9001, 0.3, undefined );
    self.chud[ "right side info line up" ] setShader( "white", 416, 2 );
    
    // you are a ...
    self.chud[ "team notify you" ] = selectClassHud( self, 422, 108, "center", "top", 9001, 1, 1 );
    self.chud[ "team notify you" ] setText( &"You are a" );
    self.chud[ "team notify team" ] = selectClassHud( self, 424, 112, "center", "top", 9001, 1, 4 );
    
    // for those who don't know what to do :p
	self.chud[ "attack" ] = selectClassHud( self, 412, 424, "center", "middle", 9003, 1, 1.25 );
	self.chud[ "attack" ].color = ( 1, 0, 0 );
	self.chud[ "attack" ] setText( &"Press [{+attack}] to change selection" );
	
	self.chud[ "use" ] = selectClassHud( self, 412, 448, "center", "middle", 9003, 1, 1.4 );
	self.chud[ "use" ].color = ( 0, 1, 0 );
	self.chud[ "use" ] setText( &"Press [{+activate}] to spawn" );
    
    if ( self.pers[ "team" ] == "allies" )
    {
        self.chud[ "team notify team" ] setText( &"Zombie" );
        self.chud[ "team notify team" ].color = ( 1, 0, 0 );
    }
    else
    {
        self.chud[ "team notify team" ] setText( &"Hunter" );
        self.chud[ "team notify team" ].color = ( 1, 0, 1 );
    }
    
    if ( self.pers[ "team" ] == "allies" )
        myclasses = level.classes[ "zombies" ];
    else
        myclasses = level.classes[ "hunters" ];
	self.chud[ "classes" ] = [];
    
    startx = 106;
	starty = 90;
	
    // fill out class list
	for ( i = 0; i < myclasses.size; i++ ) {
		m = myclasses[ i ];
		s = self.chud[ "classes" ].size;
		self.chud[ "classes" ][ s ] = selectClassHud( self, startx, starty, "center", "middle", 9002, 1, 1.4 );
		self.chud[ "classes" ][ s ] setText( m.lName );
		
		if ( !self.isRegistered && s != 0 )
			self.chud[ "classes" ][ s ].color = ( 0.1, 0.1, 0.1 );
		
		starty += 32;
	}
	
	// class selector
	self.chud[ "selector" ] = selectClassHud( self, startx, 90, "center", "middle", 9003, 0.3, undefined );
	self.chud[ "selector" ].color = ( 0, 1, 0 );
	self.chud[ "selector" ] setShader( "white", 188, 32 );
    
    // class description
	self.chud[ "desc" ] = selectClassHud( self, 216, 264, undefined, "middle", 9003, 1, 1 );
	self.chud[ "desc" ].label = &"Description:\n    ";
	
	// perk description
	//self.chud[ "perks" ] = selectClassHud( self, 236, 160, undefined, "middle", 9003, 1, 1.3 );
	//self.chud[ "perks" ].label = &"Perks:\n";
    
    self thread selectClass_menuStopper();
    self thread selectClass_notifyStop();
    self thread selectClass_timeout();
    
    index = 0;
    self.chudselectedclass = myclasses[ index ];
    
	self.chud[ "desc" ] setText( myclasses[ index ].lDescription );
	//self.chud[ "perks" ] setText( myclasses[ index ].lPerks );
    
    wait 0.5;
	
	while ( 1 ) 
    {
		wait 0.05;
		
		// go to next class, update info
		if ( self attackbuttonpressed() && self.isRegistered ) {
			if ( !hasattacked ) {
				hasattacked = true;
				//self.chud[ "auto" ] fadeOverTime( 0.5 );
				//self.chud[ "auto" ].alpha = 1;
			}
			
			pausedtime = 0;
			index++;
			
			if ( index > myclasses.size - 1 )
				index = 0;
				
			self.chud[ "selector" ] moveOverTime( 0.1 );
			self.chud[ "selector" ].y = self.chud[ "classes" ][ index ].y + 2; // safe?
            self.chudselectedclass = myclasses[ index ];
            
            self.chud[ "desc" ] fadeOverTime( 0.05 );
			self.chud[ "desc" ].alpha = 0;
			//self.chud[ "perks" ] fadeOverTime( 0.05 );
			//self.chud[ "perks" ].alpha = 0;
			
			wait 0.05;
			
			self.chud[ "desc" ] setText( myclasses[ index ].lDescription );
			self.chud[ "desc" ] fadeOverTime( 0.05 );
			self.chud[ "desc" ].alpha = 1;
			//self.chud[ "perks" ] setText( myclasses[ index ].lPerks );
			//self.chud[ "perks" ] fadeOverTime( 0.05 );
			//self.chud[ "perks" ].alpha = 1;
            
            wait 0.05;
		}
		
		// SPAWN TIME!
		if ( self usebuttonpressed() ) {
			self.class = self.chudselectedclass.sName;
			break;
		}
	}
    
	self.atclassmenu = undefined;
	self notify( "select class notify stop" );
}

selectClass_destroy()
{
    self.chud[ "left side select bg" ]              thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select line left" ]       thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select line up" ]         thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select line right" ]      thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select line bot" ]        thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select line divider" ]    thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select text" ]            thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select line divider2" ]   thread selectClassFadeOut( 0.5 );
    self.chud[ "left side select autoselect" ]      thread selectClassFadeOut( 0.5 );
    self.chud[ "right side info bg" ]               thread selectClassFadeOut( 0.5 );
    self.chud[ "right side info line right" ]       thread selectClassFadeOut( 0.5 );
    self.chud[ "right side info line bot" ]         thread selectClassFadeOut( 0.5 );
    self.chud[ "right side info line left" ]        thread selectClassFadeOut( 0.5 );
    self.chud[ "right side info line up" ]          thread selectClassFadeOut( 0.5 );
    self.chud[ "team notify you" ]                  thread selectClassFadeOut( 0.5 );
    self.chud[ "team notify team" ]                 thread selectClassFadeOut( 0.5 );
    self.chud[ "attack" ]                           thread selectClassFadeOut( 0.5 );
    self.chud[ "use" ]                              thread selectClassFadeOut( 0.5 );
	for ( i = 0; i < self.chud[ "classes" ].size; i++ )
		self.chud[ "classes" ][ i ]                 thread selectClassFadeOut( 0.5 );

	self.chud[ "selector" ]                         thread selectClassFadeOut( 0.5 );
    self.chud[ "desc" ]                             thread selectClassFadeOut( 0.5 );
    //self.chud[ "perks" ]                            thread selectClassFadeOut( 0.5 );
    
    wait 0.6;
    self.chud = undefined;
    self.atclassmenu = undefined;
}


selectClass_menuStopper() 
{
	self endon( "select class notify stop" );
	
	while ( 1 ) {
		self waittill( "menuresponse", menu, response );
		break;
	}
	
	self.pers[ "team" ] = "spectator";
	self.pers[ "weapon" ] = undefined;
	self.pers[ "savedmodel" ] = undefined;
	self.team = "spectator";
	self.sessionteam = "spectator";
	self.sessionstate = "spectator";
	self notify( "select class notify stop" );
    self [[ level.call ]]( "spawn_spectator" );
}

selectClass_notifyStop() 
{
	self waittill( "select class notify stop" );
	self thread selectClass_destroy();
}

selectClass_timeout() 
{	
    self endon( "select class notify stop" );
	
	self.chud[ "left side select autoselect" ] setTimer( 60 );
	time = 0;
	while ( 1 ) {
		wait 0.05;
		
		if ( self attackButtonPressed() ) {
			time = 0;
			self.chud[ "left side select autoselect" ] setTimer( 60 );
		}
			
		if ( time > 60 )
			break;
			
		time += 0.05;
	}
	
	self notify( "select class notify stop" );
    
    self [[ level.call ]]( "print", "Moved to spectator for AFK", true );
    self [[ level.call ]]( "spawn_spectator" );
}

zombieClasses() 
{
	// base class values
	self.health = 500;
	self.maxhealth = 500;
	
	if ( !isDefined( self.class ) )
		return;
		
	if ( self.class == "random" ) 
    {
		r = randomInt( level.classes[ "zombies" ].size - 1 );	// minus the random one
		self.class = level.classes[ "zombies" ][ r ].sName;
	}
		
	weapon = "enfield_mp";
		
	switch ( self.class ) 
    {
		case "jumper": self thread zombieClass_jumper(); break;
		case "inferno": self thread zombieClass_fire(); break;
		case "shocker": self thread zombieClass_shocker(); break;
		case "poison": weapon = "bren_mp"; self thread zombieClass_poison(); break;
		case "fast": weapon = "sten_mp"; self thread zombieClass_fast(); break;
			break;
		default:
			// unknown class:o
			break;
	}
    
    self.pers[ "weapon" ] = weapon;
	
	self giveWeapon( weapon );
	self setWeaponSlotAmmo( "primary", 0 );
	self setWeaponSlotClipAmmo( "primary", 0 );
	self setSpawnWeapon( weapon );
}

// original code from brax's 1.5 zombie mod
// heavily modified by Cheese :)
zombieClass_jumper() 
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_respawn" );

	wait 1;
    
    doublejumped = false;
    self.jumpblocked = false;
    airjumps = 0;
	while ( 1 ) {
		if ( self useButtonPressed() && !self.jumpblocked ) 
        {
            if ( !self isOnGround() )
                airjumps++;
                
            if ( airjumps == 2 ) {
                airjumps = 0;
                self thread blockjump();
            }

			for ( i = 0; i < 2; i++ ) 
            {
				self.health += 2000;
				self finishPlayerDamage(self, self, 2000, 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize(self.origin - (self.origin + (0,0,-1))), "none");
			}
			wait 1;
		}
		wait 0.05;
	}
}

blockjump() 
{
    self.jumpblocked = true;
    
    while ( !self isOnGround() )
        wait 0.05;
        
    self.jumpblocked = false;
}

zombieClass_poison() 
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_respawn" );
	
	self.maxhealth = 750;
	self.health = 750;
}

be_poisoned( dude )
{	
    //self endon( "death" );
    self endon( "disconnect" );
    self endon( "end_respawn" );
    
    self.ispoisoned = true;
    
	self.poisonhud = newClientHudElem( self );
	self.poisonhud.x = 0;
	self.poisonhud.y = 0;
	self.poisonhud setShader( "white", 640, 480 );
	self.poisonhud.color = ( 0, 1, 0 );
	self.poisonhud.alpha = 0.1;
	self.poisonhud.sort = 1;
	
	self iPrintLnBold( "You have been ^2poisoned^7!" );
	
	while ( isAlive( self ) && isDefined( self.ispoisoned ) )
	{
		oldhealth = self.health;
		
		dmg = 5;
		
		self finishPlayerDamage( dude, dude, dmg, 0, "MOD_MELEE", "bren_mp", self.origin, ( 0, 0, 0 ), "none" );
		
		wait 2;
		
		if ( self.health > oldhealth )
			break;
	}
	
	self.poisonhud destroy();
	self.ispoisoned = undefined;
}

zombieClass_fire() 
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_respawn" );
	
	while ( 1 ) {
		playfx( level._effect[ "zombies_fire" ], self.origin + ( 0, 0, 24 ) );
		wait 0.2;
	}
}

zombieClass_fast() 
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_respawn" );
	
	self.maxhealth = 250;
	self.health = 250;
}

zombieClass_shocker() 
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_respawn" );
}

be_shocked( dude )
{
    self shellshock( "groggy", 2 );
}

hunterClasses() {
	// base class values
	self.health = 100;
	self.maxhealth = 100;
	
	if ( !isDefined( self.class ) )
		return;
		
	if ( self.class == "random" ) {
		r = randomInt( level.classes[ "hunters" ].size - 1 );	// minus the random one
		self.class = level.classes[ "hunters" ][ r ].sName;
	}
	
	weapon = "";
		
	switch ( self.class ) {
		default:
            case "scout":               weapon = "ppsh_mp";             self hunterClass_scout();               break;
            case "soldier":             weapon = "panzerfaust_mp";      self hunterClass_soldier();             break;
            case "sniper":              weapon = "kar98k_sniper_mp";    self hunterClass_sniper();              break;
            case "support":             weapon = "mp44_mp";             self hunterClass_support();             break;
            case "medic":               weapon = "thompson_mp";         self hunterClass_medic();               break;
            case "engineer":            weapon = "m1garand_mp";         self hunterClass_engineer();            break;
            case "heavy":               weapon = "fg42_mp";             self hunterClass_heavy();               break;
			// unknown class:o
			break;
	}
	
    self.pers[ "weapon" ] = weapon;
	self giveWeapon( weapon );
	self giveMaxAmmo( weapon );
	self setSpawnWeapon( weapon );
	
	self hunterClass_updateAmmo();	
	
	self.health = self.maxhealth;
}

hunterClass_default_loadout()
{
    self giveWeapon( "luger_mp" );
    self giveWeapon( "stielhandgranate_mp" );   
    self setWeaponSlotAmmo( "grenade", 1 );
}

hunterClass_default() {
	self endon( "death" );
	
	self openMenu( "weapon_americangerman" );
	
	weapon = "";
	
	while ( 1 )
	{
		self waittill( "menuresponse", menu, response );
		
        // don't allow 'default' players to exit out of a weapon choice
		if ( response == "open" )
			continue;
		
		if ( response == "close" )
		{
			self openMenu( "weapon_americangerman" );
			continue;
		}
			
		if ( menu == "weapon_americangerman" )
		{
			if ( response == "team" || response == "viewmap" || response == "callvote" )
			{
				self closeMenu();
				wait 0.05;
				self openMenu( "weapon_americangerman" );
				continue;
			}
			
			self.pers[ "weapon" ] = response;
			break;
		}
	}
	
	wait 0.05;
	
	self.maxhealth = 100;
	self.health = self.maxhealth;
}

hunterClass_scout() {
    self.maxhealth = 125;
    
    self giveWeapon( "colt_mp" );
}

hunterClass_soldier() {
    self.maxhealth = 200;
    
    self setWeaponSlotWeapon( "primaryb", "mp40_mp" );
    self giveMaxAmmo( "mp40_mp" );
}

hunterClass_heavy() {
	self.maxhealth = 300;
    
    self setWeaponSlotWeapon( "primaryb", "bar_mp" );
    self giveMaxAmmo( "bar_mp" );
}

hunterClass_engineer() {
    self.maxhealth = 125;
    self setWeaponSlotWeapon( "grenade", "mk1britishfrag_mp" );
    self setWeaponSlotAmmo( "grenade", 0 );
}

hunterClass_medic() {
    self.maxhealth = 150;
    
    self setWeaponSlotWeapon( "grenade", "mk1britishfrag_mp" );
    self setWeaponSlotAmmo( "grenade", 0 );
    
    self thread heal();
    self thread regen_health();
}

regen_health()
{
    self endon( "death" );
    self endon( "disconnect" );
    
    while ( isAlive( self ) )
    {
        // got hurt somehow
        if ( self.health < self.maxhealth && self.lasthittime + 3000 < gettime() )
            self.health++;
            
        wait 0.5;
    }
}

heal()
{
    mypack = spawn( "script_model", self getOrigin() );
    mypack setModel( "xmodel/health_large" );
    
    self thread dohealing( mypack );
    
    while ( isAlive( self ) )
    {  
        wait 0.05;
        
        mypack hide();
        
        if ( self getCurrentWeapon() != "mk1britishfrag_mp" )
            continue;

        mypack show();
        traceDir = anglesToForward( self.angles );
        traceEnd = self.origin + ( 0, 0, 36 );
        traceEnd += [[ level.call ]]( "vector_scale", traceDir, 16 );
        trace = bulletTrace( self.origin + ( 0, 0, 36 ), traceEnd, false, mypack );

        pos = trace[ "position" ];
        mypack moveto( pos, 0.05 );
        mypack.angles = self.angles;
    }

    mypack delete();
}

dohealing( mypack )
{
    while ( isAlive( self ) )
    {
        wait 0.25;
        
        if ( self getCurrentWeapon() != "mk1britishfrag_mp" )
            continue;
            
        players = [[ level.call ]]( "get_good_players" );
        for ( i = 0; i < players.size; i++ )
        {
            if ( players[ i ].pers[ "team" ] == "axis" && distance( self.origin, players[ i ].origin ) < 56 )
            {
                if ( isDefined( players[ i ].ispoisoned ) )
                    players[ i ].ispoisoned = undefined;
                    
                if ( players[ i ] != self && players[ i ].health < players[ i ].maxhealth )
                    players[ i ].health++;
            }
        } 
    }
}

hunterClass_sniper() {
    self.maxhealth = 150;
    
    self setWeaponSlotAmmo( "grenade", 1 );
}

hunterClass_support() {
	self.maxhealth = 175;
    
    self setWeaponSlotWeapon( "grenade", "mk1britishfrag_mp" );
    self setWeaponSlotAmmo( "grenade", 0 );
    
    self thread ammobox();
}

hunterClass_updateAmmo() {
}

// support class gets to place an ammobox :p
ammobox()
{  
    boxmodels = [];
    boxmodels[ 0 ] = "xmodel/crate_misc1";
    boxmodels[ 1 ] = "xmodel/crate_misc_red1";
    boxmodels[ 2 ] = "xmodel/crate_misc_green1";
    boxmodels[ 3 ] = "xmodel/crate_champagne3";
    modeli = 0;
    
    mybox = spawn( "script_model", self getOrigin() );
    mybox setModel( boxmodels[ modeli ] );
    
    self [[ level.call ]]( "print", "double tap [f] to place ammobox", true );
    
    while ( isAlive( self ) )
    {  
        wait 0.05;
        
        mybox hide();
        
        if ( self getCurrentWeapon() != "mk1britishfrag_mp" )
            continue;

        mybox show();
        traceDir = anglesToForward( self.angles );
        traceEnd = self.origin;
        traceEnd += [[ level.call ]]( "vector_scale", traceDir, 80 );
        trace = bulletTrace( self.origin, traceEnd, false, mybox );

        pos = trace[ "position" ];
        mybox moveto( pos, 0.05 );
        mybox.angles = self.angles;
            
        // stoled from lev
        if ( self useButtonPressed() )
        {
            catch_next = false;
            lol = false;

			for ( i = 0; i <= 0.30; i += 0.01 )
			{
				if ( catch_next && self useButtonPressed() )
				{
					lol = true;
					break;
				}
				else if ( !( self useButtonPressed() ) )
					catch_next = true;

				wait 0.01;
			}
            
            if ( lol )
                break;
        }
        
        if ( self meleeButtonPressed() )
        {
            modeli++;
            
            if ( modeli >= boxmodels.size )
                modeli = 0;
                
            mybox setModel( boxmodels[ modeli ] );
        }
        
        wait 0.05;
    }
    
    trace = bullettrace( mybox.origin, mybox.origin + ( 0, 0, -1024 ), false, undefined );
    mybox moveto( trace[ "position" ], 0.1 );
    
    self [[ level.call ]]( "print", "ammobox placed!" );
    
    self switchToWeapon( self getWeaponSlotWeapon( "primary" ) );
    self setWeaponSlotWeapon( "grenade", "none" );
    
    self thread ammobox_remove();
    self thread ammobox_remove_count( mybox );
    self thread ammobox_think( mybox );
    
    self waittill( "remove ammobox" );
    mybox delete();
}

ammobox_remove()
{
    self waittill( "death" );
    self notify( "remove ammobox" );
}

// removes ammobox after it's depleted
ammobox_remove_count( box )
{
    self endon( "remove ammobox" );
   
    box.ammocount = randomInt( 20 ) + 10;
    
    while ( box.ammocount > 0 )
        wait 1;
        
    self notify( "remove ammobox" );
}

ammobox_think( box )
{
    self endon( "remove ammobox" );
    
	while ( 1 )
	{
		players = [[ level.call ]]( "get_good_players" );
		for ( i = 0; i < players.size; i++ )
		{
			if ( distance( box.origin, players[ i ].origin ) < 32 && players[ i ].pers[ "team" ] == "axis" && !isDefined( players[ i ].gettingammo ) )
				players[ i ] thread getammo( box );
		}
		
		wait 0.1;
	}
}

getammo( box )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.gettingammo = true;
	
	while ( isDefined( box ) && distance( box.origin, self.origin ) < 32 && isAlive( self ) )
	{	
		if ( !isDefined( self.ammonotice ) || !isDefined( self.boxnotice ) )
		{
			self.ammonotice = newClientHudElem( self );
			self.ammonotice.alignX = "center";
			self.ammonotice.alignY = "middle";
			self.ammonotice.x = 320;
			self.ammonotice.y = 320;
			self.ammonotice.alpha = 1;
			self.ammonotice setText( &"Hold [{+activate}] to get ammo" );
            
            self.boxnotice = newClientHudElem( self );
			self.boxnotice.alignX = "center";
			self.boxnotice.alignY = "middle";
			self.boxnotice.x = 320;
			self.boxnotice.y = 330;
			self.boxnotice.alpha = 1;
			self.boxnotice.label = &"Ammo left until depleted: ";
		}
        
        self.boxnotice setValue( box.ammocount );
		
		while ( !isDefined( self.givenammo ) && self usebuttonpressed() && self isOnGround() && isAlive( self ) )
		{
			org = spawn( "script_origin", self.origin );
			if ( !isdefined( self.progressbackground ) )
			{
				self.progressbackground = newClientHudElem( self );				
				self.progressbackground.alignX = "center";
				self.progressbackground.alignY = "middle";
				self.progressbackground.x = 320;
				self.progressbackground.y = 385;
				self.progressbackground.alpha = 0.75;
			}
			self.progressbackground setShader( "black", ( 288 + 4 ), 12 );		

			if ( !isdefined( self.progressbar ) )
			{
				self.progressbar = newClientHudElem( self );				
				self.progressbar.alignX = "left";
				self.progressbar.alignY = "middle";
				self.progressbar.x = ( 320 - ( 288 / 2.0 ) );
				self.progressbar.y = 385;
				self.progressbar.alpha = 1;
			}
			self.progressbar setShader( "white", 0, 8 );
			self.progressbar scaleOverTime( 2, 288, 8 );
			
			self linkto( org );
			
			self.progresstime = 0;
			while( self useButtonPressed() && ( self.progresstime < 2 ) && isAlive( self ) )
			{
				self.progresstime += 0.05;
				wait 0.05;
			}
			
			org delete();
			
			if ( self.progresstime >= 2 )
			{			
				// ideally we'll decrement the amount of uses this ammobox has here
                box.ammocount--;
                
                // stolen from kill3r's mod
                // this way is better suited for this version of zombies, since we're not actually giving health anymore
                self playlocalsound( "weap_pickup" );

                oldamountpri = self getWeaponSlotAmmo( "primary" );
                oldamountprib = self getWeaponSlotAmmo( "primaryb" );
                oldamountpistol = self getWeaponSlotAmmo( "pistol" );
                oldamountgrenade = self getWeaponSlotAmmo( "grenade" );
                oldamountsmokegrenade = self getWeaponSlotAmmo( "smokegrenade" );

                self setWeaponSlotAmmo( "primary", ( oldamountpri + 90 ) );
                self setWeaponSlotAmmo( "primaryb", ( oldamountprib + 90 ) );
                self setWeaponSlotAmmo( "pistol", ( oldamountpistol + 30 ) );
				
				self.givenammo = true;
				
				self.progressbackground destroy();
				self.progressbar destroy();
				
				self playSound( "weap_ammo_pickup" );
				
				self thread waitammo();
				break;
			}
			else
			{
				self.progressbackground destroy();
				self.progressbar destroy();
			}
		}
		
		wait 0.05;
	}
	
	self.ammonotice destroy();
    self.boxnotice destroy();
	self.gettingammo = undefined;
}
/*
getammo( box )
{
    self endon( "death" );
    self endon( "disconnect" );
    
    self.gettingammo = true;
    
    self playlocalsound( "weap_pickup" );

    oldamountpri = self getWeaponSlotAmmo( "primary" );
    oldamountprib = self getWeaponSlotAmmo( "primaryb" );
    oldamountpistol = self getWeaponSlotAmmo( "pistol" );

    self setWeaponSlotAmmo( "primary", ( oldamountpri + 30 ) );
    self setWeaponSlotAmmo( "primaryb", ( oldamountprib + 30 ) );
    self setWeaponSlotAmmo( "pistol", ( oldamountpistol + 10 ) );
    
    wait 2;
    
    self.gettingammo = undefined;
}
*/
waitammo()
{
	wait 1;
	self.givenammo = undefined;
}

loadout()
{
    if ( self.pers[ "team" ] == "axis" )
    {
        if ( self.class != "default" )
            self hunterClasses();
    }
    else
        self zombieClasses();
}