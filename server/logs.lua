local discordWebhook = "https://discord.com/api/webhooks/"
local cachedUsers = {}

---@param id string
---@return { username: string, avatar: string } | nil
local function getForumUserFromId(id)
	if cachedUsers[id] then
		return cachedUsers[id]
	end

	local getPromise = promise.new()

	PerformHttpRequest("https://policy-live.fivem.net/api/getUserInfo/" .. id, function(statusCode, response, headers)
		if statusCode ~= 200 then
			getPromise:resolve()
		end

		local responseData = json.decode(response)

		getPromise:resolve({
			username = responseData.username,
			avatar = "https://forum.cfx.re/" .. responseData.avatar_template:gsub("{size}", "512")
		})
	end, "GET", "", {["Content-Type"] = "application/json"})

	local user = Citizen.Await(getPromise)

	if user then
		cachedUsers[id] = user
	end

	return user
end

---@param source number
---@param event string
---@param message string
function Log(source, event, message)
	if not Config.LogSystem then
		return
	end

	if Config.LogSystem == "ox_lib" then
		lib.Logger(source, event, message)
	end

	if Config.LogSystem ~= "discord" then
		return
	end

	if discordWebhook == "https://discord.com/api/webhooks/" then
		infoprint("warning", "Config.LogSystem is set to discord, but no discord webhook has been set in loaf_spikestrips/server/logs.lua")
		return
	end

	local cleanedUpIdentifiers = {}
	local accounts = {}
	local identifiers = GetPlayerIdentifiers(source)
	local avatar = "https://st3.depositphotos.com/9998432/13335/v/450/depositphotos_133352156-stock-illustration-default-placeholder-profile-icon.jpg"
	local description = "**Message:**\n" .. message
	local accountsCount = 0

	for i = 1, #identifiers do
		local identifierTypeIndex = identifiers[i]:find(":")

		if not identifierTypeIndex then
			goto continue
		end

		local identifierType = identifiers[i]:sub(1, identifierTypeIndex - 1)
		local identifier = identifiers[i]:sub(identifierTypeIndex + 1)

		if identifierType == "steam" then
			accountsCount += 1
			accounts[accountsCount] = "- Steam: https://steamcommunity.com/profiles/" .. tonumber(identifier, 16)
		elseif identifierType == "fivem" then
			local user = getForumUserFromId(identifier)

			if user then
				avatar = user.avatar
				accountsCount += 1
				accounts[accountsCount] = "- Forum account: [" .. user.username .. "](https://forum.cfx.re/u/" .. user.username .. ")"
			end
		elseif identifierType == "discord" then
			accountsCount += 1
			accounts[accountsCount] = "- Discord: <@" .. identifier .. ">"
		end

		if identifierType ~= "ip" then
			cleanedUpIdentifiers[identifierType] = identifier
		end

		::continue::
	end

	---@diagnostic disable-next-line: param-type-mismatch
	local currentTime = os.time(os.date("!*t")) -- Get the current time in UTC
    local timestamp = os.date("%Y-%m-%dT%H:%M:%S.000Z", currentTime)

	if accountsCount > 0 then
		description = description .. "\n\n**Accounts:**\n"
		for i = 1, accountsCount do
			description = description .. accounts[i] .. "\n"
		end
	end

	description = description .. "**Identifiers:**"

	for identifierType in pairs(cleanedUpIdentifiers) do
		description = description .. "\n- **" .. identifierType .. ":** " .. cleanedUpIdentifiers[identifierType]
	end

	local embed = {
		title = event,
		description = description,
		color = 15633643,
		timestamp = timestamp,
		author = {
			name = GetPlayerName(source) .. " | " .. source,
			icon_url = avatar
		},
		footer = {
			text = "loaf_spikestrips",
			icon_url = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/3abb800c9903d7ba189328c8f520e76c96bf35ba.png"
		}
	}

	PerformHttpRequest(discordWebhook, function() end, "POST", json.encode({
		username = "Loaf - Spike strips",
		avatar_url = "https://dunb17ur4ymx4.cloudfront.net/webstore/logos/3abb800c9903d7ba189328c8f520e76c96bf35ba.png",
		embeds = {
			embed
		}
	}), {
		["Content-Type"] = "application/json"
	})
end
