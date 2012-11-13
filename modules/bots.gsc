init()
{
    if ( getCvar( "bot_count" ) == "" )
        setCvar( "bot_count", "0" );
}

main()
{
    for ( ;; ) 
    {
        if ( getCvarInt( "bot_count" ) > 0 )
            break;
        
        wait 1;
    }
    
    iAmount = getCvarInt( "bot_count" );
    for ( i = 0; i < iAmount; i++ ) 
    {
        eBot = addtestclient();
        wait 0.5;
        
        if ( isPlayer( eBot ) )
        {
            eBot notify( "menuresponse", game[ "menu_team" ], "axis" );
            wait 0.5;
            eBot notify( "menuresponse", game[ "menu_weapon_axis" ], "mp44_mp" );
        }
    }
}