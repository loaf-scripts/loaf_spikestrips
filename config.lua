Config = {}

Config.Debug = false

-------------------
-- Customization --
-------------------

Config.Framework = "auto" -- esx, qbcore or standalone
Config.Language = "en" -- add your own language in locales/
Config.InteractStyle = "auto" -- auto: use target if available, otherwise native. native: press E, target: qtarget, qb-target or ox_target
Config.NotificationSystem = "ox_lib" -- framework or ox_lib, modify in client/functions.lua
Config.SpawnMethod = "server" -- local (non-networked), networked or server
Config.BurstNPC = false -- burst tires of NPCs? note that this can be resource intensive
Config.LogSystem = false -- "discord" or "ox_lib". Set your discord webhook in server/logs.lua. Set to false to disable
Config.Blips = false -- show blips of all spike strips on the map for allowed jobs?
Config.AllowFromVehicle = false -- allow throwing spike strips from vehicles?

Config.BlipsCommand = "spikestripblips" -- command to toggle blips (set to false to disable)
Config.Command = "spikestrip" -- command to place spike strip, set to false to disable
Config.ClearCommand = "clearspikestrips" -- admin command to clear all spike strips, set to false to disable

------------------
-- Restrictions --
------------------

Config.OnlyRoads = false -- only allow placing spike strips on roads?
Config.AutoDelete = 120 -- how many minutes after placing to delete spike strip? set to false to disable
Config.MaxStingers = 100 -- max amount of stingers that can be placed, set to false to disable
Config.RemoveDisconnect = false -- remove spike strips when player disconnects?
Config.RemoveDistance = false -- if the person who placed it goes this far away, remove it. set to false to disable

Config.Item = {}
Config.Item.Require = true -- require item to place a spike strip?
Config.Item.Usable = true -- allow using item to place a spike strip?
Config.Item.Remove = true -- remove item after placing a spike strip? it will be given back when taking up
Config.Item.Name = "spikestrip"

Config.Job = {}
Config.Job.RequirePlace = true -- require job to place a spike strip?
Config.Job.RequireRemove = true -- require job to remove placed spike strips?
Config.Job.Allowed = { "police", "sheriff", "leo" }

-----------
-- Misc --
----------

Config.PickupKey = {
	key = "E",
	mapper = "KEYBOARD",

	secondaryKey = "LRIGHT_INDEX",
	secondaryMapper = "PAD_DIGITALBUTTON"
}

Config.Bones = {
	{ bone = "wheel_lf", index = 0 },
	{ bone = "wheel_rf", index = 1 },
	{ bone = "wheel_lm1", index = 2 },
	{ bone = "wheel_rm1", index = 3 },
	{ bone = "wheel_lr", index = 4 },
	{ bone = "wheel_rr", index = 5 },
	{ bone = "wheel_lm2", index = 45 },
	{ bone = "wheel_lm3", index = 46 },
	{ bone = "wheel_rm2", index = 47 },
	{ bone = "wheel_rm3", index = 48 },
}
