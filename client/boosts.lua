local SleepinessPercentage, freshSleepinessPercentage = 0, false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	Citizen.CreateThread(function()
		while true do
			Wait(0)
			if SleepinessPercentage < 40 and not IsPedInAnyVehicle(PlayerPedId()) then 
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
end)