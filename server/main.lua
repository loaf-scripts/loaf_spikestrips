local police = {
    "steam:11000010ded0daa"
}

local function IsPolice(identifier)
    for _, policeIdent in pairs(police) do
        if policeIdent == identifier then
            return true
        end
    end
end

RegisterNetEvent("loaf_stingers:checkPolice")
AddEventHandler("loaf_stingers:checkPolice", function()
    local src = source

    for k, v in pairs(GetPlayerIdentifiers(src)) do
        if IsPolice(v) then
            TriggerClientEvent("loaf_stingers:setPolice", src)
            break
        end
    end
end)