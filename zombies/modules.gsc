/*
    File:           modules.gsc
    Author:         Cheese
    Last update:    11/12/2012
*/

init()
{
    [[ level.register ]]( "load_modules", ::load_modules );
    [[ level.register ]]( "register_module", ::register_module );
    
    // register all "stock" modules here
    register_module( "precache", zombies\precache::init, ::blank );      // first
    register_module( "utilities", zombies\utilities::init, ::blank );   // second
    register_module( "teams", zombies\_teams::init, ::blank );
    register_module( "menus", zombies\menus::init, ::blank );
    register_module( "classes", zombies\classes::init, ::blank );
    register_module( "hud", zombies\hud::init, ::blank );
    register_module( "models", zombies\models::init, ::blank );
    register_module( "players", zombies\players::init, ::blank );
    register_module( "socket", zombies\socket::init, ::blank );
    register_module( "stats", zombies\stats::init, ::blank );
    register_module( "killcam", zombies\killcam::init, ::blank );
    register_module( "gamemodes", zombies\gamemodes::init, ::blank );
    register_module( "quickmessages", zombies\quickmessages::init, ::blank );
    register_module( "spawnlogic", zombies\_spawnlogic::init, ::blank );
    register_module( "mapvote", zombies\mapvote::init, ::blank );
    register_module( "weather", zombies\weather::init, zombies\weather::main );
    register_module( "logo", zombies\logo::init, zombies\logo::main );
    register_module( "base", zombies\base::init, zombies\base::main );                  // last :)
    
    init_modules();
    
    // this is ONE of TWO function calls that explicitly state the function & file!
    modules\custom::init();
}

init_modules()
{
    for ( i = 0; i < level.aModules.size; i++ )
    {
        oModule = level.aModules[ i ];
        //thread [[ oModule.pFunction ]]();
        thread run_thread( oModule.pFunction, "init:" + oModule.sName );
    }
}

load_modules( o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{
    for ( i = 0; i < level.aModules.size; i++ )
    {
        oModule = level.aModules[ i ];
        //thread [[ oModule.pRunFunction ]]();
        thread run_thread( oModule.pRunFunction, "load:" + oModule.sName );
    }
}

run_thread( oFunc, sName, o1, o2, o3, o4, o5, o6, o7, o8, o9 )
{       
    level.threadcount++;
    //iprintln( gettime() + "/mod:" + sName + "/start/" + isPlayer( self ) + "/" + isDefined( self ) );
    
    self [[ oFunc ]]( o1, o2, o3, o4, o5, o6, o7, o8, o9 );

    //iprintln( gettime() + "/mod:" + sName + "/stop/" + isPlayer( self ) + "/" + isDefined( self ) );
    level.threadcount--;
    
    return;
}

register_module( sModuleName, pFunction, pRunFunction, o4, o5, o6, o7, o8, o9 )
{
    if ( !isDefined( level.aModules ) )
        level.aModules = [];
        
    sName = checkModuleName( sModuleName );
    
    oModule = spawnstruct();
    oModule.sName = sName;
    oModule.pFunction = pFunction;
    oModule.pRunFunction = pRunFunction;
    
    level.aModules[ level.aModules.size ] = oModule;
}

checkModuleName( sName )
{
    while ( true )
    {
        bFoundName = false;
        
        for ( i = 0; i < level.aModules.size; i++ )
        {
            if ( level.aModules[ i ].sName == sName )
            {
                sName += gettime();
                bFoundName = true;
            }
        }
        
        if ( !bFoundName )
            break;
    }
    
    return sName;
}

blank()
{
}