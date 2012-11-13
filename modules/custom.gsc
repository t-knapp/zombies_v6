init()
{
    [[ level.call ]]( "register_module", "bots", modules\bots::init, modules\bots::main );
}

blank()
{
}