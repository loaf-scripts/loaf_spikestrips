local police = {
    "steam:11000010ded0daa"
}

local function IsPolice(identifier)
    for _, policeIdent in pairs(police) do
        if policeIdent == identifier then
            return true
        end
    end
end

RegisterNetEvent("loaf_spikestrips:checkPolice")
AddEventHandler("loaf_spikestrips:checkPolice", function()
    local src = source

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if IsPolice(v) then
            TriggerClientEvent("loaf_spikestrips:setPolice", src)
            break
        end
    end
end)

if Config.ESX then
    TriggerEvent("esx:getSharedObject", function(ESX) 
        if Config.ESXFeatures.Item then
            ESX.RegisterUsableItem(Config.ESXFeatures.Item, function(src)
                local xPlayer = ESX.GetPlayerFromId(src)
                xPlayer.removeInventoryItem(Config.ESXFeatures.Item, 1)
                TriggerClientEvent("loaf_spikestrips:placeSpikestrip", src)
            end)

            if Config.ESXFeatures.ReceiveRemove then
                -- WARNING: THIS EVENT CAN BE ABUSED TO GET FREE SPIKESTRIPS
                RegisterNetEvent("loaf_spikestrips:removedSpike")
                AddEventHandler("loaf_spikestrips:removedSpike", function()
                    local xPlayer = ESX.GetPlayerFromId(source)
                    if xPlayer then
                        local isPolice = false
                        for _, job in pairs(Config.ESXFeatures.PoliceJobs) do
                            if xPlayer.job.name == job then
                                isPolice = true
                                break
                            end
                        end
                        
                        if isPolice or not Config.RequireJobRemove then
                            if not isPolice or (isPolice and Config.ESXFeatures.ReceiveJob) then 
                                xPlayer.addInventoryItem(Config.ESXFeatures.Item, 1)
                            end
                        end
                    end
                end)
            end
        end
    end)
end