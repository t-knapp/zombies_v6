init()
{
    [[ level.call ]]( "precache", &"^1zomb^7ies ^2alpha", "string" );
    [[ level.call ]]( "precache", &"mod by ^3cheese", "string" );
    [[ level.call ]]( "precache", &"xfire^2:^7 thecheeseman999", "string" );
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
		level.logo setText( &"^1zomb^7ies ^2alpha" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
		
		level.logo setText( &"mod by ^3cheese" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
		
		level.logo setText( &"xfire^2:^7 thecheeseman999" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
	}
}