fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Loaf Scripts"
description "Spike strip script that only bursts the touching tires."

version "2.1.0"

shared_scripts {
	"@ox_lib/init.lua",
	"config.lua",
	"locales/*.lua",
	"shared/**/*.lua"
}

server_script "server/**/*.lua"
client_script "client/**/*.lua"

file {
	"sounds/dlc_stinger/stinger.awc",
	"sounds/data/stinger.dat54.rel"
}

data_file "AUDIO_WAVEPACK" "sounds/dlc_stinger"
data_file "AUDIO_SOUNDDATA" "sounds/data/stinger.dat"

dependency "ox_lib"
