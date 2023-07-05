local h = 6
local m = 0
local s = 0

local gta_seconds_per_real_second = 30
local loopwhole = 1000 / gta_seconds_per_real_second
local looptime = loopwhole % 1 >= 0.5 and math.ceil(loopwhole) or math.floor(loopwhole)

Citizen.CreateThread(function()
	local time = MySQL.query.await('SELECT * FROM time')
	time = time[1]

	h = time.h
	m = time.m
	s = time.s

	print('Booted with ingame time pulled from DB: ' .. json.encode(time))

	local timer = 0
	while true do
		Citizen.Wait(looptime)
		timer = timer + 1
		s = s + 1
		
		if s >= 60 then
			s = 0
			m = m + 1
		end
		
		if m >= 60 then
			m = 0
			h = h + 1
		end
		
		if h >= 24 then
			h = 0
		end
		
		if timer >= 60 * gta_seconds_per_real_second then
			timer = 0
			TriggerClientEvent("gametime:serversync", -1, h, m, s, gta_seconds_per_real_second)
		end
	end
end)

RegisterServerEvent("gametime:requesttime")
AddEventHandler("gametime:requesttime", function()
	TriggerClientEvent("gametime:serversync", -1, h, m, s, gta_seconds_per_real_second)
end)

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function(playerId, cb)
	print('Player logged out, saving new time to DB (h, m): ' .. h .. ', ' .. m)
	MySQL.update('UPDATE time SET h = @h, m = @m, s = 0', { ['@h'] = h, ['@m'] = m })
end)

RegisterCommand("teleport", function(source, a)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setCoords(vector3(tonumber(a[1]), tonumber(a[2]), tonumber(a[3])))
end, true)