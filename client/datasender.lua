local oldoffers = {}
local newoffers = {"a"}

RegisterNetEvent(GetCurrentResourceName() .. ':offer_data')
AddEventHandler(GetCurrentResourceName() .. ':offer_data', function(offers)
    newoffers = offers
    local data = {
        offers = offers
    }
    

    SendNUIMessage({
        type = "offer_list",
        data = data
    })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if ESX.PlayerData.identifier ~= nil then
            if #oldoffers ~= #newoffers then
                TriggerServerEvent(GetCurrentResourceName() .. ":getmissions")
                oldoffers = newoffers
            end
        end
    end
end)
