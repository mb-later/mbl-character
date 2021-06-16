

RegisterNUICallback("NUIFocusOff", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerEvent('mbl_interact:closeMenu')
end)

RegisterNetEvent('mbl_interact:closeMenu')
AddEventHandler('mbl_interact:closeMenu', function()
    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeMenu"
    })
end)

RegisterNetEvent('mbl_interact:enableSlider')
AddEventHandler('mbl_interact:enableSlider', function()
    FreezeEntityPosition(PlayerPedId(), false)
    SendNUIMessage({
        action = "enableSlider"
    })
end)

RegisterNUICallback("turnOffNUI", function(data, cb)
    local turnOffNUI = true
    SetNuiFocus(false, false)
    FreezeEntityPosition(PlayerPedId(), false)
    Citizen.CreateThread(function()
        while turnOffNUI do
            if IsControlJustPressed(0, 20) then
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "updateMouseSkinMove",
                    text = "<small>PRESS [<span class='text-info'>Z</span>] CONTROL CHARACTER</small>"
                })
                turnOffNUI = false
                break;
            end
            Citizen.Wait(1)
        end
    end)
end)

RegisterNUICallback("toggleNUI", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(false, false)
    local focus = true
    Citizen.CreateThread(function()
        while focus do
            if IsControlJustReleased(0, 20) then
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "resetMouseText"
                })
                focus = false
            end
            Citizen.Wait(1)
        end
    end)
end)

RegisterNUICallback("requestAction", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.trigger == "server" then
            TriggerServerEvent(data.action, data.value)
        elseif data.trigger == "client" then
            TriggerEvent(data.action, data.value)
        end
    end
end)

function tprint (t, s)
    for k, v in pairs(t) do
        local kfmt = '["' .. tostring(k) ..'"]'
        if type(k) ~= 'string' then
            kfmt = '[' .. k .. ']'
        end
        local vfmt = '"'.. tostring(v) ..'"'
        if type(v) == 'table' then
            tprint(v, (s or '')..kfmt)
        else
            if type(v) ~= 'string' then
                vfmt = tostring(v)
            end
            print(type(t)..(s or '')..kfmt..' = '..vfmt)
        end
    end
end

function checkforCallback(data)
    for k, v in pairs(data) do
        for k, v in pairs(v) do
            if v.callback then
                if v.callback.eventArgs == nil then
                    v.callback.eventArgs = {}
                    v.callback.eventArgs.cancelled = true
                else
                    v.callback.eventArgs.cancelled = true
                end

                if v.callback.eventType == "client" then
                    TriggerEvent(v.callback.eventName, v.callback.eventArgs)
                else 
                    TriggerServerEvent(v.callback.eventName, v.callback.eventArgs)
                end
            end
        end
    end
end

RegisterNUICallback("cancelAction", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    checkforCallback(data.response)
end)

RegisterNUICallback("submitForm", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.trigger == "server" then
            TriggerServerEvent(data.action, data.response)
        else
            TriggerEvent(data.action, data.response)
        end
    end
end)

RegisterNUICallback("doCancel", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.post[1] ~= nil then
            for k, v in pairs(data.post) do
                if v.method == "server" then
                    TriggerServerEvent(v.trigger, v.data)
                else
                    Wait(100)
                    TriggerEvent(v.trigger, v.data)
                end
            end
        end
    end
end)

RegisterNetEvent('mbl_interact:simulateClose')
AddEventHandler('mbl_interact:simulateClose', function()
    FreezeEntityPosition(PlayerPedId(), false)
    SendNUIMessage({
        action = "simulateClose",
    })
end)

RegisterNUICallback("colorSave", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.trigger == "client" then
            TriggerEvent(data.action, data)
        else
            TriggerServerEvent(data.action, data)
        end
    end
end)

RegisterNUICallback("sliderActionSkin", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.triggertype == "client" then
            TriggerEvent(data.trigger, data.data)
        else
            TriggerServerEvent(data.trigger, data.data)
        end
    end
end)

RegisterNUICallback("colorPreview", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.trigger == "client" then
            TriggerEvent(data.action, data)
        else
            TriggerServerEvent(data.action, data)
        end
    end
end)

RegisterNUICallback("selectBlip", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.triggertype == "client" then
            TriggerEvent(data.trigger, data.blip)
        else
            TriggerServerEvent(data.trigger, data.blip)
        end
        --TriggerEvent('mbl_interact:closeMenu')
    end
end)

RegisterNUICallback("selectBlipColor", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.triggertype == "client" then
            TriggerEvent(data.trigger, data.color)
        else
            TriggerServerEvent(data.trigger, data.color)
        end
        --TriggerEvent('mbl_interact:closeMenu')
    end
end)

RegisterNetEvent('test')
AddEventHandler('test', function(blip)
    print('test?')
    print('Blip Requested: ', blip)
end)

RegisterNUICallback("doSkinReturn", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.triggertype == "client" then
            TriggerEvent(data.trigger, data.data)
        else
            TriggerServerEvent(data.trigger, data.data)
        end
    end
end)

RegisterNetEvent('mbl_interact:generateMenu')
AddEventHandler('mbl_interact:generateMenu', function(menu, title, cancel, keepOpen, options)
    FreezeEntityPosition(PlayerPedId(), false)
    if keepOpen == nil then
        keepOpen = false
    end
    if options == nil then
        options = {}
    end
    if menu ~= nil then 
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openMenu",
            menuOptions = menu,
            menuTitle = title,
            keepOpen = keepOpen,
            cancel = cancel,
            options = options,
        })
    end
end)

function roundNum(num, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

RegisterNetEvent('mbl_interact:generateForm')
AddEventHandler('mbl_interact:generateForm', function(trigger, triggertype, form, title, center, keepOpen, width, cancel, opt)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local coordsTable = {
        ['x'] = roundNum(coords.x, 3),
        ['y'] = roundNum(coords.y, 3),
        ['z'] = roundNum(coords.z, 3),
        ['h'] = roundNum(heading, 3),
    }
    FreezeEntityPosition(playerPed, false)
    if keepOpen == nil then
        keepOpen = false
    end
    if width == nil or width == 0 then
        width = "350px"
    end
    if form ~= nil then
        Citizen.Wait(200)
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openForm",
            formOptions = form,
            submitTrigger = trigger,
            submitMethod = triggertype,
            menuTitle = title,
            keepOpen = keepOpen,
            cancel = cancel,
            width = width,
            center = center,
            coords = coordsTable,
            json = json.encode(coordsTable),
            opt = opt
        })
    end
end)

RegisterNetEvent('mbl_interact:generateBlips')
AddEventHandler('mbl_interact:generateBlips', function(triggers, cancel)
    FreezeEntityPosition(PlayerPedId(), false)
    if triggers ~= nil then
        SetNuiFocus(true, true)
        SendNUIMessage({
            trigger = triggers.trigger,
            triggertype = triggers.type,
            cancel = cancel,
            action = "openBlips",
        })
    end
end)

RegisterNetEvent('mbl_interact:generateBlipColor')
AddEventHandler('mbl_interact:generateBlipColor', function(triggers, cancel)
    FreezeEntityPosition(PlayerPedId(), false)
    if triggers ~= nil then
        SetNuiFocus(true, true)
        SendNUIMessage({
            trigger = triggers.trigger,
            triggertype = triggers.type,
            cancel = cancel,
            action = "openBlipColor",
        })
    end
end)

--[[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 38) then
            TriggerEvent('mbl_interact:generateBlipColor', { ['trigger'] = "test", ['type'] = "client" }, {{['trigger'] = 'test', ['method'] = "client"}})
        end
    end
end)
]]
local open = false
RegisterNetEvent('mbl_interact:generateColorPicker')
AddEventHandler('mbl_interact:generateColorPicker', function(triggers, title, fdata, options, cancel)    
    FreezeEntityPosition(PlayerPedId(), false)
    if triggers and title then
        if options == nil then
            options = {}
        end

        if cancel == nil then
            cancel = {}
        end

        if options.width == nil or options.width == 0 then
            options.width = "350px"
        end
        open = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "colorPicker",
            triggers = triggers,
            title = title,
            options = options,
            cancel = cancel,
            width = options.width,
            data = fdata
        });
    end
end)

RegisterNetEvent('mbl_interact:generateSkinChangeMenu')
AddEventHandler('mbl_interact:generateSkinChangeMenu', function(title, sliders, options)
    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(true, true)
    SendNUIMessage({
        title = title,
        action = "skinSliders",
        sliders = sliders,
        options = options,
    })
end)

RegisterNetEvent('mbl_interact:generateSlider')
AddEventHandler('mbl_interact:generateSlider', function(options, trigger, triggertype, title, desc, preload, cancel)
    FreezeEntityPosition(PlayerPedId(), false)
    if options ~= nil then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openSlider",
            data = options,
            trigger = trigger,
            method = triggertype,
            menuTitle = title,
            description = desc,
            preloads = preload,
            cancel = cancel
        })
    end
end)

RegisterNUICallback("sliderAction", function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    if data ~= nil then
        if data.trigger == "server" then
            TriggerServerEvent(data.action, data.response)
        else
            TriggerEvent(data.action, data.response)
        end
    end
end)

RegisterNetEvent('mbl_interact:test')
AddEventHandler('mbl_interact:test', function(result)
    print('Test 1 Trigger')
    tprint(result)
end)

RegisterNetEvent('mbl_interact:test2')
AddEventHandler('mbl_interact:test2', function(result)
    print('Test 2 Trigger')
    tprint(result)
end)

function openForm()
    local options = {  
                    { ['label'] = "Aldi A3 testing a long ass name be", ['data'] = { ['model'] = "aa3", ['price'] = 1600, ['trigger'] = "mbl_interact:test2", ['triggerType'] = "client"} },
                    { ['label'] = "Aldi A2", ['data'] = { ['model'] = "aa2", ['price'] = 163550, ['trigger'] = "mbl_interact:test2", ['triggerType'] = "client"} },
                    { ['label'] = "Aldi A4", ['data'] = { ['model'] = "aa4", ['price'] = 16350, ['trigger'] = "mbl_interact:test2", ['triggerType'] = "client"} },
                }
    TriggerEvent('mbl_interact:generateSlider', options, 'mbl_interact:test', 'client', "Slider Title", "Slider Description can go here including any <span class='text-success'>HTML Formatting</span>", {vehicle = true})
end

