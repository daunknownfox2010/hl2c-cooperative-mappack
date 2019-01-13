RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( 1280, 0, 512 ), 180 }

NEXT_MAP = "map_select_v2" -- Default to map select, feel free to change it

FORCE_PLAYER_RESPAWNING = true


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
function hl2cMapEdit()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Ghost Hunt"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )
