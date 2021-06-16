RLCore = nil
LoginSafe = {}
Login = {}
Login.CreatedPeds = {}
Login.CurrentPed = nil
Login.CurrentPedInfo = nil
Login.Hiding = false
Login.Open = false
LoginSafe.Cam = nil
Login.Selected = false
Login.CurrentClothing = {}
Login.HasTransistionFinished = true
Login.LoadFinished = true
Login.isTrainMoving = false
Login.currentProtected = {}
Login.finished = true
Login.custompeds = {}
local choosingCharacter = false
local cam = nil
Login.actionsBlocked = false

local vehicle = nil
local vehicleBack = nil

local charPed = nil

Citizen.CreateThread(function() 
        while RLCore == nil do
        Citizen.Wait(0)
        TriggerEvent("RLCore:GetObject", function(obj) RLCore = obj end)    
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerEvent('mbl-multicharacterv2:client:chooseChar')
            DisplayRadar(false)
			return
		end
	end
end)

Config = {
    PedCoords = {x = -44.22, y = -575.89, z = 88.71, h = 215.56, r = 1.0}, 
    HiddenCoords = {x = -41.60, y = -576.48, z = 88.73, h = 51.06, r = 1.0}, 
    CamCoords = {x = -43.68, y = -574.19, z = 88.71, h = 251.88, r = 1.0}, 
}


function SetSkin(model, setDefault)
    -- TODO: If not isCop and model not in copModellist, do below.
    -- Model is a hash, GetHashKey(modelName)
    SetEntityInvincible(PlayerPedId(),true)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        player = GetPlayerPed(-1)
        FreezePedCameraRotation(player, true)
        
        if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
            SetPedRandomComponentVariation(GetPlayerPed(-1), true)
        else
            SetPedHeadBlendData(player, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
            SetPedComponentVariation(player, 11, 0, 11, 0)
            SetPedComponentVariation(player, 8, 0, 1, 0)
            SetPedComponentVariation(player, 6, 1, 2, 0)
            SetPedHeadOverlayColor(player, 1, 1, 0, 0)
            SetPedHeadOverlayColor(player, 2, 1, 0, 0)
            SetPedHeadOverlayColor(player, 4, 2, 0, 0)
            SetPedHeadOverlayColor(player, 5, 2, 0, 0)
            SetPedHeadOverlayColor(player, 8, 2, 0, 0)
            SetPedHeadOverlayColor(player, 10, 1, 0, 0)
            SetPedHeadOverlay(player, 1, 0, 0.0)
            SetPedHairColor(player, 1, 1)
        end
        
    end
    SetEntityInvincible(PlayerPedId(),false)
end

RegisterNetEvent("ikincigiris")
AddEventHandler("ikincigiris", function()
    print("girdim2")
    aadss()
end)



aadss = function()
    while RLCore.Functions.GetPlayerData() == nil do
        Wait(0)
    end
    RLCore.Functions.GetPlayerData(function(karkater)
        RLCore.Functions.TriggerCallback('wp-spawn:server:isJailed', function(lmfao, tt)
            print(lmfao)
            print(tt)
            print('+++++++++++++++++++++++++++++++++++++++++++')
            if lmfao == false then
            SetEntityCoords(PlayerPedId(), karkater.position.x, karkater.position.y, karkater.position.z)
            
            if karkater.metadata.isdead then
                DoScreenFadeIn(12)
                TriggerServerEvent("raid_clothes:get_character_current")
                return
            end
            Citizen.Wait(100)
            TriggerEvent("nvd-select:set")
            DoScreenFadeIn(12)
            TriggerServerEvent("raid_clothes:get_character_current")
            
        else
            SetDisplay(false)
            Citizen.Wait(2000)
            SetEntityCoords(PlayerPedId(), 1769.14, 257709, 45.72)
            TriggerServerEvent('wp-houses:server:SetInsideMeta', 0, false)
            Citizen.Wait(500)
            SetEntityCoords(PlayerPedId(), 1769.14, 257709, 45.72)
            SetEntityHeading(PlayerPedId(), 269.01)
            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityVisible(GetPlayerPed(-1), true)
            TriggerServerEvent('RLCore:Server:OnPlayerLoaded')
            TriggerEvent('RLCore:Client:OnPlayerLoaded')
            SwitchIN()
            TriggerEvent('beginJail', tt)
            DoScreenFadeIn(12)
            end
        end)
    end)
end



RegisterNetEvent("yarra")
AddEventHandler("yarra", function()
    TriggerServerEvent("mbl:serverdenclienteyollamaeventi")
end)


RegisterNetEvent('mbl_character:client:setupCharCreation')
AddEventHandler('mbl_character:client:setupCharCreation', function(selectionCoords)   
    print(selectionCoords.x)
    local LocalPlayer = RLCore.Functions.GetPlayerData()
    local gender = LocalPlayer.charinfo.gender
    DisableAllControlActions(0)
    DoScreenFadeOut(1000)

    if gender ~= 0 then
        SetSkin(GetHashKey("mp_f_freemode_01"), true)
    else
        SetSkin(GetHashKey("mp_m_freemode_01"), true)
    end
    local playerPed = PlayerPedId() 

    SetEntityCoords(playerPed, selectionCoords.x, selectionCoords.y, selectionCoords.z, 0,0,0,0)
    SetEntityHeading(playerPed, selectionCoords.h)
    FreezeEntityPosition(playerPed, true)
    SetEntityInvincible(playerPed, true)
    Citizen.Wait(1000)
    local pedCoords = GetEntityCoords(playerPed, true)
    local cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", (selectionCoords.x + 1.4), (selectionCoords.y + 0.03), (selectionCoords.z + 1.5), 0.00, 0.00, 0.00, 75.0, false, 2)
    local cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", (selectionCoords.x + 0.5), (selectionCoords.y + 0.03), (selectionCoords.z + 1.7), 0.00, 0.00, 0.00, 75.0, false, 2)
    local cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", (selectionCoords.x + 0.8), (selectionCoords.y + 0.03), (selectionCoords.z + 0.6), 0.00, 0.00, 0.00, 75.0, false, 2)
    
    cameras = {
        ['clothing'] = cam1,
        ['facial'] = cam2,
        ['shoes'] = cam3
    }
    PointCamAtCoord(cameras.clothing, selectionCoords.x, selectionCoords.y, (selectionCoords.z + 1.0))
    PointCamAtCoord(cameras.facial,  selectionCoords.x, selectionCoords.y, (selectionCoords.z + 1.60))
    PointCamAtCoord(cameras.shoes,  selectionCoords.x, selectionCoords.y,  selectionCoords.z - 0.20)

    SetCamActive(cameras.clothing, true)
    RenderScriptCams(true, true, 500, true, true)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    Citizen.Wait(1001)
    TriggerEvent("raid_clothes:openClothing")
    TriggerEvent("raid_clothes:inSpawn", true)
    SetEntityVisible(playerPed, true, false)
end)


function SetSkin(model, setDefault)
    SetEntityInvincible(PlayerPedId(),true)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while (not HasModelLoaded(model)) do
            Citizen.Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        player = GetPlayerPed(-1)
        FreezePedCameraRotation(player, true)
        
        if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
            SetPedRandomComponentVariation(GetPlayerPed(-1), true)
        else
            SetPedHeadBlendData(player, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
            SetPedComponentVariation(player, 11, 0, 11, 0)
            SetPedComponentVariation(player, 8, 0, 1, 0)
            SetPedComponentVariation(player, 6, 1, 2, 0)
            SetPedHeadOverlayColor(player, 1, 1, 0, 0)
            SetPedHeadOverlayColor(player, 2, 1, 0, 0)
            SetPedHeadOverlayColor(player, 4, 2, 0, 0)
            SetPedHeadOverlayColor(player, 5, 2, 0, 0)
            SetPedHeadOverlayColor(player, 8, 2, 0, 0)
            SetPedHeadOverlayColor(player, 10, 1, 0, 0)
            SetPedHeadOverlay(player, 1, 0, 0.0)
            SetPedHairColor(player, 1, 1)
        end
        
    end
    SetEntityInvincible(PlayerPedId(),false)
end

RegisterNetEvent("mbl-spawn:finishedClothing")
AddEventHandler("mbl-spawn:finishedClothing", function(endType)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local pos = vector3(-3965.88,2014.55, 501.6)
    local distance = #(playerCoords - pos)

    TriggerEvent("raid_clothes:inSpawn", false)
    if distance <= 10 then
    	if endType == "Finished" then
            TriggerEvent("raid_clothes:Spawning", false)
            Citizen.Wait(500)
            DoScreenFadeOut(100)
            FreezeEntityPosition(PlayerPedId(), false)
            SetNuiFocus(false, false)
            EnableAllControlActions(0)
            TriggerEvent("RLCore:Client:OnPlayerLoaded")
            TriggerServerEvent("RLCore:Server:OnPlayerLoaded")
    	else
    		print("yarra yediin")
    	end
    end	
end)





local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}

function SetClothing(ped, drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(ped, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(ped, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(ped, i-1)
        SetPedPropIndex(ped,i-1,propZ,propTextures[i][2], true)
    end
end

function SetFace(player, head, haircolor, headStructure, headOverlay)
    if head then
        SetPedHeadBlendData(player,
            tonumber(head['shapeFirst']),
            tonumber(head['shapeSecond']),
            tonumber(head['shapeThird']),
            tonumber(head['skinFirst']),
            tonumber(head['skinSecond']),
            tonumber(head['skinThird']),
            tonumber(head['shapeMix']),
            tonumber(head['skinMix']),
            tonumber(head['thirdMix']),
        false)
    end

    if headStructure then
        for i = 1, #face_features do
            SetPedFaceFeature(player, i-1, headStructure[i])
        end
    end

    if haircolor then
        SetPedHairColor(player, tonumber(haircolor[1]), tonumber(haircolor[2]))
    end

    if headOverlay then
        if json.encode(headOverlay) ~= "[]" then
            for i = 1, #head_overlays do
                SetPedHeadOverlay(player,  i-1, tonumber(headOverlay[i].overlayValue),  tonumber(headOverlay[i].overlayOpacity))
            end
    
            SetPedHeadOverlayColor(player, 0, 0, tonumber(headOverlay[1].firstColour), tonumber(headOverlay[1].secondColour))
            SetPedHeadOverlayColor(player, 1, 1, tonumber(headOverlay[2].firstColour), tonumber(headOverlay[2].secondColour))
            SetPedHeadOverlayColor(player, 2, 1, tonumber(headOverlay[3].firstColour), tonumber(headOverlay[3].secondColour))
            SetPedHeadOverlayColor(player, 3, 0, tonumber(headOverlay[4].firstColour), tonumber(headOverlay[4].secondColour))
            SetPedHeadOverlayColor(player, 4, 2, tonumber(headOverlay[5].firstColour), tonumber(headOverlay[5].secondColour))
            SetPedHeadOverlayColor(player, 5, 2, tonumber(headOverlay[6].firstColour), tonumber(headOverlay[6].secondColour))
            SetPedHeadOverlayColor(player, 6, 0, tonumber(headOverlay[7].firstColour), tonumber(headOverlay[7].secondColour))
            SetPedHeadOverlayColor(player, 7, 0, tonumber(headOverlay[8].firstColour), tonumber(headOverlay[8].secondColour))
            SetPedHeadOverlayColor(player, 8, 2, tonumber(headOverlay[9].firstColour), tonumber(headOverlay[9].secondColour))
            SetPedHeadOverlayColor(player, 9, 0, tonumber(headOverlay[10].firstColour), tonumber(headOverlay[10].secondColour))
            SetPedHeadOverlayColor(player, 10, 1, tonumber(headOverlay[11].firstColour), tonumber(headOverlay[11].secondColour))
            SetPedHeadOverlayColor(player, 11, 0, tonumber(headOverlay[12].firstColour), tonumber(headOverlay[12].secondColour))
        end
    end
end





function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    choosingCharacter = bool
    skyCam(bool)
end

RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

RegisterNUICallback('selectCharacter', function(data)
    local cData = data.cData
    DoScreenFadeOut(100)
    TriggerServerEvent('mbl-multicharacterv2:server:loadUserData', cData)
    openCharMenu(false)
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerScreenblurFadeOut(150)
    SetFrontendActive(false)
    Citizen.Wait(100)
    N_0x98215325a695e78a(true)
    SetPauseMenuPedLighting(false)
    SetPauseMenuPedSleepState(false)
end)

RegisterNetEvent('mbl-multicharacterv2:client:closeNUI')
AddEventHandler('mbl-multicharacterv2:client:closeNUI', function()
    TriggerScreenblurFadeOut(150)
    SetNuiFocus(false, false)
    
end)


local aasa = false
local Countdown = 1
RegisterNetEvent('mbl-multicharacterv2:client:chooseChar')
AddEventHandler('mbl-multicharacterv2:client:chooseChar', function()
    
    TriggerScreenblurFadeIn(150)
    SetNuiFocus(false, false)
    DoScreenFadeOut(10)
    Citizen.Wait(1000)
    local interior = GetInteriorAtCoords(-814.89, 181.95, 76.85 - 18.9)
    LoadInterior(interior)
    while not IsInteriorReady(interior) do
         Citizen.Wait(1000)
    end
    Citizen.Wait(1500)
    NetworkSetTalkerProximity(0.0)
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    Citizen.Wait(1)
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    openCharMenu(true)
    DoScreenFadeIn(150)
    vehicle = true
    aasa = true
end)








RegisterNetEvent("mbl-spawn:finishedClothing")
AddEventHandler("mbl-spawn:finishedClothing", function(endType)
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local pos = vector3(-3965.88,2014.55, 501.6)
    local distance = #(playerCoords - pos)

    -- TriggerEvent("raid_clothes:inSpawn", false)
    if distance <= 10 then
    	if endType == "Finished" then
            TriggerEvent("raid_clothes:Spawning", false)
            Citizen.Wait(500)
            DoScreenFadeOut(100)
            FreezeEntityPosition(PlayerPedId(), false)
            SetNuiFocus(false, false)
            EnableAllControlActions(0)
            TriggerEvent("RLCore:Client:OnPlayerLoaded")
            TriggerServerEvent("RLCore:Server:OnPlayerLoaded")
    	else

    	end
    end	
end)

function selectChar()
    openCharMenu(true)
end

RegisterNUICallback('cDataPed', function(data)
    SetFrontendActive(false)
    Citizen.Wait(100)
    N_0x98215325a695e78a(true)

    SetPauseMenuPedLighting(false)
    SetPauseMenuPedSleepState(false)
    local cData = data.cData  
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    if cData ~= nil then
        RLCore.Functions.TriggerCallback('mbl-multicharacterv2:server:getSkin', function(data, inf)
            local model = data.model ~= nil and tonumber(data.model) or 1885233650
            if model ~= nil then
                Citizen.CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    charPed = CreatePed(2, model, 306.25, -991.09, -99.99, 89.5, false, true)
                    --//--
                   
                       --//--

                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
    
                    SetClothing(charPed, data.drawables, data.props, data.drawtextures, data.proptextures)
                    SetFace(charPed, data.headBlend, data.hairColor, data.headStructure, data.headOverlay)
                    SetFrontendActive(true)
                    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY"), false, -1)
                    Citizen.Wait(100)
                    N_0x98215325a695e78a(false)
                    
                    local PlayerPedPreview = ClonePed(charPed, GetEntityHeading(charPed), false, false)
                    SetEntityVisible(PlayerPedPreview, false, false)

                    GivePedToPauseMenu(PlayerPedPreview, 2)
                    SetPauseMenuPedLighting(true)
                    SetPauseMenuPedSleepState(true)
                   
                end)
            else
                Citizen.CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end
                    charPed = CreatePed(2, model, 306.25, -991.09, -99.99, 89.5, false, true)
                    SetPedComponentVariation(charPed, 0, 0, 0, 2)
                    FreezeEntityPosition(charPed, false)
                    SetEntityInvincible(charPed, true)
                    PlaceObjectOnGroundProperly(charPed)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                      --//--
                      SetFrontendActive(true)
                      ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY"), false, -1)
  
                      Citizen.Wait(100)
                      N_0x98215325a695e78a(false)
  
                      local PlayerPedPreview = ClonePed(charPed, GetEntityHeading(charPed), false, false)
                      SetEntityVisible(PlayerPedPreview, false, false)
  
                      Wait(200)
                      GivePedToPauseMenu(PlayerPedPreview, 2)
                      SetPauseMenuPedLighting(false)
                      SetPauseMenuPedLighting(false)

                         --//--
                end)
            end
        end, cData.citizenid)
    else
        Citizen.CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            charPed = CreatePed(2, model, 306.25, -991.09, -99.99, 89.5, false, true)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)
              --//--
              SetFrontendActive(true)
              ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY"), false, -1)

              Citizen.Wait(100)
              N_0x98215325a695e78a(false)

              local PlayerPedPreview = ClonePed(charPed, GetEntityHeading(charPed), false, false)
              SetEntityVisible(PlayerPedPreview, false, false)

              Wait(200)
              GivePedToPauseMenu(PlayerPedPreview, 2)
              SetPauseMenuPedLighting(false)
              SetPauseMenuPedSleepState(false)

                 --//--
        end)
    end
end)
--[[
RegisterNUICallback('setupCharacters', function()
    RLCore.Functions.TriggerCallback("mbl-multicharacterv2:server:get:char:data", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end)]]--


RegisterNUICallback('setupCharacters', function()
    RLCore.Functions.TriggerCallback("mbl-multicharacterv2:server:get:char:data", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
    end)
end)


RegisterNUICallback('removeBlur', function()
    SetTimecycleModifier('default')
end)

RegisterNUICallback('createNewCharacter', function(data)
    local cData = data
    openCharMenu(false)
    DoScreenFadeOut(100)
    if cData.gender == "man" then
        cData.gender = 0
    elseif cData.gender == "vrouw" then
        cData.gender = 1
    end
    TriggerServerEvent('mbl-multicharacterv2:server:createCharacter', cData)
    SetFrontendActive(false)
    Citizen.Wait(100)
    N_0x98215325a695e78a(true)

    SetPauseMenuPedLighting(false)
    SetPauseMenuPedSleepState(false)
    Citizen.Wait(500)
    TriggerScreenblurFadeOut(150)
end)

RegisterNUICallback('removeCharacter', function(data)
    SetFrontendActive(false)
    Citizen.Wait(100)
    N_0x98215325a695e78a(true)

    SetPauseMenuPedLighting(false)
    SetPauseMenuPedSleepState(false)
    TriggerServerEvent('mbl-multicharacterv2:server:deleteCharacter', data.citizenid)
end)

function skyCam(bool)
    SetRainFxIntensity(0.0)
    SetWeatherTypePersist('EXTRASUNNY')
    SetWeatherTypeNow('EXTRASUNNY')
    SetWeatherTypeNowPersist('EXTRASUNNY')
    NetworkOverrideClockTime(12, 0, 0)
    if bool then
        DoScreenFadeIn(1000)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(PlayerPedId(), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 30.557178, -1228.419, 61.540588, 0.0, 0.0, 197.09211, 60.00, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end