/*
    File:           hud.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/

init()
{
    [[ level.register ]]( "player_hud", ::player_hud );
    
    [[ level.call ]]( "precache", &"Class: ", "string" );
    [[ level.call ]]( "precache", &"Claymores: ", "string" );
    [[ level.call ]]( "precache", &"Heal points: ", "string" );
    [[ level.call ]]( "precache", &"Infections healed: ", "string" );
    [[ level.call ]]( "precache", &"Fires put out: ", "string" );
}

player_hud()
{
    self thread waittill_death();
    self thread waittill_remove();
    
    self.hud = [];
    
    self addTextHud( "health", 567, 465, "center", "middle", 1, 0.8, 10, &"" );
    self addTextHud( "class", 630, 415, "right", "middle", 1, 1, 10, &"Class: " );
    
    if ( self.class == "sniper" )
        self addTextHud( "claymores", 630, 400, "right", "middle", 1, 1, 10, &"Claymores: " );
    else if ( self.class == "medic" )
    {
        self addTextHud( "healpoints", 630, 400, "right", "middle", 1, 1, 10, &"Heal points: " );
        self addTextHud( "infections", 630, 385, "right", "middle", 1, 1, 10, &"Infections healed: " );
        self addTextHud( "fires", 630, 370, "right", "middle", 1, 1, 10, &"Fires put out: " );
    }
    
    self thread run_hud();
}

waittill_death()
{
    self waittill( "death" );
    
    self notify( "remove_hud_stuff" );
}

waittill_remove()
{
    self waittill( "remove_hud_stuff" );
    
    if ( isDefined( self.hud[ "health" ] ) )                self.hud[ "health" ] destroy();
    if ( isDefined( self.hud[ "class" ] ) )                 self.hud[ "class" ] destroy();
    if ( isDefined( self.hud[ "claymores" ] ) )             self.hud[ "claymores" ] destroy();
    if ( isDefined( self.hud[ "healpoints" ] ) )            self.hud[ "healpoints" ] destroy();
    if ( isDefined( self.hud[ "infections" ] ) )            self.hud[ "infections" ] destroy();
    if ( isDefined( self.hud[ "fires" ] ) )                 self.hud[ "fires" ] destroy();
}

run_hud()
{
    self endon( "remove_hud_stuff" );
    
    if ( self.pers[ "team" ] == "axis" )
        class = [[ level.call ]]( "get_class_information", self.class, "hunters" );
    else
        class = [[ level.call ]]( "get_class_information", self.class, "zombies" );
        
    self.hud[ "class" ] setText( class.lName );
    
    while ( 1 )
    {
        self.hud[ "health" ] setValue( self.health );
        
        if ( self.class == "sniper" )
            self.hud[ "claymores" ] setValue( self.claymores );
        else if ( self.class == "medic" )
        {
            self.hud[ "healpoints" ] setValue( self.stats[ "healPoints" ] );
            self.hud[ "infections" ] setValue( self.stats[ "infectionsHealed" ] );
            self.hud[ "fires" ] setValue( self.stats[ "firesPutOut" ] );
        }
        
        wait 0.1;
    }
}

addTextHud( name, x, y, alignX, alignY, alpha, fontScale, sort, label )
{
	self.hud[ name ] = newClientHudElem( self );
	self.hud[ name ].x = x;
	self.hud[ name ].y = y;
	self.hud[ name ].alignX = alignX;
	self.hud[ name ].alignY = alignY;
	self.hud[ name ].alpha = alpha;
	self.hud[ name ].fontScale = fontScale;
	self.hud[ name ].sort = sort;
	self.hud[ name ].label = label;
}