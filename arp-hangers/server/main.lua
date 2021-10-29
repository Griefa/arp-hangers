-- Code

RegisterServerEvent('arp-hangers:server:SetBerthVehicle')
AddEventHandler('arp-hangers:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('arp-hangers:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    
    Config.Locations["berths"][BerthId]["aircraftModel"] = aircraftModel
end)

RegisterServerEvent('arp-hangers:server:SetDockInUse')
AddEventHandler('arp-hangers:server:SetDockInUse', function(BerthId, InUse)
    Config.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('arp-hangers:client:SetDockInUse', -1, BerthId, InUse)
end)

ARPCore.Functions.CreateCallback('arp-hangers:server:GetBusyDocks', function(source, cb)
    cb(Config.Locations["berths"])
end)


ARPCore.Functions.CreateUseableItem("jerry_can", function(source, item)
    local Player = ARPCore.Functions.GetPlayer(source)

    TriggerClientEvent("arp-hangers:client:UseJerrycan", source)
end)

ARPCore.Functions.CreateCallback('arp-hangers:server:GetMyAircrafts', function(source, cb, dock)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)
    local result = exports.ghmattimysql:executeSync('SELECT * FROM player_aircrafts WHERE citizenid=@citizenid AND hanger=@hanger', {['@citizenid'] = Player.PlayerData.citizenid, ['@hanger'] = dock})
    if result[1] ~= nil then
        print(json.encode(result))
        cb(result)
    else
        cb(nil)
    end
end)

ARPCore.Functions.CreateCallback('arp-hangers:server:GetDepotAircrafts', function(source, cb, dock)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)
    local result = exports.ghmattimysql:executeSync('SELECT * FROM player_aircrafts WHERE citizenid=@citizenid AND state=@state', {['@citizenid'] = Player.PlayerData.citizenid, ['@state'] = 1})
    if result[1] ~= nil then
        print(result)
        cb(result)
    else
        cb(nil)
    end
end)

RegisterServerEvent('arp-hangers:server:SetBoatState')
AddEventHandler('arp-hangers:server:SetBoatState', function(plate, state, hanger, fuel)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)
    local result = exports.ghmattimysql:scalarSync('SELECT 1 FROM player_aircrafts WHERE plate=@plate', {['@plate'] = plate})
    if result ~= nil then
        exports.ghmattimysql:execute('UPDATE player_aircrafts SET state=@state, fuel=@fuel WHERE plate=@plate AND citizenid=@citizenid', {['@state'] = state, ['@fuel'] = fuel, ['@plate'] = plate, ['@citizenid'] = Player.PlayerData.citizenid})
        if state == 1 then
            exports.ghmattimysql:execute('UPDATE player_aircrafts SET hanger=@hanger WHERE plate=@plate AND citizenid=@citizenid', {['@hanger'] = hanger, ['@plate'] = plate, ['@citizenid'] = Player.PlayerData.citizenid})
        end
    end
end)
