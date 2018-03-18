INFO_PLAYER_SPAWN = { Vector( -10744, -505, 2020 ), 270 }

NEXT_MAP = "syn_apprehension"	-- Change this for your server

NEXT_MAP_TIME = 10

TRIGGER_CHECKPOINT = {
	{ Vector( -9412, 1264, 64 ), Vector( -8976, 1360, 140 ) },
	{ Vector( -8016, -1216, 336 ), Vector( -7792, -1120, 400 ) },
	{ Vector( -9392, -1624, -64 ), Vector( -8848, -1368, 20 ) }
}


-- Player spawns
function HL2C_PlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Synergy Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 10" )

	-- Remove vortigaunts from godlike npcs on player
	ply:SendLua( "table.RemoveByValue( GODLIKE_NPCS, \"npc_vortigaunt\" )" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_medkit" )

	-- Ammo
	ply:GiveAmmo( 60, game.GetAmmoID( "Pistol" ) )
	ply:GiveAmmo( 135, game.GetAmmoID( "SMG1" ) )

end
hook.Add( "PlayerSpawn", "HL2C_PlayerSpawn", HL2C_PlayerSpawn )


-- Initialize entities
function HL2C_InitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Synergy Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Remove vortigaunts from godlike npcs
	table.RemoveByValue( GODLIKE_NPCS, "npc_vortigaunt" )

	-- Remove game_player_equip entities
	for _, ent in pairs( ents.FindByClass( "game_player_equip" ) ) do
	
		ent:Remove()
	
	end

	-- Remove the garg vent
	ents.FindByName( "garg01_vent" )[ 1 ]:Fire( "SetHealth", "0" )

end
hook.Add( "InitPostEntity", "HL2C_InitPostEntity", HL2C_InitPostEntity )


-- Accept entity input
function HL2C_AcceptInput( ent, input )

	-- Game end will end the game
	if ( ent:GetClass() == "game_end" && ( string.lower( input ) == "endgame" ) ) then
	
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "HL2C_AcceptInput", HL2C_AcceptInput )
