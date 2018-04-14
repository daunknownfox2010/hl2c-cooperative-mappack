RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( -10744, -505, 2020 ), 270 }

NEXT_MAP = "syn_apprehension"	-- Change this for your server

NEXT_MAP_TIME = 10

TRIGGER_CHECKPOINT = {
	{ Vector( -9412, 1264, 64 ), Vector( -8976, 1360, 140 ) },
	{ Vector( -8016, -1216, 336 ), Vector( -7792, -1120, 400 ) },
	{ Vector( -9392, -1624, -64 ), Vector( -8848, -1368, 20 ) }
}

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
	[ "item_healthvial" ] = true,
	[ "item_rpg_round" ] = true,
	[ "weapon_frag" ] = true
}

RESPAWNING_ITEMS = {}


-- Player spawns
function hl2cPlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Synergy Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 10" )

	-- Remove vortigaunts from godlike npcs on player
	ply:SendLua( "table.RemoveByValue( GODLIKE_NPCS, \"npc_vortigaunt\" )" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_medkit" )

	-- Ammo
	ply:GiveAmmo( 60, game.GetAmmoID( "Pistol" ) )
	ply:GiveAmmo( 135, game.GetAmmoID( "SMG1" ) )

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
	GAMEMODE.Name = "[HL2C] Synergy Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Remove vortigaunts from godlike npcs
	table.RemoveByValue( GODLIKE_NPCS, "npc_vortigaunt" )

	-- Remove game_player_equip entities
	for _, ent in pairs( ents.FindByClass( "game_player_equip" ) ) do
	
		ent:Remove()
	
	end

	-- Remove the garg vent
	ents.FindByName( "garg01_vent" )[ 1 ]:Fire( "SetHealth", "0" )

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
function hl2cAcceptInput( ent, input )

	-- Game end will end the game
	if ( ent:GetClass() == "game_end" && ( string.lower( input ) == "endgame" ) ) then
	
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )
