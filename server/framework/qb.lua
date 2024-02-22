if Config.Framework ~= "qbcore" then
	return
end

QB = exports["qb-core"]:GetCoreObject()

function HasItem(source, item)
	local qPlayer = QB.Functions.GetPlayer(source)

	return (qPlayer?.Functions.GetItemByName(item)?.amount or 0) > 0
end

function RemoveItem(source, item, amount)
	local qPlayer = QB.Functions.GetPlayer(source)

	if qPlayer and HasItem(source, item) then
		qPlayer.Functions.RemoveItem(item, 1)
		TriggerClientEvent("inventory:client:ItemBox", source, QB.Shared.Items[item], "remove")
		return true
	end

	return false
end

function AddItem(source, item)
	local qPlayer = QB.Functions.GetPlayer(source)

	if not qPlayer then
		return false
	end

	qPlayer.Functions.AddItem(item, 1)
	TriggerClientEvent("inventory:client:ItemBox", source, QB.Shared.Items[item], "add")
end

function IsPolice(source)
	local qPlayer = QB.Functions.GetPlayer(source)

	if not qPlayer then
		return false
	end

	return PoliceJobsLookup[qPlayer.PlayerData.job.name] == true
end

---@param command string
---@param description string
---@param cb fun(source: number)
function RegisterAdminCommand(command, description, cb)
	QB.Commands.Add(command, description, {}, false, function(source)
		cb(source)
	end, "admin")
end

function CreateUsableItem(item, cb)
	QB.Functions.CreateUseableItem(item, cb)
end
