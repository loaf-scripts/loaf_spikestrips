# Loaf - Spike Strips V2

Spike strip script for FiveM that only bursts the tires that are touching the spikes.

![](https://img.shields.io/github/downloads/loaf-scripts/loaf_spikestrips/total?logo=github)
![](https://img.shields.io/github/downloads/loaf-scripts/loaf_spikestrips/latest/total?logo=github)
![](https://img.shields.io/github/v/release/loaf-scripts/loaf_spikestrips?logo=github)

Showcase: https://www.youtube.com/watch?v=iarfWQxAMAg

<details>
<summary>Changes from V1</summary>

-   Better performance
-   Now supports more tires (previously only 4). This makes it work correctly on e.g a Dubsta 6x6
-   Audio when placing a spike strip
-   Target inteaction to pick up spike strips
-   Option to spawn entities on the server or locally
-   Animation when picking up
-   Better support for frameworks
-   Version checking
-   Logs
-   A bunch of quality of life features
    -   /clearspikestrips admin command to clear all spike strips
    -   Notifications
    -   Automatically delete after a certain time
    -   Delete on script stop
    -   Option to only allow placing on roads
-   And a lot more

</details>

## Performance

6 spikestrips placed, `Config.BurstNPC` disabled:

-   not in a vehicle: 0.00ms
-   in a vehicle: 0.01ms
-   in a vehicle, very close: 0.03-0.06ms

6 spikestrips placed, `Config.BurstNPC` enabled with NPC's driving over:

-   not in a vehicle: 0.03-0.04ms
-   in a vehicle: 0.05ms
-   in a vehicle, very close: 0.08ms

## Installation

1. Download the latest [release](https://github.com/loaf-scripts/loaf_spikestrips/releases/latest)
2. Install all [dependencies](#dependencies)
3. [Add the item](#adding-the-item) to your server
4. [Configure](#configuration) the script to your liking
5. Add `ensure loaf_spikestrips` to your server.cfg
6. Either restart your server, or start the resource by running `refresh` and then `ensure loaf_spikestrips` in your server console

If you use esx_policejob, you can remove the built in functionality by removing `p_ld_stinger_s` from [the table](https://github.com/esx-framework/esx_policejob/blob/c62253c1fc9993e024bc68c50954035419995289/client/main.lua#L1378) in the `-- Enter / Exit entity zone events` thread in `esx_policejob/client/main.lua`.

If you use qb-policejob, you can remove the built in functionality by removing [the thread](https://github.com/qbcore-framework/qb-policejob/blob/63026f9051f10abf703cc1b56ea5073a0c301c4f/client/objects.lua#L237) in `qb-policejob/client/object.lua` that handles the spike strip.

### Dependencies

-   [ox_lib](https://github.com/overextended/ox_lib/releases/latest)

### Adding the item

You can use the included `spikestrip.png` as the item image.

<details>
<summary>Default ESX</summary>
Run the following query in your database:

```sql
INSERT INTO `items` (`name`, `label`, `weight`) VALUES ("spikestrip", "Spike strip", 500);
```

</details>

<details>
<summary>ox_inventory</summary>
Add to ox_inventory/data/items.lua:

```lua
["spikestrip"] = {
	label = "Spike strip",
	weight = 500,
	stack = true
}
```

</details>

<details>
<summary>qb-inventory</summary>
Add to qb-core/shared/items.lua:

```lua
spikestrip = { name = 'spikestrip', label = 'Spike strip', weight = 500, type = 'item', image = 'spikestrip.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Useful for stopping the bad guys' },
```

</details>

## Configuration

**Config.SpawnMethod** - The method used to spawn the spike strip. This can be one of the following:
| Value | Description |
| ----- | ----------- |
| `"local"` | The spike strip entity is spawned locally on each client, and deleted when out of view. |
| `"networked"` | The entity is spawned networked by the person who places it |
| `"server"` | The entity is spawned by the server |

### Logs

The script supports logging via Discord webhooks or [ox_lib](https://overextended.dev/ox_lib/Modules/Logger/Server).

If you wish to use ox_lib, set `Config.LogSystem` to `"ox_lib"`. For discord, set it to `"discord"` and set your webhook in `loaf_spikestrips/server/logs.lua`
