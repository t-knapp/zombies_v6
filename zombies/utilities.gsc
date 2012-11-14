/*
    File:           utilities.gsc
    Author:         Cheese & Cato
    Last update:    9/10/2012
*/

init()
{
    // general utilities
	[[ level.register ]]( "name_fix", ::nameFix, level.iFLAG_RETURN );
	[[ level.register ]]( "delete_entity", ::deleteEntity );
	[[ level.register ]]( "array_remove", ::array_remove, level.iFLAG_RETURN );
	[[ level.register ]]( "in_array", ::in_array, level.iFLAG_RETURN );
    [[ level.register ]]( "array_shuffle", ::array_shuffle, level.iFLAG_RETURN );
    [[ level.register ]]( "strtok", ::strTok, level.iFLAG_RETURN );
    [[ level.register ]]( "get_server_setting", ::getServerSetting, level.iFLAG_RETURN );
    [[ level.register ]]( "strip", ::strip, level.iFLAG_RETURN );
    [[ level.register ]]( "is_numeric", ::is_numeric, level.iFLAG_RETURN );
    [[ level.register ]]( "get_plant", ::getPlant, level.iFLAG_RETURN );
    [[ level.register ]]( "orient_to_normal", ::orientToNormal, level.iFLAG_RETURN );
    [[ level.register ]]( "save_model", ::saveModel, level.iFLAG_RETURN );
    [[ level.register ]]( "load_model", ::loadModel );
    [[ level.register ]]( "play_sound_in_space", ::play_sound_in_space );
    [[ level.register ]]( "get_player", ::getPlayer, level.iFLAG_RETURN );
    [[ level.register ]]( "get_good_players", ::getGoodPlayers, level.iFLAG_RETURN );
    [[ level.register ]]( "get_weapon_type", ::getWeaponType, level.iFLAG_RETURN );
    [[ level.register ]]( "error", ::error );
    [[ level.register ]]( "print", ::print );
    [[ level.register ]]( "set_team", ::set_team );
    [[ level.register ]]( "remove_game_objects", ::remove_game_objects );
    [[ level.register ]]( "spawn", ::_spawn, level.iFLAG_RETURN );
    [[ level.register ]]( "delete", ::_delete );
    [[ level.register ]]( "convert_time", ::convert_time, level.iFLAG_RETURN );
	
	// math stuff
	[[ level.register ]]( "abs", ::abs, level.iFLAG_RETURN );
	[[ level.register ]]( "sqrt ", ::sqrt, level.iFLAG_RETURN );
    [[ level.register ]]( "pow", ::pow, level.iFLAG_RETURN );
    [[ level.register ]]( "factorial", ::factorial, level.iFLAG_RETURN );
    [[ level.register ]]( "lshift", ::lshift, level.iFLAG_RETURN );
    [[ level.register ]]( "rshift", ::rshift, level.iFLAG_RETURN );
    [[ level.register ]]( "round", ::round, level.iFLAG_RETURN );
    [[ level.register ]]( "floor", ::floor, level.iFLAG_RETURN );
	[[ level.register ]]( "rand", ::rand, level.iFLAG_RETURN );
	[[ level.register ]]( "rand_range", ::randRange, level.iFLAG_RETURN );
    
    // vectors
	[[ level.register ]]( "vector_scale", ::vector_scale, level.iFLAG_RETURN );
    [[ level.register ]]( "vector_multiply", ::vector_multiply, level.iFLAG_RETURN );
    [[ level.register ]]( "vector_add", ::vector_add, level.iFLAG_RETURN );
    [[ level.register ]]( "vector_subtract", ::vector_subtract, level.iFLAG_RETURN );
	
	deleteEntity( "mpweapon_m1carbine" );
	deleteEntity( "mpweapon_m1garand" );
	deleteEntity( "mpweapon_thompson" );
	deleteEntity( "mpweapon_bar" );
	deleteEntity( "mpweapon_springfield" );
	deleteEntity( "mpweapon_enfield" );
	deleteEntity( "mpweapon_sten" );
	deleteEntity( "mpweapon_bren" );
	deleteEntity( "mpweapon_mosinnagant" );
	deleteEntity( "mpweapon_ppsh" );
	deleteEntity( "mpweapon_mosinnagantsniper" );
	deleteEntity( "mpweapon_kar98k" );
	deleteEntity( "mpweapon_mp40" );
	deleteEntity( "mpweapon_mp44" );
	deleteEntity( "mpweapon_kar98ksniper" );
	deleteEntity( "mpweapon_fg42" );
	deleteEntity( "mpweapon_panzerfaust" );
}

nameFix(s, notplayer, o3, o4, o5, o6, o7, o8, o9) {
  if(!isDefined(s))
    return "";
  
  allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!'#/&()=?+`^~*-.,;<>|$@:[]{}_ ";
  
  badName = false;
    
  for(i = 0; i < s.size; i++) {
    matchFound = false;
    
    for(z = 0; z < allowedChars.size; z++) {
      if(s[i] == allowedChars[z]) {
        matchFound = true;
        break;
      }
    }
    
    if(!matchFound) {
      badName = true;
      break;
    }
  }
  
  if(badName) {
    fixedName = "";
    
    for(i = 0; i < s.size; i++) {
      for(z = 0; z < allowedChars.size; z++) {
        if(s[i] == allowedChars[z]) {
          fixedName += s[i];
          break;
        }
      }
    }
    
    if ( !isDefined( notplayer ) || ( isDefined( notplayer ) && !notplayer ) )
    {
      self [[ level.call ]]( "print", "Unallowed characters in name!", true );
      self setClientCvar("name", fixedName);
    }
    return fixedName;
  } else {
    return s;
  }
}

deleteEntity(entity, o2, o3, o4, o5, o6, o7, o8, o9) {
	entities = getEntArray(entity, "classname");
	for(i = 0; i < entities.size; i++) {
    if(isDefined(entities[i]))
      entities[i] delete();
	}
}

array_remove(arr, str, r, o4, o5, o6, o7, o8, o9) {
  if(!isDefined(r))
    r = false;

  x = 0;
  _tmpa = [];
  for(i = 0; i < arr.size; i++) {    
    if(arr[i] != str) {
      _tmpa[x] = arr[i];
      x++;
    } else {
      if(r) {
        _tmpa[x - 1] = undefined;
        x--;
      }
    }
  }

  _tmp = _tmpa;

  if(r) { // If set to true, it will remove previous elemnts aswell, used in mapvote
    y = 0;
    _tmpb = [];
    for(i = 0; i < _tmpa.size; i++) {    
      if(isDefined(_tmpa[i])) {
        _tmpb[y] = _tmpa[i];
        y++;
      }
    }
    _tmp = _tmpb;
  }
  return _tmp;
}

in_array(arr, needle, o3, o4, o5, o6, o7, o8, o9) {
  for(i = 0; i < arr.size; i++)
    if(arr[i] == needle)
      return true;
  
  return false;
}

array_shuffle(arr, o2, o3, o4, o5, o6, o7, o8, o9) {
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

strTok(longStr, separator, o3, o4, o5, o6, o7, o8, o9)  {
   sepcount = 0; //Seperation Counts    -1 default
   string = [];
   longStr += ""; // turn it into a string if it isn't  already   
   for(i = 0; i < longStr.size; i++){
      if(longStr[i] == separator) {
         sepcount++;
      } else {
         if(!isDefined(string[sepcount]))
            string[sepcount] = "";
            
         string[sepcount] += longStr[i];
      }
   }
   
   return string;
}

getServerSetting( cvar, defaultvalue, type, min, max, o6, o7, o8, o9 ) {
	temp = "";
    
    // cvar is blank/not set
    if ( getCvar( cvar ) == "" )
        return defaultvalue;
        
	switch ( type ) {
		case "int": temp = getCvarInt( cvar ); break;
		case "float": temp = getCvarFloat( cvar ); break;
		case "string":
		default: temp = getCvar( cvar ); break;
	}
		
	if ( type == "int" || type == "float" ) {
		if ( temp < min )
			temp = min;
		if ( temp > max )
			temp = max;
	}
	
	return temp;
}

strip(s, o2, o3, o4, o5, o6, o7, o8, o9) {
	if(s == "")
		return "";

	s2 = "";
	s3 = "";

	i = 0;
	while(i < s.size && s[i] == " ")
		i++;

	if(i == s.size)
		return "";
	
	for(; i < s.size; i++) {
		s2 += s[i];
	}

	i = s2.size-1;
	while(s2[i] == " " && i > 0)
		i--;

	for(j = 0; j <= i; j++) {
		s3 += s2[j];
	}
		
	return s3;
}

is_numeric(n, o2, o3, o4, o5, o6, o7, o8, o9) {
  n = (string)n;
  for(i = 0; i < n.size; i++) {
    switch(n[i]) {
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
      case "7":
      case "8":
      case "9":
      case "0":
      break;
      
      default:
        return false;
    }
  }
  
  return true;
}

// object - function calling (required)
// string - what to put in the actual log (required)
// important - bool
log( object, string, important, o4, o5, o6, o7, o8, o9 ) {
	logPrint( object + " - " + string + "\n" );
	if ( isDefined( important ) && important )
		iPrintLnBold( object + " - " + string );
}

getPlant( o1, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	start = self.origin + (0, 0, 10);

	range = 11;
	forward = anglesToForward(self.angles);
	forward = vector_scale(forward, range);

	traceorigins[0] = start + forward;
	traceorigins[1] = start;

	trace = bulletTrace(traceorigins[0], (traceorigins[0] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1) {
		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orientToNormal(trace["normal"]);
		return temp;
	}

	trace = bulletTrace(traceorigins[1], (traceorigins[1] + (0, 0, -18)), false, undefined);
	if(trace["fraction"] < 1) {
		temp = spawnstruct();
		temp.origin = trace["position"];
		temp.angles = orientToNormal(trace["normal"]);
		return temp;
	}

	traceorigins[2] = start + (16, 16, 0);
	traceorigins[3] = start + (16, -16, 0);
	traceorigins[4] = start + (-16, -16, 0);
	traceorigins[5] = start + (-16, 16, 0);

	for(i = 0; i < traceorigins.size; i++) {
		trace = bulletTrace(traceorigins[i], (traceorigins[i] + (0, 0, -1000)), false, undefined);

		if(!isdefined(besttracefraction) || (trace["fraction"] < besttracefraction)) {
			besttracefraction = trace["fraction"];
			besttraceposition = trace["position"];
		}
	}
	
	if(besttracefraction == 1)
		besttraceposition = self.origin;
	
	temp = spawnstruct();
	temp.origin = besttraceposition;
	temp.angles = orientToNormal(trace["normal"]);
	return temp;
}

orientToNormal(normal, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	hor_normal = (normal[0], normal[1], 0);
	hor_length = length(hor_normal);

	if(!hor_length)
		return (0, 0, 0);
	
	hor_dir = vectornormalize(hor_normal);
	neg_height = normal[2] * -1;
	tangent = (hor_dir[0] * neg_height, hor_dir[1] * neg_height, hor_length);
	plant_angle = vectortoangles(tangent);

	return plant_angle;
}

saveModel( o1, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	info["model"] = self.model;
	info["viewmodel"] = self getViewModel();
	attachSize = self getAttachSize();
	
	for(i = 0; i < attachSize; i++) {
		info["attach"][i]["model"] = self getAttachModelName(i);
		info["attach"][i]["tag"] = self getAttachTagName(i);
	}
	
	return info;
}

loadModel(info, o2, o3, o4, o5, o6, o7, o8, o9) {
	self detachAll();
	self setModel(info["model"]);
	self setViewModel(info["viewmodel"]);
	attachInfo = info["attach"];
	attachSize = attachInfo.size;
    
	for(i = 0; i < attachSize; i++)
		self attach(attachInfo[i]["model"], attachInfo[i]["tag"]);
}

play_sound_in_space (alias, origin, o3, o4, o5, o6, o7, o8, o9) {
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	org playsound (alias);
	wait ( 10.0 );
	org delete();
}

rand( num, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	temparr = [];
	for ( i = 0; i < 1024; i++ )
		temparr[ i ] = randomInt( num );
		
	thisint = temparr[ randomInt( temparr.size ) ];
	return thisint;
}

randRange( min, max, o3, o4, o5, o6, o7, o8, o9 ) {
	temparr = [];
	for ( i = 0; i < 1024; i++ )
		temparr[ i ] = randomInt( max );
		
	goods = [];
	for ( i = 0; i < temparr.size; i++ ) {
		if ( temparr[ i ] < min )
			continue;
		goods[ goods.size ] = temparr[ i ];
	}
	
	thisint = goods[ randomInt( goods.size ) ];
	return thisint;
}

getPlayer( iID, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	eGuy = undefined;
	ePlayers = getEntArray( "player", "classname" );
	for ( i = 0; i < ePlayers.size; i++ ) {
		if ( ePlayers[ i ] getEntityNumber() == iID ) {
			eGuy = ePlayers[ i ];
			break;
		}
	}
			
	return eGuy;
}

getGoodPlayers( o1, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	players = getEntArray( "player", "classname" );
	good = [];
	for ( i = 0; i < players.size; i++ ) {
		if ( players[ i ].pers[ "team" ] != "spectator" && players[ i ].sessionstate == "playing" )
			good[ good.size ] = players[ i ];
	}
	
	return good;
}

abs( val, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	if ( val < 0 )
		return val * -1;
	
	return val;
}

sqrt( n, o2, o3, o4, o5, o6, o7, o8, o9 ) {
	e = 1;
	
	for ( i = 0; i < 100; i++ ) {
		e = ( e + ( n / e ) ) / 2;
	}
	
	return e;
}

pow( n, e, o3, o4, o5, o6, o7, o8, o9 ) {
    r = n;
    
    for ( i = 1; i < e; i++ ) {
        r *= n;
    }
    
    return r;
}

factorial( n, o2, o3, o4, o5, o6, o7, o8, o9 ) {
    if ( n < 0 )    return -1;
    
    for ( i = n - 1; i > 0; i-- ) {
        n *= i;
    }
    
    return n;
}

lshift( n, s, o3, o4, o5, o6, o7, o8, o9 ) {
    return ( n * pow( 2, s ) );
}

rshift( n, s, o3, o4, o5, o6, o7, o8, o9 ) {
    return ( n / pow( 2, s ) );
}

round( n, d, o3, o4, o5, o6, o7, o8, o9 ) {
    if ( ((int)(n * pow( 10, d )) % pow( 10, d )) >= ( pow( 10, d ) / 2 ) )
        return (((int)(n * pow( 10, d )) - ((int)(n * pow( 10, d )) % pow( 10, d ))) + (((int)(n * pow( 10, d )) % pow( 10, d )) - (((int)(n * pow( 10, d )) % pow( 10, d )))) + pow( 10, d )) / pow( 10, d );
    else
        return (int)n;
}

floor( n, o2, o3, o4, o5, o6, o7, o8, o9 ) {
    return (int)n;
}

vector_scale( vecA, scale, o3, o4, o5, o6, o7, o8, o9 ) {
    return ( vecA[ 0 ] * scale, vecA[ 1 ] * scale, vecA[ 2 ] * scale );
}

vector_multiply( vecA, vecB, o3, o4, o5, o6, o7, o8, o9 ) {
    return ( vecA[ 0 ] * vecB[ 0 ], vecA[ 1 ] * vecB[ 1 ], vecA[ 2 ] * vecB[ 2 ] );
}

vector_add( vecA, vecB, o3, o4, o5, o6, o7, o8, o9 ) {
    return ( vecA[ 0 ] + vecB[ 0 ], vecA[ 1 ] + vecB[ 1 ], vecA[ 2 ] + vecB[ 2 ] );
}

vector_subtract( vecA, vecB, o3, o4, o5, o6, o7, o8, o9 ) {
    return ( vecA[ 0 ] - vecB[ 0 ], vecA[ 1 ] - vecB[ 1 ], vecA[ 2 ] - vecB[ 2 ] );
}

getWeaponType( weapon, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    switch ( weapon )
    {
        case "fraggrenade_mp":
        case "stielhandgranate_mp":
        case "mk1britishfrag_mp":
        case "rgd-33russianfrag_mp":
            return "grenade";
        case "colt_mp":
        case "luger_mp":
            return "pistol";
        default:
            return "primary";
    }
}

error(msg, o2, o3, o4, o5, o6, o7, o8, o9)
{
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	println("^c*ERROR* ", msg);
	wait .05;	// waitframe

	if(getcvar("debug") != "1")
	{
		blah = getent("Time to Stop the Script!", "targetname");
			println(THIS_IS_A_FORCED_ERROR___ATTACH_LOG.origin);
	}
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
}

print( sMessage, bLarge, o3, o4, o5, o6, o7, o8, o9 )
{
    if ( !isDefined( bLarge ) || ( isDefined( bLarge ) && !bLarge ) ) {
        self iPrintLn( nameFix( sMessage, true ) );
        logPrint( "iPrintLn: " + nameFix( sMessage, true ) );
    }
    
    if ( isDefined( bLarge ) && bLarge ) {
        self iPrintLnBold( nameFix( sMessage, true ) );
        logPrint( "iPrintLnBold: " + nameFix( sMessage, true ) );
    }
}

set_team( sTeam, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    sRealTeam = "";
    
    switch ( sTeam )
    {
        case "hunters":     sRealTeam = "axis"; break;
        case "zombies":     sRealTeam = "allies"; break;
        case "spectator":
        case "intermission":
            sRealTeam = sTeam;
            break;
    }
    
    // this should never happen
    if ( sRealTeam == "" )
        return;
        
    if ( isAlive( self ) )
        self suicide();
        
    self.pers[ "team" ] = sRealTeam;
    
    if ( sRealTeam == "spectator" || sRealTeam == "intermission" )
    {
        self.pers[ "weapon" ] = undefined;
        self.pers[ "savedmodel" ] = undefined;
        self.sessionstate = sRealTeam;
    }
}

remove_game_objects( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    allowed[ 0 ] = "tdm";
    
	entitytypes = getentarray();
	for(i = 0; i < entitytypes.size; i++)
	{
		if(isdefined(entitytypes[i].script_gameobjectname))
		{
			dodelete = true;
			
			for(j = 0; j < allowed.size; j++)
			{
				if(entitytypes[i].script_gameobjectname == allowed[j])
				{	
					dodelete = false;
					break;
				}
			}
			
			if(dodelete)
			{
				//println("DELETED: ", entitytypes[i].classname);
				entitytypes[i] delete();
			}
		}
	}
}

_spawn( sClassName, vOrigin, o3, o4, o5, o6, o7, o8, o9 )
{
    iID = level.aSpawnedObjects.size;
    
    oStruct = spawnstruct();
    oStruct.sClassName = sClassName;
    oStruct.vOrigin = vOrigin;
    oStruct.iID = iID;
    
    oObject = spawn( sClassName, vOrigin );
    oObject.iID = iID;
    
    level.aSpawnedObjects[ iID ] = oStruct;
    
    //iPrintLn( "added " + iID + " to spawnedobjects" );
    
    return oObject;
}

_delete( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    if ( isDefined( self.iID ) && isDefined( level.aSpawnedObjects[ self.iID ] ) )
        level.aSpawnedObjects = array_remove( level.aSpawnedObjects, level.aSpawnedObjects[ self.iID ] );
        
    //iPrintLn( "removed " + self.iID + " from spawnedobjects" );
        
    self delete();
}

convert_time( iTime, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    iSeconds = iTime % 60;
    iMinutes = ( iTime - iSeconds ) / 60;
    iMinutes2 = iMinutes % 60;
    iHours = ( iMinutes - iMinutes2 ) / 60;
    iHours2 = iHours % 24;
    iDays = ( iHours - iHours2 ) / 24;
    
    return iDays + ":" + iHours2 + ":" + iMinutes2 + ":" + iSeconds;
}