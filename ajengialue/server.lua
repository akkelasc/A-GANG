local gangAreas = {}

-- Tarkista onko pelaaja admin
local function isAdmin(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in ipairs(identifiers) do
        if id:match("steam:") then
            return true
        end
    end
    return false
end

RegisterServerEvent('gangareas:createArea')
AddEventHandler('gangareas:createArea', function(areaName, coords)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Gang Areas', 'Sinulla ei ole oikeuksia luoda alueita!' } })
        return
    end

    if not gangAreas[areaName] then
        gangAreas[areaName] = coords
        TriggerClientEvent('chat:addMessage', -1, { args = { 'Gang Areas', 'Alue luotu: ' .. areaName } })
        TriggerClientEvent('gangareas:receiveAreas', -1, gangAreas)
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Gang Areas', 'Alue on jo olemassa!' } })
    end
end)

RegisterServerEvent('gangareas:deleteArea')
AddEventHandler('gangareas:deleteArea', function(areaName)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Gang Areas', 'Sinulla ei ole oikeuksia poistaa alueita!' } })
        return
    end

    if gangAreas[areaName] then
        gangAreas[areaName] = nil
        TriggerClientEvent('chat:addMessage', -1, { args = { 'Gang Areas', 'Alue poistettu: ' .. areaName } })
        TriggerClientEvent('gangareas:receiveAreas', -1, gangAreas)
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Gang Areas', 'Aluetta ei löydy!' } })
    end
end)

RegisterServerEvent('gangareas:listAreas')
AddEventHandler('gangareas:listAreas', function()
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Gang Areas', 'Sinulla ei ole oikeuksia listata alueita!' } })
        return
    end
    TriggerClientEvent('gangareas:receiveAreas', _source, gangAreas)
end)

RegisterNetEvent('gangareas:getAreas')
AddEventHandler('gangareas:getAreas', function()
    TriggerClientEvent('gangareas:receiveAreas', source, gangAreas)
end)
