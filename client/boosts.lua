local SleepinessPercentage, freshSleepinessPercentage = 0, false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local isinvehicle = IsPedInAnyVehicle(PlayerPedId())
		local vehiclemodel = GetEntityModel(GetVehiclePedIsIn(PlayerPedId()))
		local isabike = IsThisModelABike(vehiclemodel)
		if SleepinessPercentage < 40 and ( (not isinvehicle) or isabike) then 
			SetPedMoveRateOverride(PlayerPedId(), 2.0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(3000)
		freshSleepinessPercentage = false
		TriggerEvent('esx_status:getStatus', 'sleepiness', function(status) freshSleepinessPercentage = status.getPercent() end)
		while not freshSleepinessPercentage do Wait(100) end
		SleepinessPercentage = freshSleepinessPercentage
	end
end)

