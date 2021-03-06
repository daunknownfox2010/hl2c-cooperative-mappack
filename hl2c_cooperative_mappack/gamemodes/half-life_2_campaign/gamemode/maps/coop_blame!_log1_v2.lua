RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( -480, -7104, -5060 ), 90 }

NEXT_MAP = "coop_blame!_log2_v2"

NEXT_MAP_TIME = 0

FORCE_PLAYER_RESPAWNING = true

RESPAWNABLE_ITEMS = {
	[ "item_ammo_357" ] = true,
	[ "item_ammo_357_large" ] = true,
	[ "item_ammo_ar2" ] = true,
	[ "item_ammo_ar2_altfire" ] = true,
	[ "item_ammo_crossbow" ] = true,
	[ "item_ammo_pistol" ] = true,
	[ "item_ammo_smg1" ] = true,
	[ "item_ammo_smg1_grenade" ] = true,
	[ "item_battery" ] = true,
	[ "item_box_buckshot" ] = true,
	[ "item_healthkit" ] = true,
	[ "item_healthvial" ] = true
}

RESPAWNING_ITEMS = {}


-- Player spawns
function hl2cPlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 0" )

	-- Remove vortigaunts from godlike npcs on player
	ply:SendLua( "table.RemoveByValue( GODLIKE_NPCS, \"npc_vortigaunt\" )" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_ar2" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_medkit" )

	-- Ammo
	ply:GiveAmmo( 160, game.GetAmmoID( "Pistol" ) )
	ply:GiveAmmo( 225, game.GetAmmoID( "SMG1" ) )
	ply:GiveAmmo( 3, game.GetAmmoID( "SMG1_Grenade" ) )
	ply:GiveAmmo( 130, game.GetAmmoID( "AR2" ) )
	ply:GiveAmmo( 3, game.GetAmmoID( "AR2AltFire" ) )
	ply:GiveAmmo( 40, game.GetAmmoID( "Buckshot" ) )

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
function hl2cMapEdit()

	-- Gamemode Name will change here
	GAMEMODE.Name = "[HL2C] Co-operative"

	-- Flashlight doesn't drain AUX
	flashlightDrainsAUX = false

	-- Remove vortigaunts from godlike npcs
	table.RemoveByValue( GODLIKE_NPCS, "npc_vortigaunt" )

	-- Remove info_player_combine entities
	for _, ent in pairs( ents.FindByClass( "info_player_combine" ) ) do
	
		ent:Remove()
	
	end

	-- Remove info_player_deathmatch entities
	for _, ent in pairs( ents.FindByClass( "info_player_deathmatch" ) ) do
	
		ent:Remove()
	
	end

	-- Remove info_player_rebel entities
	for _, ent in pairs( ents.FindByClass( "info_player_rebel" ) ) do
	
		ent:Remove()
	
	end

	-- Remove player_weaponstrip entities
	for _, ent in pairs( ents.FindByClass( "player_weaponstrip" ) ) do
	
		ent:Remove()
	
	end

	-- Remove game_player_equip entities
	for _, ent in pairs( ents.FindByClass( "game_player_equip" ) ) do
	
		ent:Remove()
	
	end

	-- Remove game_score entities
	for _, ent in pairs( ents.FindByClass( "game_score" ) ) do
	
		ent:Remove()
	
	end

	-- Remove game_end entities
	for _, ent in pairs( ents.FindByClass( "game_end" ) ) do
	
		ent:Remove()
	
	end

	-- Remove makerebel
	for _, ent in pairs( ents.FindByName( "makerebel" ) ) do
	
		ent:Remove()
	
	end

	-- Remove client
	for _, ent in pairs( ents.FindByName( "client" ) ) do
	
		ent:Remove()
	
	end

	-- Remove server
	for _, ent in pairs( ents.FindByName( "server" ) ) do
	
		ent:Remove()
	
	end

	-- Remove endcount
	for _, ent in pairs( ents.FindByName( "endcount" ) ) do
	
		ent:Remove()
	
	end

	-- Create a new endcount
	local endCount = ents.Create( "math_counter" )
	endCount:SetPos( Vector( -5577.35, 5559, -22.1589 ) )
	endCount:SetName( "endcount" )
	endCount:SetKeyValue( "max", "2" )
	endCount:SetKeyValue( "startvalue", "2" )
	endCount:SetKeyValue( "OnHitMin", "mapchange,Command,,10,1" )
	endCount:SetKeyValue( "OnHitMin", "es,PickRandom,,5,1" )
	endCount:Spawn()
	endCount:Activate()

	-- Create a new point_servercommand
	local serverCommand = ents.Create( "point_servercommand" )
	serverCommand:SetPos( Vector( 5547.09, 5559, -15.2944 ) )
	serverCommand:SetName( "mapchange" )

	-- Create a crossbow
	local weaponCrossbow = ents.Create( "weapon_crossbow" )
	weaponCrossbow:SetPos( Vector( 478, 2403, -194 ) )
	weaponCrossbow:Spawn()
	weaponCrossbow:Activate()

	-- Create a 357
	local weapon357 = ents.Create( "weapon_357" )
	weapon357:SetPos( Vector( -445, 1601, -250 ) )
	weapon357:Spawn()
	weapon357:Activate()

	-- Create an RPG
	local weaponRPG = ents.Create( "weapon_rpg" )
	weaponRPG:SetPos( Vector( -377, 5126, -250 ) )
	weaponRPG:Spawn()
	weaponRPG:Activate()

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
hook.Add( "MapEdit", "hl2cMapEdit", hl2cMapEdit )


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

	-- Used for changing the map
	if ( ent:GetName() == "mapchange" && ( string.lower( input ) == "command" ) ) then
	
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )
