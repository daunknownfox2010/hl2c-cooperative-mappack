RESET_WEAPONS = true

INFO_PLAYER_SPAWN = { Vector( 96, 0, 192 ), 0 }

NEXT_MAP = "map_select_v2"

NEXT_MAP_TIME = 0

FORCE_PLAYER_RESPAWNING = true


-- Player spawns
function hl2cPlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 0" )

	-- Weapons
	ply:Give( "weapon_crowbar" )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Initialize entities
function hl2cMapEdit()

	-- Make players invulnerable
	game.SetGlobalState( "gordon_invulnerable", GLOBAL_ON )

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Map 1
	ents.FindByName( "wall_map01" )[ 1 ]:Fire( "Disable" )
	ents.FindByName( "door_map01" )[ 1 ]:Fire( "SetHealth", "1000" )
	ents.FindByName( "text_map01" )[ 1 ]:Fire( "AddOutput", "message d1_trainstation_01" )
	ents.FindByName( "trigger_map01" )[ 1 ]:Fire( "AddOutput", "OnTrigger server,Command,changelevel d1_trainstation_01,5,1" )

end
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )


-- Accept entity input
function hl2cAcceptInput( ent, input, activator, caller, value )

	-- Allow point_servercommand
	if ( ent:GetClass() == "point_servercommand" && ( string.lower( input ) == "command" ) ) then
	
		local changeToLevel = string.gsub( value, "changelevel ", "" )
	
		NEXT_MAP = changeToLevel
		GAMEMODE:NextMap()
	
		game.SetGlobalState( "gordon_invulnerable", GLOBAL_DEAD )
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )
