PoliceJobsLookup = {}

for i = 1, #Config.Job.Allowed do
	PoliceJobsLookup[Config.Job.Allowed[i]] = true
end

function debugprint(text, ...)
	if not Config.Debug then
		return
	end

	print("^5[DEBUG]^7: " .. tostring(text), ...)
end

local infoLevels = {
    success = "^2[SUCCESS]",
	info = "^5[INFO]",
	warning = "^3[WARNING]",
	error = "^1[ERROR]"
}

---@param level "success" | "info" | "warning" | "error"
---@param text string
function infoprint(level, text, ...)
	local prefix = infoLevels[level]

	if not prefix then
		prefix = "^5[INFO]^7:"
	end

	print(prefix .. "^7: " .. text, ...)
end

---@param resource string
---@return boolean
local function isResourceStartedOrStarting(resource)
	local state = GetResourceState(resource)

	return state == "started" or state == "starting"
end

if Config.Framework == "auto" then
	debugprint("Config.Framework is set to auto, detecting framework")

	if isResourceStartedOrStarting("es_extended") then
		Config.Framework = "esx"
	elseif isResourceStartedOrStarting("qb-core") then
		Config.Framework = "qbcore"
	else
		Config.Framework = "standalone"
	end

	debugprint("Detected framework: " .. Config.Framework)
end

if Config.InteractStyle == "auto" then
	if isResourceStartedOrStarting("qtarget") then
		Config.InteractStyle = "target"
	else
		Config.InteractStyle = "native"
	end
end

---@param path string
---@param args? { [string]: string }
---@return string
function L(path, args)
	if not Locales then
		infoprint("warning", "Invalid Config.Language (" .. tostring(Config.Language) .. ")")
		return path
	end

	local translation = Locales[path] or path

	if args then
		for k, v in pairs(args) do
			local safeValue = tostring(v):gsub("%%", "%%%%")

			translation = translation:gsub("{" .. k .. "}", safeValue)
		end
	end

	return translation
end
