if Config.Debug then
	return
end

local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)

if not currentVersion then
	return
end

local resultPromise = promise.new()

PerformHttpRequest("https://api.github.com/repos/loaf-scripts/loaf_spikestrips/releases/latest", function(status, body, headers)
	if status ~= 200 then
		resultPromise:resolve(nil)
		print("Failed to check status", status)
		return
	end

	local data = json.decode(body)

	if not data.tag_name or not data.html_url then
		resultPromise:resolve(nil)
		return
	end

	resultPromise:resolve(data)
end, "GET")

local result = Citizen.Await(resultPromise)

if not result then
	return
end

local latestVersion = result.tag_name
local downloadLink = result.html_url

local currentVersionArray = {}
local latestVersionArray = {}

for part in string.gmatch(currentVersion, "([^%.]+)") do
	currentVersionArray[#currentVersionArray+1] = tonumber(part)
end

for part in string.gmatch(latestVersion, "([^%.]+)") do
	latestVersionArray[#latestVersionArray+1] = tonumber(part)
end

for i = 1, 3 do
	local current = currentVersionArray[i] or 0
	local latest = latestVersionArray[i] or 0

	if current < latest then
		infoprint("warning", "An update is available. You can download the latest version at: ^5" .. downloadLink .. "^7")
		break
	elseif current > latest then
		break
	end
end
