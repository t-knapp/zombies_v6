init()
{
    [[ level.register ]]( "model_setup", ::model_setup );
}

model_setup()
{
    if ( self.pers[ "team" ] == "axis" )
        [[ game[ "axis_model" ] ]]();
    else if ( self.pers[ "team" ] == "allies" )
        [[ game[ "allies_model" ] ]]();
}