/*
    File:           classes.gsc
    Author:         Cato (updated by Cheese)
    Last update:    11/17/2012
*/

init()
{
    [[ level.register ]]( "map_vote", ::mapvote );
    
    game["mapvote"] = &"Press ^1FIRE ^7to vote                           Votes";
    game["maptimeleft"] = &"Time left: ";
    
    [[ level.call ]]( "precache", game[ "mapvote" ], "string" );
    [[ level.call ]]( "precache", game[ "maptimeleft" ], "string" );

    // mapvote
    level.mapvote = 0;
    if(getCvar("scr_zom_mapvote") != "" && getCvarInt("scr_zom_mapvote") > 0)
        level.mapvote = 1;

    level.mapvotetime = 15;
    if(getCvar("scr_zom_mapvotetime") != "" && getCvarInt("scr_zom_mapvotetime") >= 10)
        level.mapvotetime = getCvarInt("scr_zom_mapvotetime");
    if(level.mapvotetime > 60)
        level.mapvotetime = 60;

    level.mapvotereplay = 0;
    if(getCvar("scr_zom_mapvotereplay") != "" && getCvarInt("scr_zom_mapvotereplay") > 0)
        level.mapvotereplay = 1;

    level.mapvoterandom = 0;
    if(getCvar("scr_zom_mapvoterandom") != "" && getCvarInt("scr_zom_mapvoterandom") > 0)
        level.mapvoterandom = 1;

    level.mapvotegametype = 1;
    if(getCvar("scr_zom_mapvotegametype") != "" && getCvarInt("scr_zom_mapvotegametype") == 0)
        level.mapvotegametype = 0;

    level.mapvotebans = 0;
    if(getCvar("scr_zom_mapvotebans") != "" && getCvarInt("scr_zom_mapvotebans") > 0)
        level.mapvotebans = getCvarInt("scr_zom_mapvotebans");

    if(level.mapvoterandom && level.mapvotereplay)
        level.mapvoterandom = 0;
}

/*********************************************************************************************************/


mapvote()
{
  if(!level.mapvote)
    return;

  level.mapvotehudoffset = 30;
  
  wait 0.5;
  
  createHud();
  
  thread runMapVote();
  
  level waittill("voting_complete");
  
  destroyHud();
}

createHud()
{
 	level.vote_hud_bgnd = newHudElem();
	level.vote_hud_bgnd.archived = false;
	level.vote_hud_bgnd.alpha = .7;
	level.vote_hud_bgnd.x = 205;
	level.vote_hud_bgnd.y = level.mapvotehudoffset + 17;
	level.vote_hud_bgnd.sort = 9000;
	level.vote_hud_bgnd.color = (0,0,0);
	level.vote_hud_bgnd setShader("white", 260, 140);
	
	level.vote_header = newHudElem();
	level.vote_header.archived = false;
	level.vote_header.alpha = .3;
	level.vote_header.x = 208;
	level.vote_header.y = level.mapvotehudoffset + 19;
	level.vote_header.sort = 9001;
	level.vote_header setShader("white", 254, 21);

	level.vote_leftline = newHudElem();
	level.vote_leftline.archived = false;
	level.vote_leftline.alpha = .3;
	level.vote_leftline.x = 207;
	level.vote_leftline.y = level.mapvotehudoffset + 19;
	level.vote_leftline.sort = 9001;
	level.vote_leftline setShader("white", 1, 135);
	
	level.vote_rightline = newHudElem();
	level.vote_rightline.archived = false;
	level.vote_rightline.alpha = .3;
	level.vote_rightline.x = 462;
	level.vote_rightline.y = level.mapvotehudoffset + 19;
	level.vote_rightline.sort = 9001;
	level.vote_rightline setShader("white", 1, 135);
	
	level.vote_bottomline = newHudElem();
	level.vote_bottomline.archived = false;
	level.vote_bottomline.alpha = .3;
	level.vote_bottomline.x = 207;
	level.vote_bottomline.y = level.mapvotehudoffset + 154;
	level.vote_bottomline.sort = 9001;
	level.vote_bottomline setShader("white", 256, 1);

	level.vote_hud_timeleft = newHudElem();
	level.vote_hud_timeleft.archived = false;
	level.vote_hud_timeleft.x = 400;
	level.vote_hud_timeleft.y = level.mapvotehudoffset + 26;
	level.vote_hud_timeleft.sort = 9998;
	level.vote_hud_timeleft.fontscale = .8;
	level.vote_hud_timeleft.label = game["maptimeleft"];
	level.vote_hud_timeleft setValue( level.mapvotetime );	
	
	level.vote_hud_instructions = newHudElem();
	level.vote_hud_instructions.archived = false;
	level.vote_hud_instructions.x = 340;
	level.vote_hud_instructions.y = level.mapvotehudoffset + 56;
	level.vote_hud_instructions.sort = 9998;
	level.vote_hud_instructions.fontscale = 1;
	level.vote_hud_instructions.label = game["mapvote"];
	level.vote_hud_instructions.alignX = "center";
	level.vote_hud_instructions.alignY = "middle";
	
	level.vote_map1 = newHudElem();
	level.vote_map1.archived = false;
	level.vote_map1.x = 434;
	level.vote_map1.y = level.mapvotehudoffset + 69;
	level.vote_map1.sort = 9998;
		
	level.vote_map2 = newHudElem();
	level.vote_map2.archived = false;
	level.vote_map2.x = 434;
	level.vote_map2.y = level.mapvotehudoffset + 85;
	level.vote_map2.sort = 9998;
		
	level.vote_map3 = newHudElem();
	level.vote_map3.archived = false;
	level.vote_map3.x = 434;
	level.vote_map3.y = level.mapvotehudoffset + 101;
	level.vote_map3.sort = 9998;	

	level.vote_map4 = newHudElem();
	level.vote_map4.archived = false;
	level.vote_map4.x = 434;
	level.vote_map4.y = level.mapvotehudoffset + 117;
	level.vote_map4.sort = 9998;	

	level.vote_map5 = newHudElem();
	level.vote_map5.archived = false;
	level.vote_map5.x = 434;
	level.vote_map5.y = level.mapvotehudoffset + 133;
	level.vote_map5.sort = 9998;	 
}

destroyHud()
{
	level.vote_hud_timeleft destroy();	
	level.vote_hud_instructions destroy();
	level.vote_map1 destroy();
	level.vote_map2 destroy();
	level.vote_map3 destroy();
	level.vote_map4 destroy();
	level.vote_map5 destroy();
	level.vote_hud_bgnd destroy();
	level.vote_header destroy();
	level.vote_leftline destroy();
	level.vote_rightline destroy();
	level.vote_bottomline destroy();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isDefined(players[i].vote_indicator))
			players[i].vote_indicator destroy();
}

runMapVote()
{
  randomMapRotation = getRandomMapRotation();

  if(!isDefined(randomMapRotation)) {
    level notify("voting_complete");
    return;
  }
  
  for(i = 0; i < 5; i++) {
		if(level.mapvoterandom && !level.mapvotereplay) {
      randMap = randomInt(randomMapRotation.size);
      if(randMap <= 0)
        randMap = 1;
      
      level.mapcandidate[i]["map"] = randomMapRotation[randMap]["map"];
      level.mapcandidate[i]["mapname"] = "mystery map";
		} else {
      level.mapcandidate[i]["map"] = level.mapname;
      level.mapcandidate[i]["mapname"] = "replay this map";
    }
		level.mapcandidate[i]["gametype"] = level.gametype;
		level.mapcandidate[i]["votes"] = 0;
  }
  
  for(i = 0; i < 5; i++) {
		if(!isDefined(randomMapRotation[i]))
      break;
    
		level.mapcandidate[i]["map"] = randomMapRotation[i]["map"];
		level.mapcandidate[i]["mapname"] = randomMapRotation[i]["map"];
		level.mapcandidate[i]["gametype"] = randomMapRotation[i]["gametype"];
		level.mapcandidate[i]["votes"] = 0;
      
    if(((level.mapvotereplay && !level.mapvoterandom) || (!level.mapvotereplay && level.mapvoterandom)) && i > 2)
      break;
  }
  
  thread displayMapChoices();
  
  game["menu_team"] = "";
  
  players = getEntArray("player", "classname");
  for(i = 0; i < players.size; i++)
    players[i] thread playerVote();
    
  thread voteLogic();
  
  wait 0.1;
}

voteLogic()
{
  for(; level.mapvotetime >= 0; level.mapvotetime--) {
    for(x = 0; x < 10; x++) {
      for(i = 0; i < 5; i++)
        level.mapcandidate[i]["votes"] = 0;

      players = getEntArray("player", "classname");
      for(i = 0; i < players.size; i++) {
        if(isDefined(players[i].votechoice)) {
          if(getCvarInt("scr_zom_mapvotecheat") > 0) {
            privateSlots = getCvarInt("sv_privateclients");
            
            if(isDefined(privateSlots)) {
              if(players[i] getEntityNumber() < privateSlots) {
                level.mapcandidate[players[i].votechoice]["votes"] += getCvarInt("scr_zom_mapvotecheat");
              } else {
                level.mapcandidate[players[i].votechoice]["votes"]++;
              }
            } else {
              level.mapcandidate[players[i].votechoice]["votes"]++;
            }
          } else {
            level.mapcandidate[players[i].votechoice]["votes"]++;
          }
        }
      }

      level.vote_map1 setValue(level.mapcandidate[0]["votes"]);
      level.vote_map2 setValue(level.mapcandidate[1]["votes"]);
      level.vote_map3 setValue(level.mapcandidate[2]["votes"]);
      level.vote_map4 setValue(level.mapcandidate[3]["votes"]);
      level.vote_map5 setValue(level.mapcandidate[4]["votes"]);
    
      wait 0.1;  
    }
    level.vote_hud_timeleft setValue(level.mapvotetime);
  }
  
  wait 0.2;
  
  nextmapnum  = 0;
  topvotes = 0;
  
  for(i = 0; i < 5; i++) {
    if(level.mapcandidate[i]["votes"] > topvotes) {
      nextmapnum = i;
      topvotes = level.mapcandidate[i]["votes"];
    }
  }
  
  setMapWinner(nextmapnum);
}

setMapWinner(val)
{
	map = level.mapcandidate[val]["map"];
	mapname	= level.mapcandidate[val]["mapname"];
	gametype = level.mapcandidate[val]["gametype"];

	setCvar("sv_mapRotationCurrent", " gametype " + gametype + " map " + map);

  if(level.mapvotebans > 0) {
    if(level.mapname != map) {
      tmpBanList = map;

      mapBanList = [[ level.call ]]( "strtok", getCvar("tmp_zom_mapvotebanlist"), " " );
      for(i = 0; i < mapBanList.size; i++) {
        if((i + 1) < level.mapvotebans)
          tmpBanList += " " + mapBanList[i];
      }
      setCvar("tmp_zom_mapvotebanlist", tmpBanList);
    }
  }

	wait 0.1;

	level notify("voting_done");

	wait 0.05;

	iPrintLnBold(" ");
	iPrintLnBold(" ");
	iPrintLnBold(" ");
	iPrintLnBold("The winner is");
	iPrintLnBold("^2" + mapname);
	if(level.mapvotegametype)
    iPrintLnBold("^2" + getGametypeName(gametype));
  else
    iPrintLnBold(" ");

	level.vote_hud_timeleft fadeOverTime(1);	
	level.vote_hud_instructions fadeOverTime(1);
	level.vote_map1 fadeOverTime(1);
	level.vote_map2 fadeOverTime(1);
	level.vote_map3 fadeOverTime(1);
	level.vote_map4 fadeOverTime(1);
	level.vote_map5 fadeOverTime(1);
	level.vote_hud_bgnd fadeOverTime(1);
	level.vote_header fadeOverTime(1);
	level.vote_leftline fadeOverTime(1);
	level.vote_rightline fadeOverTime(1);
	level.vote_bottomline fadeOverTime(1);

	level.vote_hud_timeleft.alpha = 0;	
	level.vote_hud_instructions.alpha = 0;
	level.vote_map1.alpha = 0;
	level.vote_map2.alpha = 0;
	level.vote_map3.alpha = 0;
	level.vote_map4.alpha = 0;
	level.vote_map5.alpha = 0;
	level.vote_hud_bgnd.alpha = 0;
	level.vote_header.alpha = 0;
	level.vote_leftline.alpha = 0;
	level.vote_rightline.alpha = 0;
	level.vote_bottomline.alpha = 0;

	players = getEntArray("player", "classname");
	
	for(i = 0; i < players.size; i++) {
		if(isDefined(players[i].vote_indicator)) {
			players[i].vote_indicator fadeOverTime(1);
			players[i].vote_indicator.alpha = 0;
		}
	}

	wait 4;
	level notify("voting_complete");
}

playerVote()
{
  level endon("voting_done");
  self  endon("disconnect");
  
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
  
  resettimeout();
  
	self setClientCvar("g_scriptMainMenu", "");
	self closeMenu();
	
	colors[0] = (0  ,  0,  1);
	colors[1] = (0  ,0.5,  1);
	colors[2] = (0  ,  1,  1);
	colors[3] = (0  ,  1,0.5);
	colors[4] = (0  ,  1,  0);
	
	self.vote_indicator = newClientHudElem( self );
	self.vote_indicator.alignY = "middle";
	self.vote_indicator.x = 208;
	self.vote_indicator.y = level.mapvotehudoffset + 75;
	self.vote_indicator.archived = false;
	self.vote_indicator.sort = 9998;
	self.vote_indicator.alpha = 0;
	self.vote_indicator.color = colors[0];
	self.vote_indicator setShader("white", 254, 17);
	
	hasVoted = false;
	
	for(;;) {
    wait 0.01;
	
    if(self attackButtonPressed()) {
      if(!hasVoted) {
				self.vote_indicator.alpha = 0.3;
				self.votechoice = 0;
				hasVoted = true;
      } else {
        self.votechoice++;
      }
      
      if(self.votechoice >= 5)
        self.votechoice = 0;
      
      if(level.mapvotegametype)
        self iPrintLn("You have voted for ^2" + level.mapcandidate[self.votechoice]["mapname"] + " ^7(" + level.mapcandidate[self.votechoice]["gametype"] + ")");
      else
        self iPrintLn("You have voted for ^2" + level.mapcandidate[self.votechoice]["mapname"]);
        
      self.vote_indicator.y = level.mapvotehudoffset + 77 + self.votechoice * 16;			
			self.vote_indicator.color = colors[self.votechoice];
    }
    
    while(self attackButtonPressed())
      wait 0.01;
      
		self.sessionstate = "spectator";
		self.spectatorclient = -1;
	}
}

displayMapChoices()
{
  level endon("voting_done");
	for(;;)
	{
    if(level.mapvotegametype) {
      iPrintLnBold(level.mapcandidate[0]["mapname"] + " (" + level.mapcandidate[0]["gametype"] +")");
      iPrintLnBold(level.mapcandidate[1]["mapname"] + " (" + level.mapcandidate[1]["gametype"] +")");
      iPrintLnBold(level.mapcandidate[2]["mapname"] + " (" + level.mapcandidate[2]["gametype"] +")");
      iPrintLnBold(level.mapcandidate[3]["mapname"] + " (" + level.mapcandidate[3]["gametype"] +")");
      iPrintLnBold(level.mapcandidate[4]["mapname"] + " (" + level.mapcandidate[4]["gametype"] +")");
		} else {
      iPrintLnBold(level.mapcandidate[0]["mapname"]);
      iPrintLnBold(level.mapcandidate[1]["mapname"]);
      iPrintLnBold(level.mapcandidate[2]["mapname"]);
      iPrintLnBold(level.mapcandidate[3]["mapname"]);
      iPrintLnBold(level.mapcandidate[4]["mapname"]);
		}
		wait 7.8;
	}	
}

getRandomMapRotation()
{
  mapRotation = [[ level.call ]]( "strip", getCvar("sv_mapRotation"));
  mapRotation = [[ level.call ]]( "strtok", mapRotation, " ");

  if(!isDefined(mapRotation))
    return undefined;

  _tmp = [];
  for(i = 0; i < mapRotation.size; i++) {
    arrElem = [[ level.call ]]( "strip", mapRotation[i]);
      if(arrElem != "")
        _tmp[_tmp.size] = arrElem; 
  }
  
  mapRotation = _tmp;

  if(!isDefined(mapRotation))
    return undefined;

  if( [[ level.call ]]( "in_array", mapRotation, level.mapname)) {
    mapRotation = [[ level.call ]]( "array_remove", mapRotation, level.mapname, true);
  }
    
  if(level.mapvotebans > 0) {
    mapBanList = [[ level.call ]]( "strtok", getCvar("tmp_zom_mapvotebanlist"), " ");
    for(i = 0; i < mapBanList.size; i++) {
      if(![[ level.call ]]( "in_array", mapBanList, level.mapname))
        if(i >= (mapBanList.size - 1))
          break;

      mapRotation = [[ level.call ]]( "array_remove", mapRotation, mapBanList[i], true);
      
      if(i >= mapRotation.size - 5) // TMP FIX
        break;
    }
  }

  _tmp = [];
  lastgt = level.gametype;
  for(i = 0; i < mapRotation.size;/* /!\ */) {
    switch(mapRotation[i]) {
      case "gametype":
        if(isDefined(mapRotation[i + 1]))
          lastgt = mapRotation[i + 1];
        
        i += 2;
      break;
      case "map":
        if(isDefined(mapRotation[i + 1])) {
          _tmp[_tmp.size]["gametype"] = lastgt;
          _tmp[_tmp.size - 1]["map"]  = mapRotation[i + 1];
        }
        
        i += 2;
      break;
      default:
        iPrintLnBold("^1WARNING: ^7Error(s) detected in map rotation.");
        if(isGametype(mapRotation[i])) {
          lastgt = mapRotation[i]; // ?????
        } else {
          _tmp[_tmp.size]["gametype"] = lastgt;
          _tmp[_tmp.size - 1]["map"]  = mapRotation[i];
        }
        
        i += 1;
      break;
    }
  } 
  
  mapRotation = [[ level.call ]]( "array_shuffle", _tmp);
  
  return mapRotation;
}

isGametype(gt)
{
  switch(gt) {
    case "dm": case "tdm": case "sd": case "zom": return true;
    default: return false;
  }
}

getGametypeName(gt)
{
  switch(gt) {
    case "dm": gtname = "Deathmatch"; break;
    case "tdm": gtname = "Team Deathmatch"; break;
    case "sd": gtname = "Search & Destroy"; break;		
    case "zom": gtname = "Zombies"; break;
    default: gtname = gt; break;
  }

  return gtname;
}