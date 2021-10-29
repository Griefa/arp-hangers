fx_version 'cerulean'
game 'gta5'

description 'An Airport Garage script for QB'
version '1.0.0'

shared_scripts { 
	'@arp-core/import.lua',
	'config.lua'
}

server_scripts {
	'server/main.lua',
}

client_scripts {
    'client/main.lua',
    'client/garage.lua',
    'client/gui.lua',
}