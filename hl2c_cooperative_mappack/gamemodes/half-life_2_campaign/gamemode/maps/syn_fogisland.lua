INFO_PLAYER_SPAWN = { Vector( 135, 3453, 323 ), 0 }

NEXT_MAP = "syn_fogisland"	-- Change this for your server

NEXT_MAP_TIME = 10


-- Player spawns
function HL2C_PlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Synergy Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 10" )

	-- Weapons
	ply:Give( "weapon_357" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_medkit" )

	-- Ammo
	ply:GiveAmmo( 90, game.GetAmmoID( "SMG1" ) )
	ply:GiveAmmo( 20, game.GetAmmoID( "Buckshot" ) )

end
hook.Add( "PlayerSpawn", "HL2C_PlayerSpawn", HL2C_PlayerSpawn )


-- Initialize entities
function HL2C_InitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Synergy Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Remove game_player_equip entities
	for _, ent in pairs( ents.FindByClass( "game_player_equip" ) ) do
	
		ent:Remove()
	
	end

	-- Unlock door
	ents.FindByName( "door" )[ 1 ]:Fire( "Unlock" )

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
