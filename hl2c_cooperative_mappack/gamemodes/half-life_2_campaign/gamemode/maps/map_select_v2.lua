RESET_WEAPONS = true

INFO_PLAYER_SPAWN = { Vector( 96, 0, 192 ), 0 }

NEXT_MAP = "map_select_v2"

NEXT_MAP_TIME = 0


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
function hl2cInitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Map 1
	--ents.FindByName( "wall_map01" )[ 1 ]:Fire( "Disable" )
	--ents.FindByName( "door_map01" )[ 1 ]:Fire( "SetHealth", "1000" )
	--ents.FindByName( "text_map01" )[ 1 ]:Fire( "AddOutput", "message d1_trainstation_01" )
	--ents.FindByName( "trigger_map01" )[ 1 ]:Fire( "AddOutput", "OnTrigger server,Command,changelevel d1_trainstation_01,5,1" )

end
hook.Add( "InitPostEntity", "hl2cInitPostEntity", hl2cInitPostEntity )


-- Accept entity input
function hl2cAcceptInput( ent, input, activator, caller, value )

	-- Allow point_servercommand
	if ( ent:GetClass() == "point_servercommand" && ( string.lower( input ) == "command" ) ) then
	
		local changeToLevel = string.gsub( value, "changelevel ", "" )
	
		NEXT_MAP = changeToLevel
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )
