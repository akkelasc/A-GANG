-- Komento jengin luomiseen
RegisterCommand('createGang', function(source, args, rawCommand)
    local gangName = args[1]
    TriggerServerEvent('gangs:create', gangName)
end, false)

-- Komento liitty‰ jengiin
RegisterCommand('joinGang', function(source, args, rawCommand)
    local gangName = args[1]
    TriggerServerEvent('gangs:join', gangName)
end, false)

-- Komento j‰tt‰‰ jengin
RegisterCommand('leaveGang', function(source, args, rawCommand)
    TriggerServerEvent('gangs:leave')
end, false)

-- N‰yt‰ ilmoitus pelaajalle
RegisterNetEvent('gangs:notify')
AddEventHandler('gangs:notify', function(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end)
RegisterCommand('adminpanel', function()
    -- Tarkista, onko pelaajalla admin-oikeudet ennen hallintapaneelin n‰ytt‰mist‰
    TriggerServerEvent('checkAdminStatus')
end, false)

RegisterNetEvent('adminStatus')
AddEventHandler('adminStatus', function(isAdmin)
    if isAdmin then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'show' })
    else
        TriggerEvent('gangs:notify', 'Sinulla ei ole oikeuksia k‰ytt‰‰ hallintapaneelia!')
    end
end)

RegisterNUICallback('hide', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('createGang', function(data, cb)
    TriggerServerEvent('gangadmin:createGang', data.gangName)
    cb({ success = true })
end)

RegisterNUICallback('listGangs', function(_, cb)
    TriggerServerEvent('gangadmin:listGangs')
    cb('ok')
end)

RegisterNUICallback('deleteGang', function(data, cb)
    TriggerServerEvent('gangadmin:deleteGang', data.gangName)
    cb({ success = true })
end)

RegisterNetEvent('gangadmin:receiveGangs')
AddEventHandler('gangadmin:receiveGangs', function(gangList)
    SendNUIMessage({
        action = 'updateGangList',
        gangs = gangList
    })
end)
