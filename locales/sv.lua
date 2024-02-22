if Config.Language ~= "sv" then
	return
end

Locales = {
	clear_description = "Ta bort alla spikmattor",
	place_description = "Lägg ut en spikmatta",
	keybind_description = "Ta upp en spikmatta",

	remove_spikestrip = "Plocka upp spikmattan",
	remove_spikestrip_help = "Tryck {key} för att plocka upp spikmattan",

	only_roads = "Du kan bara lägga ut spikmattor på vägen",
	only_police = "Endast poliser kan lägga ut spikmattor",
	need_item = "Du behöver en spikmatta för att kunna lägga ut en",
	max_reached = "Det är för många spikmattor utlagda",

	logs_cleared_spikestrips = "Tog bort alla spikmattor",
	logs_removed_distance = "Tog bort spikmattan {id} eftersom spelaren gick för långt bort",
	logs_picked_up = "Plockade upp spikmattan {id}",
	logs_placed_spikestrip = "Lade ut en spikmatta med id {id}",
}