fx_version 'cerulean'
game        'gta5'
lua54       'yes'
author      'zozoman'


shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page {
    'nui/ui.html'

}

files {
    'nui/ui.html',
    'nui/style.css',
    'nui/script.js'
}