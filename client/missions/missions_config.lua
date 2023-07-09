MISSIONS = {
	-- Paleto rescue
	{
		sms = {
			char = 'CHAR_HUMANDEFAULT',
			sender = 'UNKOWN',
			subject = 'I Need Your Help',
			message = "You're the ex military right? Electricist? Listen, I need your help..."
		},
		success_sms = {
			char = 'CHAR_HUMANDEFAULT',
			sender = 'UNKOWN',
			subject = 'Thank you!',
			message = "I wired you my thanks! I'm sorry, it's all I have"
		},
		enemies = {
			{hash = 0x106D9A99, v3 = vector3(-467.3274, 6286.3647, 13.60), heading =  238.2483},
			{hash = 0x106D9A99, v3 = vector3(-472.2593, 6283.2133, 13.60), heading =  139.4590},
			{hash = 0x106D9A99, v3 = vector3(-470.1362, 6282.1713, 13.60), heading =  161.3239},
			{hash = 0x106D9A99, v3 = vector3(-472.6549, 6292.7075, 13.60), heading =  332.5000},
		},
		victim = {hash = 0x30830813, v3 = vector3(-471.2439, 6287.5649, 13.71), heading = 51.94},
		rescue = {v3 = vector3(-441.92, 6020.84, 30.49)},
		weapon_drop = {
			v3 = vector3(-681.731873, 5801.789062, 17.316528),
			heading = 148.8043,
			drop_type = 'hostile', 
			hash = 0xE497BBEF,
			weapon = 'WEAPON_PISTOL',
			ammo = 'ammo-9'
		}
	},
}