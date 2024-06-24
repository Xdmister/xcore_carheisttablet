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
local contracts = assert(loadCFGfile("configs/contracts.lua"), "Chyba při zpracování konfiguračního souboru")
-- configloader


local function getMissionCounts()
    local response = MySQL.prepare.await(
        'SELECT COUNT(*) AS count FROM xcore_carheisttablet_offers')
    return response
end


function new_offer(name, price, vehicle_model, vehicle_img, spawn_position, category, dispatchinfo, locator)
    local res = MySQL.insert.await([[
    INSERT INTO `xcore_carheisttablet_offers` (`id`, `name`, `price`, `vehicle_model`, `vehicle_img`, `spawn_position`, `category`, `dispatchinfo`, `locator`) VALUES
    (NULL, ?, ?, ?, ?, ?, ?, ?, ?);
]],
        { name, price, vehicle_model, vehicle_img, spawn_position, category, dispatchinfo, locator})
    return res
end

MySQL.prepare.await('TRUNCATE TABLE xcore_carheisttablet_offers')






local function shuffle(array)
    local counter = #array
    while counter > 1 do
        local index = math.random(counter)
        array[counter], array[index] = array[index], array[counter]
        counter = counter - 1
    end
    return array
end









Citizen.CreateThreadNow(function()
    while true do
        if getMissionCounts() < config.settings.max_offers then
            local count_generated = 0
            local offers = contracts.missions
            offers = shuffle(offers)
            for _, offer in ipairs(offers) do
                Citizen.Wait(100)
                if offer.name ~= nil
                    and offer.price ~= nil
                    and offer.vehicle_model ~= nil
                    and offer.vehicle_img ~= nil
                    and offer.category ~= nil
                    and offer.spawn_positions ~= nil
                    and offer.quanta_mission ~= nil
                    and offer.randomPriceMultipler ~= nil
                    and offer.chance ~= nil then
                    if math.random(100) <= offer.chance then
                        for i = offer.quanta_mission.min, math.random(offer.quanta_mission.min, offer.quanta_mission.max) do
                            new_offer(
                                offer.name,
                                offer.price * math.random(offer.randomPriceMultipler.min, offer.randomPriceMultipler.max),
                                offer.vehicle_model,
                                offer.vehicle_img,
                                json.encode(offer.spawn_positions[math.random(1, #offer.spawn_positions)]),
                                offer.category,
                                offer.dispatchinfo,
                                offer.locator
                            )
                            count_generated = count_generated + 1
                        end
                    end
                end
            end
        end
        Citizen.Wait(config.settings.duration_regeneration)
    end
end)
