RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( -3072, 2112, -2308 ), 90 }

NEXT_MAP = "coop_123module_v2"	-- Change this for your server

NEXT_MAP_TIME = 10

RESPAWNABLE_ITEMS = {
	[ "item_ammo_357" ] = true,
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
	ply:SendLua( "NEXT_MAP_TIME = 10" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_ar2" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_crossbow" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_medkit" )

	-- Ammo
	ply:GiveAmmo( 160, game.GetAmmoID( "Pistol" ) )
	ply:GiveAmmo( 225, game.GetAmmoID( "SMG1" ) )
	ply:GiveAmmo( 3, game.GetAmmoID( "SMG1_Grenade" ) )
	ply:GiveAmmo( 130, game.GetAmmoID( "AR2" ) )
	ply:GiveAmmo( 40, game.GetAmmoID( "Buckshot" ) )
	ply:GiveAmmo( 6, game.GetAmmoID( "XBowBolt" ) )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Player uses an entity
function hl2cPlayerUse( ply, ent )

	-- Kill the player if they use the cube
	if ( ent:GetName() == "cube" ) then
	
		timer.Simple( 0.01, function() hl2cDissolvePlayer( ply ) end )
	
	end

end
hook.Add( "PlayerUse", "hl2cPlayerUse", hl2cPlayerUse )


-- Dissolves the player
function hl2cDissolvePlayer( ply )

	if ( !IsValid( ply ) ) then return end
	if ( !ply:IsPlayer() ) then return end
	if ( !ply:Alive() ) then return end

	local damageInfo = DamageInfo()
	damageInfo:SetDamage( 9999 )
	damageInfo:SetAttacker( ply )
	damageInfo:SetDamageType( DMG_DISSOLVE )

	ply:TakeDamageInfo( damageInfo )

end


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

	-- Remove point_servercommand entities
	for _, ent in pairs( ents.FindByClass( "point_servercommand" ) ) do
	
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

	-- Remove points003
	for _, ent in pairs( ents.FindByName( "points003" ) ) do
	
		ent:Remove()
	
	end

	-- Remove points005
	for _, ent in pairs( ents.FindByName( "points005" ) ) do
	
		ent:Remove()
	
	end

	-- Remove client
	for _, ent in pairs( ents.FindByName( "client" ) ) do
	
		ent:Remove()
	
	end

	-- Remove playercommand
	for _, ent in pairs( ents.FindByName( "playercommand" ) ) do
	
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
function hl2cAcceptInput( ent, input )

	-- Game end will end the game
	if ( ent:GetClass() == "game_end" && ( string.lower( input ) == "endgame" ) ) then
	
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "hl2cAcceptInput", hl2cAcceptInput )
