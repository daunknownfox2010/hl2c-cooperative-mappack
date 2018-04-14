RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( 1280, 0, 512 ), 180 }

NEXT_MAP = "gm_ghosthunt_3"	-- Change this for your server


-- Player spawns
function hl2cPlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Ghost Hunt\"" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_physcannon" )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Initialize entities
function hl2cInitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Ghost Hunt"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

end
hook.Add( "InitPostEntity", "hl2cInitPostEntity", hl2cInitPostEntity )
