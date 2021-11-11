Config = {
    Debugging = false,

    -- video: https://gyazo.com/8f713a51b2fd2a1e2faa7735e2cc1921
    NPCVehicles = false, -- should the script burst tyres of npcs vehicles? (NOTE: PERFORMANCE HEAVY FOR THE CLIENTS!  ~0.03 - 0.20 ms)
    
    Framework = "none", --[[ What framework to use
        Valid options:
            * "qb" (qb-core)
            * "esx" (ESX)
            * "none" (Standalone)
    ]]

    RequireJobPlace = true, -- require job to place a spike strip?
    RequireJobRemove = false, -- should everyone be able to remove a spikestrip, or just people with job allowed to place spikestrips?
    
    Menu = {
        Enabled = true, -- TriggerEvent("loaf_spikestrips:spikestripMenu") to open the menu
        Command = "spikestrip", -- set to false to disable
        Keybind = "F5", -- set to false to disable (NOTE: COMMAND CAN'T BE FALSE IF YOU WANT A KEYBIND)
    },
    
    FrameworkFeatures = { -- these features are only if you use Config.Framework "esx" or "qb"
        Item = "spikestrip", -- item to deploy a spikestrip (set to false if you don't want to have this enabled)
        ReceiveRemove = true, -- receive spikestrip item if you remove a spikestrip?
        ReceiveJob = true, -- false = police won't receive a spikestrip when they remove it | true = police will receive a spikestrip item when they remove a spikestrip
        
        UseWarmenu = false, -- false = default esx menu, true = use warmenu (looks like gta:o)
        PoliceJobs = { -- police jobs
            "police",
            "sheriff",
        },
    },
}

Strings = {
    ["remove_stinger"] = "~INPUT_CONTEXT~ ~r~Remove ~s~spikestrip",
    ["not_police"] = "You are not a police officer and can therefore not access this menu.",

    ["menu_label"] = "Spikestrip menu",
    ["menu_sublabel"] = "By Loaf Scripts#7785",
    ["place_spikestrip"] = "Place a spikestrip",
    ["remove_spikestrip"] = "Remove closest spikestrip",
    ["close_menu"] = "Close menu",

    ["cant_carry"] = "Your inventory is full, you did not receive a spikestrip.",
}