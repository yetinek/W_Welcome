shared_script '@waitrp_shield2/ai_module_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
}

client_scripts {
	'config.lua',
	'client.lua'
}

server_scripts {
	'config.lua',
	'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
	'html/*.svg',
	'html/sound/*.wav',
}