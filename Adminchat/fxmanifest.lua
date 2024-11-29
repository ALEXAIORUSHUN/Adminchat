fx_version 'cerulean'
game 'gta5'

author 'ALEXAIORUS'
description 'Adminchat'
version '1.0.0'

server_scripts {
    '@es_extended/locale.lua', -- ESX használata esetén
    'server.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}