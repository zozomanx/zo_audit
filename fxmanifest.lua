fx_version 'cerulean'
game        'gta5'
lua54       'yes'
author      'zozoman'
description 'An audit script for FIB/CID/DoJ to audit the finances of a person'


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
    'nui/script.js',
    'nui/img/*.*'
}