local atm_models = {`prop_fleeca_atm`, `prop_atm_01`, `prop_atm_02`, `prop_atm_03`}
local player = PlayerPedId()
local pv3, enemyv3, near = false, false, 0
local mugger = false
local hour = GetClockHours()

Citizen.CreateThread(function()
	player = PlayerPedId()

	while true do
		Wait(1000)

		if mugger and IsPedDeadOrDying(mugger) then
			mugger = false
		end

		local hour = GetClockHours()
		if IsPedOnFoot(player) and (hour > 22 or hour < 4) then
			pv3 = GetEntityCoords(player)
			near = 0

			for i = 1, #atm_models do
				if near == 0 then
					near = GetClosestObjectOfType(pv3.x, pv3.y, pv3.z, 2.0, atm_models[i])
				end
			end

			if(near ~= 0 and (math.random(100) <= Config.mugging_chance) and not mugger) then
				enemyv3 = get_spawn_point_near_player(pv3)
				mugger = create_atm_mugger(0x6A8F1F9B, enemyv3)
			end
			Wait(30000)
		end
	end
end)

function get_spawn_point_near_player(playerV3)
	local enemyv3 ={x = pv3.x + 3, y = pv3.y + 3, z = pv3.z}
	if not GetGroundZFor_3dCoord(enemyv3.x, enemyv3.y, enemyv3.z, enemyv3.z, true) then
		enemyv3 = {x = pv3.x - 3, y = pv3.y -3, z = pv3.z}
	end
	if not GetGroundZFor_3dCoord(enemyv3.x, enemyv3.y, enemyv3.z, enemyv3.z, true) then
		enemyv3 = {x = pv3.x - 3, y = pv3.y, z = pv3.z}
	end
	if not GetGroundZFor_3dCoord(enemyv3.x, enemyv3.y, enemyv3.z, enemyv3.z, true) then
		enemyv3 = {x = pv3.x, y = pv3.y -3, z = pv3.z}
	end
	if not GetGroundZFor_3dCoord(enemyv3.x, enemyv3.y, enemyv3.z, enemyv3.z, true) then
		enemyv3 = {x = pv3.x, y = pv3.y +3, z = pv3.z}
	end
	if not GetGroundZFor_3dCoord(enemyv3.x, enemyv3.y, enemyv3.z, enemyv3.z, true) then
		enemyv3 = {x = pv3.x + 3, y = pv3.y, z = pv3.z}
	end
	return enemyv3
end

function create_atm_mugger(hash, coords)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(1)
	end

	local hostile = CreatePed(1, hash, coords.x, coords.y, coords.z, 60, true, true)
	if Config.armed_mugger then GiveWeaponToPed(hostile, `weapon_knife`) end
	TaskCombatPed(hostile, PlayerPedId(), 0, 16)
	return hostile
end