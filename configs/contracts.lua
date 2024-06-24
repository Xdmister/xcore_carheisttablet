local contracts = {}


contracts.missions = {
    -- sedans
    {
        name = "Superd", -- The name that will be displayed on the tablet
        price = 241, -- A price that will be further multiplied by a random multiplier
        chance = 90, -- The chance that determines whether the order is added to the contract or not
        vehicle_model = "superd", -- The name of the model you use when spawning a car
        vehicle_img = "./customimgs/Superd.png", -- Name your car image. Please upload the image to html/customimgs, just rewrite the name of the image here
        category = "Sedans", -- Category doesn't matter much. It's just for tablet viewing.
        dispatchinfo = true, -- This line determines whether or not the police dispatch should be sent for this car
        locator = true, -- The locator determines whether the police location will be displayed for this car during the transfer of the car to the container. In a later update, I want to make an item that will remove the locator
        spawn_positions = { -- A position where a vehicle can randomly spawn anywhere
            {x = -2336.4841, y = 284.3604, z = 169.4671, heading = 292.8767},
            {x = -687.4128, y = 502.0818, z = 110.0786, heading = 203.0244}
        },
        quanta_mission = { -- The number of contracts to be added during generation if this contract is randomly selected. A minimum of 0 and a maximum of 0 means 1. If you give 0 and 1, the number of contracts is added by 2
            min = 0,
            max = 0,
        },
        randomPriceMultipler = { -- A random multiplier that multiplies the main price of the car. You can also set it so that the price is flaot by setting 0 0 here, and for price you put the main price.
            min = 50,
            max = 60
        },
    },
    {
        name = "Emperor",
        price = 180,
        chance = 90,
        vehicle_model = "emperor",
        vehicle_img = "./customimgs/emperor.png",
        category = "Sedans",
        dispatchinfo = true,
        spawn_positions = {
            {x = -16.0674, y = -1405.4603, z = 29.3164, heading = 87.6874},
            {x = -327.7153, y = -1528.7511, z = 27.5357, heading = 181.4476},
            {x = 72.7485, y = -1921.0145, z = 21.0193, heading = 46.3479},
            {x = 329.0505, y = -2030.8922, z = 21.0425, heading = 322.6603},
            {x = -66.1844, y = -2101.9319, z = 16.7048, heading = 194.3125}
        },
        quanta_mission = {
            min = 0,
            max = 0,
        },
        randomPriceMultipler = {
            min = 30,
            max = 40
        },
    },
    {
        name = "Stanier",
        price = 220,
        chance = 90,
        vehicle_model = "stanier",
        vehicle_img = "./customimgs/stanier.png",
        category = "Sedans",
        dispatchinfo = true,
        locator = true,
        spawn_positions = {
            {x = -298.5148, y = -774.8691, z = 53.2463, heading = 160.3038},
            {x = -456.1511, y = -785.2790, z = 45.0187, heading = 86.0093},
            {x = -692.3700, y = -742.9467, z = 37.9987, heading = 180.9421},
            {x = -1113.2938, y = -854.0350, z = 13.5146, heading = 220.8270},
            {x = 835.4631, y = -794.9298, z = 26.2767, heading = 295.9974}
        },
        quanta_mission = {
            min = 0,
            max = 0,
        },
        randomPriceMultipler = {
            min = 50,
            max = 55
        },
    },
    {
        name = "Primo",
        price = 224,
        chance = 80,
        vehicle_model = "primo",
        vehicle_img = "./customimgs/primo.png",
        category = "Sedans",
        dispatchinfo = true,
        locator = true,
        spawn_positions = {
            {x = -298.5148, y = -774.8691, z = 53.2463, heading = 160.3038},
            {x = -456.1511, y = -785.2790, z = 45.0187, heading = 86.0093},
            {x = -692.3700, y = -742.9467, z = 37.9987, heading = 180.9421},
            {x = -1113.2938, y = -854.0350, z = 13.5146, heading = 220.8270},
            {x = 835.4631, y = -794.9298, z = 26.2767, heading = 295.9974}
        },
        quanta_mission = {
            min = 0,
            max = 0,
        },
        randomPriceMultipler = {
            min = 50,
            max = 55
        },
    },

-- offroads
{
    name = "Dune special",
    price = 400,
    chance = 10,
    vehicle_model = "dune2",
    vehicle_img = "./customimgs/dune2.png",
    category = "Off-Road",
    dispatchinfo = true,
    locator = true,
    spawn_positions = {
        {x = 2330.3579, y = 2571.4543, z = 46.1505, heading = 168.2530}
    },
    quanta_mission = {
        min = 0,
        max = 0,
    },
    randomPriceMultipler = {
        min = 120,
        max = 125
    },
},



-- sports classic
    {
        name = "Infernus",
        price = 323,
        chance = 40,
        vehicle_model = "infernus2",
        vehicle_img = "./customimgs/Infernus2.png",
        category = "Sports Classic",
        dispatchinfo = true,
        locator = true,
        spawn_positions = {
            {x = -1018.8010, y = 694.7354, z = 161.2816, heading = 350.7490},
            {x = -1113.2533, y = 768.8680, z = 163.4492, heading = 22.6960}
        },
        quanta_mission = {
            min = 0,
            max = 0,
        },
        randomPriceMultipler = {
            min = 70,
            max = 80
        },
    },
    
    
    
    -- sports
    {
        name = "Banshee",
        price = 350,
        chance = 30,
        vehicle_model = "banshee",
        vehicle_img = "./customimgs/banshee.png",
        category = "Sports",
        dispatchinfo = true,
        locator = true,
        spawn_positions = {
            {x = 442.7047, y = 253.7239, z = 103.2097, heading = 246.9267},
            {x = 769.4183, y = 222.5178, z = 86.0349, heading = 239.6772}
        },
        quanta_mission = {
            min = 0,
            max = 0,
        },
        randomPriceMultipler = {
            min = 80,
            max = 90
        },
    },
    {
        name = "Deveste",
        price = 400,
        chance = 30,
        vehicle_model = "deveste",
        vehicle_img = "./customimgs/deveste.png",
        category = "Sports",
        dispatchinfo = true,
        locator = true,
        spawn_positions = {
            {x = 879.8799, y = -17.8626, z = 78.7640, heading = 235.1615},
            {x = 716.0515, y = 657.2031, z = 128.9111, heading = 15.1664}
        },
        quanta_mission = {
            min = 0,
            max = 0,
        },
        randomPriceMultipler = {
            min = 80,
            max = 90
        },
    },

    -- suvs
    {
        name = "Gresley",
        price = 260,
        chance = 60,
        vehicle_model = "gresley",
        vehicle_img = "./customimgs/gresley.png",
        category = "SUVs",
        dispatchinfo = true,
        locator = true,
        spawn_positions = {
            {x = 336.1678, y = -207.0286, z = 54.0863, heading = 252.9556},
            {x = 914.5582, y = -626.6002, z = 58.0490, heading = 310.5815},
            {x = 1016.1085, y = -770.8658, z = 57.9034, heading = 132.5995},
        },
        quanta_mission = {
            min = 0,
            max = 0,
        },
        randomPriceMultipler = {
            min = 55,
            max = 60
        },
    },
}

return contracts