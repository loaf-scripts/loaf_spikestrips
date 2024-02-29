---@alias stinger { id: string, netId?: number, entity?: number, coords: vector3, rotation: vector3, minOffset: vector3, maxOffset: vector3, point?: table, blip?: number }

---@type {string: stinger }
local stingers = lib.callback.await("loaf_spikestrips:getSpikestrips")
---@type stinger[]
local nearbyStingers = {}
local nearbyCount = 0
---@type { number: boolean }
local targettableEntities = {}
local bones = Config.Bones
local placing
local stingersTick
local pickupKeyHelp
local currentStinger

local function placeStinger()
	local playerPed = cache.ped
	local offset = GetOffsetFromEntityInWorldCoords(playerPed, -0.2, 2.0, 0.0)
	local heading = GetEntityHeading(playerPed)
	local onFoot = IsPedOnFoot(playerPed)
	local skipAnimation = false
	local stinger
	local netId

	if not onFoot and cache.vehicle then
		local model = GetEntityModel(cache.vehicle)
		local min = model and GetModelDimensions(model) or { y = -2.5 }

		offset = GetOffsetFromEntityInWorldCoords(cache.vehicle, 0.0, min.y, 0.0)
		heading -= 90
		skipAnimation = true
	end

	if not Config.AllowFromVehicle and not onFoot then
		Notify(L("cant_vehicle"), "error")
		return
	end

	if Config.OnlyRoads then
		if not IsPointOnRoad(offset.x, offset.y, offset.z, 0) then
			Notify(L("only_roads"), "error")
			return
		end
	end

	if Config.SpawnMethod == "server" then
		netId = lib.callback.await("loaf_spikestrips:createSpikestrip", false, offset)

		if not netId then
			return
		end

		stinger = WaitForControlAndNetId(netId)
	else
		local allowedPlace = lib.callback.await("loaf_spikestrips:startPlacing")

		if not allowedPlace then
			return
		end
	end

	local playerDict = LoadDict("amb@medic@standing@kneel@enter")
	local stingerDict = LoadDict("p_ld_stinger_s")
	local model = LoadModel(`p_ld_stinger_s`)

	if Config.SpawnMethod == "local" then
		stinger = CreateObject(model, offset.x, offset.y, offset.z, false, false, false)
		placing = stinger
	elseif Config.SpawnMethod == "networked" then
		stinger = CreateObject(model, offset.x, offset.y, offset.z, true, true, false)
		netId = NetworkGetNetworkIdFromEntity(stinger)
	end

	FreezeEntityPosition(stinger, true)
	SetEntityVisible(stinger, false, false)
	SetEntityCoordsNoOffset(stinger, offset.x, offset.y, offset.z, true, true, true)
	SetEntityHeading(stinger, heading)
	PlaceObjectOnGroundProperly(stinger)

	local coords = GetEntityCoords(stinger)
	local minOffset = GetOffsetFromEntityInWorldCoords(stinger, 0.0, -1.84, -0.1)
	local maxOffset = GetOffsetFromEntityInWorldCoords(stinger, 0.0, 1.84, 0.1)

	TriggerServerEvent("loaf_spikestrips:placedSpikestrip", coords, GetEntityRotation(stinger, 2), minOffset, maxOffset, netId)

	if not skipAnimation then
		-- Player deploying animation
		TaskPlayAnim(playerPed, playerDict, "enter", 1000.0, -1.0, 200, 16, 0, false, false, false)

		WaitForAnimation(playerPed, playerDict, "enter")

		SetAnimRate(playerPed, 3.0, 1.0, false)

		Wait(550)
	end

	-- Stinger animation
	PlayEntityAnim(stinger, "p_stinger_s_deploy", stingerDict, 1000.0, false, true, false, 0.0, 0)

	WaitForAnimation(stinger, stingerDict, "p_stinger_s_deploy")

	SetEntityVisible(stinger, true, false)
	PlayDeployAudio(stinger)

	-- Cleanup
	RemoveAnimDict(playerDict)
	RemoveAnimDict(stingerDict)
	SetModelAsNoLongerNeeded(model)
end

RegisterNetEvent("loaf_spikestrips:placeSpikestrip", placeStinger)

RegisterNetEvent("loaf_spikestrips:removeSpikestrip", function(data)
	local entity = currentStinger or data?.entity
	local stingerId

	if not entity or not IsPedOnFoot(cache.ped) then
		return
	end

	for i = 1, nearbyCount do
		local stinger = nearbyStingers[i]

		if stinger?.entity == entity then
			stingerId = stinger.id
			break
		end
	end

	if not stingerId then
		return
	end

	local dict = LoadDict("pickup_object")
	TaskPlayAnim(cache.ped, dict, "pickup_low", 8.0, -8.0, -1, 48, 0, false, false, false)

	Wait(500)

	TriggerServerEvent("loaf_spikestrips:removeSpikestrip", stingerId)

	RemoveAnimDict(dict)
end)

RegisterNetEvent("loaf_spikestrips:spikestripAdded", function(placer, id, coords, rotation, minOffset, maxOffset, netId)
	local entity = netId and NetworkDoesNetworkIdExist(netId) and NetworkGetEntityFromNetworkId(netId) or nil

	if Config.SpawnMethod == "local" and placer ~= cache.serverId and #(GetEntityCoords(cache.ped) - coords) < 150.0 then
		Wait(550)

		local stingerDict = LoadDict("p_ld_stinger_s")
		local model = LoadModel(`p_ld_stinger_s`)
		local stinger = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)

		FreezeEntityPosition(stinger, true)
		PlaceObjectOnGroundProperly(stinger)
		SetEntityRotation(stinger, rotation.x, rotation.y, rotation.z, 2, true)
		PlayEntityAnim(stinger, "p_stinger_s_deploy", stingerDict, 1000.0, false, true, false, 0.0, 0)

		WaitForAnimation(stinger, stingerDict, "p_stinger_s_deploy")

		RemoveAnimDict(stingerDict)
		SetModelAsNoLongerNeeded(model)

		entity = stinger
	elseif Config.SpawnMethod == "local" and placer == cache.serverId then
		entity = placing
		placing = nil
	end

	local point

	if entity and Config.InteractStyle == "target" then
		targettableEntities[entity] = true
	elseif Config.InteractStyle == "native" then
		point = lib.points.new({
			coords = coords,
			distance = 2
		})

		function point:onEnter()
			currentStinger = stingers[id]?.entity
			ShowHelpText("PICK_UP_STINGER")
		end

		function point:onExit()
			currentStinger = nil
			ClearHelpText()
		end
	end

	stingers[id] = {
		id = id,
		netId = netId,
		entity = entity,
		coords = coords,
		rotation = rotation,
		minOffset = minOffset,
		maxOffset = maxOffset,
		point = point,
	}

	if Config.Blips and IsPolice() then
		stingers[id].blip = CreateStingerBlip(coords)
	end

	if Config.RemoveDistance and placer == cache.serverId then
		while #(GetEntityCoords(cache.ped) - coords) < Config.RemoveDistance and stingers[id] do
			Wait(1000)
		end

		if stingers[id] then
			debugprint("remove due to distance")
			TriggerServerEvent("loaf_spikestrips:removeSpikestrip", id, true)
		end
	end
end)

RegisterNetEvent("loaf_spikestrips:updateNetId", function(id, netId)
	if not stingers[id] then
		return
	end

	stingers[id].netId = netId
	debugprint("updated netId for stinger", id, "to", netId)
end)

RegisterNetEvent("loaf_spikestrips:spikestripRemoved", function(id)
	local stinger = stingers[id]

	if not stinger then
		debugprint("can't remove: doesn't exist")
		return
	end

	if stinger.point then
		stinger.point:onExit()
		stinger.point:remove()
	end

	if stinger.blip then
		RemoveBlip(stinger.blip)
	end

	if Config.SpawnMethod == "local" and stinger.entity then
		if Config.InteractStyle == "target" and targettableEntities[stinger.entity] then
			targettableEntities[stinger.entity] = nil
		end

		DeleteEntity(stinger.entity)
	end

	stingers[id] = nil
end)

local function handleTouching(minOffset, maxOffset, vehicle)
	for i = 1, #bones do
		local bone = bones[i]
		local boneIndex = GetEntityBoneIndexByName(vehicle, bone.bone)

		if boneIndex == -1 or IsVehicleTyreBurst(vehicle, bone.index, false) then
			goto nextBone
		end

		local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
		local wheelTouching =  IsPointInAngledArea(
			boneCoords.x, boneCoords.y, boneCoords.z,
			minOffset.x, minOffset.y, minOffset.z,
			maxOffset.x, maxOffset.y, maxOffset.z,
			0.45, false, false
		)

		if wheelTouching then
			SetVehicleTyreBurst(vehicle, bone.index, wheelTouching, 1000.0)
		end

		::nextBone::
	end
end

local function processStingers()
	local vehicle = cache.vehicle

	if not vehicle and not Config.BurstNPC then
		return
	end

	local vehicleCoords = vehicle and GetEntityCoords(vehicle)

	for i = 1, nearbyCount do
		local stinger = nearbyStingers[i]
		local stingerCoords = stinger?.coords
		local stingerEntity = stinger?.entity
		local minOffset = stinger?.minOffset
		local maxOffset = stinger?.maxOffset

		if not stingerCoords or not stingerEntity or not minOffset or not maxOffset then
			goto continue
		end

		if vehicle and #(vehicleCoords - stingerCoords) < 10.0 and IsEntityTouchingEntity(stingerEntity, vehicle) then
			handleTouching(minOffset, maxOffset, vehicle)
		end

		if not Config.BurstNPC then
			goto continue
		end

		local closestVehicle = GetClosestVehicle(stingerCoords.x, stingerCoords.y, stingerCoords.z, 10.0, 0, 39)

		if closestVehicle ~= 0 and closestVehicle ~= vehicle and NetworkHasControlOfEntity(closestVehicle) and IsEntityTouchingEntity(stingerEntity, closestVehicle) then
			handleTouching(minOffset, maxOffset, closestVehicle)
		end

		::continue::
	end
end

CreateThread(function()
	while true do
		if nearbyCount ~= 0 then
			table.wipe(nearbyStingers)
			nearbyCount = 0
		end

		local coords = GetEntityCoords(cache.ped)

		for id, stinger in pairs(stingers) do
			local distance = #(coords - stinger.coords)

			if not Config.BurstNPC and distance > 100.0 then
				goto continue
			end

			if not stinger.entity or not DoesEntityExist(stinger.entity) then
				if Config.InteractStyle == "target" and stinger.entity then
					targettableEntities[stinger.entity] = nil
				end

				if stinger.netId and NetworkDoesNetworkIdExist(stinger.netId) then
					stinger.entity = NetworkGetEntityFromNetworkId(stinger.netId)
				elseif Config.SpawnMethod == "local" and distance < 150.0 then
					local model = LoadModel(`p_ld_stinger_s`)

					stinger.entity = CreateObjectNoOffset(model, stinger.coords.x, stinger.coords.y, stinger.coords.z, false, false, false)

					FreezeEntityPosition(stinger.entity, true)
					PlaceObjectOnGroundProperly(stinger.entity)
					SetEntityRotation(stinger.entity, stinger.rotation.x, stinger.rotation.y, stinger.rotation.z, 2, true)

					SetModelAsNoLongerNeeded(model)
					debugprint("created local entity for stinger", id)
				end

				if Config.InteractStyle == "target" and stinger.entity then
					targettableEntities[stinger.entity] = true
				end
			end


			if stinger.entity and DoesEntityExist(stinger.entity) then
				if Config.SpawnMethod == "server" and #(GetEntityRotation(stinger.entity, 2) - stinger.rotation) > 1.0 then
					debugprint("rotation out of sync, updating", id)
					SetEntityRotation(stinger.entity, stinger.rotation.x, stinger.rotation.y, stinger.rotation.z, 2, true)
				end

				nearbyCount += 1
				nearbyStingers[nearbyCount] = stinger
			end

			::continue::
		end

		if nearbyCount > 0 and (cache.seat == -1 or Config.BurstNPC) then
			if not stingersTick then
				stingersTick = SetInterval(processStingers)
			end
		elseif stingersTick then
			stingersTick = ClearInterval(stingersTick)
		end

		Wait(250)
	end
end)

if Config.InteractStyle == "target" then
	exports.qtarget:AddTargetModel({ `p_ld_stinger_s` }, {
		distance = 3.0,
		options = {
			{
				event = "loaf_spikestrips:removeSpikestrip",
				icon = "fa-solid fa-road-spikes",
				label = L("remove_spikestrip"),
				canInteract = function(entity)
					if Config.Job.RequireRemove then
						if not IsPolice then
							infoprint("error", "IsPolice function not defined")
							return
						elseif not IsPolice() then
							return
						end
					end

					if not IsPedOnFoot(cache.ped) then
						return
					end

					return targettableEntities[entity]
				end
			}
		},
	})
elseif Config.InteractStyle == "native" then
	local keyBind = Config.PickupKey

	local pickupKey = lib.addKeyBind({
		name = "pickup_spikestirp",
		description = L("keybind_description"),

		defaultKey = keyBind.key,
		defaultMapper = keyBind.mapper,

		secondaryKey = keyBind.secondaryKey,
		secondaryMapper = keyBind.secondaryMapper,

		onReleased = function()
			if currentStinger then
				TriggerEvent("loaf_spikestrips:removeSpikestrip")
			end
		end
	})

	local hex = string.upper(string.format("%x", pickupKey.hash))

	if pickupKey.hash < 0 then
		hex = string.gsub(hex, string.rep("F", 8), "")
	end

	pickupKeyHelp = "~INPUT_" .. hex .. "~"

	AddTextEntry("PICK_UP_STINGER", L("remove_spikestrip_help", {
		key = pickupKeyHelp
	}))
end

if Config.Command then
	RegisterCommand(Config.Command, function()
		placeStinger()
	end, false)

	TriggerEvent("chat:addSuggestion", "/" .. Config.Command, L("place_description"), {})
end

local function refreshBlips(isPolice)
	for _, stinger in pairs(stingers) do
		if Config.Blips and isPolice and not stinger.blip then
			stinger.blip = CreateStingerBlip(stinger.coords)
		elseif stinger.blip then
			RemoveBlip(stinger.blip)
			stinger.blip = nil
		end
	end
end

if Config.Blips and Config.BlipsCommand then
	RegisterCommand(Config.BlipsCommand, function()
		local isPolice = IsPolice()

		if not isPolice then
			return debugprint("not police")
		end

		Config.Blips = not Config.Blips

		refreshBlips(isPolice)
	end, false)
end

AddEventHandler("loaf_spikestrips:toggleIsPolice", function(isPolice)
	if not Config.Blips then
		return
	end

	refreshBlips(isPolice)
end)

AddTextEntry("SPIKESTRIP_BLIP", L("blip_name"))

AddEventHandler("onResourceStop", function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end

	for _, stinger in pairs(stingers) do
		if stinger.blip then
			RemoveBlip(stinger.blip)
		end

		if stinger.entity then
			DeleteEntity(stinger.entity)
		end
	end

	if Config.Command then
		TriggerEvent("chat:removeSuggestion", "/" .. Config.Command)
	end
end)
