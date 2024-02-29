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
	while not ESX do
		TriggerEvent("esx:getSharedObject", function(esx)
			ESX = esx
		end)

		Wait(250)
	end
end

RegisterNetEvent("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent("esx:setJob", function(job)
	if not ESX.PlayerData then
		return
	end

	local wasPolice = IsPolice()

	ESX.PlayerData.job = job

	local isPolice = IsPolice()

	if wasPolice ~= isPolice then
		TriggerEvent("loaf_spikestrips:toggleIsPolice", isPolice)
	end
end)

function IsPolice()
	local job = ESX.PlayerData.job?.name

	if not job then
		return
	end

	return PoliceJobsLookup[job] == true
end

function FrameworkNotify(text, errType)
	ESX.ShowNotification(text, errType)
end

while not ESX.PlayerLoaded do
	Wait(500)
end

debugprint("ESX loaded")
