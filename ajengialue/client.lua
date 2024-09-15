-- Komento jengialueiden hallintaan
RegisterCommand('createarea', function(source, args)
    local areaName = args[1]
    local coords = { x = tonumber(args[2]), y = tonumber(args[3]), z = tonumber(args[4]) }

    if areaName and coords.x and coords.y and coords.z then
        TriggerServerEvent('gangareas:createArea', areaName, coords)
    else
        TriggerEvent('chat:addMessage', { args = { 'Gang Areas', 'Syötä alueen nimi ja koordinaatit (x, y, z)!' } })
    end
end, false)

RegisterCommand('deletearea', function(source, args)
    local areaName = args[1]
    if areaName then
        TriggerServerEvent('gangareas:deleteArea', areaName)
    else
        TriggerEvent('chat:addMessage', { args = { 'Gang Areas', 'Syötä alueen nimi!' } })
    end
end, false)

RegisterCommand('listareas', function()
    TriggerServerEvent('gangareas:listAreas')
end, false)

RegisterNetEvent('gangareas:receiveAreas')
AddEventHandler('gangareas:receiveAreas', function(areas)
    local areaList = {}
    for name, coords in pairs(areas) do
        table.insert(areaList, string.format('%s: (x: %.2f, y: %.2f, z: %.2f)', name, coords.x, coords.y, coords.z))
    end
    local message = #areaList > 0 and table.concat(areaList, '\n') or 'Ei alueita!'
    TriggerEvent('chat:addMessage', { args = { 'Gang Areas', message } })
end)
