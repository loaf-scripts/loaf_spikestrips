Config = {
    Debugging = false,

    ESX = false, -- use esx?
    RequireJobRemove = false, -- should everyone be able to remove a spikestrip, or just people with job allowed to use spikestrips?
    
    Menu = {
        Enabled = true, -- TriggerEvent("loaf_spikestrips:spikestripMenu") to open the menu
        Command = "spikestrip", -- set to false to disable
        Keybind = "F5", -- set to false to disable
    },

    JobBased = false, -- require job to place a spike strip?
    
    ESXFeatures = {
        Item = "spikestrip", -- item to deploy a spikestrip (set to false if you don't want to have this enabled)
        ReceiveRemove = true, -- receive spikestrip item if you remove a spikestrip?
        ReceiveJob = false, -- false = police won't receive a spikestrip when they remove it | true = police will receive a spikestrip item when they remove a spikestrip
        
        UseWarmenu = false, -- false = default esx menu, true = use warmenu (looks like gta:o)
        PoliceJobs = { -- ESX police jobs
            "police",
        },
    },
}

Strings = {
    ["remove_stinger"] = "~INPUT_CONTEXT~ ~r~Remove ~s~spikestrip",
    ["not_police"] = "You are not a police officer and can therefore not access this menu.",

    ["menu_label"] = "Spikestrip menu",
    ["menu_sublabel"] = "By Loaf Scripts#7785",
    ["place_spikestrip"] = "Place spikestrip",
    ["remove_spikestrip"] = "Remove closest spikestrip",
    ["select_spikestrip"] = "Spikestrip",
    ["close_menu"] = "Close menu",
    ["back"] = "Back",
}