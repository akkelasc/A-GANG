-- Komento boss-menuen avaamiseen
RegisterCommand('bossmenu', function()
    TriggerServerEvent('checkAdminStatus')
end, false)

RegisterNetEvent('adminStatus')
AddEventHandler('adminStatus', function(isAdmin)
    if isAdmin then
        print('Boss-menu käytettävissä.')
        -- Komennot boss-menulle
        print('Kirjoita "/creategang [gangName]" luodaksesi jengin.')
        print('Kirjoita "/listgangs" listataksesi jengit.')
        print('Kirjoita "/deletegang [gangName]" poistaaksesi jengin.')
        print('Kirjoita "/addmember [gangName] [playerId]" lisätäksesi jäsenen.')
        print('Kirjoita "/removemember [gangName] [playerId]" poistaaksesi jäsenen.')
    else
        TriggerEvent('chat:addMessage', { args = { 'Boss Menu', 'Sinulla ei ole oikeuksia käyttää tätä!' } })
    end
end)

-- Luo jengi
RegisterCommand('creategang', function(source, args)
    local gangName = table.concat(args, " ")
    if gangName and #gangName > 0 then
        TriggerServerEvent('bossmenu:createGang', gangName)
    else
        TriggerEvent('chat:addMessage', { args = { 'Boss Menu', 'Syötä jengin nimi!' } })
    end
end, false)

-- Listaa jengit
RegisterCommand('listgangs', function()
    TriggerServerEvent('bossmenu:listGangs')
end, false)

-- Poista jengi
RegisterCommand('deletegang', function(source, args)
    local gangName = table.concat(args, " ")
    if gangName and #gangName > 0 then
        TriggerServerEvent('bossmenu:deleteGang', gangName)
    else
        TriggerEvent('chat:addMessage', { args = { 'Boss Menu', 'Syötä jengin nimi!' } })
    end
end, false)

-- Lisää jäsen
RegisterCommand('addmember', function(source, args)
    local gangName = args[1]
    local playerId = args[2]
    if gangName and playerId then
        TriggerServerEvent('bossmenu:addMember', gangName, playerId)
    else
        TriggerEvent('chat:addMessage', { args = { 'Boss Menu', 'Syötä jengin nimi ja pelaajan ID!' } })
    end
end, false)

-- Poista jäsen
RegisterCommand('removemember', function(source, args)
    local gangName = args[1]
    local playerId = args[2]
    if gangName and playerId then
        TriggerServerEvent('bossmenu:removeMember', gangName, playerId)
    else
        TriggerEvent('chat:addMessage', { args = { 'Boss Menu', 'Syötä jengin nimi ja pelaajan ID!' } })
    end
end, false)

RegisterNetEvent('bossmenu:receiveGangs')
AddEventHandler('bossmenu:receiveGangs', function(gangList)
    if #gangList > 0 then
        local gangNames = table.concat(gangList, ", ")
        TriggerEvent('chat:addMessage', { args = { 'Boss Menu', 'Jengit: ' .. gangNames } })
    else
        TriggerEvent('chat:addMessage', { args = { 'Boss Menu', 'Ei jengejä!' } })
    end
end
