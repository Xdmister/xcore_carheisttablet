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
local client_config = assert(loadCFGfile("configs/client.config.lua"), "Chyba při zpracování client config souboru")
local lang = assert(loadCFGfile("langues/lang_" .. config.settings.lang .. ".lua"),
    "Chyba při zpracování jazykového souboru")
-- configloader


local pd_count = 0



RegisterNetEvent(GetCurrentResourceName() .. ":get_police")
AddEventHandler(GetCurrentResourceName() .. ":get_police", function(pds)
    pd_count = pds
end)



-- global vars
local mission_vehicle = nil
local dist_blip = nil
local spawn_position = nil
local area_blip = nil
local end_checkpoint = nil
local in_vehicle = false
local avalible_locator = true
local avalbile_stole = true
local sended_blip = false

--
local container = nil
local end_cords = nil
local in_mission = false

RegisterNetEvent(GetCurrentResourceName() .. ':offer_start')
AddEventHandler(GetCurrentResourceName() .. ':offer_start', function(offer)
    if avalbile_stole then
        if in_mission == false then
            TriggerServerEvent(GetCurrentResourceName() .. ":getpds")
            if pd_count >= config.police.minimumrequier then
                in_mission = true
                start_offer(offer)
            else
                client_config.sendNotify({

                    description = lang.minimumpd,
                    position = "top",
                    type = "error",
                    duration = 10000,
                })
            end
        else
            client_config.sendNotify({
                description = lang.alreday_have,
                position = "top",
                type = "error",
                duration = 10000,
            })
        end
    else
        client_config.sendNotify({
            title = 'CHT',
            description = lang.cooldown_stole,
            position = "top",
            type = "error",
            duration = 3000,
        })
    end
end)



RegisterNUICallback(GetCurrentResourceName() .. ":cancel_offer", function(data, cb)
    TriggerServerEvent(GetCurrentResourceName() .. ":cancel_offer", data)
    reset()
end)

function reset()
    if in_mission then
        in_mission = false
        Restart_mission()
    end
end

function start_offer(offer)
    spawn_position = json.decode(offer.spawn_position)

    if offer ~= nil then
        if GetDistance(GetEntityCoords(PlayerPedId()), spawn_position) >= 100 then
            client_config.sendNotify({
                description = lang.far_from_the_place,
                position = "top",
                type = "inform",
                duration = 3000,
            })
            dist_blip = Create_blip(
                vector3(spawn_position.x + math.random(-50, 50), spawn_position.y + math.random(-50, 50),
                    spawn_position.z),
                lang.far_from_the_place, 1, 1, lang.destination)
        end


        -- cekani na hrace az bude blízko + spawn vozidla
        local value = waitFor(
            function()
                if GetDistance(GetEntityCoords(PlayerPedId()), spawn_position) < 100 then
                    if mission_vehicle == nil then
                        dist_blip = Rem_blip(dist_blip)
                        ESX.Game.SpawnVehicle(offer.vehicle_model,
                            vector3(spawn_position.x, spawn_position.y, spawn_position.z), spawn_position.heading,
                            function(vehicle)
                                SetVehicleColours(vehicle, math.random(0, 159), math.random(0, 159))
                                local plate = GetVehicleNumberPlateText(vehicle)
                                client_config.onSpawnVehicle(vehicle, plate)
                                if config.settings.chance_to_unlock_car then
                                    local rand = math.random(1, 5)
                                    if rand ~= 3 then
                                        SetVehicleDoorsLocked(vehicle, 7)
                                    end
                                else
                                    SetVehicleDoorsLocked(vehicle, 7)
                                end

                                Set_v(vehicle)
                            end)

                        return true
                    end
                end
            end,
            function()
                Restart_mission()
                return false
            end,
            30000
        )

        function Set_v(vehicle)
            mission_vehicle = vehicle
        end

        -- cekani na hrace az bude blízko








        -- cekani na nastoupeni auta
        Citizen.Wait(1000)
        if value then
            client_config.sendNotify({
                description = lang.stole_car,
                position = "top",
                type = "inform",
                duration = 5000,
            })

            area_blip = Create_blip_area(
                vector3(spawn_position.x + math.random(-50, 50), spawn_position.y + math.random(-50, 50),
                    spawn_position.z),
                1, 150.0)

            local value_x2 = waitFor(
                function()
                    if mission_vehicle ~= nil then
                        if IsPlayerInVehicle() then
                            if GetVehiclePedIsIn(PlayerPedId(), false) == mission_vehicle then
                                local vehicleNetId = NetworkGetNetworkIdFromEntity(mission_vehicle)
                                TriggerServerEvent(GetCurrentResourceName() .. ":syncalarm", vehicleNetId)
                                return true
                            end
                        end
                    else
                        Restart_mission()
                        return false
                    end
                end,
                function()
                    Restart_mission()
                    return false
                end,
                30000
            )




            Citizen.Wait(1000)
            if value_x2 then
                -- cekani na dojeti k blizkosti
                area_blip = Rem_blip(area_blip)
                client_config.sendNotify({

                    description = lang.end_tx,
                    position = "top",
                    type = "inform",
                    duration = 10000,
                })

                if mission_vehicle ~= nil then
                    local data = {
                        vehicle = mission_vehicle,
                        plate = GetVehicleNumberPlateText(mission_vehicle),
                        coords = GetEntityCoords(mission_vehicle),
                        car_name = GetDisplayNameFromVehicleModel(mission_vehicle)
                    }
                    if offer.dispatchinfo ~= nil then
                        if offer.dispatchinfo then
                            client_config.sendDispatch(data)
                        end
                    end
                end




                end_cords = config.plase_of_destination[math.random(1, #config.plase_of_destination)]

                end_checkpoint = CreateCheckpointAtCoordinates(end_cords)

                dist_blip = Create_blip(vector3(end_cords.x, end_cords.y, end_cords.z), lang.end_dist, 863, 48, lang.destination)



                local value_x3 = waitFor(
                    function()
                        if mission_vehicle ~= nil then
                            -- locator
                            if offer.locator ~= nil then
                                if offer.locator then
                                    if avalible_locator then
                                        if not sended_blip then
                                            if config.settings.blip_on_stolean_car then
                                                local netID = NetworkGetNetworkIdFromEntity(mission_vehicle)
                                                TriggerServerEvent(GetCurrentResourceName() .. ":blip_sync", netID)
                                                sended_blip = true
                                            end
                                        end
                                    end
                                end
                            end
                            -- locator

                            if IsPlayerInVehicle then
                                if GetVehiclePedIsIn(PlayerPedId(), false) == mission_vehicle then
                                    if GetDistance(GetEntityCoords(PlayerPedId()), vector3(end_cords.x, end_cords.y, end_cords.z)) < 200 then
                                        return true
                                    end
                                else
                                    client_config.sendNotify({
                    
                                        description = lang.badcar,
                                        position = "top",
                                        type = "error",
                                        duration = 10000,
                                    })
                                    Restart_mission()
                                    return false
                                end
                            end
                        else
                            Restart_mission()
                            return false
                        end
                    end,

                    function()
                        Restart_mission()
                        return false
                    end,
                    30000
                )
                -- cekani na dojeti k blizkosti


                -- cekani na auto do kontianeru
                if value_x3 then
                    container = CreateObject(config.settings.container_prop_name, end_cords.x, end_cords.y, end_cords.z - 1,
                        false, false, false)
                    FreezeEntityPosition(container, true)
                    SetEntityHeading(container, end_cords.heading)


                    client_config.sendNotify({
    
                        description = lang.txt,
                        position = "top",
                        type = "inform",
                        duration = 10000,
                    })



                    local value_x4 = waitFor(
                        function()
                            if mission_vehicle ~= nil then
                                local headingRad = end_cords.heading * math.pi / 180
                                local deltaX = math.sin(headingRad) * 2.5
                                local deltaY = -math.cos(headingRad) * 2.5
                                deltaX = deltaX * -1
                                deltaY = deltaY * -1

                                if GetVehiclePedIsIn(PlayerPedId(), false) == mission_vehicle then
                                    if GetDistance(GetEntityCoords(PlayerPedId()), vector3(end_cords.x + deltaX, end_cords.y + deltaY, end_cords.z)) < 2 then
                                        dist_blip = Rem_blip(dist_blip)
                                        FreezeEntityPosition(mission_vehicle, true)
                                        return true
                                    end
                                else
                                    client_config.sendNotify({
                    
                                        description = lang.badcar,
                                        position = "top",
                                        type = "error",
                                        duration = 10000,
                                    })
                                    Restart_mission()
                                    return false
                                end
                            else
                                Restart_mission()
                                return false
                            end
                        end,
                        function()
                            Restart_mission()
                            return false
                        end,
                        30000
                    )
                    -- cekani na auto do kontianeru


                    -- cekani na vystoupeni a odchod z konteineru
                    if value_x4 then
                        client_config.sendNotify({
        
                            description = lang.leave,
                            position = "top",
                            type = "inform",
                            duration = 10000,
                        })

                        local value_x5 = waitFor(
                            function()
                                if mission_vehicle ~= nil then
                                    if not IsPlayerInVehicle() then
                                        if GetDistance(GetEntityCoords(PlayerPedId()), vector3(end_cords.x, end_cords.y, end_cords.z)) > 10 then
                                            local vehicles = lib.getNearbyVehicles(
                                                vector3(end_cords.x, end_cords.y, end_cords.z), 5)

                                            if next(vehicles) == nil then
                                                Restart_mission()
                                                return false
                                            end
                                            for _, vehicleData in ipairs(vehicles) do
                                                local vehicleHandle = vehicleData.vehicle
                                                if vehicleHandle == nil then
                                                    Restart_mission()
                                                    return false
                                                else
                                                    if vehicleHandle == mission_vehicle then
                                                        return true
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    Restart_mission()
                                    return false
                                end
                            end,
                            function()
                                Restart_mission()
                                return false
                            end,
                            30000
                        )
                        -- cekani na vystoupeni a odchod z konteineru

                        if value_x5 then
                            local vehicles = lib.getNearbyVehicles(vector3(end_cords.x, end_cords.y, end_cords.z), 10)

                            for _, vehicleData in ipairs(vehicles) do
                                local vehicleHandle = vehicleData.vehicle
                                if vehicleHandle == nil then
                                    Restart_mission()
                                    return false
                                end
                                if vehicleHandle == mission_vehicle then
                                    if mission_vehicle ~= nil then
                                        client_config.onRemoveVehicle(mission_vehicle,
                                            GetVehicleNumberPlateText(mission_vehicle))
                                    end
                                    ESX.Game.DeleteVehicle(vehicleHandle)
                                    if container ~= nil then
                                        if DoesEntityExist(container) then
                                            DeleteEntity(container)
                                        end
                                    end

                                    if end_checkpoint ~= nil then
                                        DeleteCheckpoint(end_checkpoint)
                                    end


                                    container = CreateObject(config.settings.closed_container_prop_name, end_cords.x, end_cords.y,
                                        end_cords.z - 1,
                                        false, false, false)
                                    FreezeEntityPosition(container, true)
                                    SetEntityHeading(container, end_cords.heading)
                                    delayDelete(120000, container)

                                    client_config.sendNotify({
                    
                                        description = lang.finish,
                                        position = "top",
                                        type = "inform",
                                        duration = 10000,
                                    })

                                    avalbile_stole = false
                                    DelayStole()
                                    TriggerServerEvent(GetCurrentResourceName() .. ":paycheck", offer)

                                    local data = {

                                    }

                                    SendNUIMessage({
                                        type = "completed_mission",
                                        data = data
                                    })

                                    SendNUIMessage({
                                        type = "hide_cbtn"
                                    })
                                    mission_vehicle = nil
                                    dist_blip = nil
                                    spawn_position = nil
                                    area_blip = nil
                                    end_checkpoint = nil
                                    in_vehicle = false
                                    container = nil
                                    end_cords = nil
                                    in_mission = false
                                else
                                    Restart_mission()
                                    return false
                                end
                            end
                        end
                    end
                end
            end
        end
        -- cekani na nastoupeni auta
    end
end

function Restart_mission()
    SendNUIMessage({
        type = "hide_cbtn"
    })
    dist_blip = Rem_blip(dist_blip)
    area_blip = Rem_blip(area_blip)


    if container ~= nil then
        if DoesEntityExist(container) then
            DeleteEntity(container)
        end
    end

    if end_checkpoint ~= nil then
        DeleteCheckpoint(end_checkpoint)
    end

    if mission_vehicle ~= nil then
        if DoesEntityExist(mission_vehicle) then
            ESX.Game.DeleteVehicle(mission_vehicle)
        end
    end




    client_config.sendNotify({
        title = 'CHT',
        description = lang.miss_canceled,
        position = "top",
        type = "error",
        duration = 10000,
    })

    mission_vehicle = nil
    dist_blip = nil
    spawn_position = nil
    area_blip = nil
    end_checkpoint = nil
    in_vehicle = false
    container = nil
    end_cords = nil
    in_mission = false
    sended_blip = false
end

function waitFor(cb, tmcb, timeout)
    local timer = 0
    while true do
        timer = timer + 1
        local cbResult = cb()
        if cbResult ~= nil then
            return cbResult
        end

        if timer >= timeout then
            return tmcb()
        end
        Citizen.Wait(0)
    end
end

function GetDistance(source, target)
    if target ~= nil then
        local dx = source.x - target.x
        local dy = source.y - target.y
        local dz = source.z - target.z
        return math.sqrt(dx * dx + dy * dy + dz * dz)
    end
end

function Create_blip_area(cord, color, radius)
    local radiusBlip = AddBlipForRadius(cord.x, cord.y, cord.z, radius)
    SetBlipColour(radiusBlip, color)
    SetBlipAlpha(radiusBlip, 100)
    SetBlipHighDetail(radiusBlip, false)
    SetBlipAsShortRange(radiusBlip, false)
    return radiusBlip
end

function Create_blip(cord, name, blip_sprite, color, name)
    local blip = AddBlipForCoord(cord.x, cord.y, cord.z)
    SetBlipSprite(blip, blip_sprite)
    SetBlipColour(blip, color)
    SetBlipRoute(blip, true)
    SetBlipNameToPlayerName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

function IsPlayerInVehicle()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed, false)
end

function Rem_blip(blip)
    if blip ~= nil then
        RemoveBlip(blip)
        return nil
    end
end

function CreateCheckpointAtCoordinates(end_cords)
    local checkpointRadius = 4.0
    local check = CreateCheckpoint(47, vector3(end_cords.x, end_cords.y, end_cords.z - 4), end_cords.x,
        end_cords.y,
        end_cords.z, checkpointRadius, 0,
        116, 255, 50, 1)
    return check
end

function delayDelete(time, entity)
    Citizen.CreateThreadNow(function()
        Citizen.Wait(time)
        if entity ~= nil then
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end
    end)
end

function DelayStole()
    Citizen.CreateThreadNow(function()
        avalbile_stole = false
        Citizen.Wait(config.settings.cooldown_stole)
        avalbile_stole = true
    end)
end
