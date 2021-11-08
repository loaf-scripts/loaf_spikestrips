# loaf_spikestrips
FiveM Spikestrips, only bursts the tyres that are actually touching the spikestrip. 
YouTube Showcase: https://www.youtube.com/watch?v=D3UtNxFXnpU

## Features
* Animation when laying down a spikestrip
* You can remove spikestrips
* Only the tyre that is touching the spikestrip will burst, unlike some other resources which bursts all tyres.
* Performance friendly, uses ~0.01ms

## Standalone & ESX.
The script works with and without ESX. (follow [this guide](https://github.com/loaf-scripts/loaf_spikestrips/wiki/esx_policejob-compatibility) if you use esx_policejob).

If you only want certain jobs to be able to use spikestrips but you don't have ESX, set [`Config.JobBased`](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/config.lua#L13) to true. You can edit who is able to use the script at the server.lua, simply add an identifier (any identifier works) to the `police` table in the [server/main.lua](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/server/main.lua#L1) file.

If you only want certain jobs to be able to use spikestrips and you use ESX, set [`Config.JobBased`](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/config.lua#L13) to true. You also need to set [`Config.ESX`](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/config.lua#L4) to true. You can configure what jobs are able to use spikestrips by editing the [`PoliceJobs`](https://github.com/loaf-scripts/loaf_spikestrips/blob/main/config.lua#L21) table in the config.
