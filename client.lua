local Framework = nil
local bombedVehicles = {}

CreateThread(function()
    if Config.Framework == 'esx' then
        Framework =  exports['es_extended']:getSharedObject()
    elseif Config.Framework == 'qb' then
        Framework = exports['qb-core']:GetCoreObject()
    end
end)

local function GetVehicleIdentifier(vehicle)
    return NetworkGetNetworkIdFromEntity(vehicle)
end

local function SetCarBomb(vehicle, bombType, speed)
    local identifier = GetVehicleIdentifier(vehicle)
    bombedVehicles[identifier] = {
        type = bombType,
        speed = speed,
        exploded = false
    }
end

local function RemoveCarBomb(vehicle)
    local identifier = GetVehicleIdentifier(vehicle)
    bombedVehicles[identifier] = nil
end

local function ExplodeVehicle(vehicle)
    local coords = GetEntityCoords(vehicle)
    AddExplosion(coords.x, coords.y, coords.z, 7, 100.0, true, false, 1.0)
    SetEntityHealth(vehicle, 0)
end

local function HasItem(item)
    if Config.Inventory == 'ox' then
        local hasItem = exports.ox_inventory:Search('count', item)
        return hasItem > 0
    elseif Config.Inventory == 'qb' then
        return Framework.Functions.HasItem(item)
    end
    return false
end


RegisterNetEvent('carBomb:placeBomb')
AddEventHandler('carBomb:placeBomb', function(data)
    local playerPed = PlayerPedId()
    local vehicle = data.entity

    if HasItem(Config.BombItem) then
        local success = lib.skillCheck({'easy', 'medium', 'medium'}, {'w','a','s','d'})
        if success then
            lib.progressCircle({
                duration = Config.PlantDuration,
                label = 'Planting bomb...',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                    clip = 'machinic_loop_mechandplayer'
                },
                prop = {
                    model = `prop_bomb_01`,
                    pos = vec3(0.12, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0)
                },
            })

            TriggerServerEvent('carBomb:removeItem', Config.BombItem)

            local input = lib.inputDialog('Set Bomb', {
                {type = 'select', label = 'Bomb Type', options = {
                    {label = 'Explode when someone enters in vehicle', value = 'enter'},
                    {label = 'Explode when engine starts', value = 'engine'},
                    {label = 'Explode at specific speed', value = 'speed'}
                }},
            })

            if input then
                local bombType = input[1]
                local speed = nil

                if bombType == 'speed' then
                    local speedInput = lib.inputDialog('Set Speed', {
                        {type = 'number', label = 'Speed (' ..Config.SpeedUnit.. ')', description = 'Enter the speed at which the bomb will explode'}
                    })
                    if speedInput then
                        speed = speedInput[1]
                    else
                        return
                    end
                end

                SetCarBomb(vehicle, bombType, speed)
                lib.notify({
                    title = 'Success',
                    description = 'Car bomb planted successfully',
                    type = 'success'
                })
            end
        else
            lib.notify({
                title = 'Failed',
                description = 'You failed to plant the bomb',
                type = 'error'
            })
        end
    else
        lib.notify({
            title = 'Error',
            description = 'You don\'t have a car bomb',
            type = 'error'
        })
    end
end)

RegisterNetEvent('carBomb:removeBomb')
AddEventHandler('carBomb:removeBomb', function(data)
    local vehicle = data.entity
    local identifier = GetVehicleIdentifier(vehicle)

    if bombedVehicles[identifier] then
        if HasItem(Config.RemoverItem) then
            local success = lib.skillCheck({'easy', 'medium', 'medium'}, {'w','a','s','d'})
            if success then
                RemoveCarBomb(vehicle)
                TriggerServerEvent('carBomb:removeItem', Config.RemoverItem)
                lib.notify({
                    title = 'Success',
                    description = 'Car bomb removed successfully',
                    type = 'success'
                })
            else
                ExplodeVehicle(vehicle)
                lib.notify({
                    title = 'Failed',
                    description = 'You failed to remove the bomb and it exploded!',
                    type = 'error'
                })
            end
        else
            lib.notify({
                title = 'Error',
                description = 'You don\'t have a car bomb remover',
                type = 'error'
            })
        end
    else
        lib.notify({
            title = 'Info',
            description = 'This vehicle doesn\'t have a bomb',
            type = 'info'
        })
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local identifier = GetVehicleIdentifier(vehicle)
            if bombedVehicles[identifier] and not bombedVehicles[identifier].exploded then
                local bomb = bombedVehicles[identifier]
                if bomb.type == 'enter' then
                    ExplodeVehicle(vehicle)
                    bombedVehicles[identifier].exploded = true
                elseif bomb.type == 'engine' and GetIsVehicleEngineRunning(vehicle) then
                    ExplodeVehicle(vehicle)
                    bombedVehicles[identifier].exploded = true
                elseif bomb.type == 'speed' then
                    local speed = GetEntitySpeed(vehicle) * 3.6
                    if Config.SpeedUnit == 'mph' then
                        speed = speed / 1.60934
                    end
                    if speed >= bomb.speed then
                        ExplodeVehicle(vehicle)
                        bombedVehicles[identifier].exploded = true
                    end
                end
            end
        end
    end
end)


exports.ox_target:addGlobalVehicle({
    {
        name = 'place_car_bomb',
        icon = 'fa-solid fa-bomb',
        label = 'Place Car Bomb',
        event = 'carBomb:placeBomb',
        canInteract = function(entity, distance, coords, name)
            return distance <= Config.InteractionDistance and HasItem(Config.BombItem)
        end
    },
    {
        name = 'remove_car_bomb',
        icon = 'fa-solid fa-bomb',
        label = 'Remove Car Bomb',
        event = 'carBomb:removeBomb',
        canInteract = function(entity, distance, coords, name)
            return distance <= Config.InteractionDistance and HasItem(Config.RemoverItem)
        end
    }
})