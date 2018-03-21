INFO_PLAYER_SPAWN = { Vector( 256, -469, 1733 ), 90 }

NEXT_MAP = "gm_ghosthunt_2"	-- Change this for your server


-- Player spawns
function HL2C_PlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Ghost Hunt\"" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_physcannon" )

end
hook.Add( "PlayerSpawn", "HL2C_PlayerSpawn", HL2C_PlayerSpawn )


-- Initialize entities
function HL2C_InitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Ghost Hunt"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

end
hook.Add( "InitPostEntity", "HL2C_InitPostEntity", HL2C_InitPostEntity )
