-- configloader
function loadCFGfile(file)
    local configFile = LoadResourceFile(GetCurrentResourceName(), file)

    if configFile then
        local configFunc, errorMessage = load(configFile)
        if configFunc then
            return configFunc()
        else
            error("Chyba při načítání konfiguračního souboru: " .. errorMessage)
        end
    else
        error("Chyba: Nelze načíst soubor " .. file)
    end
end

local config = assert(loadCFGfile("configs/config.lua"), "Chyba při zpracování konfiguračního souboru")
local client_config = assert(loadCFGfile("configs/client.config.lua"), "Chyba při zpracování konfiguračního souboru")
local lang = assert(loadCFGfile("langues/lang_" .. config.settings.lang .. ".lua"),
    "Chyba při zpracování konfiguračního souboru")
-- configloader




RegisterServerEvent(GetCurrentResourceName() .. ":getmissions")
AddEventHandler(GetCurrentResourceName() .. ":getmissions", function()
    local offers = {}
    local sourceId = source

    local response = MySQL.prepare.await('SELECT * FROM xcore_carheisttablet_offers', {})
    if response ~= nil then
        for _, row in ipairs(response) do
            local order = {
                id = row['id'],
                name = row['name'],
                price = row['price'],
                vehicle_img = row['vehicle_img'],
                category = row['category']
            }

            table.insert(offers, order)
        end
        TriggerClientEvent(GetCurrentResourceName() .. ':offer_data', sourceId, offers)
    end
end)





function get_offer_data(id)
    local offer = MySQL.single.await('SELECT * FROM `xcore_carheisttablet_offers` WHERE `id` = ? LIMIT 1', {
        id
    })
    return offer
end

function remove_offer(id)
    local offer = MySQL.single.await(
        'DELETE FROM `xcore_carheisttablet_offers` WHERE `xcore_carheisttablet_offers`.`id` = ?', {
            id
        })
end

RegisterServerEvent(GetCurrentResourceName() .. ":start_offer")
AddEventHandler(GetCurrentResourceName() .. ":start_offer", function(data)
    local sourceId = source
    local offer_data = get_offer_data(data.offer_id)
    remove_offer(data.offer_id)
    if sourceId ~= nil then
        TriggerClientEvent(GetCurrentResourceName() .. ':offer_start', sourceId, offer_data)
    end
end)

RegisterServerEvent(GetCurrentResourceName() .. ":paycheck")
AddEventHandler(GetCurrentResourceName() .. ":paycheck", function(data)
    local sourceId = source
    local xPlayer = ESX.GetPlayerFromId(sourceId)
    xPlayer.addAccountMoney("money", data.price)
end)

local jobCount = 0
RegisterServerEvent(GetCurrentResourceName() .. ":getpds")
AddEventHandler(GetCurrentResourceName() .. ":getpds", function(data)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local job = xPlayer.getJob().name
        local jobs_names = config.police.jobs_names
        for _, job2 in ipairs(jobs_names) do
            if job == job2 then
                jobCount = jobCount + 1
            end
        end
    end
    TriggerClientEvent(GetCurrentResourceName() .. ":get_police", source, jobCount)
end)






RegisterServerEvent(GetCurrentResourceName() .. ":syncalarm")
AddEventHandler(GetCurrentResourceName() .. ":syncalarm", function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        TriggerClientEvent(GetCurrentResourceName() .. 'carAlarmActivated', -1, vehicleNetId)
    end
end)


local entityNetIds = {}

local function doesEntityExist(entityNetId)
    if NetworkGetEntityFromNetworkId(entityNetId) ~= 0 then
        return true
    end
    return false
end

local function checkEntities()
    for i = #entityNetIds, 1, -1 do
        if not doesEntityExist(entityNetIds[i]) then
            table.remove(entityNetIds, i)
        end
    end
end

RegisterServerEvent(GetCurrentResourceName() .. ":blip_sync")
AddEventHandler(GetCurrentResourceName() .. ":blip_sync", function(entitynetid)
    table.insert(entityNetIds, entitynetid)
    checkEntities()
end)

Citizen.CreateThread(function()
    while true do
        checkEntities()
        local players = GetPlayers()
        local jobs_names = config.police.jobs_names

        for _, playerId in ipairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local job = xPlayer.getJob().name
                for _, job2 in ipairs(jobs_names) do
                    if job == job2 then
                        if playerId ~= nil then
                            local coordinatesTable = {}
                            
                            for _, entityNetId in ipairs(entityNetIds) do
                                local entity = NetworkGetEntityFromNetworkId(entityNetId)
                                if entity then
                                    local coords = GetEntityCoords(entity)
                                    table.insert(coordinatesTable, {entityNetId = entityNetId, coords = coords})
                                end
                            end

                            TriggerClientEvent(GetCurrentResourceName() .. 'c_blip_sync', tonumber(playerId), coordinatesTable)
                        end
                    end
                end
            end
        end
        Citizen.Wait(config.settings.blip_interval)
    end
end)

