RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( 0, 0, 512 ), 180 }

NEXT_MAP = "gm_ghosthunt"	-- Change this for your server


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

	-- Remove the viewcontrol
	ents.FindByClass( "point_viewcontrol" )[ 1 ]:Remove()

	-- Remove the broken overlay
	ents.FindByClass( "env_screenoverlay" )[ 1 ]:Remove()

end
hook.Add( "InitPostEntity", "hl2cInitPostEntity", hl2cInitPostEntity )
