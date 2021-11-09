if Config.Menu.Enabled then
    CreateThread(function()
        while not NetworkIsSessionStarted() do
            Wait(500)
        end

        if Config.Menu.Command then
            RegisterCommand(Config.Menu.Command, function()
                if isPolice or not Config.RequireJobRemove then
                    TriggerEvent("loaf_spikestrips:spikestripMenu")
                else
                    TriggerEvent("chat:addMessage", {
                        color = {255, 0, 0},
                        args = {"[Spikestrips]", Strings["not_police"]}
                    })
                end
            end)
            
            if Config.Menu.Keybind then
                RegisterKeyMapping(Config.Menu.Command, Strings["menu_label"], "keyboard", Config.Menu.Keybind)
            end
        end

        if Config.Framework == "esx" and not Config.FrameworkFeatures.UseWarmenu then
            while not ESX do
                Wait(500)
            end

            RegisterNetEvent("loaf_spikestrips:spikestripMenu")
            AddEventHandler("loaf_spikestrips:spikestripMenu", function()
                if isPolice or not Config.RequireJobRemove then
                    ESX.UI.Menu.CloseAll()

                    local elements = {}
                    if isPolice then
                        table.insert(elements, {
                            label = Strings["place_spikestrip"],
                            value = "place_spikestrip"
                        })
                    end
                    table.insert(elements, {
                        label = Strings["remove_spikestrip"],
                        value = "remove_spikestrip"
                    })
            
                    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "spikestrip_menu", {
                        title = Strings["menu_label"],
                        align = "bottom-right",
                        elements = elements,
                    }, function(data, menu)
                        if data.current.value == "place_spikestrip" then
                            DeployStinger()
                        elseif data.current.value == "remove_spikestrip" then
                            RemoveStinger()
                        end
                    end, function(data, menu)
                        menu.close()
                    end)
                else
                    ESX.ShowNotification(Strings["not_police"])
                end
            end)
        elseif Config.Framework == "qb" and not Config.FrameworkFeatures.UseWarmenu then
            while not QBCore do
                Wait(500)
            end
            
            RegisterNetEvent("loaf_spikestrips:spikestripMenu")
            AddEventHandler("loaf_spikestrips:spikestripMenu", function()
                if isPolice or not Config.RequireJobRemove then
                    exports["qb-menu"]:closeMenu()

                    local elements = {
                        {
                            header = Strings["place_spikestrip"],
                            params = {
                                event = "loaf_spikestrips:placeSpikestrip",
                            }
                        }
                    }
                    if isPolice or not Config.RequireJobRemove then
                        table.insert(elements, {
                            header = Strings["remove_spikestrip"],
                            params = {
                                event = "loaf_spikestrips:removeSpikestrip",
                            }
                        })
                    end
                    table.insert(elements, {
                        header = Strings["close_menu"],
                        params = {
                            event = "qb-menu:client:closeMenu",
                        }
                    })
                    exports["qb-menu"]:openMenu(elements)
                else
                    QBCore.Functions.Notify(Strings["not_police"])
                end
            end)
        else
            WarMenu.CreateMenu("spikestrip", Strings["menu_label"], Strings["menu_sublabel"])

            WarMenu.SetMenuWidth("spikestrip", 0.2)
            WarMenu.SetMenuTitleBackgroundColor("spikestrip", 32, 28, 52, 255)
            WarMenu.SetMenuTitleBackgroundSprite("spikestrip", "commonmenu", "gradient_nav")
            WarMenu.SetMenuTitleColor("spikestrip", 255, 255, 255)
            WarMenu.SetMenuSubTitleColor("spikestrip", 255, 255, 255)

            RegisterNetEvent("loaf_spikestrips:spikestripMenu")
            AddEventHandler("loaf_spikestrips:spikestripMenu", function()
                WarMenu.OpenMenu("spikestrip")
            end)

            while true do
                Wait(500)
                while WarMenu.Begin("spikestrip") do
                    Wait(0)
                    if isPolice and IsPedOnFoot(PlayerPedId()) and WarMenu.Button(Strings["place_spikestrip"]) then
                        DeployStinger()
                    end

                    if isPolice or not Config.RequireJobRemove then
                        if WarMenu.Button(Strings["remove_spikestrip"]) then
                            RemoveStinger()
                        end
                    end

                    if WarMenu.Button(Strings["close_menu"]) then
                        WarMenu.CloseMenu()
                    end
                    WarMenu.End()
                end
            end
        end
    end)
end