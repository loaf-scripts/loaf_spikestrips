---@param text string
---@param errType "info" | "error" | "success
function Notify(text, errType)
	if Config.NotificationSystem == "framework" and FrameworkNotify then
		FrameworkNotify(text, errType)
	else
		lib.notify({
			description = text,
			type = errType
		})
	end
end

RegisterNetEvent("loaf_spikestrips:notify", Notify)

---@param entity number
function PlayDeployAudio(entity)
	debugprint("Loading audio bank..")

	while not RequestScriptAudioBank("dlc_stinger/stinger", false) do
		Wait(0)
	end

	debugprint("Audio bank loaded")

	local soundId = GetSoundId()

	PlaySoundFromEntity(soundId, "deploy_stinger", entity, "stinger", false, 0)

	ReleaseSoundId(soundId)
	ReleaseNamedScriptAudioBank("stinger")
end

---Loads an anim dict and returns it
---@param dict string
---@return string
function LoadDict(dict)
	RequestAnimDict(dict)

	while not HasAnimDictLoaded(dict) do
		Wait(0)
	end

	return dict
end

---Loads a model and returns the hash
---@param model number | string
---@return number
function LoadModel(model)
	local hash = type(model) == "string" and joaat(model) or model

	RequestModel(hash)

	while not HasModelLoaded(hash) do
		Wait(0)
	end

	---@diagnostic disable-next-line: return-type-mismatch
	return hash
end

---Wait for an animation to start
---@param entity number
---@param dict string
---@param animation string
function WaitForAnimation(entity, dict, animation)
	while not IsEntityPlayingAnim(entity, dict, animation, 3) do
		Wait(0)
	end
end

---Waits for a network id to exists, takes control of the entity and returns it
---@param netId number
---@return number entity
function WaitForControlAndNetId(netId)
	while not NetworkDoesNetworkIdExist(netId) or not NetworkGetEntityFromNetworkId(netId) do
        Wait(0)
    end

    local entity = NetworkGetEntityFromNetworkId(netId)

    while not NetworkHasControlOfEntity(entity) do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end

    return entity
end

function ShowHelpText(textEntry)
	ClearHelp(true)
	BeginTextCommandDisplayHelp(textEntry)
	EndTextCommandDisplayHelp(0, true, true, 0)
end

function ClearHelpText()
	ClearHelp(true)
end
