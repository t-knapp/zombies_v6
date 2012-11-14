/*
    File:           _teams.gsc
    Author:         Infinity Ward (modified by Cheese)
    Last update:    11/14/2012
*/


init()
{
    [[ level.register ]]( "teams_modeltype", ::modeltype );
    [[ level.register ]]( "teams_model", ::model );
    [[ level.register ]]( "restrict_anyteam", ::restrict_anyteam, level.iFLAG_RETURN );
    [[ level.register ]]( "get_weapon_name", ::getWeaponName, level.iFLAG_RETURN );
    [[ level.register ]]( "use_an", ::useAn, level.iFLAG_RETURN );
    [[ level.register ]]( "loadout", ::loadout );
}

modeltype()
{
	switch(game["allies"])
	{
	case "american":
		if(isdefined(game["american_soldiertype"]))
		{
			switch(game["american_soldiertype"])
			{
			case "airborne":
				if(isdefined(game["american_soldiervariation"]))
				{
					switch(game["american_soldiervariation"])
					{
					case "normal":
						mptype\american_airborne::precache();
						game["allies_model"] = mptype\american_airborne::main;	
						break;
					
					case "winter":
						mptype\american_airborne_winter::precache();
						game["allies_model"] = mptype\american_airborne_winter::main;
						break;
				
					default:
						println("Unknown american_soldiervariation specified, using default");
						mptype\american_airborne::precache();
						game["allies_model"] = mptype\american_airborne::main;
						break;
					}
				}
				else
				{
					mptype\american_airborne::precache();
					game["allies_model"] = mptype\american_airborne::main;
				}
				break;
				
			default:
				println("Unknown american_soldiertype specified, using default");
				mptype\american_airborne::precache();
				game["allies_model"] = mptype\american_airborne::main;
				break;
			}
		}
		else
		{
			mptype\american_airborne::precache();
			game["allies_model"] = mptype\american_airborne::main;
		}
		break;

	case "british":
		if(isdefined(game["british_soldiertype"]))
		{
			switch(game["british_soldiertype"])
			{
			case "airborne":
				if(isdefined(game["british_soldiervariation"]))
				{
					switch(game["british_soldiervariation"])
					{
					case "normal":
						mptype\british_airborne::precache();
						game["allies_model"] = mptype\british_airborne::main;	
						break;
					
					default:
						println("Unknown british_soldiervariation specified, using default");
						mptype\british_airborne::precache();
						game["allies_model"] = mptype\british_airborne::main;
						break;
					}
				}
				else
				{
					mptype\british_airborne::precache();
					game["allies_model"] = mptype\british_airborne::main;
				}
				break;

			case "commando":
				if(isdefined(game["british_soldiervariation"]))
				{
					switch(game["british_soldiervariation"])
					{
					case "normal":
						mptype\british_commando::precache();
						game["allies_model"] = mptype\british_commando::main;	
						break;
					
					case "winter":
						mptype\british_commando_winter::precache();
						game["allies_model"] = mptype\british_commando_winter::main;
						break;
				
					default:
						println("Unknown british_soldiervariation specified, using default");
						mptype\british_commando::precache();
						game["allies_model"] = mptype\british_commando::main;
						break;
					}
				}
				else
				{
					mptype\british_commando::precache();
					game["allies_model"] = mptype\british_commando::main;
				}
				break;
				
			default:
				println("Unknown british_soldiertype specified, using default");
				mptype\british_commando::precache();
				game["allies_model"] = mptype\british_commando::main;
				break;
			}
		}
		else
		{
			mptype\british_commando::precache();
			game["allies_model"] = mptype\british_commando::main;
		}
		break;

	case "russian":
		if(isdefined(game["russian_soldiertype"]))
		{
			switch(game["russian_soldiertype"])
			{
			case "conscript":
				if(isdefined(game["russian_soldiervariation"]))
				{
					switch(game["russian_soldiervariation"])
					{
					case "normal":
						mptype\russian_conscript::precache();
						game["allies_model"] = mptype\russian_conscript::main;	
						break;
					
					case "winter":
						mptype\russian_conscript_winter::precache();
						game["allies_model"] = mptype\russian_conscript_winter::main;
						break;
				
					default:
						println("Unknown russian_soldiervariation specified, using default");
						mptype\russian_conscript::precache();
						game["allies_model"] = mptype\russian_conscript::main;
						break;
					}
				}
				else
				{
					mptype\russian_conscript::precache();
					game["allies_model"] = mptype\russian_conscript::main;
				}
				break;
				
			case "veteran":
				if(isdefined(game["russian_soldiervariation"]))
				{
					switch(game["russian_soldiervariation"])
					{
					case "normal":
						mptype\russian_veteran::precache();
						game["allies_model"] = mptype\russian_veteran::main;	
						break;
					
					case "winter":
						mptype\russian_veteran_winter::precache();
						game["allies_model"] = mptype\russian_veteran_winter::main;	
						break;

					default:
						println("Unknown russian_soldiervariation specified, using default");
						mptype\russian_veteran::precache();
						game["allies_model"] = mptype\russian_veteran::main;
						break;
					}
				}
				else
				{
					mptype\russian_veteran::precache();
					game["allies_model"] = mptype\russian_veteran::main;
				}
				break;

			default:
				println("Unknown russian_soldiertype specified, using default");
				mptype\russian_conscript::precache();
				game["allies_model"] = mptype\russian_conscript::main;
				break;
			}
		}
		else
		{
			mptype\russian_conscript::precache();
			game["allies_model"] = mptype\russian_conscript::main;
		}
		break;
	}

	switch(game["axis"])
	{
	case "german":
		if(isdefined(game["german_soldiertype"]))
		{
			switch(game["german_soldiertype"])
			{
			case "wehrmacht":
				if(isdefined(game["german_soldiervariation"]))
				{
					switch(game["german_soldiervariation"])
					{
					case "normal":
						mptype\german_wehrmacht::precache();
						game["axis_model"] = mptype\german_wehrmacht::main;	
						break;
					
					case "winter":
						mptype\german_wehrmacht_winter::precache();
						game["axis_model"] = mptype\german_wehrmacht_winter::main;
						break;
				
					default:
						println("Unknown german_soldiervariation specified, using default");
						mptype\german_wehrmacht::precache();
						game["axis_model"] = mptype\german_wehrmacht::main;
						break;
					}
				}
				else
				{
					mptype\german_wehrmacht::precache();
					game["axis_model"] = mptype\german_wehrmacht::main;
				}
				break;
				
			case "waffen":
				if(isdefined(game["german_soldiervariation"]))
				{
					switch(game["german_soldiervariation"])
					{
					case "normal":
						mptype\german_waffen::precache();
						game["axis_model"] = mptype\german_waffen::main;	
						break;
					
					case "winter":
						mptype\german_waffen_winter::precache();
						game["axis_model"] = mptype\german_waffen_winter::main;
						break;
				
					default:
						println("Unknown german_soldiervariation specified, using default");
						mptype\german_waffen::precache();
						game["axis_model"] = mptype\german_waffen::main;
						break;
					}
				}
				else
				{
					mptype\german_waffen::precache();
					game["axis_model"] = mptype\german_waffen::main;
				}
				break;

			case "fallschirmjagercamo":
				if(isdefined(game["german_soldiervariation"]))
				{
					switch(game["german_soldiervariation"])
					{
					case "normal":
						mptype\german_fallschirmjagercamo::precache();
						game["axis_model"] = mptype\german_fallschirmjagercamo::main;	
						break;
					
					default:
						println("Unknown german_soldiervariation specified, using default");
						mptype\german_fallschirmjagercamo::precache();
						game["axis_model"] = mptype\german_fallschirmjagercamo::main;
						break;
					}
				}
				else
				{
					mptype\german_fallschirmjagercamo::precache();
					game["axis_model"] = mptype\german_fallschirmjagercamo::main;
				}
				break;

			case "fallschirmjagergrey":
				if(isdefined(game["german_soldiervariation"]))
				{
					switch(game["german_soldiervariation"])
					{
					case "normal":
						mptype\german_fallschirmjagergrey::precache();
						game["axis_model"] = mptype\german_fallschirmjagergrey::main;	
						break;
					
					default:
						println("Unknown german_soldiervariation specified, using default");
						mptype\german_fallschirmjagergrey::precache();
						game["axis_model"] = mptype\german_fallschirmjagergrey::main;
						break;
					}
				}
				else
				{
					mptype\german_fallschirmjagergrey::precache();
					game["axis_model"] = mptype\german_fallschirmjagergrey::main;
				}
				break;

			case "kriegsmarine":
				if(isdefined(game["german_soldiervariation"]))
				{
					switch(game["german_soldiervariation"])
					{
					case "normal":
						mptype\german_kriegsmarine::precache();
						game["axis_model"] = mptype\german_kriegsmarine::main;	
						break;
					
					default:
						println("Unknown german_soldiervariation specified, using default");
						mptype\german_kriegsmarine::precache();
						game["axis_model"] = mptype\german_kriegsmarine::main;
						break;
					}
				}
				else
				{
					mptype\german_kriegsmarine::precache();
					game["axis_model"] = mptype\german_kriegsmarine::main;
				}
				break;
			
			default:
				println("Unknown german_soldiertype specified, using default");
				mptype\german_wehrmacht::precache();
				game["axis_model"] = mptype\german_wehrmacht::main;
				break;
			}
		}
		else
		{
			mptype\german_wehrmacht::precache();
			game["axis_model"] = mptype\german_wehrmacht::main;
		}
		break;
	}
}

initGlobalCvars()
{
	makeCvarServerInfo("scr_motd", "");
	makeCvarServerInfo("scr_allow_vote", "1");
	makeCvarServerInfo("scr_allow_m1carbine", "1");
	makeCvarServerInfo("scr_allow_m1garand", "1");
	makeCvarServerInfo("scr_allow_thompson", "1");
	makeCvarServerInfo("scr_allow_bar", "1");
	makeCvarServerInfo("scr_allow_springfield", "1");
	makeCvarServerInfo("scr_allow_enfield", "1");
	makeCvarServerInfo("scr_allow_sten", "1");
	makeCvarServerInfo("scr_allow_bren", "1");
	makeCvarServerInfo("scr_allow_nagant", "1");
	makeCvarServerInfo("scr_allow_ppsh", "1");
	makeCvarServerInfo("scr_allow_nagantsniper", "1");
	makeCvarServerInfo("scr_allow_kar98k", "1");
	makeCvarServerInfo("scr_allow_mp40", "1");
	makeCvarServerInfo("scr_allow_mp44", "1");
	makeCvarServerInfo("scr_allow_kar98ksniper", "1");
	makeCvarServerInfo("scr_allow_fg42", "1");
	makeCvarServerInfo("scr_allow_panzerfaust", "1");
}

model()
{
	self detachAll();
	
	if(self.pers["team"] == "allies")
		[[game["allies_model"] ]]();
	else if(self.pers["team"] == "axis")
		[[game["axis_model"] ]]();

	self.pers["savedmodel"] = [[ level.call ]]( "save_model" );
}

loadout()
{
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			self giveWeapon("colt_mp");
			self giveMaxAmmo("colt_mp");
			self giveWeapon("fraggrenade_mp");
			self giveMaxAmmo("fraggrenade_mp");
			break;

		case "british":
			self giveWeapon("colt_mp");
			self giveMaxAmmo("colt_mp");
			self giveWeapon("mk1britishfrag_mp");
			self giveMaxAmmo("mk1britishfrag_mp");
			break;

		case "russian":
			self giveWeapon("luger_mp");
			self giveMaxAmmo("luger_mp");
			self giveWeapon("rgd-33russianfrag_mp");
			self giveMaxAmmo("rgd-33russianfrag_mp");
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])
		{
		case "german":
			self giveWeapon("luger_mp");
			self giveMaxAmmo("luger_mp");
			self giveWeapon("stielhandgranate_mp");
			self giveMaxAmmo("stielhandgranate_mp");
			break;
		}			
	}
}

isPistolOrGrenade(weapon)
{
	switch(weapon)
	{
	case "colt_mp":
	case "luger_mp":
	case "fraggrenade_mp":
	case "mk1britishfrag_mp":
	case "rgd-33russianfrag_mp":
	case "stielhandgranate_mp":
		return true;
	default:
		return false;
	}
}

restrict(response)
{
	if(self.pers["team"] == "allies")
	{
		switch(game["allies"])		
		{
		case "american":
			switch(response)		
			{
			case "m1carbine_mp":
				if(!getcvar("scr_allow_m1carbine"))
				{
					self iprintln(&"MPSCRIPT_M1A1_CARBINE_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "m1garand_mp":
				if(!getcvar("scr_allow_m1garand"))
				{
					self iprintln(&"MPSCRIPT_M1_GARAND_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "thompson_mp":
				if(!getcvar("scr_allow_thompson"))
				{
					self iprintln(&"MPSCRIPT_THOMPSON_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "bar_mp":
				if(!getcvar("scr_allow_bar"))
				{
					self iprintln(&"MPSCRIPT_BAR_IS_A_RESTRICTED_WEAPON");
					response = "restricted";
				}
				break;
				
			case "springfield_mp":
				if(!getcvar("scr_allow_springfield"))
				{
					self iprintln(&"MPSCRIPT_SPRINGFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
			}
			break;

		case "british":
			switch(response)		
			{
			case "enfield_mp":
				if(!getcvar("scr_allow_enfield"))
				{
					self iprintln(&"MPSCRIPT_LEEENFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "sten_mp":
				if(!getcvar("scr_allow_sten"))
				{
					self iprintln(&"MPSCRIPT_STEN_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "bren_mp":
				if(!getcvar("scr_allow_bren"))
				{
					self iprintln(&"MPSCRIPT_BREN_LMG_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
			
			case "springfield_mp":
				if(!getcvar("scr_allow_springfield"))
				{
					self iprintln(&"MPSCRIPT_SPRINGFIELD_IS_A_RESTRICTED1");
					response = "restricted";
				}
				break;

			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
			}
			break;

		case "russian":
			switch(response)		
			{
			case "mosin_nagant_mp":
				if(!getcvar("scr_allow_nagant"))
				{
					self iprintln(&"MPSCRIPT_MOSINNAGANT_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "ppsh_mp":
				if(!getcvar("scr_allow_ppsh"))
				{
					self iprintln(&"MPSCRIPT_PPSH_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mosin_nagant_sniper_mp":
				if(!getcvar("scr_allow_nagantsniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_MOSINNAGANT_IS");
					response = "restricted";
				}
				break;

			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
			}
			break;
		}
	}
	else if(self.pers["team"] == "axis")
	{
		switch(game["axis"])		
		{
		case "german":
			switch(response)		
			{
			case "kar98k_mp":
				if(!getcvar("scr_allow_kar98k"))
				{
					self iprintln(&"MPSCRIPT_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp40_mp":
				if(!getcvar("scr_allow_mp40"))
				{
					self iprintln(&"MPSCRIPT_MP40_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp44_mp":
				if(!getcvar("scr_allow_mp44"))
				{
					self iprintln(&"MPSCRIPT_MP44_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "kar98k_sniper_mp":
				if(!getcvar("scr_allow_kar98ksniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
			}
			break;
		}			
	}
	return response;
}

restrict_anyteam(response)
{
			switch(response)		
			{
			case "m1carbine_mp":
				if(!getcvar("scr_allow_m1carbine"))
				{
					self iprintln(&"MPSCRIPT_M1A1_CARBINE_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "m1garand_mp":
				if(!getcvar("scr_allow_m1garand"))
				{
					self iprintln(&"MPSCRIPT_M1_GARAND_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "thompson_mp":
				if(!getcvar("scr_allow_thompson"))
				{
					self iprintln(&"MPSCRIPT_THOMPSON_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;
				
			case "bar_mp":
				if(!getcvar("scr_allow_bar"))
				{
					self iprintln(&"MPSCRIPT_BAR_IS_A_RESTRICTED_WEAPON");
					response = "restricted";
				}
				break;
				
			case "springfield_mp":
				if(!getcvar("scr_allow_springfield"))
				{
					self iprintln(&"MPSCRIPT_SPRINGFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "enfield_mp":
				if(!getcvar("scr_allow_enfield"))
				{
					self iprintln(&"MPSCRIPT_LEEENFIELD_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "sten_mp":
				if(!getcvar("scr_allow_sten"))
				{
					self iprintln(&"MPSCRIPT_STEN_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "bren_mp":
				if(!getcvar("scr_allow_bren"))
				{
					self iprintln(&"MPSCRIPT_BREN_LMG_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mosin_nagant_mp":
				if(!getcvar("scr_allow_nagant"))
				{
					self iprintln(&"MPSCRIPT_MOSINNAGANT_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "ppsh_mp":
				if(!getcvar("scr_allow_ppsh"))
				{
					self iprintln(&"MPSCRIPT_PPSH_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mosin_nagant_sniper_mp":
				if(!getcvar("scr_allow_nagantsniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_MOSINNAGANT_IS");
					response = "restricted";
				}
				break;

			case "kar98k_mp":
				if(!getcvar("scr_allow_kar98k"))
				{
					self iprintln(&"MPSCRIPT_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp40_mp":
				if(!getcvar("scr_allow_mp40"))
				{
					self iprintln(&"MPSCRIPT_MP40_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "mp44_mp":
				if(!getcvar("scr_allow_mp44"))
				{
					self iprintln(&"MPSCRIPT_MP44_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			case "kar98k_sniper_mp":
				if(!getcvar("scr_allow_kar98ksniper"))
				{
					self iprintln(&"MPSCRIPT_SCOPED_KAR98K_IS_A_RESTRICTED");
					response = "restricted";
				}
				break;

			default:
				self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
				response = "restricted";
				break;
			}
	return response;
}

sayMoveIn()
{
	wait 2;
	
	alliedsoundalias = game["allies"] + "_move_in";
	axissoundalias = game["axis"] + "_move_in";

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(player.pers["team"] == "allies")
			player playLocalSound(alliedsoundalias);
		else if(player.pers["team"] == "axis")
			player playLocalSound(axissoundalias);
	}
}

getWeaponName(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
		weaponname = &"WEAPON_M1A1CARBINE";
		break;
		
	case "m1garand_mp":
		weaponname = &"WEAPON_M1GARAND";
		break;
		
	case "thompson_mp":
		weaponname = &"WEAPON_THOMPSON";
		break;
		
	case "bar_mp":
		weaponname = &"WEAPON_BAR";
		break;
		
	case "springfield_mp":
		weaponname = &"WEAPON_SPRINGFIELD";
		break;
		
	case "enfield_mp":
		weaponname = &"WEAPON_LEEENFIELD";
		break;
		
	case "sten_mp":
		weaponname = &"WEAPON_STEN";
		break;
		
	case "bren_mp":
		weaponname = &"WEAPON_BREN";
		break;
		
	case "mosin_nagant_mp":
		weaponname = &"WEAPON_MOSINNAGANT";
		break;
		
	case "ppsh_mp":
		weaponname = &"WEAPON_PPSH";
		break;
		
	case "mosin_nagant_sniper_mp":
		weaponname = &"WEAPON_SCOPEDMOSINNAGANT";
		break;
		
	case "kar98k_mp":
		weaponname = &"WEAPON_KAR98K";
		break;
		
	case "mp40_mp":
		weaponname = &"WEAPON_MP40";
		break;
		
	case "mp44_mp":
		weaponname = &"WEAPON_MP44";
		break;
		
	case "kar98k_sniper_mp":
		weaponname = &"WEAPON_SCOPEDKAR98K";
		break;
		
	default:
		weaponname = &"WEAPON_UNKNOWNWEAPON";
		break;
	}

	return weaponname;
}

useAn(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "mp40_mp":
	case "mp44_mp":
		result = true;
		break;
		
	default:
		result = false;
		break;
	}

	return result;
}