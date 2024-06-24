local function onSpawnVehicle(vehicle, plate)
    print("SPAWN VEHICLE:" .. vehicle .. " Plate:" .. plate)
    if config.settings.fuel == 'ox_fuel' then
        Entity(vehicle).state.fuel = 100.0
    elseif config.settings.fuel == 'legacy_fuel' then
        exports["LegacyFuel"]:SetFuel(vehicle, 100)
    elseif config.settings.fuel == 'ti_fuel' then
        exports["ti_fuel"]:setFuel(vehicle, 100.0)
    elseif config.settings.fuel == 'x-fuel' then
        exports['x-fuel']:SetFuel(vehicle, 100.0)
    elseif config.settings.fuel == 'custom' then
        -- your code for setfuel
    end
end


local function onRemoveVehicle(vehicle, plate)
    print("REMOVE VEHICLE:" .. vehicle .. " Plate:" .. plate)
end





local function sendNotify(data)
    if config.settings.notify == 'ox_lib' then
        lib.notify({
            title = data.title,
            description = data.description,
            position = data.position,
            iconAnimation = data.iconAnimation,
            type = data.type,
            duration = data.duration,
        })
    elseif config.settings.notify == 'okok' then
        exports['okokNotify']:Alert(data.title, data.description, data.duration, data.type, true)
    elseif config.settings.notify == 'qs' then
        exports['qs-notify']:Alert(data.description, data.duration, data.type)
    elseif config.settings.notify == 'esx' then
        ESX.ShowNotification(data.description)
    elseif config.settings.notify == 'custom' then
        -- your code for notify system
    end
end


local function sendDispatch(data)
    print(config.settings.dispatch)
    if config.settings.dispatch == "cd_dispatch" then
        local data2 = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = config.police.jobs_names,
            coords = data.coords,
            title = '10-16 - Krádež vozidla',
            message = 'A ' .. data2.sex .. ' Krade auto s ' .. data.plate .. data2.street,
            flash = 0,
            unique_id = data2.unique_id,
            sound = 1,
            blip = {
                sprite = 225,
                scale = 0.7,
                colour = 1,
                flashes = false,
                text = '911 - Krádež vozidla',
                time = 5,
                radius = 0,
            }
        })
    elseif config.settings.dispatch == "rcore_dispatch" then
        local data = {
            code = '10-16',                    -- string -> The alert code, can be for example '10-64' or a little bit longer sentence like '10-64 - Shop robbery'
            default_priority = 'medium',       -- 'low' | 'medium' | 'high' -> The alert priority
            coords = data.coords,              -- vector3 -> The coords of the alert
            job = config.police.jobs_names,    -- string | table -> The job, for example 'police' or a table {'police', 'ambulance'}
            text = 'Krádež vozidla',           -- string -> The alert text
            type = 'car_robbery',              -- alerts | shop_robbery | car_robbery | bank_robbery -> The alert type to track stats
            blip_time = 5,                     -- number (optional) -> The time until the blip fades
            custom_sound = 'url_to_sound.mp3', -- string (optional) -> The url to the sound to play with the alert
            blip = {                           -- Blip table (optional)
                sprite = 225,                  -- number -> The blip sprite: Find them here (https://docs.fivem.net/docs/game-references/blips/#blips)
                colour = 1,                    -- number -> The blip colour: Find them here (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
                scale = 0.7,                   -- number -> The blip scale
                text = 'Krádež vozidla',       -- number (optional) -> The blip text
                flashes = false,               -- boolean (optional) -> Make the blip flash
                radius = 0,                    -- number (optional) -> Create a radius blip instead of a normal one
            }
        }
        TriggerServerEvent('rcore_dispatch:server:sendAlert', data)
    elseif config.settings.dispatch == "core_dispatch" then
        exports['core_dispatch']:addCall("10-16", "Krádež vozidla", {
        }, data.coords, config.police.jobs_names, 3000, 326, 1)
    elseif config.settings.dispatch == "aty_dispatch" then
        exports["aty_dispatch"]:SendDispatch("Krádež vozidla", "10-16", 225, config.police.jobs_names)
    elseif config.settings.dispatch == "custom" then
        --put your dispatch code here
    end
    -- print("vehicle " .. data.vehicle)
    -- print("coords " .. data.coords)
    -- print("plate" .. data.plate)
    -- print("car_name " .. data.car_name)
end



return {
    sendNotify = sendNotify,
    onSpawnVehicle = onSpawnVehicle,
    onRemoveVehicle = onRemoveVehicle,
    sendDispatch = sendDispatch,
}
