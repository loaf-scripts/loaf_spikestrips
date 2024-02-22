---@type { string: { netId?: number, coords: vector3, rotation: vector3, minOffset: vector3, maxOffset: vector3, placer: number } }
local stingers = {}
local stingersCount = 0
local placing = {}
local model = `p_ld_stinger_s`

local function allowedToPlace(source)
	if placing[source] then
		return false
	end

	if Config.MaxStingers and stingersCount >= Config.MaxStingers then
		debugprint("max stingers reached")
		TriggerClientEvent("loaf_spikestrips:notify", source, L("max_reached"), "error")
		return false
	end

	if Config.Job.RequirePlace then
		if not IsPolice then
			infoprint("error", "IsPolice is not defined")
			return false
		end

		if not IsPolice(source) then
			TriggerClientEvent("loaf_spikestrips:notify", source, L("only_police"), "error")
			return false
		end
	end

	if Config.Item.Require then
		if not HasItem then
			infoprint("error", "HasItem is not defined")
			return false
		end

		if not HasItem(source, Config.Item.Name) then
			TriggerClientEvent("loaf_spikestrips:notify", source, L("need_item"), "error")
			return false
		end
	end

	if Config.Item.Require and Config.Item.Remove then
		if not RemoveItem then
			infoprint("error", "RemoveItem is not defined")
			return false
		end

		RemoveItem(source, Config.Item.Name)
	end

	return true
end

if Config.SpawnMethod == "server" then
	lib.callback.register("loaf_spikestrips:createSpikestrip", function(source, coords)
		if not allowedToPlace(source) then
			return false
		end

		local entity = CreateObjectNoOffset(model, coords.x, coords.y, coords.z - 4.0, true, false, false)
		local netId = NetworkGetNetworkIdFromEntity(entity)

		SetEntityIgnoreRequestControlFilter(entity, true)

		placing[source] = entity

		return netId
	end)
else
	lib.callback.register("loaf_spikestrips:startPlacing", function(source)
		if not allowedToPlace(source) then
			return false
		end

		placing[source] = true

		return true
	end)
end

lib.callback.register("loaf_spikestrips:getSpikestrips", function()
	return stingers
end)

local function removeStinger(id)
	local stinger = stingers[id]

	if not stinger then
		return
	end

	if stinger.netId then
		local entity = NetworkGetEntityFromNetworkId(stinger.netId)

		if entity then
			DeleteEntity(entity)
		end
	end

	stingers[id] = nil
	stingersCount -= 1

	TriggerClientEvent("loaf_spikestrips:spikestripRemoved", -1, id)

	debugprint("deleted spikestrip", id)

	return true
end

RegisterNetEvent("loaf_spikestrips:placedSpikestrip", function(coords, rotation, minOffset, maxOffset, netId)
	local src = source

	if Config.SpawnMethod ~= "local" and not netId then
		return
	end

	if not placing[src] then
		return
	end

	if Config.SpawnMethod == "server" then
		SetEntityIgnoreRequestControlFilter(placing[src], false)
	end

	local id = lib.string.random(".......")

	while stingers[id] do
		id = lib.string.random(".......")
		Wait(0)
	end

	stingersCount += 1
	placing[src] = nil
	stingers[id] = {
		netId = netId,
		coords = coords,
		rotation = rotation,
		minOffset = minOffset,
		maxOffset = maxOffset,
		placer = src
	}

	TriggerClientEvent("loaf_spikestrips:spikestripAdded", -1, src, id, coords, rotation, minOffset, maxOffset, netId)

	if Config.AutoDelete then
		SetTimeout(Config.AutoDelete * 60000, function()
			removeStinger(id)
		end)
	end

	Log(src, "placedSpikestrip", L("logs_placed_spikestrip", { id = id }))
end)

RegisterNetEvent("loaf_spikestrips:removeSpikestrip", function(id, distance)
	local src = source

	if not id or not stingers[id] then
		return
	end

	if not distance and #(GetEntityCoords(GetPlayerPed(src)) - stingers[id].coords) > 5.0 then
		debugprint("player too far from spikestrip")
		return
	end

	if Config.Job.RequireRemove then
		if not IsPolice then
			infoprint("error", "IsPolice is not defined")
			return
		end

		if not IsPolice(src) then
			return
		end
	end

	if not distance and Config.Item.Require and Config.Item.Remove then
		AddItem(src, Config.Item.Name)
	end

	if distance then
		Log(src, "removeSpikestrip", L("logs_removed_distance", { id = id }))
	else
		Log(src, "removeSpikestrip", L("logs_picked_up", { id = id }))
	end

	removeStinger(id)
end)

CreateThread(function()
	if not Config.Item.Usable then
		return
	end

	if not CreateUsableItem then
		return infoprint("error", "CreateUsableItem is not defined")
	end

	CreateUsableItem(Config.Item.Name, function(source)
		TriggerClientEvent("loaf_spikestrips:placeSpikestrip", source)
	end)
end)

if Config.ClearCommand then
	if not RegisterAdminCommand then
		return infoprint("error", "RegisterAdminCommand is not defined")
	end

	RegisterAdminCommand(Config.ClearCommand, L("clear_description"), function(source)
		Wait(0) -- print on server console, not f8

		for id, _ in pairs(stingers) do
			removeStinger(id)
		end

		Log(source, "clearspikestrips", L("logs_cleared_spikestrips"))
	end)
end

CreateThread(function()
	if Config.SpawnMethod ~= "server" then
		return
	end

	while true do
		Wait(1000)

		for id, stinger in pairs(stingers) do
			local netId = stinger?.netId
			local coords = stinger?.coords
			local rotation = stinger?.rotation

			if not netId or not coords or not rotation then
				goto continue
			end

			local entity = NetworkGetEntityFromNetworkId(stinger.netId)

			if entity and entity ~= 0 then
				goto continue
			end

			debugprint("entity not found for stinger", id, "respawning..")

			local nwEntity = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, false, false)
			local newNetId = NetworkGetNetworkIdFromEntity(nwEntity)

			FreezeEntityPosition(nwEntity, true)
			SetEntityRotation(nwEntity, rotation.x, rotation.y, rotation.z, 2, true)

			stinger.netId = newNetId

			debugprint("respawned stinger", id, newNetId)
			TriggerClientEvent("loaf_spikestrips:updateNetId", -1, id, newNetId)

			::continue::
		end
	end
end)

AddEventHandler("playerDropped", function()
	local src = source

	if placing[src] then
		if Config.SpawnMethod == "server" then
			DeleteEntity(placing[src])
		end

		placing[src] = nil
	end

	if Config.RemoveDisconnect then
		for id, stinger in pairs(stingers) do
			if stinger.placer == src then
				removeStinger(id)
			end
		end
	end
end)

AddEventHandler("onResourceStop", function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end

	for _, stinger in pairs(stingers) do
		if stinger.netId then
			DeleteEntity(NetworkGetEntityFromNetworkId(stinger.netId))
		end
	end
end)
