INFO_PLAYER_SPAWN = { Vector( 135, 3453, 323 ), 0 }

NEXT_MAP = "syn_fogisland"	-- Change this for your server

NEXT_MAP_TIME = 10

RESPAWNABLE_ITEMS = {
	[ "item_ammo_357" ] = true,
	[ "item_ammo_357_large" ] = true,
	[ "item_ammo_ar2" ] = true,
	[ "item_ammo_ar2_altfire" ] = true,
	[ "item_ammo_ar2_large" ] = true,
	[ "item_ammo_crossbow" ] = true,
	[ "item_ammo_smg1" ] = true,
	[ "item_ammo_smg1_grenade" ] = true,
	[ "item_ammo_smg1_large" ] = true,
	[ "item_battery" ] = true,
	[ "item_box_buckshot" ] = true,
	[ "item_healthkit" ] = true,
	[ "item_rpg_round" ] = true,
	[ "weapon_frag" ] = true
}

RESPAWNING_ITEMS = {}


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


-- Entity is being removed
function HL2C_EntityRemoved( ent )

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
hook.Add( "EntityRemoved", "HL2C_EntityRemoved", HL2C_EntityRemoved )


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

	-- Convert weapon medkits into item healthkits
	for _, ent in pairs( ents.FindByClass( "weapon_medkit" ) ) do
	
		if ( ent:CreatedByMap() ) then
		
			-- Spawn the healthkit
			local spawnItem = ents.Create( "item_healthkit" )
			spawnItem:SetAngles( ent:GetAngles() )
			spawnItem:SetPos( ent:GetPos() )
			spawnItem:Spawn()
			spawnItem:Activate()
		
			-- Make the healthkits respawnable
			spawnItem.isRespawnable = true
			spawnItem.originalAng = ent:GetAngles()
			spawnItem.originalPos = ent:GetPos()
			spawnItem.spawnFlags = ent:GetSpawnFlags()
		
			-- Remove the medkit
			ent:Remove()
		
		end
	
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
hook.Add( "InitPostEntity", "HL2C_InitPostEntity", HL2C_InitPostEntity )


-- Called every frame/tick
function HL2C_Think()

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
hook.Add( "Think", "HL2C_Think", HL2C_Think )


-- Accept entity input
function HL2C_AcceptInput( ent, input )

	-- Game end will end the game
	if ( ent:GetClass() == "game_end" && ( string.lower( input ) == "endgame" ) ) then
	
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "HL2C_AcceptInput", HL2C_AcceptInput )
