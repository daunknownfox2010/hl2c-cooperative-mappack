RESET_PL_INFO = true

INFO_PLAYER_SPAWN = { Vector( 64, -15040, -15812 ), 90 }

NEXT_MAP = "coop_epicycle_v4"	-- Change this for your server

NEXT_MAP_TIME = 10


-- Player spawns
function HL2C_PlayerSpawn( ply )

	-- Update Gamemode Name on client
	ply:SendLua( "GAMEMODE.Name = \"[HL2C] Co-operative\"" )

	-- Update next map time on client
	ply:SendLua( "NEXT_MAP_TIME = 10" )

	-- Remove vortigaunts from godlike npcs on player
	ply:SendLua( "table.RemoveByValue( GODLIKE_NPCS, \"npc_vortigaunt\" )" )

	-- Weapons
	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_357" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_ar2" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_crossbow" )
	ply:Give( "weapon_rpg" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_medkit" )

	-- Ammo
	ply:GiveAmmo( 160, game.GetAmmoID( "Pistol" ) )
	ply:GiveAmmo( 20, game.GetAmmoID( "357" ) )
	ply:GiveAmmo( 225, game.GetAmmoID( "SMG1" ) )
	ply:GiveAmmo( 3, game.GetAmmoID( "SMG1_Grenade" ) )
	ply:GiveAmmo( 130, game.GetAmmoID( "AR2" ) )
	ply:GiveAmmo( 3, game.GetAmmoID( "AR2AltFire" ) )
	ply:GiveAmmo( 40, game.GetAmmoID( "Buckshot" ) )
	ply:GiveAmmo( 6, game.GetAmmoID( "XBowBolt" ) )

end
hook.Add( "PlayerSpawn", "HL2C_PlayerSpawn", HL2C_PlayerSpawn )


-- Initialize entities
function HL2C_InitPostEntity()

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

	-- Remove point_servercommand entities
	for _, ent in pairs( ents.FindByClass( "point_servercommand" ) ) do
	
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

	-- Remove makerebel
	for _, ent in pairs( ents.FindByName( "makerebel" ) ) do
	
		ent:Remove()
	
	end

	-- Remove client
	for _, ent in pairs( ents.FindByName( "client" ) ) do
	
		ent:Remove()
	
	end

	-- Add relationship timer
	local relationshipTimer = ents.Create( "logic_timer" )
	relationshipTimer:SetPos( Vector( 94.4048, -10433, -12023 ) )
	relationshipTimer:SetKeyValue( "RefireTime", "5" )
	relationshipTimer:SetKeyValue( "OnTimer", "hate,ApplyRelationship,,0,-1" )
	relationshipTimer:Spawn()
	relationshipTimer:Activate()

end
hook.Add( "InitPostEntity", "HL2C_InitPostEntity", HL2C_InitPostEntity )


-- Accept entity input
function HL2C_AcceptInput( ent, input )

	-- Game end will end the game
	if ( ent:GetClass() == "game_end" && ( string.lower( input ) == "endgame" ) ) then
	
		GAMEMODE:NextMap()
	
	end

end
hook.Add( "AcceptInput", "HL2C_AcceptInput", HL2C_AcceptInput )
