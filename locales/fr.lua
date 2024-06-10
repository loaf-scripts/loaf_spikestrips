if Config.Language ~= "fr" then
	return
end

Locales = {
	clear_description = "Retirer toutes les herses",
	place_description = "Placer une herse",
	keybind_description = "Récupérer la herse",

	remove_spikestrip = "Récupérer la herse",
	remove_spikestrip_help = "Appuyer sur {key} pour récupérer la herse",

	only_roads = "Vous ne pouvez placer des herses que sur les routes",
	only_police = "Vous devez être un policier pour placer des herses",
	need_item = "Vous avez besoin d'une herse pour en placer une",
	max_reached = "Il y a déjà trop de herses placées",

	logs_cleared_spikestrips = "Toutes les herses ont été retirées",
	logs_removed_distance = "Retiré la herse {id} car le joueur s'est éloigné trop loin",
	logs_picked_up = "Récupéré la herse {id}",
	logs_placed_spikestrip = "Placé une herse avec l'id {id}",

	cant_vehicle = "Vous ne pouvez pas placer de herses depuis un véhicule",

	blip_name = "Herses",
}