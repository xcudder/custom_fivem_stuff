fx_version 'adamant'

game 'gta5'

description 'Small Customizations'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua',
}

client_scripts {
	'client/boosts.lua',
	'client/cayo.lua',
	'client/commands.lua',
	'client/mugger.lua',
	'client/timing.lua',
	'client/missions/missions_config.lua',
	'client/missions/general_functions.lua',
	'client/missions/ped_spawn_functions.lua',
	'client/missions/missions.lua',
}

dependencies {
    'es_extended',
}