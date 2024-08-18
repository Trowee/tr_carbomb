# TR_CARBOMB

The `tr_carbomb` script allows players to plant and remove bombs on vehicles in a FiveM server. The bombs can be set to detonate under various conditions such as when a player enters the vehicle, starts the engine, or reaches a specified speed.

## Preview
https://streamable.com/pt35k9
If you have any suggestions/ideas you can contact me on discord: _.trowe

## Features

- **Place Bombs on Vehicles**: Plant bombs that explode under different conditions.
- **Remove Bombs from Vehicles**: Safely disarm and remove bombs from vehicles.
- **Customizable Configurations**: Adjust bomb types, speed units, and other settings through the `config.lua` file.

## Installation

1. **Download**: Download the script and place it in your server's `resources` folder.
2. **Add to Server Configuration**: Add the following line to your `server.cfg`: ensure tr_carbomb
3. **Configure**: Edit the `config.lua` file to customize the settings according to your server's needs.

## Configuration

The `config.lua` file allows you to customize various aspects of the script:

```lua
Config = {}

-- Set this to 'esx' or 'qb' depending on your framework
Config.Framework = 'esx'

-- Set this to the inventory system you are using. 'ox' for ox_inventory or 'qb' for qb-inventory
Config.Inventory = 'ox'

-- Item names
Config.BombItem = 'car_bomb'
Config.RemoverItem = 'car_bomb_remover'

-- Speed Unit 'kmh' or 'mph'
Config.SpeedUnit = 'kmh'

-- Interaction distance
Config.InteractionDistance = 2.0

-- Bomb planting duration (in ms)
Config.PlantDuration = 5000
```
## Configuration Options

- Framework: Choose between 'esx' and 'qb' frameworks.

- Inventory: Choose the inventory system ('ox' for ox_inventory or 'qb' for qb-inventory).

- BombItem: The item required to plant a bomb (car_bomb by default).

- RemoverItem: The item required to remove a bomb (car_bomb_remover by default).

- SpeedUnit: Set the speed unit to either 'kmh' or 'mph'.

- InteractionDistance: The distance within which players can interact with vehicles to plant or remove bombs.

- PlantDuration: The time it takes to plant a bomb (in milliseconds).

## Exploding Conditions

    - Enter Bomb: Detonates when a player enters the vehicle.
    - Engine Bomb: Detonates when the engine is started.
    - Speed Bomb: Detonates when the vehicle reaches the specified speed.

## Dependencies

    - Framework: Compatible with both ESX and QB-Core frameworks.
    - Inventory: Compatible with ox_inventory and qb-inventory.
    - ox_lib
