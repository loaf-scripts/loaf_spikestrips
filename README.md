# loaf_spikestrips
FiveM Spikestrips, only bursts the tyres that are actually touching the spikestrip. 
YouTube Showcase: https://www.youtube.com/watch?v=D3UtNxFXnpU

## Features
* Animation when laying down a spikestrip
* You can remove spikestrips
* Only the tyre that is touching the spikestrip will burst, unlike some other resources which bursts all tyres.
* Performance friendly, uses ~0.01ms

## Standalone & ESX.
The script works without ESX and with ESX. (please note that you should remove the spikestrip part from your esx_policejob if you intend on using this resource).
If you only want certain jobs to be able to use spikestrips but you don't have ESX, set `Config.JobBased.Enabled` to true, [line 3 in the config.lua](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/config.lua#L3). You can edit who is able to use the script at the server.lua, simply add an identifier (any identifier works) to the `police` table in the [server/main.lua](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/server/main.lua#L1) file.

If you only want certain jobs to be able to use spikestrips and you use ESX, set `Config.JobBased.Enabled` to true [line 3 in the config.lua](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/config.lua#L3) and also set `Config.JobBased.ESX` to true [line 4 in the config.lua](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/config.lua#L4). You can configure what jobs are able to use spikestrips by editing the `PoliceJobs` table in the config.
