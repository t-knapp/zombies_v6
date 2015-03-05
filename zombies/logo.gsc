init()
{
    [[ level.call ]]( "precache", &"^1codzombies.de ^7STATSAVE", "string" );
    [[ level.call ]]( "precache", &"forked from ^3cheese^7's beta_v6", "string" );
    [[ level.call ]]( "precache", &"Stats getting saved if you are registered!", "string" );
    [[ level.call ]]( "precache", &"^1Register at ^7codzombies.de", "string" );
    
}

main()
{
	level.logo = newHudElem();
	level.logo.x = 10;
	level.logo.y = 10;
	level.logo.alignx = "left";
	level.logo.aligny = "middle";
	level.logo.fontscale = 0.9;
	level.logo.archived = true;

	while ( 1 )
	{
		level.logo.alpha = 0;
		level.logo setText( &"^1codzombies.de ^7STATSAVE" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
		
		level.logo setText( &"forked from ^3cheese^7's beta_v6" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
		
		level.logo setText( &"Stats getting saved if you are registered!" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
		
		//Register
		level.logo setText( &"^1Register at ^7codzombies.de");
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
	}
}