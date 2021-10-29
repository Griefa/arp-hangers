-- Code

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('arp-hangers:client:UseJerrycan')
AddEventHandler('arp-hangers:client:UseJerrycan', function()
    local ped = PlayerPedId()
    local inAircraft = IsPedInAnyPlane(ped)
    local inHeli = IsPedInAnyHeli(ped)

    if inAircraft or inHeli then
        local curVeh = GetVehiclePedIsIn(ped, false)
        ARPCore.Functions.Progressbar("reful_aircraft", "Refueling Aircraft ..", 25000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            exports['LegacyFuel']:SetFuel(curVeh, 100)
            ARPCore.Functions.Notify('The aircraft has been refueled', 'success')
            TriggerServerEvent('arp-hangers:server:RemoveItem', 'jerry_can', 1)
            TriggerEvent('inventory:client:ItemBox', ARPCore.Shared.Items['jerry_can'], "remove")
        end, function() -- Cancel
            ARPCore.Functions.Notify('Refueling has been cancelled!', 'error')
        end)
    else
        ARPCore.Functions.Notify('You are not in an aircraft', 'error')
    end
end)
