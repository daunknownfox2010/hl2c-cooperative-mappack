RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( -889, 8, 20 ), 90 }

NEXT_MAP = "sp_sawlife2"    -- Change this for your server

NEXT_MAP_TIME = 10

RESPAWNABLE_ITEMS = {
	[ "item_ammo_pistol" ] = true
}

RESPAWNING_ITEMS = {}


-- Player spawns
function hl2cPlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 10" )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Entity is being removed
function hl2cEntityRemoved( ent )

	-- Store respawnable items in a respawning list
	if ( ent.isRespawnable ) then
	
		-- Store the variables needed in local variables
		local entIndex = ent:EntIndex()
		local entClass = ent:GetClass()
		local entOriginalAng = ent.originalAng
		local entOriginalPos = ent.originalPos
		local entSpawnFlags = ent.spawnFlags
	
		-- Insert the EntIndex first
		table.insert( RESPAWNING_ITEMS, entIndex )
	
		-- Add details to the table
		for k, v in pairs( RESPAWNING_ITEMS ) do
		
			if ( v == entIndex ) then
			
				RESPAWNING_ITEMS[ k ] = {}
				RESPAWNING_ITEMS[ k ][ "Class" ] = entClass
				RESPAWNING_ITEMS[ k ][ "Angles" ] = entOriginalAng
				RESPAWNING_ITEMS[ k ][ "Position" ] = entOriginalPos
				RESPAWNING_ITEMS[ k ][ "SpawnFlags" ] = entSpawnFlags
				RESPAWNING_ITEMS[ k ][ "RespawnTime" ] = CurTime() + 10
			
			end
		
		end
	
	end

end
hook.Add( "EntityRemoved", "hl2cEntityRemoved", hl2cEntityRemoved )


-- Initialize entities
function hl2cInitPostEntity()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Remove trigger_weapon_strip entities
	for _, ent in pairs( ents.FindByClass( "trigger_weapon_strip" ) ) do
	
		ent:Remove()
	
	end

	-- Get respawnable items
	for _, ent in pairs( ents.GetAll() ) do
	
		if ( ent:CreatedByMap() && RESPAWNABLE_ITEMS[ ent:GetClass() ] ) then
		
			ent.isRespawnable = true
			ent.originalAng = ent:GetAngles()
			ent.originalPos = ent:GetPos()
			ent.spawnFlags = ent:GetSpawnFlags()
		
		end
	
	end

end
hook.Add( "InitPostEntity", "hl2cInitPostEntity", hl2cInitPostEntity )


-- Called every frame/tick
function hl2cThink()

	-- Respawn items in the table
	for k, v in pairs( RESPAWNING_ITEMS ) do
	
		-- Only respawn when the time is ready
		if ( RESPAWNING_ITEMS[ k ] && ( RESPAWNING_ITEMS[ k ][ "RespawnTime" ] < CurTime() ) ) then
		
			-- Create the item
			local respawnItem = ents.Create( RESPAWNING_ITEMS[ k ][ "Class" ] )
			respawnItem.isRespawnable = true
		
			-- Set up the item
			for k2, v2 in pairs( RESPAWNING_ITEMS[ k ] ) do
			
				if ( k2 == "Angles" ) then
				
					respawnItem.originalAng = v2
					respawnItem:SetAngles( v2 )
				
				elseif ( k2 == "Position" ) then
				
					respawnItem.originalPos = v2
					respawnItem:SetPos( v2 )
				
				elseif ( k2 == "SpawnFlags" ) then
				
					respawnItem.spawnFlags = v2
					respawnItem:SetKeyValue( "AddOutput", "spawnflags "..v2 )
				
				end
			
			end
		
			-- Spawn the item
			respawnItem:Spawn()
			respawnItem:Activate()
		
			-- Play a sound
			respawnItem:EmitSound( "AlyxEmp.Charge" )
		
			-- Remove the item from the table
			table.remove( RESPAWNING_ITEMS, k )
		
		end
	
	end

end
hook.Add( "Think", "hl2cThink", hl2cThink )


-- Accept entity input
function hl2cAcceptInput( ent, input, activator, caller, value )

	-- Player Speedmod
	if ( !game.SinglePlayer() && ( ent:GetClass() == "player_speedmod" ) && ( string.lower( input ) == "modifyspeed" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetLaggedMovementValue( tonumber( value ) )
		
		end
	
	end

	-- Game end will end the game
	if ( ent:GetClass() == "game_end" && ( string.lower( input ) == "endgame" ) ) then
	
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )
