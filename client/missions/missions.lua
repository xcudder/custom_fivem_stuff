
local _hg, hostile_group = AddRelationshipGroup('b_ops_kidnappers')
local _vg, victim_group = AddRelationshipGroup('kidnapped')

local victim = false
local hostiles = {}
local dead_hostiles = {}
local hostage_blip = false
local safezone_blip = false
local is_hostage_following = false
local safe_point = false

function run_mission()
	local M = MISSIONS[math.random(#MISSIONS)]

	SMS_Message(M.sms.char, M.sms.sender, M.sms.subject, M.sms.message, true)
	safe_point = M.rescue.v3
	hostage_blip = setupBlip({ title="Hostage", colour=77, id=480, v3=M.victim.v3 })
	safezone_blip = setupBlip({ title="Safe Zone", colour=5, id=181, v3=safe_point })

	victim = create_victim(M.victim.hash, M.victim.v3, M.victim.heading, M.rescue.v3)
	SetPedRelationshipGroupHash(victim, victim_group)
	SetRelationshipBetweenGroups(1, victim_group, GetHashKey("HATES_PLAYER"))
	SetRelationshipBetweenGroups(1, victim_group, GetHashKey("PLAYER"))

	for i = 1, #M.enemies do
		hostiles[i] = create_unaware_hostile(M.enemies[i].hash, M.enemies[i].v3, M.enemies[i].heading)
		SetPedAsGroupMember(hostiles[i], hostile_group)
		SetPedRelationshipGroupDefaultHash(hostiles[i], hostile_group)
		SetPedRelationshipGroupHash(hostiles[i], hostile_group)
	end

	spawn_control_threads()
end

function spawn_control_threads()
	-- hostile control
	Citizen.CreateThread(function()
		while not (#hostiles == #dead_hostiles) do
			Wait(1000)
			for i = 1, #hostiles do
				if IsPedDeadOrDying(hostiles[i]) then
					dead_hostiles[i] = hostiles[i]
				elseif HasEntityClearLosToEntity(hostiles[i], PlayerPedId()) then
					if HasEntityClearLosToEntityInFront(hostiles[i], PlayerPedId()) or (GetPedAlertness(hostiles[i]) > 2) or CanPedHearPlayer(PlayerPedId(), hostiles[i]) then
						TaskCombatPed(hostiles[i], PlayerPedId(), 0, 16)
						break
					end
				end
			end
		end
	end)

	-- mission info control (frame by frame)
	Citizen.CreateThread(function()
		local hv3 = GetEntityCoords(victim)
		while not IsPedDeadOrDying(victim) do
			Wait(0)
			hv3 = GetEntityCoords(victim)
			SetBlipCoords(hostage_blip, hv3.x, hv3.y, hv3.z)

			if not is_hostage_following then
				missionText("Rescue the ~f~hostage~s~.", 1)
			else
				missionText("Lead the ~f~hostage~s~ to the ~y~safe zone~s~", 1)
			end
		end
	end)

	-- mission status control
	Citizen.CreateThread(function()
		while victim do
			Wait(500)
			if IsPedDeadOrDying(victim) then
				terminate_mission()
				show_message()
			end

			if entity_close_to_coord(victim, safe_point, 5.0) then
				DeletePed(victim)
				terminate_mission(true)
				show_message(true)
			end
		end
	end)

	-- hostage rescue control
	Citizen.CreateThread(function()
		local player_car = GetVehiclePedIsIn(PlayerPedId())
		local victim_car = GetVehiclePedIsIn(victim)
		local entity_to_follow = PlayerPedId()

		while not IsPedDeadOrDying(victim) do
			Wait(500)

			-- pickup hostage
			if entities_close_enough(PlayerPedId(), victim, 1.0) and not is_hostage_following then
				is_hostage_following = true
				ClearPedTasksImmediately(victim)
			end

			-- continuous following logic
			if is_hostage_following then
				player_car = GetVehiclePedIsIn(PlayerPedId())
				victim_car = GetVehiclePedIsIn(victim)

				-- First of all, leave a vehicle the player is not in
				if player_car == 0 and victim_car > 0 then
					TaskLeaveVehicle(victim, victim_car)
					Wait(1500)
				end

				-- Keep close to the player or a vehicle the player entered
				entity_to_follow = player_car
				if entity_to_follow == 0 then entity_to_follow = PlayerPedId() end
				if not entities_close_enough(entity_to_follow, victim, 1.5) then
					TaskGoToEntity(victim, entity_to_follow, -1, 1.2, 11.0, 1073741824.0, 0)
				end

				-- If you're close and the player is in a car, enter
				if player_car > 0 and victim_car == 0 and entities_close_enough(entity_to_follow, victim, 3) then
					EnterVehicleWrapper(victim, player_car)
					Wait(5000)
				end
			end
		end
	end)
end

function terminate_mission()
	if DoesBlipExist(safezone_blip) then RemoveBlip(safezone_blip) end
	if DoesBlipExist(hostage_blip) then RemoveBlip(hostage_blip) end
	DeletePed(victim)
	for i = 1, #hostiles do DeletePed(hostiles[i]) end

	victim = false
	hostiles = {}
	dead_hostiles = {}
	is_hostage_following = false
	safe_point = false
end

RegisterCommand('run_mission', function(source, args)
	run_mission()
end)

function show_message(success)
	local sf = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
	local showSf = true

	local txt = 'Failed'
	if success then txt = 'Success!' end

	while not HasScaleformMovieLoaded(sf) do Citizen.Wait(1000) end
	BeginScaleformMovieMethod(sf, "SHOW_CENTERED_MP_MESSAGE_LARGE")
	PushScaleformMovieMethodParameterString(txt)
  	-- PushScaleformMovieMethodParameterString("Hostage Rescued")
	EndScaleformMovieMethod()
	EndScaleformMovieMethodReturn()

	Citizen.CreateThread(function()
		while showSf do 
			Wait(0)
			DrawScaleformMovieFullscreen(sf, 255, 255, 255, 255)
		end
	end)

	Wait(3000)
	showSf = false
end

--for debug
RegisterCommand('show_message', function(source, args)
	show_message(args[1])
end)