wheels = {
    ["wheel_lf"] = 0,
    ["wheel_rf"] = 1,
    ["wheel_rr"] = 5,
    ["wheel_lr"] = 4,
}

function DeployStinger()
    local stinger = CreateObject(LoadModel("p_ld_stinger_s").model, GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 2.0, 0.0), true, true, 0)
    SetEntityAsMissionEntity(stinger, true, true)
    SetEntityHeading(stinger, GetEntityHeading(PlayerPedId()))
    FreezeEntityPosition(stinger, true)
    PlaceObjectOnGroundProperly(stinger)
    SetEntityVisible(stinger, false)

    -- init scene
    local scene = NetworkCreateSynchronisedScene(GetEntityCoords(PlayerPedId()), GetEntityRotation(PlayerPedId(), 2), 2, false, false, 1065353216, 0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, LoadDict("amb@medic@standing@kneel@enter"), "enter", 8.0, -8.0, 3341, 16, 1148846080, 0)
    NetworkStartSynchronisedScene(scene)
    -- wait for the scene to start
    while not IsSynchronizedSceneRunning(NetworkConvertSynchronisedSceneToSynchronizedScene(scene)) do
        Wait(0)
    end
    -- make the scene faster (looks better)
    SetSynchronizedSceneRate(NetworkConvertSynchronisedSceneToSynchronizedScene(scene), 3.0)
    -- wait a bit
    while GetSynchronizedScenePhase(NetworkConvertSynchronisedSceneToSynchronizedScene(scene)) < 0.14 do
        Wait(0)
    end
    -- stop the scene early
    NetworkStopSynchronisedScene(scene)

    -- play deploy animation for stinger
    PlayEntityAnim(stinger, "P_Stinger_S_Deploy", LoadDict("p_ld_stinger_s"), 1000.0, false, true, 0, 0.0, 0)
    while not IsEntityPlayingAnim(stinger, "p_ld_stinger_s", "P_Stinger_S_Deploy", 3) do
        Wait(0)
    end
    SetEntityVisible(stinger, true)
    while IsEntityPlayingAnim(stinger, "p_ld_stinger_s", "P_Stinger_S_Deploy", 3) and GetEntityAnimCurrentTime(stinger, "p_ld_stinger_s", "P_Stinger_S_Deploy") <= 0.99 do
        Wait(0)
    end
    PlayEntityAnim(stinger, "p_stinger_s_idle_deployed", LoadDict("p_ld_stinger_s"), 1000.0, false, true, 0, 0.99, 0)

    return stinger
end

RegisterNetEvent("loaf_spikestrips:placeSpikestrip")
AddEventHandler("loaf_spikestrips:placeSpikestrip", function()
    DeployStinger()
end)

function RemoveStinger()
    if DoesEntityExist(closestStinger) then
        NetworkRequestControlOfEntity(closestStinger)
        SetEntityAsMissionEntity(closestStinger, true, true)
        DeleteEntity(closestStinger)

        Wait(250)
        if not DoesEntityExist(closestStinger) then
            TriggerServerEvent("loaf_spikestrips:removedSpike")
        end
    end
end

RegisterNetEvent("loaf_spikestrips:removeSpikestrip")
AddEventHandler("loaf_spikestrips:removeSpikestrip", function()
    RemoveStinger()
end)

function TouchingStinger(coords, stinger)
    local min, max = GetModelDimensions(GetEntityModel(stinger))
    local size = max - min
    local w, l, h = size.x, size.y, size.z

    local offset1 = GetOffsetFromEntityInWorldCoords(stinger, 0.0, l/2, h*-1)
    local offset2 = GetOffsetFromEntityInWorldCoords(stinger, 0.0, l/2 * -1, h)

    return IsPointInAngledArea(coords, offset1, offset2, w*2, 0, false)
end

function LoadDict(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end

    return Dict
end

function LoadModel(model)
    model = type(model) == "string" and GetHashKey(model) or model

    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        local timer = GetGameTimer() + 20000 -- 20 seconds to load
        RequestModel(model)
        while not HasModelLoaded(model) and timer >= GetGameTimer() do -- wait for the model to load
            Wait(50)
        end
    end

    return {loaded = HasModelLoaded(model), model = model}
end

function HelpText(text, sound)
    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(0, 0, (sound == true), -1)
end