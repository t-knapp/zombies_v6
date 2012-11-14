/*
    File:           menus.gsc
    Author:         Cheese
    Last update:    9/10/2012
*/

init()
{
    [[ level.register ]]( "menu_handler", ::menu_handler, level.iFLAG_THREAD );
}

menu_handler()
{
    level endon( "intermission" );
    
    for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		if(response == "open" || response == "close")
			continue;

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":
                if ( level.iGameFlags & level.iFLAG_GAME_STARTED )
                    response = "allies";
                else
                    response = "axis";
                    
                // for dev testing
                if ( getCvar( "forceteam" ) != "" )
                    response = getCvar( "forceteam" );
                    
                if ( isDefined( self.atclassmenu ) && self.atclassmenu ) 
                {
					self notify( "selectclass notify stop" );
					break;
				}
                
                // let zombies rechoose a class
				if ( response == "allies" && self.pers[ "team" ] == "allies" && isDefined( self.class ) ) 
                {
					self suicide();
                    self.skiprespawn = true;
					self.class = undefined;
				}
                
                // let hunters rechoose a class ONLY during the pregame :D
                if ( response == "axis" && self.pers[ "team" ] == "axis" && isDefined( self.class ) && !level.gamestarted )
                {
                    self suicide();
                    self.skiprespawn = true;
                    self.class = undefined;
                }
                
                if ( response == self.pers[ "team" ] && self.sessionstate == "playing" )
					break;

				if( response != self.pers[ "team" ] && self.sessionstate == "playing" )
                {
					self suicide();
                    self.class = undefined;
                }
				
				self notify("end_respawn");
                self.pers["team"] = response;
				self.pers["weapon"] = undefined;
				self.pers["savedmodel"] = undefined;
                
                self [[ level.call ]]( "spawn_player" );
				break;

			case "spectator":
				if(self.pers["team"] != "spectator")
				{
                    self [[ level.call ]]( "set_team", "spectator" );
					self setClientCvar("g_scriptMainMenu", game["menu_team"]);
					self setClientCvar("scr_showweapontab", "0");
					self [[ level.call ]]( "spawn_spectator" );
				}
				break;

			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;
				
			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}		
		else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
		{
			if(response == "team")
			{
				self openMenu(game["menu_team"]);
				continue;
			}
			else if(response == "viewmap")
			{
				self openMenu(game["menu_viewmap"]);
				continue;
			}
			else if(response == "callvote")
			{
				self openMenu(game["menu_callvote"]);
				continue;
			}
			
			if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
				continue;

			weapon = self [[ level.call ]]( "restrict_anyteam", response );

			if(weapon == "restricted")
			{
				self openMenu(menu);
				continue;
			}
			
			if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
				continue;
			
			if(!isdefined(self.pers["weapon"]))
			{
				self.pers["weapon"] = weapon;
				//self [[ level.call ]]( "spawn_player" );;
			}
			else
			{
				self.pers["weapon"] = weapon;

				weaponname = [[ level.call ]]( "get_weapon_name", self.pers["weapon"] );
				
				if( [[ level.call ]]( "use_an", self.pers["weapon"] ) )
					self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
				else
					self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
			}
		}
		else if(menu == game["menu_viewmap"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}
		else if(menu == game["menu_callvote"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;
			}
		}
		else if(menu == game["menu_quickcommands"])
			self [[ level.call ]]( "quickmessage_commands", response );
		else if(menu == game["menu_quickstatements"])
			self [[ level.call ]]( "quickmessage_statements", response );
		else if(menu == game["menu_quickresponses"])
			self [[ level.call ]]( "quickmessage_responses", response );
	}
}