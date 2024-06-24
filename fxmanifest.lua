fx_version 'cerulean'

game 'gta5'

author 'Xdmister'

lua54 'on'


shared_script {'@es_extended/imports.lua','@ox_lib/init.lua',}

client_script {
    'client/*',
}
server_script { 
    '@oxmysql/lib/MySQL.lua',
    'server/*',
}

dependency 'es_extended'

ui_page 'html/index.html'

files { 
    'html/index.html',
    'html/styles/*',
    'html/js/*',
    'html/configs/*',
    'configs/*',
    'html/customimgs/*',
    'html/imgs/*',
    'langues/*'
}