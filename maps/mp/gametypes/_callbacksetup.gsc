CodeCallback_StartGameType()
{
    [[ level.call ]]( "start_game_type" );
}

CodeCallback_PlayerConnect()
{
    [[ level.call ]]( "player_connect" );
}

CodeCallback_PlayerDisconnect()
{
    [[ level.call ]]( "player_disconnect" );
}

CodeCallback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc )
{
	[[ level.call ]]( "player_damage", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
}

CodeCallback_PlayerKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc )
{
    [[ level.call ]]( "player_killed", eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );
}