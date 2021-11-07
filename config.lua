Config = {
    JobBased = {
        Enabled = true,
        ESX = false, -- if enabled but esx is false, it will use the server file to check if someone is a police officer (you can edit who is police there)
        PoliceJobs = { -- ESX police jobs
            "police",
        },
    },

    DebugLine = false, -- draw a line above stingers? (useful for finding offest1 & offset 2)
    -- DebugLine looks like this: https://gyazo.com/08396daae87d3a0aab87b31a3cb2c0c4
    Stingers = {
        {
            object = "p_ld_stinger_s",
            offset1 = vector3(0.0, -1.75, -0.5),
            offset2 = vector3(0.0, 1.8, 1.5),
        }
    },
}

Strings = {
    ["remove_stinger"] = "~INPUT_CONTEXT~ ~r~Remove ~s~stinger",
    ["not_police"] = "You are not a police officer and can therefore not spawn spikestrips.",
}