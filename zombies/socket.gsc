/*
    File:           socket.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/

init()
{
    //[[ level.register ]]( "socket_get_handler", ::getHandler, level.iFLAG_RETURN );
    [[ level.register ]]( "socket_request", ::request, level.iFLAG_RETURN );
    [[ level.register ]]( "socket_get_handler", ::request_get_handler, level.iFLAG_RETURN );
    
    setCvar( "server_request", "" );
    setCvar( "server_reply", "" );
    
    level.socket = spawnstruct();
    
    level.server_request = spawnstruct();
    level.server_request.locked = false;
    level.server_request.last_request = undefined;
    level.server_request.request_timeout = 10;
    level.server_request.reply_timeout = 5;

    level.ports = [];
	for ( i = 0; i < level.maxclients; i++ )
	{
        setCvar( "port_" + i, "" );
        
		level.ports[ i ] = spawnstruct();
		level.ports[ i ].inuse = false;
	}
}

/* OLD SOCKET CODE
socket( port, recvTimeout ) 
{
	if ( !isDefined( port ) )
		port = getAvailablePort();
	if ( !isDefined( recvTimeout ) )
		recvTimeout = 3;
		
	temp = spawnstruct();
	temp.port = port;
	temp.recvTimeout = recvTimeout;
	temp.recvData = undefined;
	temp.timeout = false;
	temp.received = false;
	return temp;
}

send( data ) 
{
	if ( !isDefined( self.port ) )
		return;
		
	setCvar( "socket_send_" + self.port, data );
}

receive() 
{
	self thread receive_timeout();
	
	while ( getCvar( "socket_recv_" + self.port ) == "" && !self.timeout )
		wait 0.05;
		
	if ( self.timeout )
		return;
		
	self.received = true;
	ret = getCvar( "socket_recv_" + self.port );
	setCvar( "socket_recv_" + self.port, "" );
	setCvar( "socket_send_" + self.port, "" );
	self.recvData = ret;
}

receive_timeout() 
{
	time = 0;
	while ( time < 5 && !self.received ) 
    {
		time += 0.05;
		wait 0.05;
	}
	
	if ( !self.received ) 
    {
		self.timeout = true;
		setCvar( "socket_recv_" + self.port, "" );
		setCvar( "socket_send_" + self.port, "" );
	}
}

close( socket ) 
{
	freePort( socket.port );
	socket = undefined;
}

getAvailablePort() 
{
	while ( 1 ) 
    {
		for ( i = 0; i < level.ports.size; i++ ) 
        {
			if ( !level.ports[ i ].inuse ) 
            {
				level.ports[ i ].inuse = true;
				return i;
			}
		}
		
		wait 0.5;
	}
}

freePort( port ) 
{
	if ( level.ports[ port ].inuse )
		level.ports[ port ].inuse = false;
}

getHandler( request ) 
{
	sock = socket();
	sock send( request );
	sock receive();
    timedout = sock.timeout;
    recvData = sock.recvData;
    close( sock );
	
	if ( !timedout ) 
		return recvData;
	else
		return "timeout";
}
*/

/*
    request()
    
    This is our main socket/net function. The goal is to provide the game with
    outside information from a mysql database in the most effecient and easiest
    way possible.
    
    Ideally:
    
    {
        code calls request
        checks and makes sure we have a valid request (validate_request)
        sets cvar server_request
        waits for cvar server_reply to be set
        
        checks and makes sure we have a valid reply (validate_reply)
        runs gethandler request
    }
    
    :)
*/

get_open_port()
{
    while ( 1 )
    {
        for ( i = 0; i < level.ports.size; i++ )
        {
            if ( !level.ports[ i ].inuse )
            {
                level.ports[ i ].inuse = true;
                return i;
            }
        }
        
        wait 0.05;
    }
}

free_port( port )
{
    if ( level.ports[ port ].inuse )
        level.ports.inuse = false;
        
    setCvar( "port_" + port, "" );
}

request( sRequest, iClientNumber )
{
    req = spawnstruct();
    req thread request_run_thread( sRequest, iClientNumber );
    req waittill( "request_run_thread done" );
    
    //req thread check_for_errors();
    //req waittill( "check_for_errors done" );
    
    ret = req.ret;
    req = undefined;
    
    return ret;
}

check_for_errors()
{
    iprintln( "error check" );
    /*
    wait 0;
    
    if ( [[ level.call ]]( "contains", self.ret, "error: " ) )
    {
        iPrintLnBold( self.ret );
        setCvar( "server_reply", "" );
        level.server_request.locked = false;
    }
    */
    self notify( "check_for_errors done" );
}

request_run( sRequest, iClientNumber )
{
}

// fucking stupid piece of shit CoD
// apparently can't support the proper request_run
// fuck fuck fuck
// AND IT WORKS FUCKING FLAWLESSLY TOO
// FUCKING COD PIECE OF SHIT GAME THAT SUCKS MAJOR DICK
request_run_thread( sRequest, iClientNumber )
{
    // fucking threads
    wait 0;
   // iprintln( "request_run_thread" );
    
    // --> changed this without realizing :> <--
    if ( !isDefined( sRequest ) ) {
        self.ret = "error: no request";
        self notify( "request_run_thread done" );
        return;
    }
        
    if ( !isDefined( iClientNumber ) ) {
        self.ret = "error: no client number specified";
        self notify( "request_run_thread done" );
        return;
    }
        
    //iprintln( "validate_request" );
        
    // if we don't have a valid request, reject it
    if ( !validate_request( sRequest, iClientNumber ) ) {
       self.ret = "error: invalid request";
       self notify( "request_run_thread done" );
       return;
    }
        
    //iprintln( "request_locked_timeout" );
    
    // wait until previous requests have gone through
    if ( request_locked_timeout() ) {
        self.ret = "error: timed out on request";
        self notify( "request_run_thread done" );
        return;
    }
        
    level.server_request.locked = true;
    level.server_request.last_request = sRequest;
    
    //iprintln( "get_open_port" );
    port = get_open_port();
    
    //iprintln( "format_packet" );
    packet = format_packet( port, sRequest, iClientNumber );
    
    //iprintln( packet );

    // send this request through
    setCvar( "server_request", packet );
    
    //iprintln( "request_reply_timeout" );
    /*
    // wait for a reply
    if ( request_reply_timeout() ) {
        self.ret = "error: timed out on reply";
        self notify( "request_run_thread done" );
        return;
    }*/
    
    // STUPID CODE
    time = 0;
    
    reply = timeout_handler_thing( level.server_request.reply_timeout, "server_reply" );
    //iprintln( reply.timedout );
    //iprintln( reply.received );
    //iprintln( reply.ret );
    
    //iprintln( "timedout: " + timedout );
    //iprintln( "received: " + received );
    
    if ( reply.timedout ) {
        self.ret = "error: timed out on reply";
        self notify( "request_run_thread done" );
        return;
    }
    // END STUPID CODE
        
    // get out reply
    sReply = reply.ret;
    
    ///iprintln( sReply );
    
    //iprintln( "validate_reply" );
    // if we don't have a valid reply, reject it
    if ( !validate_reply( sReply, iClientNumber, port ) ) {
        self.ret = "error: invalid reply";
        self notify( "request_run_thread done" );
        return;
    }
              
    //iprintln( "parse_server_reply" );
    // TODO: run our get handler request
    tmp = parse_server_reply( sReply, iClientNumber, port );
    
    if ( !isDefined( tmp ) ) {
        self.ret = "error: failed to parse reply";
        self notify( "request_run_thread done" );
        return;
    }

    // at this point, we're ready for another reply
    setCvar( "server_reply", "" );
    level.server_request.locked = false;
    
    self.ret = tmp;
    
    self notify( "request_run_thread done" );
}

/*
request_run( sRequest, iClientNumber )
{   
    iprintln( "request_run" );
    
    // --> changed this without realizing :> <--
    if ( !isDefined( sRequest ) )
        return "error: no request";
        
    if ( !isDefined( iClientNumber ) )
        return "error: no client number specified";
        
    iprintln( "validate_request" );
        
    // if we don't have a valid request, reject it
    if ( !validate_request( sRequest, iClientNumber ) )
       return "error: invalid request";
        
    iprintln( "request_locked_timeout" );
    
    // wait until previous requests have gone through
    if ( request_locked_timeout() )
        return "error: timed out on request";
        
    level.server_request.locked = true;
    level.server_request.last_request = sRequest;
    
    iprintln( "get_open_port" );
    port = get_open_port();
    
    iprintln( "format_packet" );
    packet = format_packet( port, sRequest, iClientNumber );
    
    iprintln( packet );
    
    // send this request through
    setCvar( "server_request", packet );

    iprintln( "request_reply_timeout" );
    // wait for a reply
    if ( request_reply_timeout() )
        return "error: timed out on reply";
        
    // get out reply
    sReply = getCvar( "server_reply" );
    
    iprintln( sReply );
    
    iprintln( "validate_reply" );
    // if we don't have a valid reply, reject it
    if ( !validate_reply( sReply, iClientNumber, port ) )
        return "error: invalid reply";
              
    iprintln( "parse_server_reply" );
    // TODO: run our get handler request
    tmp = parse_server_reply( sReply, iClientNumber, port );
    
    if ( !isDefined( tmp ) )
        return "error: failed to parse reply";

    // at this point, we're ready for another reply
    setCvar( "server_reply", "" );
    level.server_request.locked = false;
    
    iprintln( "request_get_handler" );
    // go go go
    ret = request_get_handler( tmp );
    return ret;
}
*/

request_locked_timeout()
{
    time = 0;

    while ( level.server_request.locked && time <= level.server_request.request_timeout )
    {
        time += 0.05;
        wait 0.05;
    }
    
    if ( time > level.server_request.request_timeout )
        return true;
        
    return false;
}
/*
request_reply_timeout()
{
    time = 0;

    while ( getCvar( "server_reply" ) == "" && time <= level.server_request.reply_timeout )
    {
        time += 0.05;
        wait 0.05;
    }
    
    if ( time > level.server_request.reply_timeout )
        return true;
        
    return false;
}
*/

request_reply_timeout()
{
    time = 0;
    
    reply = spawnstruct();
    reply.timedout = false;
    reply.received = false;
    
    if ( getCvar( "server_reply" ) != "" )
        return false;

    reply thread reply_timeout( level.server_request.reply_timeout );
    reply thread reply_receive( "server_reply" );
    
    reply waittill( "done" );
    
    timedout = reply.timedout;
    received = reply.received;
    reply = undefined;
    
    //iprintln( "timedout: " + timedout );
    //iprintln( "received: " + received );
    
    if ( received )
        return false;
        
    return true;
}
/*
reply_timeout()
{
    wait 0;
    self endon( "done" );
    
    time = 0;
    while ( !self.timedout )
    {
        if ( time >= level.server_request.reply_timeout )
            break;
            
        time += 0.05;
        wait 0.05;
    }
    
    self.timedout = true;
    self notify( "done" );
}
*/

/*
    Request format:
    
    timeid/request type/client slot|
    
    where:
    
        timeid = gettime()
        request type = the name of the request type
        client slot = client slot
*/
validate_request( request, clientnum )
{
/*
	split = [[ level.call ]]( "strtok", request, "|" );
    
    // we must have two args here
    if ( !isDefined( split[ 0 ] ) || !isDefined( split[ 1 ] ) )
        return false;
        
    args = [[ level.call ]]( "strtok", split[ 0 ], "/" );
    
    // need three args
    if ( !isDefined( args[ 0 ] ) || !isDefined( args[ 1 ] ) || !isDefined( args[ 2 ] ) )
        return false;
        
    timeid = args[ 0 ];
    type = args[ 1 ];
    clientnum = args[ 2 ];
    
    // verify timeid
    if ( ![[ level.call ]]( "is_numeric", timeid ) )
		return false;
*/
    if ( request == "" )
        return false;
        
    // verify type
    switch ( request )
    {
        case "getinfo":
        case "getachievements":
        case "saveinfo":
        case "saveachievements":
            break;
        default:
            return false;
            break;
    }
	
	if ( ![[ level.call ]]( "is_numeric", clientnum ) )
		return false;
    
    // verify player
    ent = getEntByNum( (int)clientnum );
    if ( !isPlayer( ent ) || !isDefined( ent ) )
        return false;
        
    // got here? let through.
    return true;
}

/* 
    Request format:
    
    timestamp/type/slot/port|
    
    where:
    
        timeid = gettime()
        request type = the name of the request type
        client slot = client slot
*/
validate_reply( reply, requestedclient, requestedport )
{          
    if ( reply == "" ) {
        iprintln( "reply == blank" );
        return false;
    }
    
    if ( ![[ level.call ]]( "contains", reply, "|" ) ) {
        iprintln( "doesn't contain |" );
        return false;
    }
        
    split = [[ level.call ]]( "strtok", reply, "|" );
    args = [[ level.call ]]( "strtok", split[ 0 ], "/" );
    
    // need four args
    if ( !isDefined( args[ 0 ] ) || !isDefined( args[ 1 ] ) || !isDefined( args[ 2 ] ) || !isDefined( args[ 3 ] ) ) {
        iprintln( "wrong number of args" );
        return false;
    }
        
    timeid = args[ 0 ];
    type = args[ 1 ];
    clientnum = args[ 2 ];
    port = args[ 3 ];
    
    // verify timeid
    if ( ![[ level.call ]]( "is_numeric", timeid ) ) {
        iprintln( "not numeric timeid" );
		return false;
    }
    
    // verify type
    switch ( type )
    {
        case "getinforesponse":
        case "getachievementsresponse":
        case "saveinforesponse":
        case "saveachievementsresponse":
            break;
        default:
            iprintln( "badtype" );
            return false;
            break;
    }
	
	if ( ![[ level.call ]]( "is_numeric", clientnum ) ) {
        iprintln( "not numeric clientnum" );
		return false;
    }
    
    // verify player
    ent = getEntByNum( (int)clientnum );
    if ( !isPlayer( ent ) || !isDefined( ent ) ) {
        iprintln( "not an ent" );
        return false;
    }
        
    // not our requested client?
    if ( requestedclient != (int)clientnum ) {
        iprintln( "not our client" );
        return false;
    }
        
    // port
    if ( ![[ level.call ]]( "is_numeric", port ) ) {
        iprintln( "not numeric port" );
        return false;
    }
        
    if ( requestedport != (int)port ) {
        iprintln( "port is not ours" );
        return false;
    }
        
    // got here? let through.
    return true;
}

parse_server_reply( reply, iClientNumber, prt )
{
    if ( !validate_reply( reply, iClientNumber, prt ) )
        return undefined;
        
    temp = spawnstruct();
        
    split = [[ level.call ]]( "strtok", reply, "|" );
    args = [[ level.call ]]( "strtok", split[ 0 ], "/" );
    
    temp.timeid = args[ 0 ];
    temp.type = args[ 1 ];
    temp.clientnum = (int)args[ 2 ];
    temp.port = (int)args[ 3 ];
    
    return temp;
}

format_packet( port, request, clientnum )
{
    currenttime = gettime();
    packet = currenttime + "/" + request + "/" + clientnum + "/" + port + "|";
    return packet;
}

request_get_handler( reply )
{
    //iprintln( "request_get_handler" );
    //iprintln( reply.port );
    
    req = spawnstruct();
    req thread request_get_handler_thread( reply );
    req waittill( "request_get_handler_thread done" );
    
    //req thread check_for_errors();
    //req waittill( "check_for_errors done" );
    
    setCvar( "port_" + reply.port, "" );
    
    ret = req.ret;
    req = undefined;
    
    return ret;
}

request_get_handler_thread( reply )
{
    ret = "";
    ourport = "port_" + reply.port;
    //iprintln( "ourport = " + ourport );
    handler = timeout_handler_thing( 5, ourport );
    
    // can't afford to timeout here
    if ( handler.timedout ) {
        //iprintln( "handler timed out" );
        self.ret = undefined;
        self notify( "request_get_handler_thread done" );
    }
        
    //balrg
    if ( ![[ level.call ]]( "is_numeric", handler.ret ) ) {
        //iprintln( "not numeric" );
        self.ret = undefined;
        self notify( "request_get_handler_thread done" );
    }
        
    // first packet is always the total # of packets    
    packetcount = (int)handler.ret;
    
    // we acknowledge the length
    setCvar( ourport, "acknowledged" );
    
    for ( i = 0; i < packetcount; i++ )
    {
        handler = timeout_handler_thing( 5, ourport, "acknowledged" );
        if ( handler.timedout ) {
            //iprintln( "handler timed out2" );
            self.ret = undefined;
            self notify( "request_get_handler_thread done" );
        }
            
        //iprintln( handler.ret );
        // need a terminating semicolon
        ret += handler.ret + ";";
        setCvar( ourport, "acknowledged" );
    }
    
    // at this point we're done, close the port
    free_port( reply.port );
    
    self.ret = ret;
    self notify( "request_get_handler_thread done" );
}

reply_timeout( maxtime, time )
{ 
    if ( !isDefined( self ) || self.timedout || self.received )
        return;
        
    if ( !isDefined( time ) )
        time = 0;
        
    wait ( 0.5 );
    time++;

    if ( time >= maxtime )
    {
        self.timedout = true;
        self notify( "done" );
        return;
    }
    
    self thread reply_timeout( time );
}

reply_receive( cvar, ignore )
{
    if ( !isDefined( self ) || self.timedout || self.received )
        return;
        
    wait ( 0.03 );
    
    val = getCvar( cvar );
    
    if ( val != ""  )
    {           
        go = true;
        if ( isDefined( ignore ) && val == ignore )
            go = false;
            
        if ( go ) 
        {
            wait 0.05;
            self.received = true;
            self.ret = val;
            self notify( "done" );
            return;
        }
    }

    self thread reply_receive( cvar, ignore );
}


timeout_handler_thing( maxtime, cvar, ignore )
{
    handler = spawnstruct();
    handler.timedout = false;
    handler.received = false;
    handler.ret = undefined;
    
    handler thread reply_timeout( maxtime );
    handler thread reply_receive( cvar, ignore );

    handler waittill( "done" );

    return handler;
}