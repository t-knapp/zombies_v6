/*
    File:           gamemodes.gsc
    Author:         Cheese
    Last update:    8/10/2012
*/

init()
{
    level.sGamemode = [[ level.call ]]( "get_server_setting", "zom_gamemode", "default", "string", "", "" );
    level.iGamemode = level.iFLAG_GAMEMODE_DEFAULT;
    
    switch ( level.sGamemode )
    {
        case "hardcore":    gamemode_hardcore(); break;
        case "funstyle":    gamemode_funstyle(); break;
        default:            gamemode_default(); break;
    }
}

gamemode_default()
{
    setCvar( "bg_fallDamageMaxHeight", 480 );
    setCvar( "bg_fallDamageMinHeight", 256 );
    setCvar( "g_gravity", 800 );
    setCvar( "g_speed", 190 );
    setCvar( "scr_drawfriend", 1 );
}

gamemode_hardcore()
{
    level.iGamemode |= level.iFLAG_GAMEMODE_HARDCORE;
    
    setCvar( "bg_fallDamageMaxHeight", 480 );
    setCvar( "bg_fallDamageMinHeight", 256 );
    setCvar( "g_gravity", 800 );
    setCvar( "g_speed", 190 );
    setCvar( "scr_drawfriend", 0 );
}

gamemode_funstyle()
{
    level.iGamemode |= level.iFLAG_GAMEMODE_FUNSTYLE;
    
    setCvar( "bg_fallDamageMaxHeight", 768 );
    setCvar( "bg_fallDamageMinHeight", 256 );
    setCvar( "g_gravity", 200 );
    setCvar( "g_speed", 240 );
    setCvar( "scr_drawfriend", 1 );
}
