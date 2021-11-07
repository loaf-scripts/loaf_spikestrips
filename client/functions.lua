function DeployStinger()
    local stinger = CreateObject(LoadModel(Config.Stingers[1].object).model, GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 2.0, 0.0), true, true, 0)
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
    SetEntityVisible(stinger, true)
    PlayEntityAnim(stinger, "P_Stinger_S_Deploy", LoadDict("p_ld_stinger_s"), 1000.0, false, true, 0, 0.0, 0)
    while not IsEntityPlayingAnim(stinger, "p_ld_stinger_s", "P_Stinger_S_Deploy", 3) do
        Wait(0)
    end
    while IsEntityPlayingAnim(stinger, "p_ld_stinger_s", "P_Stinger_S_Deploy", 3) and GetEntityAnimCurrentTime(stinger, "p_ld_stinger_s", "P_Stinger_S_Deploy") <= 0.99 do
        Wait(0)
    end
    PlayEntityAnim(stinger, "p_stinger_s_idle_deployed", LoadDict("p_ld_stinger_s"), 1000.0, false, true, 0, 0.99, 0)

    return stinger
end

function LoadDict(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end

    return Dict
end

function LoadModel(model)
    if type(model) == "string" then 
        model = GetHashKey(model) 
    elseif type(model) ~= "number" then
        return {loaded = false, model = model} 
    end

    local timer = GetGameTimer() + 20000 -- 20 seconds to load
    if not HasModelLoaded(model) and IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) and timer >= GetGameTimer() do -- give it time to load
            Wait(50)
        end
    end

    if HasModelLoaded(model) then
        return {loaded = true, model = model}
    else
        return {loaded = false, model = model}
    end
end

function HelpText(text, sound)
    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(0, 0, (sound == true), -1)
end