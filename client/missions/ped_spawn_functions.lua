function create_victim(hash, coords, heading, safe_point)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(1)
	end

	local victim = CreatePed(1, hash, (coords.x + 1.0), (coords.y + 1.0), (coords.z + 1.0), GetEntityHeading(PlayerPedId()), true, true)

	if heading then SetEntityHeading(victim, heading) end
	TaskStartScenarioInPlace(victim, "WORLD_HUMAN_BUM_SLUMPED", -1, true)
	SetBlockingOfNonTemporaryEvents(victim, true)
	SetCanAttackFriendly(victim, false, false)
	SetPedCombatMovement(victim, 0)

	return victim
end

function create_unaware_hostile(hash, coords, heading)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(1)
	end

	local hostile = CreatePed(1, hash, (coords.x + 1.0), (coords.y + 1.0), (coords.z + 1.0), GetEntityHeading(player), true, true)
	GiveWeaponToPed(hostile, `weapon_pistol`, 200, true, false)
	SetPedCombatMovement(hostile, 0)
	SetEntityHealth(hostile, 200)
	if heading then SetEntityHeading(hostile, heading) end
	SetPedSeeingRange(hostile, 30.0)
	SetPedHearingRange(hostile, 20.0)
	SetPedVisualFieldPeripheralRange(hostile, 90.0)
	SetPedAsEnemy(hostile)

	return hostile
end

function enterVeh(ped, car)
	Citizen.CreateThread(function()
		if GetVehiclePedIsTryingToEnter(ped) == 0 then
			TaskEnterVehicle(ped, car, 20000, 2, 2.0, 1, 0)
			Wait(20000)
		end
	end)
end

function leaveVeh(ped, car)
	Citizen.CreateThread(function()
		TaskLeaveVehicle(ped, car)
		Wait(3000)
	end)
end
