local gangs = {}

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

RegisterServerEvent('bossmenu:createGang')
AddEventHandler('bossmenu:createGang', function(gangName)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Sinulla ei ole oikeuksia luoda jengejä!' } })
        return
    end

    if not gangs[gangName] then
        gangs[gangName] = { members = {} }
        TriggerClientEvent('chat:addMessage', -1, { args = { 'Boss Menu', 'Jengi luotu: ' .. gangName } })
        TriggerClientEvent('bossmenu:receiveGangs', -1, getGangsList())
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Jengi on jo olemassa!' } })
    end
end)

RegisterServerEvent('bossmenu:listGangs')
AddEventHandler('bossmenu:listGangs', function()
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Sinulla ei ole oikeuksia listata jengejä!' } })
        return
    end
    TriggerClientEvent('bossmenu:receiveGangs', _source, getGangsList())
end)

RegisterServerEvent('bossmenu:deleteGang')
AddEventHandler('bossmenu:deleteGang', function(gangName)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Sinulla ei ole oikeuksia poistaa jengejä!' } })
        return
    end

    if gangs[gangName] then
        gangs[gangName] = nil
        TriggerClientEvent('chat:addMessage', -1, { args = { 'Boss Menu', 'Jengi poistettu: ' .. gangName } })
        TriggerClientEvent('bossmenu:receiveGangs', -1, getGangsList())
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Jengiä ei löydy!' } })
    end
end)

RegisterServerEvent('bossmenu:addMember')
AddEventHandler('bossmenu:addMember', function(gangName, playerId)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Sinulla ei ole oikeuksia lisätä jäseniä!' } })
        return
    end

    if gangs[gangName] and not gangs[gangName].members[playerId] then
        gangs[gangName].members[playerId] = true
        TriggerClientEvent('chat:addMessage', -1, { args = { 'Boss Menu', 'Pelaaja lisätty jengiin: ' .. gangName } })
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Jengiä ei löydy tai pelaaja on jo jäsen!' } })
    end
end)

RegisterServerEvent('bossmenu:removeMember')
AddEventHandler('bossmenu:removeMember', function(gangName, playerId)
    local _source = source
    if not isAdmin(_source) then
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Sinulla ei ole oikeuksia poistaa jäseniä!' } })
        return
    end

    if gangs[gangName] and gangs[gangName].members[playerId] then
        gangs[gangName].members[playerId] = nil
        TriggerClientEvent('chat:addMessage', -1, { args = { 'Boss Menu', 'Pelaaja poistettu jengistä: ' .. gangName } })
    else
        TriggerClientEvent('chat:addMessage', _source, { args = { 'Boss Menu', 'Jengiä ei löydy tai pelaaja ei ole jäsen!' } })
    end
end)

function getGangsList()
    local gangList = {}
    for gangName, _ in pairs(gangs) do
        table.insert(gangList, gangName)
    end
    return gangList
end
