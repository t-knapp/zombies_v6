/*
    File:           killcam.gsc
    Author:         Infinity Ward (modified by Cheese)
    Last update:    11/14/2012
*/

init()
{
    [[ level.register ]]( "killcam", ::killcam, level.iFLAG_THREAD, level.iPRIORITY_HIGH );
    [[ level.register ]]( "gamecam", ::gamecam, level.iFLAG_THREAD, level.iPRIORITY_HIGH );
    [[ level.register ]]( "gamecam_remove", ::gamecam_remove, level.iFLAG_THREAD, level.iPRIORITY_HIGH );
    
    [[ level.call ]]( "precache", &"GAME CAM", "string" );
}

killcam(attackerNum, delay)
{
	self endon("spawned");

	if(attackerNum < 0)
		return;

	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = delay + 7;

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		self.spectatorclient = -1;
		self.archivetime = 0;
		self.sessionstate = "dead";
	
		self [[ level.call ]]( "respawn" );
		return;
	}

	if(!isdefined(self.kc_topbar))
	{
		self.kc_topbar = newClientHudElem(self);
		self.kc_topbar.archived = false;
		self.kc_topbar.x = 0;
		self.kc_topbar.y = 0;
		self.kc_topbar.alpha = 0.5;
        self.kc_topbar.sort = 20;
		self.kc_topbar setShader("black", 640, 112);
	}

	if(!isdefined(self.kc_bottombar))
	{
		self.kc_bottombar = newClientHudElem(self);
		self.kc_bottombar.archived = false;
		self.kc_bottombar.x = 0;
		self.kc_bottombar.y = 368;
		self.kc_bottombar.alpha = 0.5;
        self.kc_bottombar.sort = 20;
		self.kc_bottombar setShader("black", 640, 112);
	}

	if(!isdefined(self.kc_title))
	{
		self.kc_title = newClientHudElem(self);
		self.kc_title.archived = false;
		self.kc_title.x = 320;
		self.kc_title.y = 40;
		self.kc_title.alignX = "center";
		self.kc_title.alignY = "middle";
		self.kc_title.sort = 21; // force to draw after the bars
		self.kc_title.fontScale = 3.5;
	}
	self.kc_title setText(&"MPSCRIPT_KILLCAM");

	if(!isdefined(self.kc_skiptext))
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 320;
		self.kc_skiptext.y = 70;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.sort = 21; // force to draw after the bars
	}
	self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	if(!isdefined(self.kc_timer))
	{
		self.kc_timer = newClientHudElem(self);
		self.kc_timer.archived = false;
		self.kc_timer.x = 320;
		self.kc_timer.y = 428;
		self.kc_timer.alignX = "center";
		self.kc_timer.alignY = "middle";
		self.kc_timer.fontScale = 3.5;
		self.kc_timer.sort = 21;
	}
	self.kc_timer setTenthsTimer(self.archivetime - delay);

	self thread spawnedKillcamCleanup();
	self thread waitSkipKillcamButton();
	self thread waitKillcamTime();
	self waittill("end_killcam");

	self removeKillcamElements();

	self.spectatorclient = -1;
	self.archivetime = 0;
	self.sessionstate = "dead";

	self [[ level.call ]]( "respawn" );
}

waitKillcamTime()
{
	self endon("end_killcam");
	
	wait (self.archivetime - 0.05);
	self notify("end_killcam");
}

waitSkipKillcamButton()
{
	self endon("end_killcam");
	
	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;
	
	self notify("end_killcam");	
}

removeKillcamElements()
{
	if(isdefined(self.kc_topbar))
		self.kc_topbar destroy();
	if(isdefined(self.kc_bottombar))
		self.kc_bottombar destroy();
	if(isdefined(self.kc_title))
		self.kc_title destroy();
	if(isdefined(self.kc_skiptext))
		self.kc_skiptext destroy();
	if(isdefined(self.kc_timer))
		self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	self removeKillcamElements();
}


gamecam( playerNum, delay )
{
	self endon( "disconnect" );
	self endon( "spawned" );

	if ( playerNum < 0 )
		return;
		
	self.sessionstate = "spectator";
	self.spectatorclient = playerNum;
	self.archivetime = delay + 7;

	wait 0.05;
		
	if ( !isDefined( self.gc_topbar ) )
	{
		self.gc_topbar = newClientHudElem( self );
		self.gc_topbar.archived = false;
		self.gc_topbar.x = 0;
		self.gc_topbar.y = 0;
		self.gc_topbar.alpha = 0.75;
		self.gc_topbar.sort = 1000;
		self.gc_topbar setShader( "black", 640, 112 );
	}

	if ( !isDefined( self.gc_bottombar ) )
	{
		self.gc_bottombar = newClientHudElem( self );
		self.gc_bottombar.archived = false;
		self.gc_bottombar.x = 0;
		self.gc_bottombar.y = 368;
		self.gc_bottombar.alpha = 0.75;
		self.gc_bottombar.sort = 1000;
		self.gc_bottombar setShader( "black", 640, 112 );
    }
    
    if ( !isdefined( self.gc_title ) )
	{
		self.gc_title = newClientHudElem( self );
		self.gc_title.archived = false;
		self.gc_title.x = 320;
		self.gc_title.y = 40;
		self.gc_title.alignX = "center";
		self.gc_title.alignY = "middle";
		self.gc_title.sort = 1001; // force to draw after the bars
		self.gc_title.fontScale = 3.5;
        self.gc_title setText( &"GAME CAM" );
	}
}

gamecam_remove()
{
	self.gc_topbar destroy();
	self.gc_bottombar destroy();
	self.gc_title destroy();
	
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.sessionstate = "dead";
}