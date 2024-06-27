config = {}

config.settings = {
    lang = "en", -- Customizable language. You can find the languages ​​in the langues folder. Supported language (cz,de,eng,pl,sk)
    duration_regeneration = 1800000, -- The time after which new jobs are generated if they are not above the maximum. 1000ms = 1s
    max_offers = 15, -- Maximum orders after which no new orders are generated
    chance_to_unlock_car = true, -- Chance of an unlocked car after spawning a car
    cooldown_stole = 3600000, --Cooldown during which the car cannot be stolen 1000ms = 1s
    blip_on_stolean_car = true, -- Icon on the map for the police if the car has a locator
    type_blip = "area", -- "icon", "area"
    area_blip_radius = 100.0, -- The radius of the circle in which the thief is
    blip_interval = 5000, -- The interval after which the blip moves to the thief
    dispatch = "aty_dispatch", -- "cd_dispatch", "rcore_dispatch", "core_dispatch", "aty_dispatch","custom"
    fuel = 'ox_fuel', -- 'ox_fuel', 'legacy_fuel', 'ti_fuel', 'x-fuel', 'custom'
    notify = 'ox_lib', -- 'ox_lib', 'okok', 'qs','esx',  custom
    container_prop_name = "prop_container_04mb", -- Name of the prop container
    closed_container_prop_name = "prop_container_03mb" -- Name of the prop container
}
    
config.plase_of_destination = { -- Here are the positions where the car can be transported, you can add more than one
    {x = 133.5878, y = -3093.0820, z = 5.8961, heading = 269.2907},
    {x = 603.9544, y = -3241.9050, z = 6.0696, heading = 176.6810},
    {x = -163.1979, y = -2699.2458, z = 6.0059, heading = 86.6521},
    {x = -314.0900, y = -2778.7717, z = 5.0002, heading = 178.7751},
    {x = 1292.7787, y = -3295.9561, z = 5.9055, heading = 181.8611}
}
config.police = {
    jobs_names = { -- Here are the police job names
        "police",
        "sheriff"
    },
    minimumrequier = 0 -- Police minimum for car theft
}
return config
