/*
    File:           quickmessages.gsc
    Author:         Cheese
    Last update:    9/10/2012
*/

init()
{
    [[ level.register ]]( "quickmessage_commands", ::quickcommands );
    [[ level.register ]]( "quickmessage_statements", ::quickstatements );
    [[ level.register ]]( "quickmessage_responses", ::quickresponses );
}

quickcommands( response, o2, o3, o4, o5, o6, o7, o8, o9 )
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

	switch( self.nationality )		
	{
        case "american":
            switch(response)		
            {
            case "1":
                soundalias = "american_follow_me";
                saytext = "Follow Me!";
                break;

            case "2":
                soundalias = "american_move_in";
                saytext = "Move in!";
                break;

            case "3":
                soundalias = "american_fall_back";
                saytext = "Fall back!";
                break;

            case "4":
                soundalias = "american_suppressing_fire";
                saytext = "Suppressing fire!";
                break;

            case "5":
                soundalias = "american_attack_left_flank";
                saytext = "Squad, attack left flank!";
                break;

            case "6":
                soundalias = "american_attack_right_flank";
                saytext = "Squad, attack right flank!";
                break;

            case "7":
                soundalias = "american_hold_position";
                saytext = "Squad, hold this position!";
                break;

            case "8":
                temp = randomInt(2);

                if(temp)
                {
                    soundalias = "american_regroup";
                    saytext = "Squad, regroup!";
                }
                else
                {
                    soundalias = "american_stick_together";
                    saytext = "Squad, stick together!";
                }
                break;
            }
            break;

        case "british":
            switch(response)		
            {
            case "1":
                soundalias = "british_follow_me";
                saytext = "Follow Me!";
                break;

            case "2":
                soundalias = "british_move_in";
                saytext = "Move in!";
                break;

            case "3":
                soundalias = "british_fall_back";
                saytext = "Fall back!";
                break;

            case "4":
                soundalias = "british_suppressing_fire";
                saytext = "Suppressing fire!";
                break;

            case "5":
                soundalias = "british_attack_left_flank";
                saytext = "Squad, attack left flank!";
                break;

            case "6":
                soundalias = "british_attack_right_flank";
                saytext = "Squad, attack right flank!";
                break;

            case "7":
                soundalias = "british_hold_position";
                saytext = "Squad, hold this position!";
                break;

            case "8":
                temp = randomInt(2);

                if(temp)
                {
                    soundalias = "british_regroup";
                    saytext = "Squad, regroup!";
                }
                else
                {
                    soundalias = "british_stick_together";
                    saytext = "Squad, stick together!";
                }
                break;
            }
            break;

        case "russian":
            switch(response)		
            {
            case "1":
                soundalias = "russian_follow_me";
                saytext = "Follow Me!";
                break;

            case "2":
                soundalias = "russian_move_in";
                saytext = "Move in!";
                break;

            case "3":
                soundalias = "russian_fall_back";
                saytext = "Fall back!";
                break;

            case "4":
                soundalias = "russian_suppressing_fire";
                saytext = "Suppressing fire!";
                break;

            case "5":
                soundalias = "russian_attack_left_flank";
                saytext = "Squad, attack left flank!";
                break;

            case "6":
                soundalias = "russian_attack_right_flank";
                saytext = "Squad, attack right flank!";
                break;

            case "7":
                soundalias = "russian_hold_position";
                saytext = "Squad, hold this position!";
                break;

            case "8":
                soundalias = "russian_regroup";
                saytext = "Squad, regroup!";
                break;
            }
            break;

        case "german":
            switch(response)		
            {
            case "1":
                soundalias = "german_follow_me";
                saytext = "Follow Me!";
                break;

            case "2":
                soundalias = "german_move_in";
                saytext = "Move in!";
                break;

            case "3":
                soundalias = "german_fall_back";
                saytext = "Fall back!";
                break;

            case "4":
                soundalias = "german_suppressing_fire";
                saytext = "Suppressing fire!";
                break;

            case "5":
                soundalias = "german_attack_left_flank";
                saytext = "Squad, attack left flank!";
                break;

            case "6":
                soundalias = "german_attack_right_flank";
                saytext = "Squad, attack right flank!";
                break;

            case "7":
                soundalias = "german_hold_position";
                saytext = "Squad, hold this position!";
                break;

            case "8":
                soundalias = "german_regroup";
                saytext = "Squad, regroup!";
                break;
            }
            break;
    }			

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();	
}

quickstatements( response, o2, o3, o4, o5, o6, o7, o8, o9 )
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
	
    switch( self.nationality )		
    {
        case "american":
            switch(response)		
            {
            case "1":
                soundalias = "american_enemy_spotted";
                saytext = "Enemy spotted!";
                break;

            case "2":
                soundalias = "american_enemy_down";
                saytext = "Enemy down!";
                break;

            case "3":
                soundalias = "american_in_position";
                saytext = "I'm in position.";
                break;

            case "4":
                soundalias = "american_area_secure";
                saytext = "Area secure!";
                break;

            case "5":
                soundalias = "american_grenade";
                saytext = "Grenade!";
                break;

            case "6":
                soundalias = "american_sniper";
                saytext = "Sniper!";
                break;

            case "7":
                soundalias = "american_need_reinforcements";
                saytext = "MEDIC!";
                break;

            case "8":
                soundalias = "american_hold_fire";
                saytext = "Hold your fire!";
                break;
            }
            break;

        case "british":
            switch(response)		
            {
            case "1":
                soundalias = "british_enemy_spotted";
                saytext = "Enemy spotted!";
                break;

            case "2":
                soundalias = "british_enemy_down";
                saytext = "Enemy down!";
                break;

            case "3":
                soundalias = "british_in_position";
                saytext = "I'm in position.";
                break;

            case "4":
                soundalias = "british_area_secure";
                saytext = "Area secure!";
                break;

            case "5":
                soundalias = "british_grenade";
                saytext = "Grenade!";
                break;

            case "6":
                soundalias = "british_sniper";
                saytext = "Sniper!";
                break;

            case "7":
                soundalias = "british_need_reinforcements";
                saytext = "Need reinforcements!";
                break;

            case "8":
                soundalias = "british_hold_fire";
                saytext = "Hold your fire!";
                break;
            }
            break;

        case "russian":
            switch(response)		
            {
            case "1":
                soundalias = "russian_enemy_spotted";
                saytext = "Enemy spotted!";
                break;

            case "2":
                soundalias = "russian_enemy_down";
                saytext = "Enemy down!";
                break;

            case "3":
                soundalias = "russian_in_position";
                saytext = "I'm in position.";
                break;

            case "4":
                soundalias = "russian_area_secure";
                saytext = "Area secure!";
                break;

            case "5":
                soundalias = "russian_grenade";
                saytext = "Grenade!";
                break;

            case "6":
                soundalias = "russian_sniper";
                saytext = "Sniper!";
                break;

            case "7":
                soundalias = "russian_need_reinforcements";
                saytext = "MEDIC!";
                break;

            case "8":
                soundalias = "russian_hold_fire";
                saytext = "Hold your fire!";
                break;
            }
            break;

        case "german":
            switch(response)		
            {
            case "1":
                soundalias = "german_enemy_spotted";
                saytext = "Enemy spotted!";
                break;

            case "2":
                soundalias = "german_enemy_down";
                saytext = "Enemy down!";
                break;

            case "3":
                soundalias = "german_in_position";
                saytext = "I'm in position.";
                break;

            case "4":
                soundalias = "german_area_secure";
                saytext = "Area secure!";
                break;

            case "5":
                soundalias = "german_grenade";
                saytext = "Grenade!";
                break;

            case "6":
                soundalias = "german_sniper";
                saytext = "Sniper!";
                break;

            case "7":
                soundalias = "german_need_reinforcements";
                saytext = "MEDIC!";
                break;

            case "8":
                soundalias = "german_hold_fire";
                saytext = "Hold your fire!";
                break;
            }
            break;
    }			

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

quickresponses( response, o2, o3, o4, o5, o6, o7, o8, o9 )
{
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

    switch( self.nationality )		
    {
        case "american":
            switch(response)		
            {
            case "1":
                soundalias = "american_yes_sir";
                saytext = "Yes Sir!";
                break;

            case "2":
                soundalias = "american_no_sir";
                saytext = "No Sir!";
                break;

            case "3":
                soundalias = "american_on_my_way";
                saytext = "On my way.";
                break;

            case "4":
                soundalias = "american_sorry";
                saytext = "Sorry.";
                break;

            case "5":
                soundalias = "american_great_shot";
                saytext = "Great shot!";
                break;

            case "6":
                soundalias = "american_took_long_enough";
                saytext = "Took long enough!";
                break;

            case "7":
                temp = randomInt(3);

                if(temp == 0)
                {
                    soundalias = "american_youre_crazy";
                    saytext = "You're crazy!";
                }
                else if(temp == 1)
                {
                    soundalias = "american_you_outta_your_mind";
                    saytext = "You outta your mind?";
                }
                else
                {
                    soundalias = "american_youre_nuts";
                    saytext = "You're nuts!";
                }
                break;
            }
            break;

        case "british":
            switch(response)		
            {
            case "1":
                soundalias = "british_yes_sir";
                saytext = "Yes Sir!";
                break;

            case "2":
                soundalias = "british_no_sir";
                saytext = "No Sir!";
                break;

            case "3":
                soundalias = "british_on_my_way";
                saytext = "On my way.";
                break;

            case "4":
                soundalias = "british_sorry";
                saytext = "Sorry.";
                break;

            case "5":
                soundalias = "british_great_shot";
                saytext = "Great shot!";
                break;

            case "6":
                soundalias = "british_took_long_enough";
                saytext = "Took long enough!";
                break;

            case "7":
                soundalias = "british_youre_crazy";
                saytext = "You're crazy!";
                break;
            }
            break;

        case "russian":
            switch(response)		
            {
            case "1":
                soundalias = "russian_yes_sir";
                saytext = "Yes Sir!";
                break;

            case "2":
                soundalias = "russian_no_sir";
                saytext = "No Sir!";
                break;

            case "3":
                soundalias = "russian_on_my_way";
                saytext = "On my way.";
                break;

            case "4":
                soundalias = "russian_sorry";
                saytext = "Sorry.";
                break;

            case "5":
                soundalias = "russian_great_shot";
                saytext = "Great shot!";
                break;

            case "6":
                soundalias = "russian_took_long_enough";
                saytext = "Took long enough!";
                break;

            case "7":
                soundalias = "russian_youre_crazy";
                saytext = "You're crazy!";
                break;
            }
            break;

        case "german":
            switch(response)		
            {
            case "1":
                soundalias = "german_yes_sir";
                saytext = "Yes Sir!";
                break;

            case "2":
                soundalias = "german_no_sir";
                saytext = "No Sir!";
                break;

            case "3":
                soundalias = "german_on_my_way";
                saytext = "On my way.";
                break;

            case "4":
                soundalias = "german_sorry";
                saytext = "Sorry.";
                break;

            case "5":
                soundalias = "german_great_shot";
                saytext = "Great shot!";
                break;

            case "6":
                soundalias = "german_took_long_enough";
                saytext = "Took you long enough!";				
                break;

            case "7":
                soundalias = "german_are_you_crazy";
                saytext = "Are you crazy?";
                break;
            }
            break;
    }			

	self saveHeadIcon();
	self doQuickMessage(soundalias, saytext);

	wait 2;
	self.spamdelay = undefined;
	self restoreHeadIcon();
}

doQuickMessage(soundalias, saytext)
{
	if(self.sessionstate != "playing")
		return;

	if(isdefined(level.QuickMessageToAll) && level.QuickMessageToAll)
	{
		self.headiconteam = "none";
		self.headicon = "gfx/hud/headicon@quickmessage";

		self playSound(soundalias);
		self sayAll(saytext);
	}
	else
	{
		if(self.sessionteam == "allies")
			self.headiconteam = "allies";
		else if(self.sessionteam == "axis")
			self.headiconteam = "axis";
		
		self.headicon = "gfx/hud/headicon@quickmessage";

		self playSound(soundalias);
        
        if ( ( level.iGamemode & level.iFLAG_GAMEMODE_HARDCORE ) == 0 )
        {
            self sayTeam( "^7" + saytext );
            self pingPlayer();
        }
	}
}

saveHeadIcon()
{
	if(isdefined(self.headicon))
		self.oldheadicon = self.headicon;

	if(isdefined(self.headiconteam))
		self.oldheadiconteam = self.headiconteam;
}

restoreHeadIcon()
{
	if(isdefined(self.oldheadicon))
		self.headicon = self.oldheadicon;

	if(isdefined(self.oldheadiconteam))
		self.headiconteam = self.oldheadiconteam;
}