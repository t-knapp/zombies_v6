/*
    File:           weather.gsc
    Author:         Cheese
    Last update:    9/10/2012
*/

init()
{
}

main()
{
    wait 5;
    setCullFog( 0, 1500, 0, 0, 0, 1 );
    
    while ( level.iGameFlags & level.iFLAG_GAME_PREGAME )
        wait 0.05;
        
    setCullFog( 0, 1500, 0, 0, 0, 5 );
}