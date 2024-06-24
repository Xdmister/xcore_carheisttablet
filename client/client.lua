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



-- menu
function openMenu(show, data)
    if show then
        TriggerServerEvent(GetCurrentResourceName() .. ":getmissions")
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "open_menu",
            data = data
        })
    else
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "close_menu",
            data = data
        })
    end
end

Citizen.Wait(100)
RegisterNUICallback('close_menu', function(data, cb)
    local data = {
        rcs = data.menu,
        rscname = GetCurrentResourceName()
    }
    openMenu(false, data)
end)
-- menu







RegisterNUICallback(GetCurrentResourceName() .. ":start_offer", function(data, cb)
    TriggerServerEvent(GetCurrentResourceName() .. ":start_offer", data)
    local data = {
        rcs = "tablet",
        rscname = GetCurrentResourceName(),
        start_offer = true
    }
    openMenu(false, data)
end)




RegisterNetEvent(GetCurrentResourceName() .. ':offer_data')
AddEventHandler(GetCurrentResourceName() .. ':offer_data', function(offers)
    local data = {
        offers = offers
    }


    SendNUIMessage({
        type = "offer_list",
        data = data
    })
end)




RegisterNetEvent(GetCurrentResourceName() .. 'carAlarmActivated')
AddEventHandler(GetCurrentResourceName() .. 'carAlarmActivated', function(vehicleNetId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    SetVehicleAlarm(vehicle, true)
    StartVehicleAlarm(vehicle)
end)






RegisterNetEvent("xcore_carheisttablet:opentablet")
AddEventHandler("xcore_carheisttablet:opentablet", function()
    if lib.progressCircle({
            duration = 500,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
        }) then
        local data = {
            rcs = "tablet",
            rscname = GetCurrentResourceName()
        }
        openMenu(true, data)
    end
end)


local created_blips = {}

RegisterNetEvent(GetCurrentResourceName() .. 'c_blip_sync')
AddEventHandler(GetCurrentResourceName() .. 'c_blip_sync', function(coordinatesTable)
    if type(coordinatesTable) == "table" then
        -- Odstranit existující blipy
        for _, existingBlip in ipairs(created_blips) do
            RemoveBlip(existingBlip)
        end
        created_blips = {}

        -- Procházet tabulkou souřadnic
        for _, coordData in ipairs(coordinatesTable) do
            local coords = coordData.coords

            print("sync_blip_02")
            local blip = nil
            local sec_blip = nil
            if config.settings.type_blip == "area" then
                local coords_l = vector3(
                    coords.x + math.random((config.settings.area_blip_radius / 2) * -1, config.settings.area_blip_radius / 2),
                    coords.y + math.random((config.settings.area_blip_radius / 2) * -1, config.settings.area_blip_radius / 2),
                    coords.z
                )
                blip = Create_blip_area(coords_l, 3, config.settings.area_blip_radius)
                sec_blip = C_blip(coords_l, lang.blip_stoled_car, 227, 3)
            elseif config.settings.type_blip == "icon" then
                blip = C_blip(coords, lang.blip_stoled_car, 227, 3)
            else
                blip = C_blip(coords, lang.blip_stoled_car, 227, 3)
            end
            
            table.insert(created_blips, blip)

            Citizen.CreateThread(function()
                local sec_blip_2 = sec_blip
                Citizen.Wait(config.settings.blip_interval)
                if sec_blip_2 ~= nil then
                    RemoveBlip(sec_blip_2)
                end
                for i, b in ipairs(created_blips) do
                    if b == blip then
                        RemoveBlip(b)
                        table.remove(created_blips, i)
                        break
                    end
                end
            end)
        end
    end
end)



function C_blip(coords, text, sprite, color)
    print("sync_blip_01")
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end



function Create_blip_area(cord, color, radius)
    local radiusBlip = AddBlipForRadius(cord.x, cord.y, cord.z, radius)
    SetBlipColour(radiusBlip, color)
    SetBlipAlpha(radiusBlip, 100)
    SetBlipHighDetail(radiusBlip, false)
    SetBlipAsShortRange(radiusBlip, false)
    return radiusBlip
end
