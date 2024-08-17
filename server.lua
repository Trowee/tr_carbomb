local Framework = nil

if Config.Framework == 'esx' then
    Framework = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'qb' then
    Framework = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('carBomb:removeItem')
AddEventHandler('carBomb:removeItem', function(item)
    local src = source
    if Config.Framework == 'esx' then
        local xPlayer = Framework.GetPlayerFromId(src)
        xPlayer.removeInventoryItem(item, 1)
    elseif Config.Framework == 'qb' then
        local Player = Framework.Functions.GetPlayer(src)
        Player.Functions.RemoveItem(item, 1)
    end
end)