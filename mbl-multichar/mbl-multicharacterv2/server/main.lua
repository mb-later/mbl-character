RLCore = nil

TriggerEvent('RLCore:GetObject', function(obj) RLCore = obj end)

RLCore.Commands.Add("logout", "Ga naar het karakter menu.", {}, false, function(source, args)
    local src = source
    local Player = RLCore.Functions.GetPlayer(src)
    RLCore.Player.Logout(src)
    Citizen.Wait(650)
    TriggerClientEvent('mbl-multicharacterv2:client:chooseChar', src)
end, "admin")

RegisterServerEvent('mbl-multicharacterv2:server:loadUserData')
AddEventHandler('mbl-multicharacterv2:server:loadUserData', function(cData)
    local src = source
    if RLCore.Player.Login(src, cData.citizenid) then
        RLCore.Commands.Refresh(src)
        loadHouseData()
        TriggerClientEvent("ikincigiris", src)
	end
end)


RLCore.Functions.CreateCallback('wp-spawn:server:isJailed', function(source, cb, cid)
	if cid ~= nil then
		RLCore.Functions.ExecuteSql(false, 'SELECT `metadata` FROM `players` WHERE `citizenid` = "'..cid..'"', function(res)
			if res[1] ~= nil then
				local zzzz = json.decode(res[1].metadata)['injail']
				if tonumber(zzzz) ~= nil and tonumber(zzzz) > 0 then
					print('OK')
					cb(true, tonumber(zzzz))
					return
				end
			end
		end)
	end

	Wait(3000)
	cb(false)
end)

RegisterServerEvent('mbl:setmugshotprofile')
AddEventHandler('mbl:setmugshotprofile',function(url,citizenid)
    RLCore.Functions.ExecuteSql(false,"UPDATE `players` SET `mugshot` = '".. url .."' WHERE `citizenid` = '".. citizenid .."'", function(result) 
    end)
end) 


RegisterServerEvent('mbl-multicharacterv2:server:createCharacter')
AddEventHandler('mbl-multicharacterv2:server:createCharacter', function(data, cid)
    print(data.gender)
    print("old")
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data
    if RLCore.Player.Login(src, false, newData) then
        RLCore.Commands.Refresh(src)
        loadHouseData()
        TriggerClientEvent("mbl-mchar:client:closeNUI", src)
        TriggerClientEvent("yarra", src)
        GiveStarterItems(src)
	end
end)

RegisterServerEvent('mbl-multicharacterv2:server:deleteCharacter')
AddEventHandler('mbl-multicharacterv2:server:deleteCharacter', function(citizenid)
    local src = source
    RLCore.Player.DeleteCharacter(src, citizenid)
end)

RLCore.Functions.CreateCallback("mbl-multicharacterv2:server:get:char:data", function(source, cb)
    local steamId = GetPlayerIdentifiers(source)[1]
    local plyChars = {}
    exports['ghmattimysql']:execute('SELECT * FROM players WHERE steam = @steam', {['@steam'] = steamId}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            table.insert(plyChars, result[i])
        end
        cb(plyChars)
    end)
end)

RLCore.Functions.CreateCallback("mbl-multicharacterv2:server:getSkin", function(source, cb, cid, inf)
    local src = source
    local info = inf
    local char = {}

    exports.ghmattimysql:execute("SELECT * FROM `character_current` WHERE citizenid = '" .. cid .. "'", {}, function(character_current)
        char.model = '1885233650'
        char.drawables = json.decode('{"1":["masks",0],"2":["hair",0],"3":["torsos",0],"4":["legs",0],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",0],"9":["vest",0],"10":["decals",0],"11":["jackets",0],"0":["face",0]}')
        char.props = json.decode('{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]}')
        char.drawtextures = json.decode('[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",2],["neck",0],["undershirts",1],["vest",0],["decals",0],["jackets",11]]')
        char.proptextures = json.decode('[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]')

        if character_current[1] and character_current[1].model then
            char.model = character_current[1].model
            char.drawables = json.decode(character_current[1].drawables)
            char.props = json.decode(character_current[1].props)
            char.drawtextures = json.decode(character_current[1].drawtextures)
            char.proptextures = json.decode(character_current[1].proptextures)
        end

        exports.ghmattimysql:execute("SELECT * FROM `character_face` WHERE citizenid = '" .. cid .. "'", {}, function(character_face)
            if character_face[1] and character_face[1].headBlend then
                char.headBlend = json.decode(character_face[1].headBlend)
                char.hairColor = json.decode(character_face[1].hairColor)
                char.headStructure = json.decode(character_face[1].headStructure)
                char.headOverlay = json.decode(character_face[1].headOverlay)
            end

            cb(char, info)
        end)
    end)
end)

function GiveStarterItems(source)
    local src = source
    local Player = RLCore.Functions.GetPlayer(src)

    for k, v in pairs(RLCore.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "A1-A2-A | AM-B | C1-C-CE"
        end
        Player.Functions.AddItem(v.item, 1, false, info)
    end
end

function loadHouseData()
    local HouseGarages = {}
    local Houses = {}
	RLCore.Functions.ExecuteSql(false, "SELECT * FROM `houselocations`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Houses[v.name] = {
					coords = json.decode(v.coords),
					owned = v.owned,
					price = v.price,
					locked = true,
					adress = v.label, 
					tier = v.tier,
					garage = garage,
					decorations = {},
				}
				HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("bb-garages:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("wp-houses:client:setHouseConfig", -1, Houses)
	end)
end




Config = {}

characterCreatorLocations = {
    [1] = { ['inuse'] = false, ['user'] = 0, ['coords'] = {['x'] = 408.78, ['y'] = -998.57, ['z'] = -99.99, ['h'] = 271.38} },
    [2] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1080.883, ['y'] = -2581.635, ['z'] = 12.868791, ['h'] = 238.68226 } },
    [3] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1079.614, ['y'] = -2579.368, ['z'] = 12.910967, ['h'] = 233.30816 } },
    [4] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1061.471, ['y'] = -2551.254, ['z'] = 12.867659, ['h'] = 236.21859 }},
    [5] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1060.411, ['y'] = -2546.454, ['z'] = 12.918975, ['h'] = 236.14614 } },
    [6] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1053.268, ['y'] = -2534.89, ['z'] = 12.905079, ['h'] = 240.61129 } }, -- Second Row
    [7] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1052.019, ['y'] = -2532.04, ['z'] = 12.916779, ['h'] = 235.48104 } },
    [8] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1044.448, ['y'] = -2522.498, ['z'] = 12.854632, ['h'] = 235.45152 }},
    [9] = { ['inuse'] = false, ['user'] = 0, ['coords'] = { ['x'] = -1032.035, ['y'] = -2501.817, ['z'] = 12.840547, ['h'] = 239.97462 } },
    [10] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1018.235, ['y'] = -2477.965, ['z'] = 12.83963, ['h'] = 242.26033 } },
    [11] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1015.025, ['y'] = -2463.305, ['z'] = 12.944487, ['h'] = 149.05192 } },
    [12] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1007.021, ['y'] = -2453.615, ['z'] = 12.838868, ['h'] = 236.36325 } },
    [13] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1005.226, ['y'] = -2449.782, ['z'] = 12.844983, ['h'] = 241.51422 } },
    [14] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -971.8812, ['y'] = -2393.306, ['z'] = 12.944541, ['h'] = 236.14184 } },
    [15] = { ['inuse'] = false, ['user'] = 0, ['coords']= { ['x'] = -1709.781, ['y'] = -2869.21, ['z'] = 12.944437, ['h'] = 323.71276 } },
    [16] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1031.103, ['y'] = -2745.729, ['z'] = 12.885207, ['h'] = 328.56893 } },
    [17] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1031.99, ['y'] = -2751.532, ['z'] = 13.597828, ['h'] = 56.65039 } },
    [18] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1031.416, ['y'] = -2737.066, ['z'] = 12.756634, ['h'] = 327.43829 } },
    [19] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1047.653, ['y'] = -2735.035, ['z'] = 12.85987, ['h'] = 328.89929 } },
    [20] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1050.417, ['y'] = -2740.965, ['z'] = 13.597834, ['h'] = 334.46539 } },
    [21] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1076.85, ['y'] = -2721.76, ['z'] = 12.776212, ['h'] = 333.37356 } },
    [22] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1083.874, ['y'] = -2710.893, ['z'] = 12.998535, ['h'] = 328.41464 }},
    [23] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1086.012, ['y'] = -2709.613, ['z'] = 13.037909, ['h'] = 327.82897 } },
    [24] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1089.654, ['y'] = -2707.473, ['z'] = 13.105198, ['h'] = 332.42767 } },
    [25] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1092.451, ['y'] = -2705.974, ['z'] = 13.118195, ['h'] = 329.45043 } },
    [26] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1094.72, ['y'] = -2704.693, ['z'] = 13.087555, ['h'] = 335.99749 } },
    [27] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1099.473, ['y'] = -2704.212, ['z'] = 13.023792, ['h'] = 57.538631 } },
    [28] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1102.434, ['y'] = -2704.075, ['z'] = 13.004762, ['h'] = 332.21923 } },
    [29] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1104.195, ['y'] = -2703.035, ['z'] = 13.005142, ['h'] = 333.53515 } },
    [30] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1106.517, ['y'] = -2701.79, ['z'] = 13.003194, ['h'] = 334.75949 } },
    [31] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1107.722, ['y'] = -2700.749, ['z'] = 13.009832, ['h'] = 349.54055 } },
    [32] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1109.444, ['y'] = -2700.086, ['z'] = 13.003273, ['h'] = 323.35638 } },
    [33] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1111.642, ['y'] = -2698.845, ['z'] = 12.002439, ['h'] = 333.47552 } },
    [34] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1113.476, ['y'] = -2697.717, ['z'] = 12.983015, ['h'] = 327.44503 } },
    [35] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1116.994, ['y'] = -2699.928, ['z'] = 12.958355, ['h'] = 54.585739 } },
    [36] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1119.2, ['y'] = -2702.502, ['z'] = 12.951722, ['h'] = 61.362197 } },
    [37] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1120.76, ['y'] = -2705.052, ['z'] = 12.950127, ['h'] = 57.111614 } },
    [38] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1122.028, ['y'] = -2706.961, ['z'] = 12.951087, ['h'] = 61.499011 } },
    [39] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1124.231, ['y'] = -2710.312, ['z'] = 12.952776, ['h'] = 57.581672 } },
    [40] = { ['inuse'] = false, ['user'] = 0, ['coords'] ={ ['x'] = -1125.503, ['y'] = -2712.314, ['z'] = 12.953781, ['h'] = 61.593589 } },
}
MBL = {}

RegisterServerEvent("CloseCharCreLoc")
AddEventHandler("CloseCharCreLoc", function ()
    MBL.CloseCharCreLoc(source)
end)

MBL.CloseCharCreLoc = function(src)
    for k, v in pairs(characterCreatorLocations) do
        if v.inuse and v.user == src then
            v.inuse = false
            v.user = 0
            break;
        end
    end
end

MBL.GenerateCharCreLoc = function(src)
    for k, v in pairs(characterCreatorLocations) do
        if not v.inuse and v.user == 0 then
            v.inuse = true
            v.user = src
            return k
        end
    end
end


RegisterServerEvent("mbl:serverdenclienteyollamaeventi")
AddEventHandler("mbl:serverdenclienteyollamaeventi", function ()
    local src = source
    local selectedSpawn = MBL.GenerateCharCreLoc(src)
    TriggerClientEvent("mbl_character:client:setupCharCreation", src, characterCreatorLocations[selectedSpawn].coords)
end)