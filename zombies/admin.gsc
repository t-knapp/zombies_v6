init()
{
	level._effect[ "admin_slay" ] = loadFx( "fx/explosions/pathfinder_explosion.efx" );
	
	precacheShellshock( "default" );
	
	precacheModel( "xmodel/toilet" );
	precacheModel( "xmodel/vehicle_tank_tiger" );
	precacheModel( "xmodel/vehicle_russian_barge" );

	// Insults
	insults[0]  = "^1's mom is like a hardware store... 10 cents a screw.";
	insults[1]  = "^1. I'd like to see things from your point of view but I can't seem to get my head that far up my ass.";
	insults[2]  = "^1's mom is so poor, she once fought a blind squirrel for a peanut.";
	insults[3]  = "^1 is so stupid he tried to eat a crayon because it looked fruity!";
	insults[4]  = "^1 is so stupid he tought a 'quarter back' is a refund.";
	insults[5]  = "^1 is so poor he uses an ice cube as his A/C.";
	insults[6]  = "^1. If you were any more stupid, he'd have to be watered twice a week.";
	insults[7]  = "^1. I could make a monkey out of you, but why should I take all the credit?";
	insults[8]  = "^1. I heard you got a brain transplant and the brain rejected you!";
	insults[9]  = "^1. How did you get here? Did someone leave your cage open?";
	insults[10] = "^1 got more issues than National Geographic!";
	insults[11] = "^1. If you were my dog, I'd shave your butt and teach you to walk backwards.";
	insults[12] = "^1. You're the reason God created the middle finger.";
	insults[13] = "^1. I hear that when your mother first saw you, she decided to leave you on the front steps of a police station while she turned herself in.";
	insults[14] = "^1. Your IQ involves the square root of -1.";
	insults[15] = "^1. You know you're a bad gamer when you still miss with an aimbot.";
	insults[16] = "^1. You're such a nerd that your penis plugs into a flash drive.";
	insults[17] = "^1's mom is so FAT32, she wouldn't be accepted by NTFS!";
	insults[18] = "^1. You're not important - you're just an NPC!";
	insults[19] = "^1, you're so slow, is your ping at 999?";
	insults[20] = "^1. You're not optimized for life are you?";
	insults[21] = "^1. You must have been born on a highway because that's where most accidents happen.";
	insults[22] = "^1. Why don't you slip into something more comfortable... like a coma.";
	insults[23] = "^1. I had a nightmare. I dreamt I was you.";
	insults[24] = "^1. Lets play 'house'. You be the door and I'll slam you.";
	insults[25] = "^1, I'm gonna get you a condom. That way you can have protection when you go fuck yourself.";
	insults[26] = "^1. Roses are red, violets are blue, I have 5 fingers, the 3rd ones for you.";
	insults[27] = "^1. Ever since I saw you in your family tree, I've wanted to cut it down.";
	insults[28] = "^1, your village just called. They're missing an idiot.";
	insults[29] = "^1, I can't think of an insult stupid enough for you.";

	level.iC = 0;
	level.insults = array_shuffle(insults);
}

main()
{
	thread watchVar( "admin_kill", ::kill );
	thread watchVar( "admin_giveweap", ::giveWeap );
	thread watchVar( "admin_say", ::say );
	thread watchVar( "admin_drop", ::drop );
	thread watchVar( "admin_rename", ::rename );
	thread watchVar( "admin_spank", ::spank );
	thread watchVar( "admin_slap", ::slap );
	thread watchVar( "admin_blind", ::blind );
	thread watchVar( "admin_forcespec", ::forcespec );
	thread watchVar( "admin_toilet", ::toilet );
	thread watchVar( "admin_runover", ::runover );
	thread watchVar( "admin_squash", ::squash );
	thread watchVar( "admin_insult", ::insult );
}

watchVar( varname, func )
{
	setCvar( varname, "" );
	
	while ( 1 )
	{
		if ( getCvar( varname ) != "" )
		{
			thread [[ func ]]( getCvar( varname ) );
			setCvar( varname, "" );
		}
			
		wait 0.05;
	}
}

kill( value )
{
	player = getPlayer( value );
	
	if ( isDefined( player ) )
	{
		player suicide();
		playFx( level._effect[ "admin_slay" ], player.origin );
		
		iPrintLn( "^1The admin killed ^2" + player.name + "^1!" );
	}
}

giveWeap( value )
{
	array = explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
		return;
		
	player = getPlayer( array[ 0 ] );
	weapon = array[ 1 ];
	slot = "primary";
	
	if ( isDefined( array[ 2 ] ) )
		slot = array[ 2 ];
		
	player setWeaponSlotWeapon( slot, weapon );
	player setWeaponSlotAmmo( slot, 9999 );
	player switchToWeapon( weapon );
}

say( value )
{
	iPrintLnBold( value );
}

drop( value )
{
	array = explode( value, " " );
	height = 512;
	
	if ( !isDefined( array[ 0 ] ) )
		return;

	player = getPlayer( array[ 0 ] );
	if ( isDefined( array[ 1 ] ) )
		height = (int)array[ 1 ];
	
	if ( isDefined( player ) )
	{
		player endon( "disconnect" );
		
		player.drop = spawn( "script_origin", player.origin );
		player linkto( player.drop );
		
		player.drop movez( height, 2 );
		wait 2;
		player unlink();
		player.drop delete();
		
		iPrintLn( "^1The admin DROPPED ^2" + player.name + "^1!" );
	}
}

spank( value )
{
	array = explode( value, " " );
	time = 30;
	
	if ( !isDefined( array[ 0 ] ) )
		return;
		
	player = getPlayer( array[ 0 ] );
	if ( isDefined( array[ 1 ] ) )
		time = (int)array[ 1 ];
		
	if ( isDefined( player ) )
	{
		iPrintLn( "^1The admin SPANKED ^2" + player.name + "^1!" );
			
		player shellshock( "default", time / 2 );
		for( i = 0; i < time; i++ )
		{
			player playSound( "melee_hit" );
			player setClientCvar( "cl_stance", 2 );
			wait randomFloat( 0.5 );
		}
		player shellshock( "default", 1 );
	}
}

slap( value )
{
	array = explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) )
		return;
		
	dmg = 10;
	player = getPlayer( array[ 0 ] );
	if ( isDefined( array[ 1 ] ) )
		dmg = (int)array[ 1 ];
		
	if ( isDefined( player ) )
	{
		eInflictor = player;
		eAttacker = player;
		iDamage = dmg;
		iDFlags = 0;
		sMeansOfDeath = "MOD_PROJECTILE";
		sWeapon = "panzerfaust_mp";
		vPoint = ( player.origin + ( 0, 0, -1 ) );
		vDir = vectorNormalize( player.origin - vPoint );
		sHitLoc = "none";
		psOffsetTime = 0;

		player playSound( "melee_hit" );
		player finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		
		iPrintLn( "^1The admin SLAPPED ^2" + player.name + "^1!" );
	}
}

rename( value )
{
	array = explode( value, " " );

	if ( !isDefined( array[ 0 ] ) && !isDefined( array[ 1 ] ) )
		return;
		
	player = getPlayer( array[ 0 ] );
	
	if ( isDefined( player ) )
	{
		newname = "";
		for ( i = 1; i < 10; i++ )
		{
			if ( isDefined( array[ i ] ) )
			{
				newname += " ";
				newname += array[ i ];
			}
		}
		
		player setClientCvar( "name", newname );
	}
}

blind( value )
{
	array = explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) )
		return;
	
	time = 10;
	player = getPlayer( array[ 0 ] );
	if ( isDefined( array[ 1 ] ) )
		time = (int)array[ 1 ];
	
	if( isDefined( player ) )
	{
		iPrintLn( "^1The admin BLINDED ^2" + player.name + "^1!" );
		half = time / 2;
		
		player shellshock( "default", time ); 
		player.blindscreen = newClientHudElem( player );
		player.blindscreen.x = 0;
		player.blindscreen.y = 0;
		player.blindscreen.alpha = 1;
		player.blindscreen setShader( "white", 640, 480 );
		
		wait half;
		
		player.blindscreen fadeOverTime( half );
		player.blindscreen.alpha = 0;
		wait time;
		player.blindscreen destroy();
	}
}

forcespec( value )
{
	player = getPlayer( value );
	if( isDefined( player ) )
	{
		player thread [[ level.call ]]( "spawn_spectator" );
		iPrintLn( "^1The admin FORCED ^2" + player.name + "^1 to spectator." );
	}
}

toilet( value )
{ 
	player = getPlayer( value );
	if( isDefined( player ) )
	{
		player detachall();
		player takeAllWeapons();
		player setmodel( "xmodel/toilet" );

		iPrintLn( "^1The admin turned ^2" + player.name + "^1 into a toilet!" );

		isSet3rdPerson = false;

		while(player.sessionstate == "playing") {
			if(!isSet3rdPerson) {
				player setClientCvar("cg_thirdperson", "1");
				isSet3rdPerson = true;
			}
			wait 0.05;  
		}
		player setClientCvar("cg_thirdperson", "0");
	}
}


insult(value)
{
	player = getPlayer(value);
	if(!isDefined(player))
	return;

	// Check if all the insults have been displayed
	if(level.iC >= (level.insults.size - 1)) {
		// If it is, print the last insult
		iPrintLnBold(player.name + level.insults[level.insults.size - 1]);
		// Shuffle the array again so we don't got the same list of insults
		level.insults = array_shuffle(level.insults);
		// Reset the insult counter
		level.iC = 0;
	} else {
		iPrintLnBold(player.name + level.insults[level.iC]);
		level.iC++;
	}
}

runover( value )
{
	player = getPlayer( value );
	if( isDefined( player ) )
	{
		lol = spawn( "script_origin", player getOrigin() );
		player linkto( lol );
		tank = spawn( "script_model", player getOrigin() + ( -512, 0, -256 ) );
		tank setmodel( "xmodel/vehicle_tank_tiger" );
		angles = vectortoangles( player getOrigin() - ( tank.origin + ( 0, 0, 256 ) ) );
		tank.angles = angles;
		tank playloopsound( "tiger_engine_high" );
		tank movez( 256, 1 );
		wait 1;
		tank movex( 1024, 5 );
		wait 1.8;
		iPrintLn( "^2" + player.name + "^1 was RUN OVER by a tank!" );
		player suicide();
		wait 3.2;
		tank movez( -256, 1 );
		wait 1;
		tank stoploopsound();
		tank delete();
		lol delete();
	}
}

squash( value )
{
	player = getPlayer( value );
	
	if( isDefined( player ) )
	{
		lol = spawn( "script_model", player getOrigin() );
		player linkto( lol );
		thing = spawn( "script_model", player getOrigin() + ( 0, 0, 1024 ) );
		thing setmodel( "xmodel/vehicle_russian_barge" );
		thing movez( -1024, 2 );
		wait 2;
		iPrintLn( "^1The admin SQUASHED ^7" + player.name + "^1 with a russian barge!" );
		player suicide();
		thing movez( -512, 5 );
		wait 5;
		thing delete();
		lol delete();
	}
}

getPlayer( iID )
{
	eGuy = undefined;
	ePlayers = getEntArray( "player", "classname" );
	for ( i = 0; i < ePlayers.size; i++ )
	{
		if ( ePlayers[ i ] getEntityNumber() == iID )
		{
			eGuy = ePlayers[ i ];
			break;
		}
	}
			
	return eGuy;
}

explode( s, delimiter )
{
	j = 0;
	temparr[ j ] = "";	

	for ( i = 0; i < s.size; i++ )
	{
		if ( s[ i ] == delimiter )
		{
			j++;
			temparr[ j ] = "";
		}
		else
			temparr[ j ] += s[i];
	}
	return temparr;
}

array_shuffle(arr)
{
	for(i = 0; i < arr.size; i++) {
		// Store the current array element in a variable
		_tmp = arr[i];

		// Generate a random number
		rN = randomInt(arr.size);

		// Replace the current with the random
		arr[i] = arr[rN];
		// Replace the random with the current
		arr[rN] = _tmp;
	}
	return arr;
}