RESET_WEAPONS = true

INFO_PLAYER_SPAWN = { Vector( 96, 0, 192 ), 0 }

NEXT_MAP = "map_select_v2"

NEXT_MAP_TIME = 0


-- Player spawns
function HL2C_PlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 0" )

	-- Weapons
	ply:Give( "weapon_crowbar" )

end
hook.Add( "PlayerSpawn", "HL2C_PlayerSpawn", HL2C_PlayerSpawn )


-- Initialize entities
function HL2C_InitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Map 1
	--ents.FindByName( "wall_map01" )[ 1 ]:Fire( "Disable" )
	--ents.FindByName( "door_map01" )[ 1 ]:Fire( "SetHealth", "1000" )
	--ents.FindByName( "text_map01" )[ 1 ]:Fire( "AddOutput", "message coop_123module_v2" )
	--ents.FindByName( "trigger_map01" )[ 1 ]:Fire( "AddOutput", "OnTrigger server,Command,changelevel coop_123module_v2,5,1" )

end
hook.Add( "InitPostEntity", "HL2C_InitPostEntity", HL2C_InitPostEntity )


-- Accept entity input
function HL2C_AcceptInput( ent, input, activator, caller, value )

	-- Allow point_servercommand
	if ( ent:GetClass() == "point_servercommand" && ( string.lower( input ) == "command" ) ) then
	
		local changeToLevel = string.gsub( value, "changelevel ", "" )
	
		NEXT_MAP = changeToLevel
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "HL2C_AcceptInput", HL2C_AcceptInput )
