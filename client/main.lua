local isPolice = false

RegisterNetEvent("loaf_stingers:setPolice")
AddEventHandler("loaf_stingers:setPolice", function()
    isPolice = true
end)

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(500)
    end

    if Config.JobBased.Enabled then
        if Config.JobBased.ESX then
            local ESX 
            while not ESX do
                Wait(500)
                TriggerEvent("esx:getSharedObject", function(esx)
                    ESX = esx
                end)
            end
        
            while not ESX.GetPlayerData() or not ESX.GetPlayerData().job or not ESX.GetPlayerData().job.name do
                Wait(500)
            end

            RegisterNetEvent("esx:setJob")
            AddEventHandler("esx:setJob", function(jobData)
                local jobName = jobData.name
                isPolice = false
                for _, job in pairs(Config.JobBased.PoliceJobs) do
                    if job == jobName then
                        isPolice = true
                        break
                    end
                end
            end)
            
            local jobName = ESX.GetPlayerData().job.name
            for _, job in pairs(Config.JobBased.PoliceJobs) do
                if job == jobName then
                    isPolice = true
                    break
                end
            end
        else
            TriggerServerEvent("loaf_stingers:checkPolice")
        end
    else
        isPolice = true
    end

    if Config.DebugLine then
        CreateThread(function()
            while true do
                Wait(500)

                for k, v in pairs(Config.Stingers) do
                    local stinger = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(v.object), false, false, false)
                    if DoesEntityExist(stinger) then
                        local leftOffset, rightOffset = GetOffsetFromEntityInWorldCoords(stinger, v.offset1), GetOffsetFromEntityInWorldCoords(stinger, v.offset2)
                        while #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(stinger)) <= 5.0 do
                            Wait(0)
                            DrawLine(vector3(leftOffset.x, leftOffset.y, GetEntityCoords(stinger).z+0.2), vector3(rightOffset.x, rightOffset.y, GetEntityCoords(stinger).z+0.2), 255, 0, 0, 255)
                        end
                    end
                end
            end
        end)
    end

    -- This loop allows you to remove stingers.
    CreateThread(function()
        while true do
            Wait(500)
            if isPolice and IsPedOnFoot(PlayerPedId()) then
                for k, v in pairs(Config.Stingers) do
                    local stinger = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, GetHashKey(v.object), false, false, false)
                    while isPolice and DoesEntityExist(stinger) and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(stinger)) <= 5.0 and IsPedOnFoot(PlayerPedId()) do
                        Wait(0)
                        HelpText(Strings["remove_stinger"], true)
                        if IsControlJustReleased(0, 51) then
                            NetworkRequestControlOfEntity(stinger)
                            SetEntityAsMissionEntity(stinger, true, true)
                            DeleteEntity(stinger)
                        end
                    end
                end
            end
        end
    end)

    -- This while loop manages bursting tyres.
    CreateThread(function()
        while true do
            Wait(1500)
            while DoesEntityExist(GetVehiclePedIsUsing(PlayerPedId())) do
                Wait(50)
                local vehicle = GetVehiclePedIsUsing(PlayerPedId())
                for k, v in pairs(Config.Stingers) do
                    local stinger = GetClosestObjectOfType(GetEntityCoords(vehicle), 5.0, GetHashKey(v.object), false, false, false)
                    local leftOffset, rightOffset = GetOffsetFromEntityInWorldCoords(stinger, v.offset1), GetOffsetFromEntityInWorldCoords(stinger, v.offset2)
                    while DoesEntityExist(stinger) and #(GetEntityCoords(vehicle) - GetEntityCoords(stinger)) <= 5.0 do
                        Wait(25)
                        local wheels = {
                            lf = {
                                coordinates = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lf")),
                                wheelId = 0
                            },
                            rf = {
                                coordinates = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rf")),
                                wheelId = 1
                            },
                            rr = {
                                coordinates = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_rr")),
                                wheelId = 5
                            },
                            lr = {
                                coordinates = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "wheel_lr")),
                                wheelId = 4
                            },
                        }
                        for k, v in pairs(wheels) do
                            if not IsVehicleTyreBurst(vehicle, v.wheelId, false) then
                                if IsPointInAngledArea(v.coordinates, leftOffset, rightOffset, 0.8, 0, true) then
                                    SetVehicleTyreBurst(vehicle, v.wheelId, 1, 1148846080)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)

RegisterCommand("stinger", function()
    if isPolice then
        DeployStinger()
    else
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            args = {"[Spikestrips]", Strings["not_police"]}
        })
    end
end)