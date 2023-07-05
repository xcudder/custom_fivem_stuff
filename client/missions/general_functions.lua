function SMS_Message(NotiPic, SenderName, Subject, MessageText, PlaySound)
	if not NotiPic then NotiPic = 'CHAR_SOCIAL_CLUB' end
	if not SenderName then SenderName = 'Corporate Ent' end
	if not Subject then Subject = 'TEST' end
	if not MessageText then MessageText = 'This is a test sms, hope it works' end

	RequestStreamedTextureDict(NotiPic,1)
	while not HasStreamedTextureDictLoaded(NotiPic)  do
		Wait(1)
	end

   	Citizen.InvokeNative(0x202709F4C58A0424,"STRING")
   	AddTextComponentString(MessageText)
   	Citizen.InvokeNative(0x92F0DA1E27DB96DC,140)
   	Citizen.InvokeNative(0x1CCD9A37359072CF,NotiPic, NotiPic, true, 4, SenderName, Subject, MessageText)
  	Citizen.InvokeNative(0xAA295B6F28BD587D,false, true)
	if PlaySound then
		PlaySoundFrontend(GetSoundId(), "Text_Arrive_Tone", "Phone_SoundSet_Default", true)
	end
end

function entities_close_enough(first_entity, second_entity, overwrite_radius)
	if not overwrite_radius then overwrite_radius = 1.5 end
	local A = GetEntityCoords(first_entity, false)
	local B = GetEntityCoords(second_entity, false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end

function entity_close_to_coord(entity, coords, overwrite_radius)
	if not overwrite_radius then overwrite_radius = 1.5 end
	local A = coords
	local B = GetEntityCoords(entity, false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end

function setupBlip(info)
	info.blip = AddBlipForCoord(info.v3.x, info.v3.y, info.v3.z)
	SetBlipSprite(info.blip, info.id)
	SetBlipDisplay(info.blip, 2)
	SetBlipScale(info.blip, 0.9)
	SetBlipColour(info.blip, info.colour)
	SetBlipAsShortRange(info.blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(info.title)
	EndTextCommandSetBlipName(info.blip)
	return info.blip
end

function missionText(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end