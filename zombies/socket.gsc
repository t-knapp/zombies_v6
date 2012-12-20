/*
    File:           socket.gsc
    Author:         Cheese
    Last update:    11/14/2012
*/

init()
{
    [[ level.register ]]( "socket_get_handler", ::getHandler, level.iFLAG_RETURN );
    
    level.socket = spawnstruct();

    level.ports = [];
	for ( i = 0; i < 32; i++ )
	{
        setCvar( "socket_recv_" + i, "" );
        setCvar( "socket_send_" + i, "" );
        
		level.ports[ i ] = spawnstruct();
		level.ports[ i ].inuse = false;
	}
}

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