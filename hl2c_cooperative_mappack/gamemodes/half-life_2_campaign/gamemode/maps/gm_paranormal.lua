INFO_PLAYER_SPAWN = { Vector( -1256, -480, 1 ), 180 }

NEXT_MAP = "gm_paranormal"	-- Change this for your server


-- Player spawns
function HL2C_PlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Paranormal\"" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_physcannon" )

end
hook.Add( "PlayerSpawn", "HL2C_PlayerSpawn", HL2C_PlayerSpawn )


-- Initialize entities
function HL2C_InitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Paranormal"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

end
hook.Add( "InitPostEntity", "HL2C_InitPostEntity", HL2C_InitPostEntity )
