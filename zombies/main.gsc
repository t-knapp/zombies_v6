/*
    File:           main.gsc
    Author:         Cheese
    Last update:    9/10/2012
*/

init()
{
    setCvar( "sv_fps", 30 );
    
    level.register = ::register;
    level.call = ::call;
    level.threadcount = 0;
    level.threads = [];
    
    setup_flags();
    
    // load up everything else
    // this is ONE of TWO function calls that explicitly state the function & file!
    zombies\modules::init();
    
    [[ level.call ]]( "load_modules" );
}

setup_flags()
{
    // for our call/register system
    level.iFLAG_DEFAULT         = 1;
    level.iFLAG_THREAD          = 2;
    level.iFLAG_RETURN          = 4;
    
    // priorities
    level.iPRIORITY_DEFAULT = 0;
    level.iPRIORITY_MEDIUM = 1;
    level.iPRIORITY_HIGH = 2;
    level.iPRIORITY_CRITICAL = 4;
    
    // gamemode stuff
    level.iFLAG_GAMEMODE_DEFAULT = 1;
    level.iFLAG_GAMEMODE_HARDCORE = 2;
    level.iFLAG_GAMEMODE_FUNSTYLE = 4;
    
	// Set defined for damage flags used in the playerDamage callback
	level.iDFLAGS_RADIUS			    = 1;
	level.iDFLAGS_NO_ARMOR			    = 2;
	level.iDFLAGS_NO_KNOCKBACK		    = 4;
	level.iDFLAGS_NO_TEAM_PROTECTION	= 8;
	level.iDFLAGS_NO_PROTECTION		    = 16;
	level.iDFLAGS_PASSTHRU			    = 32;
    
    // game flags
    level.iFLAG_GAME_PREGAME = 1;
    level.iFLAG_GAME_STARTED = 2;
    level.iFLAG_GAME_FIRST_ZOMBIE = 4;
    level.iFLAG_GAME_LAST_HUNTER = 8;
    level.iFLAG_GAME_OVER = 16;
    level.iFLAG_GAME_INTERMISSION = 32;
}

register( sFunctionName, pFunction, iFlags, iPriority, bOverwrite )
{
    if ( !isDefined( level.aFunctions ) )
        level.aFunctions = [];
        
    if ( !isDefined( sFunctionName ) || !isDefined( pFunction ) )
        return;
        
    if ( isDefined( level.aFunctions[ sFunctionName ] ) && !isDefined( bOverwrite ) && !bOverwrite )
        return;
        
    if ( !isDefined( iFlags ) )
        iFlags = level.iFLAG_DEFAULT;
        
    if ( !isDefined( iPriority ) )
        iPriority = level.iPRIORITY_DEFAULT;

    oFunc = spawnstruct();
    oFunc.sName = sFunctionName;
    oFunc.pFunction = pFunction;
    oFunc.iFlags = iFlags;
    oFunc.iPriority = iPriority;
    
    level.aFunctions[ sFunctionName ] = oFunc;
}

// this call/register idea is from codam
// competely recoded/optimised for my uses :)
// THE ONLY DOWNSIDE about this approach is the fact that if you're using external functions
// and they do NOT have (up to) 9 parameters, the code will break under developer mode ;)
call( sFunctionName, o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    oRet = self call_owner( sFunctionName, o1, o2, o3, o4, o5, o6, o7, o8, o9 );
    
    return ( oRet );
}

call_owner( sFunctionName, o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    if ( !isDefined( sFunctionName ) )
        return;
        
    if ( !isDefined( level.aFunctions[ sFunctionName ] ) )
    {
        if ( level.bDebug )
        {
            [[ level.call ]]( "print", "CODE BUG: Unknown function \'" + sFunctionName + "\'." );
            // logprint
        }
        return;
    }
        
    oFunc = level.aFunctions[ sFunctionName ];
    
    // threads should never return a value
    if ( oFunc.iFlags & level.iFLAG_THREAD )
        self thread run_thread( oFunc, o1, o2, o3, o4, o5, o6, o7, o8, o9 );
    else
    {
        oRet = self [[ oFunc.pFunction ]]( o1, o2, o3, o4, o5, o6, o7, o8, o9 );
        
        // only return values for functions that explicitly require one
        if ( oFunc.iFlags & level.iFLAG_RETURN )
            return ( oRet );
    }
    
    return;
}

run_thread( oFunc, o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    if ( oFunc.iPriority < level.iPRIORITY_HIGH )
        wait 0;
        
    level.threadcount++;
    //iprintln( gettime() + "/fnc:" + oFunc.sName + "/start/" + isPlayer( self ) + "/" + isDefined( self ) );
    
    self [[ oFunc.pFunction ]]( o1, o2, o3, o4, o5, o6, o7, o8, o9 );

    //iprintln( gettime() + "/fnc:" + oFunc.sName + "/stop/" + isPlayer( self ) + "/" + isDefined( self ) );
    level.threadcount--;
    
    return;
}