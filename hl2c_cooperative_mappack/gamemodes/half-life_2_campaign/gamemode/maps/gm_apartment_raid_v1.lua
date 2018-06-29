RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( -594, -194, 2 ), 249 }

NEXT_MAP = "gm_apartment_raid_v1"    -- Change this for your server

NEXT_MAP_TIME = 10

RESPAWNING_ITEMS = {}


-- Player spawns
function hl2cPlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 10" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_medkit" )

	-- Ammo
	ply:GiveAmmo( 100, game.GetAmmoID( "Pistol" ) )
	ply:GiveAmmo( 135, game.GetAmmoID( "SMG1" ) )
	ply:GiveAmmo( 20, game.GetAmmoID( "Buckshot" ) )

end
hook.Add( "PlayerSpawn", "hl2cPlayerSpawn", hl2cPlayerSpawn )


-- Entity is being removed
function hl2cEntityRemoved( ent )

	-- Radio operator was removed
	if ( ent:GetName() == "radio_operator" ) then
	
		GAMEMODE:NextMap()
	
	end

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

	-- Spawn in pistol ammo crates
	local pistolCrate = ents.Create( "item_ammo_crate" )
	pistolCrate:SetPos( Vector( -599, -356, 16 ) )
	pistolCrate:SetAngles( Angle( 0, 48, 0 ) )
	pistolCrate:SetKeyValue( "AmmoType", "0" )
	pistolCrate:Spawn()
	pistolCrate:Activate()

	local pistolCrate = ents.Create( "item_ammo_crate" )
	pistolCrate:SetPos( Vector( 102, -309, 16 ) )
	pistolCrate:SetAngles( Angle( 0, 178, 0 ) )
	pistolCrate:SetKeyValue( "AmmoType", "0" )
	pistolCrate:Spawn()
	pistolCrate:Activate()

	-- Spawn in smg ammo crates
	local smgCrate = ents.Create( "item_ammo_crate" )
	smgCrate:SetPos( Vector( -64, -387, 16 ) )
	smgCrate:SetAngles( Angle( 0, 89, 0 ) )
	smgCrate:SetKeyValue( "AmmoType", "1" )
	smgCrate:Spawn()
	smgCrate:Activate()

	local smgCrate = ents.Create( "item_ammo_crate" )
	smgCrate:SetPos( Vector( -536, -442, 152 ) )
	smgCrate:SetAngles( Angle( 0, 90, 0 ) )
	smgCrate:SetKeyValue( "AmmoType", "1" )
	smgCrate:Spawn()
	smgCrate:Activate()

	-- Spawn in buckshot boxes
	local buckshotBox = ents.Create( "item_box_buckshot" )
	buckshotBox:SetPos( Vector( 62, -216, 142 ) )
	buckshotBox:SetAngles( Angle( 0, -88, 0 ) )
	buckshotBox:Spawn()
	buckshotBox:Activate()
	buckshotBox.isRespawnable = true
	buckshotBox.originalAng = buckshotBox:GetAngles()
	buckshotBox.originalPos = buckshotBox:GetPos()
	buckshotBox.spawnFlags = buckshotBox:GetSpawnFlags()

	local buckshotBox = ents.Create( "item_box_buckshot" )
	buckshotBox:SetPos( Vector( 42, -193, 142 ) )
	buckshotBox:SetAngles( Angle( 0, -88, 0 ) )
	buckshotBox:Spawn()
	buckshotBox:Activate()
	buckshotBox.isRespawnable = true
	buckshotBox.originalAng = buckshotBox:GetAngles()
	buckshotBox.originalPos = buckshotBox:GetPos()
	buckshotBox.spawnFlags = buckshotBox:GetSpawnFlags()

	local buckshotBox = ents.Create( "item_box_buckshot" )
	buckshotBox:SetPos( Vector( 30, -220, 142 ) )
	buckshotBox:SetAngles( Angle( 0, -88, 0 ) )
	buckshotBox:Spawn()
	buckshotBox:Activate()
	buckshotBox.isRespawnable = true
	buckshotBox.originalAng = buckshotBox:GetAngles()
	buckshotBox.originalPos = buckshotBox:GetPos()
	buckshotBox.spawnFlags = buckshotBox:GetSpawnFlags()

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
