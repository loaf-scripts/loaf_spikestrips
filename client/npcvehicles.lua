if Config.NPCVehicles then
    local function GetSpikestrips(coords, distance)
        local stingers = {}
        local handle, stinger, found = FindFirstObject()
        local model = GetHashKey("p_ld_stinger_s")
        if DoesEntityExist(stinger) and GetEntityModel(stinger) == model and (not coords or #(GetEntityCoords(stinger) - coords) <= (distance or 50.0)) then
            table.insert(stingers, stinger)
        end
        
        repeat
            found, stinger = FindNextObject(handle)
            if DoesEntityExist(stinger) and GetEntityModel(stinger) == model and (not coords or #(GetEntityCoords(stinger) - coords) <= (distance or 50.0)) then
                table.insert(stingers, stinger)
            end
        until not found
    
        EndFindObject(handle)
        return stingers
    end

    local stingers = {}

    CreateThread(function()
        while true do
            collectgarbage()
            stingers = GetSpikestrips(GetEntityCoords(PlayerPedId()))
            Wait(1500)
        end
    end)

    CreateThread(function()
        while true do
            for flag = 1, 2 do
                flag = flag == 1 and 70 or 127
                for i, stinger in pairs(stingers) do
                    local stingerCoords = GetEntityCoords(stinger)
                    local closestVehicle = GetClosestVehicle(stingerCoords, 25.0, 0, flag)
                    if DoesEntityExist(closestVehicle) and IsEntityTouchingEntity(closestVehicle, stinger) then
                        for boneName, wheelId in pairs(wheels) do
                            if not IsVehicleTyreBurst(closestVehicle, wheelId, false) then
                                if TouchingStinger(GetWorldPositionOfEntityBone(closestVehicle, GetEntityBoneIndexByName(closestVehicle, boneName)), stinger) then
                                    SetVehicleTyreBurst(closestVehicle, wheelId, 1, 1148846080)
                                end
                            end
                        end
                    end
                end
            end

            -- higher wait = tyres won't burst, lower wait = worse performance
            Wait(5)
        end
    end)
end