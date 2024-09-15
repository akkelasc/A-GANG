local gangs = {}  -- Tallenna jengit t�h�n
local playerGangs = {}  -- Tallenna pelaajien jengit

-- Luo jengi
RegisterServerEvent('gangs:create')
AddEventHandler('gangs:create', function(gangName)
    local _source = source
    if not gangs[gangName] then
        gangs[gangName] = { members = {} }
        TriggerClientEvent('gangs:notify', _source, 'Gang created: ' .. gangName)
    else
        TriggerClientEvent('gangs:notify', _source, 'Gang already exists!')
    end
end)

-- Liity jengiin
RegisterServerEvent('gangs:join')
AddEventHandler('gangs:join', function(gangName)
    local _source = source
    if gangs[gangName] then
        playerGangs[_source] = gangName
        table.insert(gangs[gangName].members, _source)
        TriggerClientEvent('gangs:notify', _source, 'You joined gang: ' .. gangName)
    else
        TriggerClientEvent('gangs:notify', _source, 'Gang does not exist!')
    end
end)

-- J�t� jengi
RegisterServerEvent('gangs:leave')
AddEventHandler('gangs:leave', function()
    local _source = source
    local gangName = playerGangs[_source]
    if gangName then
        local index = table.indexOf(gangs[gangName].members, _source)
        if index then
            table.remove(gangs[gangName].members, index)
        end
        playerGangs[_source] = nil
        TriggerClientEvent('gangs:notify', _source, 'You left the gang.')
    else
        TriggerClientEvent('gangs:notify', _source, 'You are not in any gang.')
    end
end)

-- T�h�n voi lis�t� muita toimintoja, kuten jengialueet tai teht�v�t
local gangs = {}

-- Tarkista onko pelaaja admin
local function isAdmin(source)
    -- T�ss� esimerkiss� tarkistetaan admin-tunniste
    local userId = GetPlayerIdentifier(source)
    return userId and userId:match("steam:")  -- Esimerkki, vaihda admin-tarkistus omaan toteutukseen
end

RegisterServerEvent('gangadmin:createGang')
AddEventHandler('gangadmin:createGang', function(gangName)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('gangs:notify', _source, 'Sinulla ei ole oikeuksia luoda jengej�!')
        return
    end

    if not gangs[gangName] then
        gangs[gangName] = { members = {} }
        TriggerClientEvent('gangs:notify', -1, 'Jengi luotu: ' .. gangName)
        TriggerClientEvent('gangadmin:receiveGangs', -1, getGangsList())
    else
        TriggerClientEvent('gangs:notify', _source, 'Jengi on jo olemassa!')
    end
end)

RegisterServerEvent('gangadmin:listGangs')
AddEventHandler('gangadmin:listGangs', function()
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('gangs:notify', _source, 'Sinulla ei ole oikeuksia listata jengej�!')
        return
    end
    TriggerClientEvent('gangadmin:receiveGangs', _source, getGangsList())
end)

RegisterServerEvent('gangadmin:deleteGang')
AddEventHandler('gangadmin:deleteGang', function(gangName)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('gangs:notify', _source, 'Sinulla ei ole oikeuksia poistaa jengej�!')
        return
    end

    if gangs[gangName] then
        gangs[gangName] = nil
        TriggerClientEvent('gangs:notify', -1, 'Jengi poistettu: ' .. gangName)
        TriggerClientEvent('gangadmin:receiveGangs', -1, getGangsList())
    else
        TriggerClientEvent('gangs:notify', _source, 'Jengi� ei l�ydy!')
    end
end)

function getGangsList()
    local gangList = {}
    for gangName, _ in pairs(gangs) do
        table.insert(gangList, gangName)
    end
    return gangList
end
RegisterServerEvent('checkAdminStatus')
AddEventHandler('checkAdminStatus', function()
    local _source = source
    local isAdmin = isAdmin(_source) -- Tarkista onko pelaaja admin
    TriggerClientEvent('adminStatus', _source, isAdmin)
end)

