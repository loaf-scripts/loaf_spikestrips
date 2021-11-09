local QBCore, ESX
if Config.Framework == "esx" then
    TriggerEvent("esx:getSharedObject", function(object)
        ESX = object
    end)
elseif Config.Framework == "qb" then
    QBCore = exports["qb-core"]:GetCoreObject()
end

local police = {
    "steam:11000010ded0daa"
}

local function IsPolice(identifier)
    for _, policeIdent in pairs(police) do
        if policeIdent == identifier then
            return true
        end
    end
    return false
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

if Config.Framework == "esx" or Config.Framework == "qb" then
    if Config.FrameworkFeatures.Item then
        if Config.Framework == "esx" then
            ESX.RegisterUsableItem(Config.FrameworkFeatures.Item, function(src)
                local xPlayer = ESX.GetPlayerFromId(src)
                xPlayer.removeInventoryItem(Config.FrameworkFeatures.Item, 1)
                TriggerClientEvent("loaf_spikestrips:placeSpikestrip", src)
            end)
        elseif Config.Framework == "qb" then
            QBCore.Functions.CreateUseableItem(Config.FrameworkFeatures.Item, function(src)
                local xPlayer = QBCore.Functions.GetPlayer(src)
                xPlayer.Functions.RemoveItem(Config.FrameworkFeatures.Item, 1)
                TriggerClientEvent("loaf_spikestrips:placeSpikestrip", src)
            end)
        end

        if Config.FrameworkFeatures.ReceiveRemove then
            -- WARNING: THIS EVENT CAN BE ABUSED TO GET FREE SPIKESTRIPS
            RegisterNetEvent("loaf_spikestrips:removedSpike")
            AddEventHandler("loaf_spikestrips:removedSpike", function()
                local src, xPlayer = source
                if Config.Framework == "esx" then
                    xPlayer = ESX.GetPlayerFromId(src)
                elseif Config.Framework == "qb" then
                    xPlayer = QBCore.Functions.GetPlayer(src)
                end

                if xPlayer then
                    local isPolice = false
                    for _, job in pairs(Config.FrameworkFeatures.PoliceJobs) do
                        if (Config.Framework == "esx" and xPlayer.job.name == job) or (Config.Framework == "qb" and xPlayer.PlayerData.job.name == job) then
                            isPolice = true
                            break
                        end
                    end
                    
                    if isPolice or not Config.RequireJobRemove then
                        if not isPolice or (isPolice and Config.FrameworkFeatures.ReceiveJob) then
                            if Config.Framework == "esx" then
                                local itemdata = xPlayer.getInventoryItem(Config.FrameworkFeatures.Item)
                                if xPlayer.canCarryItem and xPlayer.canCarryItem(Config.FrameworkFeatures.Item, 1) then
                                    xPlayer.addInventoryItem(Config.FrameworkFeatures.Item, 1)
                                elseif not xPlayer.canCarryItem and (itemdata.limit == -1 or (itemdata.count + 1) <= itemdata.limit) then
                                    xPlayer.addInventoryItem(Config.FrameworkFeatures.Item, 1)
                                else
                                    TriggerClientEvent("esx:showNotification", src, Strings["cant_carry"])
                                end
                            elseif Config.Framework == "qb" then
                                xPlayer.Functions.AddItem(Config.FrameworkFeatures.Item, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end