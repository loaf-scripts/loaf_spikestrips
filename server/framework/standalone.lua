if Config.Framework ~= "standalone" then
	return
end

function HasItem(source, item)
	if GetResourceState("ox_inventory") == "started" then
		local count = exports.ox_inventory:GetItemCount(source, item) or 0

		return count > 0
	end

	return false
end

function RemoveItem(source, item)
	if not HasItem(source, item) then
		return false
	end

	if GetResourceState("ox_inventory") == "started" then
		exports.ox_inventory:RemoveItem(source, item, 1)

		return true
	end

	return false
end

function AddItem(source, item)
	if GetResourceState("ox_inventory") == "started" then
		if not exports.ox_inventory:CanCarryItem(source, item, 1) then
			return false
		end

		exports.ox_inventory:AddItem(source, item, 1)

		return true
	end

	return false
end

function IsPolice(source)
	return false
end

---@param command string
---@param description string
---@param cb fun(source: number)
function RegisterAdminCommand(command, description, cb)
	RegisterCommand(command, function(source)
		cb(source)
	end, true)
end
