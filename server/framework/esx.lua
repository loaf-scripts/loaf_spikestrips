if Config.Framework ~= "esx" then
	return
end

debugprint("Loading ESX")

local export, obj = pcall(function()
	return exports.es_extended:getSharedObject()
end)

if export then
	ESX = obj
else
	TriggerEvent("esx:getSharedObject", function(esx)
		ESX = esx
	end)
end

debugprint("ESX loaded")

function HasItem(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)

	return (xPlayer?.getInventoryItem(item)?.count or 0) > 0
end

function RemoveItem(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer and HasItem(source, item) then
		xPlayer.removeInventoryItem(item, 1)
		return true
	end

	return false
end

function AddItem(source, item)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer then
		return false
	end

	if xPlayer.canCarryItem and not xPlayer.canCarryItem(item, 1) then
		return false
	elseif not xPlayer.canCarryItem then
		local itemData = xPlayer.getInventoryItem(item)

		if itemData.limit ~= -1 and itemData.count + 1 > itemData.limit then
			return false
		end
	end

	xPlayer.addInventoryItem(item, 1)

	return true
end

function IsPolice(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer then
		return false
	end

	return PoliceJobsLookup[xPlayer.job.name] == true
end

---@param command string
---@param description string
---@param cb fun(source: number)
function RegisterAdminCommand(command, description, cb)
	ESX.RegisterCommand(command, "admin", function(xPlayer)
		cb(xPlayer.source)
	end, false, {
		help = description
	})
end

function CreateUsableItem(item, cb)
	ESX.RegisterUsableItem(item, cb)
end
