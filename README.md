# loaf_spikestrips
FiveM Spikestrips, only bursts the tyres that are actually touching the spikestrip. 
YouTube Showcase: https://www.youtube.com/watch?v=D3UtNxFXnpU

## Features
* Animation when laying down a spikestrip
* You can remove spikestrips
* Only the tyre that is touching the spikestrip will burst, unlike some other resources which bursts all tyres.
* Performance friendly, uses ~0.01ms
* Standalone, but has support for ESX and QBCore

## Standalone, ESX & QBCore
The script works with ESX, QBCore or standalone without any framework.

### Use with ESX
#### Installation
* Run the esx.sql file
* Rename from `loaf_spikestrips-main` to `loaf_spikestrips`
* Drag the resource to your server resources folder
* Add `ensure loaf_spikestrips` to your server.cfg
#### Configuration
* Set `Config.Framework` to `"esx"`
* Modify `FrameworkFeatures` to your liking.
#### esx_policejob compatibility
Visit [this page](https://github.com/loaf-scripts/loaf_spikestrips/wiki/esx_policejob-compatibility) for a guide on how to use the resource together with esx_policejob

### Use with QBCore
#### Installation
* Add the following code to your QBShared.Items file, located in [qb-core/shared.lua:51](https://github.com/qbcore-framework/qb-core/blob/main/shared.lua#L51) by default: 
```lua
["spikestrip"] = {
    ["name"] = "spikestrip",
    ["label"] = "Spikestrip",
    ["weight"] = 25,
    ["type"] = "item",
    ["image"] = "spikestrip.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "A spikestrip"
},
```
* For the not WarMenu menu, you need [qb-menu](https://github.com/qbcore-framework/qb-menu)
* Rename from `loaf_spikestrips-main` to `loaf_spikestrips`
* Drag the resource to your server resources folder
* Add `ensure loaf_spikestrips` to your server.cfg
* Move the spikestrip.png file to your qb-inventory/html/images folder
#### Configuration
* Set `Config.Framework` to `"qb"`
* Modify `FrameworkFeatures` to your liking.
#### qb-policejob compatibility
Visit [this page](https://github.com/loaf-scripts/loaf_spikestrips/wiki/qb-policejob-compatibility) for a guide on how to use the resource together with qb-policejob

### Use standalone
#### Installation
* Rename from `loaf_spikestrips-main` to `loaf_spikestrips`
* Drag the resource to your server resources folder
* Add `ensure loaf_spikestrips` to your server.cfg
#### Configuration
* Set `Config.Framework` to `"none"`
* Modify the `police` table in the server.lua file to change who is able to place spike strips.

## Credits
* `@Jay ;)#6969` - helped with adding support for qb-core
* @warxander - [warmenu](https://github.com/warxander/warmenu)
