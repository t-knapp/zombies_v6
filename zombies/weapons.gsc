init()
{
    [[ level.register ]]( "get_weapon_max_ammo", ::get_weapon_max_ammo, level.iFLAG_RETURN );
}

main()
{
}

get_weapon_max_ammo( weapon )
{
    switch ( weapon )
    {
        // recon
        case "ppsh_mp":
        case "ppsh_semi_mp":    return 355;
        case "colt_mp":         return 112;
        // explosives expert
        case "mp40_mp":         return 320;
        case "panzerfaust_mp":  return 20;
        // sharpshooter
        case "kar98k_sniper_mp":return 150;
        // support
        case "mp44_mp":
        case "mp44_semi_mp":    return 240;
        // medic:
        case "thompson_mp":     return 360;
        // engineer
        case "m1garand_mp":     return 240;
        // soviet steamroller
        case "bar_mp":          return 300;
        case "fg42_mp":         return 300;   
        // defaults
        case "m1carbine_mp":    return 400;
        case "springfield_mp":  return 150;
        case "kar98k_mp":       return 125;
        case "luger_mp":        return 64;
        default:                return 0;
    }
}
