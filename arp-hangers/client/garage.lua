local CurrentHanger = nil
local ClosestHanger = nil

Citizen.CreateThread(function()
    while true do

        local inRange = false
        local ped = PlayerPedId()
        local Pos = GetEntityCoords(ped)

        for k, v in pairs(Config.Hangers) do
            local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

            if TakeDistance < 50 then
                ClosestHanger = k
                inRange = true
                PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                local inAircraft = IsPedInAnyPlane(ped)
                local inHeli = IsPedInAnyHeli(ped)

                if inAircraft or inHeli then
                    DrawMarker(34, v.coords.put.x, v.coords.put.y, v.coords.put.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.7, 1.7, 1.7, 255, 55, 15, 255, false, false, false, true, false, false, false)
                    if PutDistance < 2 then
                        if inAircraft or inHeli then
                            DrawText3D(v.coords.put.x, v.coords.put.y, v.coords.put.z, '~g~E~w~ - Store Aircraft')
                            if IsControlJustPressed(0, 38) then
                                RemoveVehicle()
                            end
                        end
                    end
                end

                if not inAircraft or inHeli then
                    DrawMarker(23, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ - Hangar Garage')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentHanger = nil
                        elseif IsControlJustPressed(0, 38) and Menu.hidden then
                            MenuGarage()
                            Menu.hidden = not Menu.hidden
                            CurrentHanger = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestHanger ~= nil then
                    ClosestHanger = nil
                end
            end
        end

        for k, v in pairs(Config.Depots) do
            local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

            if TakeDistance < 50 then
                ClosestHanger = k
                inRange = true
                PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                local inAircraft = IsPedInAnyPlane(ped)
                local inHeli = IsPedInAnyHeli(ped)

                if not inAircraft or inHeli then
                    DrawMarker(23, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '~g~E~w~ - Aircraft Depot')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentHanger = nil
                        elseif IsControlJustPressed(0, 38) and Menu.hidden then
                            MenuBoatDepot()
                            Menu.hidden = not Menu.hidden
                            CurrentHanger = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestHanger ~= nil then
                    ClosestHanger = nil
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(4)
    end
end)

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function RemoveVehicle()
    local ped = PlayerPedId()
    local inAircraft = IsPedInAnyPlane(ped)
    local inHeli = IsPedInAnyHeli(ped)

    if inAircraft or inHeli then
        local CurVeh = GetVehiclePedIsIn(ped)
        local totalFuel = exports['LegacyFuel']:GetFuel(CurVeh)
        TriggerServerEvent('arp-hangers:server:SetBoatState', Trim(GetVehicleNumberPlateText(CurVeh)), 1, ClosestHanger, totalFuel)

        ARPCore.Functions.DeleteVehicle(CurVeh)
        SetEntityCoords(ped, Config.Hangers[ClosestHanger].coords.take.x, Config.Hangers[ClosestHanger].coords.take.y, Config.Hangers[ClosestHanger].coords.take.z)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Hangers) do
        DockGarage = AddBlipForCoord(v.coords.put.x, v.coords.put.y, v.coords.put.z)

        SetBlipSprite (DockGarage, 569)
        SetBlipDisplay(DockGarage, 4)
        SetBlipScale  (DockGarage, 0.8)
        SetBlipAsShortRange(DockGarage, true)
        SetBlipColour(DockGarage, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(DockGarage)
    end

    for k, v in pairs(Config.Depots) do
        BoatDepot = AddBlipForCoord(v.coords.take.x, v.coords.take.y, v.coords.take.z)

        SetBlipSprite (BoatDepot, 359)
        SetBlipDisplay(BoatDepot, 4)
        SetBlipScale  (BoatDepot, 0.8)
        SetBlipAsShortRange(BoatDepot, true)
        SetBlipColour(BoatDepot, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(BoatDepot)
    end
end)

-- MENU JAAAAAAAAAAAAAA

function MenuBoatDepot()
    ClearMenu()
    ARPCore.Functions.TriggerCallback("arp-hangers:server:GetDepotAircrafts", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles :"

        if result == nil then
            ARPCore.Functions.Notify("You have no vehicles in this Depot", "error", 5000)
            CloseMenu()
        else
            -- Menu.addButton(Config.Depots[CurrentHanger].label, "yeet", Config.Depots[CurrentHanger].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = "In Boathouse"

                if v.state == 1 then
                    state = "In Depot"
                end

                Menu.addButton(v.model, "TakeOutDepotBoat", v, state, "Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage", nil)
    end)
end

function VehicleList()
    ClearMenu()
    ARPCore.Functions.TriggerCallback("arp-hangers:server:GetMyAircrafts", function(result)
        ped = PlayerPedId();
        MenuTitle = "My Vehicles:"

        if result == nil then
            ARPCore.Functions.Notify("You have no aircrafts in this Hanger", "error", 5000)
            CloseMenu()
        else
            
            for k, v in pairs(result) do
                currentFuel = v.fuel
                if v.state == 1 then
                    state = "In Depot"
                elseif v.state == 0 then
                    state = "In Hangar"
                end
                print(v.model)
                print(json.encode(v))
                print(state)
                print(currentFuel)

                Menu.addButton(v.model, "TakeOutVehicle", v, state, "Fuel: "..currentFuel.. "%")
            end
        end

        Menu.addButton("Back", "MenuGarage", nil)
    end, CurrentHanger)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == 0 then
        ARPCore.Functions.SpawnVehicle(vehicle.model, function(veh)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, Config.Hangers[CurrentHanger].coords.put.w)
            exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
            ARPCore.Functions.Notify("vehicle Out: Fuel: "..currentFuel.. "%", "primary", 4500)
            CloseMenu()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            TriggerServerEvent('arp-hangers:server:SetBoatState', GetVehicleNumberPlateText(veh), 0, CurrentHanger)
        end, Config.Hangers[CurrentHanger].coords.put, true)
    else
        ARPCore.Functions.Notify("Your aircraft is not in this hangar", "error", 4500)
    end
end

function TakeOutDepotBoat(vehicle)
    ARPCore.Functions.SpawnVehicle(vehicle.model, function(veh)
        SetVehicleNumberPlateText(veh, vehicle.plate)
        SetEntityHeading(veh, Config.Depots[CurrentHanger].coords.put.w)
        exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
        ARPCore.Functions.Notify("Vehicle Off: Fuel: "..currentFuel.. "%", "primary", 4500)
        CloseMenu()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, Config.Depots[CurrentHanger].coords.put, true)
end

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil)
end

function CloseMenu()
    Menu.hidden = true
    CurrentHanger = nil
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end
