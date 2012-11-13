/*
    File:           precache.gsc
    Author:         Cheese
    Last update:    8/10/2012
*/

init()
{
    [[ level.register ]]( "precache", ::precacheObject );
    
    level.sMapName = getCvar( "mapname" );
	level.sGametype = getCvar("g_gametype");
	
	// set up game[] variables, etc.
	game[ "allies" ] = "british";
	game[ "axis" ] = "german";

	if ( !isdefined( game[ "layoutimage" ] ) )
		game[ "layoutimage" ] = "default";
	game[ "layoutname" ] = "levelshots/layouts/hud@layout_" + game[ "layoutimage" ];
	setcvar( "scr_layoutimage", game[ "layoutname" ] );
	makeCvarServerInfo( "scr_layoutimage", "" );

	game[ "menu_team"] = "team_germanonly";
	game[ "menu_weapon_allies" ] = "weapon_" + game[ "allies" ];
	game[ "menu_weapon_axis" ] = "weapon_americangerman";
	game[ "menu_viewmap" ] = "viewmap";
	game[ "menu_callvote" ] = "callvote";
	game[ "menu_quickcommands" ] = "quickcommands";
	game[ "menu_quickstatements" ] = "quickstatements";
	game[ "menu_quickresponses" ] = "quickresponses";
	game[ "headicon_allies" ] = "gfx/hud/headicon@allies.tga";
	game[ "headicon_axis" ] = "gfx/hud/headicon@axis.tga";
	
	// menus
	precacheObject( game[ "menu_team" ], "menu" );
	precacheObject( game[ "menu_weapon_allies" ], "menu" );
	precacheObject( game[ "menu_weapon_axis" ], "menu" );
	precacheObject( game[ "menu_viewmap" ], "menu" );
	precacheObject( game[ "menu_callvote" ], "menu" );
	precacheObject( game[ "menu_quickcommands" ], "menu" );
	precacheObject( game[ "menu_quickstatements" ], "menu" );
	precacheObject( game[ "menu_quickresponses" ], "menu" );
	
	// strings
	precacheObject( &"KILLCAM", "string" );
	precacheObject( &"FINAL KILLCAM", "string" );
	precacheObject( &"Zombies", "string" );
	precacheObject( &"Hunters", "string" );
	precacheObject( &"^1Zom^7bies Pre-Alpha 0.1", "string" );
	precacheObject( &"You killed ", "string" );
	precacheObject( &"Auto join in: ", "string" );
	precacheObject( &"Select Your Class", "string" );
	precacheObject( &"Press [{+attack}] to change selection", "string" );
	precacheObject( &"Press [{+activate}] to spawn", "string" );
	precacheObject( &"Description:\n    ", "string" );
	precacheObject( &"Perks:\n", "string" );
	precacheObject( &"^3You need to be registered to have access\nto the other classes listed here.\n\nRegister now at www.1.1zombies.com!", "string" );
    precacheObject( &"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN", "string" );
    precacheObject( &"^7Players needed until game starts: ^1", "string" );
    precacheObject( &"^7Game starts in: ^2", "string" );

	// shaders
	precacheObject( "white", "shader" );
	precacheObject( "black", "shader" );
	precacheObject( "hudScoreboard_mp", "shader" );
	precacheObject( "gfx/hud/hud@mpflag_spectator.tga", "shader" );
	precacheObject( game[ "layoutname" ], "shader" );
	precacheObject( "gfx/effects/mist.tga", "shader" );
	
	// items
	precacheObject( "item_health", "item" );
	precacheObject( "item_health_large", "item" );
	precacheObject( "item_health_small", "item" );
	precacheObject( "fraggrenade_mp", "item" );
	precacheObject( "colt_mp", "item" );
	precacheObject( "m1carbine_mp", "item" );
	precacheObject( "m1garand_mp", "item" );
	precacheObject( "thompson_mp", "item" );
	precacheObject( "bar_mp", "item" );
	precacheObject( "springfield_mp", "item" );
	precacheObject( "mk1britishfrag_mp", "item" );
	precacheObject( "enfield_mp", "item" );
	precacheObject( "sten_mp", "item" );
	precacheObject( "bren_mp", "item" );
	precacheObject( "rgd-33russianfrag_mp", "item" );
	precacheObject( "luger_mp", "item" );
	precacheObject( "mosin_nagant_mp", "item" );
	precacheObject( "ppsh_mp", "item" );
	precacheObject( "mosin_nagant_sniper_mp", "item" );
	precacheObject( "stielhandgranate_mp", "item" );
	precacheObject( "kar98k_mp", "item" );
	precacheObject( "mp40_mp", "item" );
	precacheObject( "mp44_mp", "item" );
	precacheObject( "kar98k_sniper_mp", "item" );
	precacheObject( "panzerfaust_mp", "item" );
	
	// models
	
	// shellshocks
	precacheObject( "default", "shellshock" );
	precacheObject( "groggy", "shellshock" );
	precacheObject( "stop", "shellshock" );
	
	// headicons
	precacheObject( "gfx/hud/headicon@quickmessage", "headicon" );
	precacheObject( game[ "headicon_allies" ], "headicon" );
	precacheObject( game[ "headicon_axis" ], "headicon" );
	
	// statusicons
	precacheObject( "gfx/hud/hud@status_dead.tga", "statusicon" );
	precacheObject( "gfx/hud/hud@status_connecting.tga", "statusicon" );
	
	// fx
	level._effect[ "zombies_fire" ] = loadfx( "fx/fire/tinybon.efx" );
    level._effect[ "zombies_groundexplode" ] = loadfx( "fx/smoke/aftermath1.efx" );
}

precacheObject( oObject, sType ) 
{
	if ( !isDefined( level.aPrecached ) )
		level.aPrecached = [];

	// will precache multiple items with the same name, but not with the same type. i.e.
	// precacheObject( "hud/icon", "headicon" );
	// precacheObject( "hud/icon", "statusicon" );
	// works, but if you try to precacheObject( "hud/icon", "headicon" ) again somewhere, it will not go through
	for ( i = 0; i < level.aPrecached.size; i++ ) 
    {
		if ( isDefined( level.aPrecached[ i ] ) ) 
        {
			oTempObject = level.aPrecached[ i ].oObject;
			sTempType = level.aPrecached[ i ].sType;
			if ( oTempObject == oObject && sTempType == sType ) 
            {
                // TODO: log here
				return;
			}
		}
	}
		
	switch ( sType ) 
    {
		case "string":      precacheString( oObject ); break;
		case "model":       precacheModel( oObject ); break;
		case "shader":      precacheShader( oObject ); break;
		case "menu":        precacheMenu( oObject ); break;
		case "item":        precacheItem( oObject ); break;
		case "shellshock":  precacheShellshock( oObject ); break;
		case "headicon":    precacheHeadIcon( oObject ); break;
		case "statusicon":  precacheStatusIcon( oObject ); break;
		default: // TODO: log here
            return;
	}
	
	oStruct = spawnstruct();
    oStruct.oObject = oObject;
	oStruct.sType = sType;
	level.aPrecached[ level.aPrecached.size ] = oStruct;
}