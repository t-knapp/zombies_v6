/*
    File:           weather.gsc
    Author:         Cheese
    Last update:    11/19/2012
*/

init()
{
}

main()
{
    wait 5;
    level.fogdist = 2000;
    setCullFog( 0, 2000, 0, 0, 0, 1 );
    
    while ( ( level.iGameFlags & level.iFLAG_GAME_STARTED ) == 0 )
        wait 0.05;
        
    setFog( 0, 750, 0, 0, 0, 1200 );
}

setFog( close, far, r, g, b, time )
{
    amount = far / ( time / 5 );
    iprintln( amount );
    
    while ( time > 0 && ( level.iGameFlags & level.iFLAG_GAME_OVER ) == 0 )
    {
        level.fogdist -= amount;
        setCullFog( close, level.fogdist, r, g, b, 5 );
        time -= 5;
        wait 5;
    }
}