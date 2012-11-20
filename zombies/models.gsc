init()
{
    [[ level.register ]]( "model_setup", ::model_setup );
    
    level.playermodels = [];
    add_model( "engineer", "xmodel/playerbody_american_airborne", "xmodel/USAirborneHelmet", "xmodel/viewmodel_hands_us", "xmodel/gear_US_load1", "xmodel/gear_US_frntknklknfe", "xmodel/gear_US_garandbelt" );
    add_model( "heavy", "xmodel/playerbody_russian_conscript", "xmodel/sovietequipment_officercap", "xmodel/viewmodel_hands_russian", "xmodel/gear_russian_load_ocoat", "xmodel/gear_russian_ppsh_ocoat" );
    add_model( "medic", "xmodel/playerbody_american_airborne", "xmodel/USAirborneHelmet_medic", "xmodel/viewmodel_hands_us", "xmodel/USEquipment_Compass:TAG_BREASTPOCKET_RIGHT", "xmodel/USEquipment_Pouch1:TAG_HELMETSIDE" );
    add_model( "scout", "xmodel/playerbody_american_airborne", "xmodel/USAirborneHelmet", "xmodel/viewmodel_hands_us" );
    add_model( "soldier", "xmodel/playerbody_german_waffen", "xmodel/gear_german_helmet_waffen", "xmodel/viewmodel_hands_waffen", "xmodel/gear_german_mg42_w", "xmodel/gear_german_load5_w" );
    add_model( "sniper", "xmodel/playerbody_german_wehrmacht", "xmodel/gear_german_hat_officer_wehr", "xmodel/viewmodel_hands_whermact", "xmodel/gear_german_k98_w", "xmodel/gear_german_load1_w" );
    add_model( "support", "xmodel/playerbody_german_fallschirmjagercamo", "xmodel/gear_german_helmet_falshrm_camo", "xmodel/viewmodel_hands_fallschirmjager", "xmodel/gear_german_mp44_falshrm", "xmodel/gear_german_load1_falshrm" );
}

add_model( name, body, hat, viewmodel, op1, op2, op3 )
{
    if ( isDefined( level.playermodels[ name ] ) )
        return;
        
    [[ level.call ]]( "precache", body, "model" );
    [[ level.call ]]( "precache", hat, "model" );
    [[ level.call ]]( "precache", viewmodel, "model" );
    
    if ( isDefined( op1 ) )     [[ level.call ]]( "precache", [[ level.call ]]( "strtok", op1, ":" )[ 0 ], "model" );
    if ( isDefined( op2 ) )     [[ level.call ]]( "precache", [[ level.call ]]( "strtok", op2, ":" )[ 0 ], "model" );
    if ( isDefined( op3 ) )     [[ level.call ]]( "precache", [[ level.call ]]( "strtok", op3, ":" )[ 0 ], "model" );
        
    model = spawnstruct();
    model.body = body;
    model.hat = hat;
    model.viewmodel = viewmodel;
    model.op1 = op1;
    model.op2 = op2;
    model.op3 = op3;
    
    level.playermodels[ name ] = model;
}

model_setup()
{
    if ( self.pers[ "team" ] == "allies" )
    {
        [[ game[ "allies_model" ] ]]();
        return;
    }
    
    switch ( self.class )
    {
        case "heavy":
            self.nationality = "russian";
            self set_player_model( self.class );
            break;
        case "engineer":
        case "medic":       
        case "scout":
            self.nationality = "american";  
            self set_player_model( self.class ); 
            break;
        case "sniper":
        case "support":
        case "soldier":
            self.nationality = "german";
            self set_player_model( self.class ); 
            break;
        default:
            self.nationality = "german";    
            [[ game[ "axis_model" ] ]](); 
            break;
    }
}

set_player_model( name )
{
    if ( !isDefined( level.playermodels[ name ] ) )
    {
        [[ game[ "axis_model" ] ]]();
        return;
    }
    
    model = level.playermodels[ name ];
	self setModel( model.body );
    
    if ( self.nationality == "german" )
        character\_utility::attachFromArray( xmodelalias\head_axis::main() );
    else
        character\_utility::attachFromArray( xmodelalias\head_allied::main() );
        
	self.hatModel = model.hat;
	self attach( self.hatModel );
    
    self setViewModel( model.viewmodel );
    
    if ( isDefined( model.op1 ) ) { vals = [[ level.call ]]( "strtok", model.op1, ":" ); if ( isDefined( vals[ 1 ] ) ) {self attach( vals[ 0 ], vals[ 1 ] ); } else { self attach( vals[ 0 ] ); } }
    if ( isDefined( model.op2 ) ) { vals = [[ level.call ]]( "strtok", model.op2, ":" ); if ( isDefined( vals[ 1 ] ) ) {self attach( vals[ 0 ], vals[ 1 ] ); } else { self attach( vals[ 0 ] ); } }
    if ( isDefined( model.op3 ) ) { vals = [[ level.call ]]( "strtok", model.op3, ":" ); if ( isDefined( vals[ 1 ] ) ) {self attach( vals[ 0 ], vals[ 1 ] ); } else { self attach( vals[ 0 ] ); } }
}