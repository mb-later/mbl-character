RegisterNetEvent('mbl-ui:ShowUI')
AddEventHandler('mbl-ui:ShowUI', function(action, text)
	SendNUIMessage({
		action = action,
		text = text,
	})
end)

RegisterNetEvent('mbl-ui:HideUI')
AddEventHandler('mbl-ui:HideUI', function()
	SendNUIMessage({
		action = 'hide'
	})
end)

