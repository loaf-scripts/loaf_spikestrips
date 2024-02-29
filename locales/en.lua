if Config.Language ~= "en" then
	return
end

Locales = {
	clear_description = "Clear all spike strips",
	place_description = "Place a spike strip",
	keybind_description = "Pick up a spike strip",

	remove_spikestrip = "Pick up spike strip",
	remove_spikestrip_help = "Press {key} to pick up the spike strip",

	only_roads = "You can only place spike strips on roads",
	only_police = "You need to be a police officer to place spike strips",
	need_item = "You need a spike strip to place one",
	max_reached = "There are already too many spike strips placed",

	logs_cleared_spikestrips = "Cleared all spike strips",
	logs_removed_distance = "Removed the spike strip {id} because the player went too far away",
	logs_picked_up = "Picked up the spike strip {id}",
	logs_placed_spikestrip = "Placed a spike strip with the id {id}",

	cant_vehicle = "You can't place spike strips from a vehicle",

	blip_name = "Spike Strip",
}