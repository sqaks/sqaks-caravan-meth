local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local started = false
local displayed = false
local progress = 0
local CurrentVehicle 
local pause = false
local selection = 0
local quality = 0
ESX = nil

local LastCar

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_methcar:stop')
AddEventHandler('esx_methcar:stop', function()
	started = false
	DisplayHelpText("~r~Production stopped...")
	FreezeEntityPosition(LastCar, false)
end)
RegisterNetEvent('esx_methcar:stopfreeze')
AddEventHandler('esx_methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)
RegisterNetEvent('esx_methcar:notify')
AddEventHandler('esx_methcar:notify', function(message)
	ESX.ShowNotification(message)
end)

RegisterNetEvent('esx_methcar:startprod')
AddEventHandler('esx_methcar:startprod', function()
	DisplayHelpText("~g~Meth yap??m?? ba??lat??l??yor.")
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	displayed = false
	print('Meth yap??m?? ba??lad??.')
	ESX.ShowNotification("~r~Meth yap??m?? ba??lad??.")	
	SetPedIntoVehicle(GetPlayerPed(-1), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('esx_methcar:blowup')
AddEventHandler('esx_methcar:blowup', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)
	
end)


RegisterNetEvent('esx_methcar:smoke')
AddEventHandler('esx_methcar:smoke', function(posx, posy, posz, bool)

	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", posx, posy, posz + 1.7, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.8)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(22000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end

end)
RegisterNetEvent('esx_methcar:drugged')
AddEventHandler('esx_methcar:drugged', function()
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)

	Citizen.Wait(300000)
	ClearTimecycleModifier()
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(playerPed) then
			
			
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())

			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)
	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)
			
			if modelName == 'JOURNEY' and car then
				
					if GetPedInVehicleSeat(car, -1) == playerPed then
						if started == false then
							if displayed == false then
								DisplayHelpText("Uyu??turucu yapmaya ba??lamak i??in ~INPUT_THROW_GRENADE~ tu??una bas.")
								displayed = true
							end
						end
						if IsControlJustReleased(0, Keys['G']) then
							if pos.y >= 3500 then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									TriggerServerEvent('esx_methcar:start')	
									progress = 0
									pause = false
									selection = 0
									quality = 0
									
								else
									DisplayHelpText('~r~Araba zaten kullan??l??yor.')
								end
							else
								ESX.ShowNotification('~r~??ehre ??ok yak??ns??n, meth pi??irmeye ba??lamak i??in kasabaya do??ru git.')
							end
							
							
							
							
		
						end
					end
					
				
				
			
			end
			
		else

				
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('Meth pi??irmeyi b??rakt??n.')
					FreezeEntityPosition(LastCar,false)
				end
		end
		
		if started == true then
			
			if progress < 96 then
				Citizen.Wait(6000)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					ESX.ShowNotification('~r~Meth pi??iriliyor: ~g~~h~' .. progress .. '%')
					Citizen.Wait(6000) 
				end

				--
				--   EVENT 1
				--
				if progress > 22 and progress < 24 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Propan borusu s??zd??r??yor, ne yapars??n??z?')	
						ESX.ShowNotification('~o~A. Bantla tuttururum')
						ESX.ShowNotification('~o~S. S??zd??rs??n nap??y??m! ')
						ESX.ShowNotification('~o~D. Boruyu de??i??tiririm')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~Bant s??z??nt??y?? biraz da olsa durdurdu')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("S se??ildi")
						ESX.ShowNotification('~r~Propan tank?? patlad??, ortal??????n a??z??na s????t??n...')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('Uyu??turucu yapmay?? b??rakt??n')
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~G??zeeel, boru art??k s??zd??rm??yor.')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 5
				--
				if progress > 30 and progress < 32 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Yere bir ??i??e aseton d??kt??n, ne yapars??n?')	
						ESX.ShowNotification('~o~A. Kokudan kurtulmak i??in pencereleri a??ar??m')
						ESX.ShowNotification('~o~S. Bir ??ey olmaz, sonra temizlerim')
						ESX.ShowNotification('~o~D. Hava filtreli bir maske takar??m')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~Kokudan kurtulmak i??in cam?? a??t??n. ')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~??ok fazla aseton solumaktan kafay?? buldun.')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Bu, sorunu ????zmenin kolay bir yolu...')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 2
				--
				if progress > 38 and progress < 40 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Meth ??ok h??zl?? berkle??ti ne yapars??n? ')	
						ESX.ShowNotification('~o~A. Bas??nc?? art??r??r??m')
						ESX.ShowNotification('~o~S. S??cakl?????? art??r??r??m')
						ESX.ShowNotification('~o~D. Bas??nc?? d??????r??r??m')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~Bas??nc?? y??kselttin ve propan ka??maya ba??lad??, indirdin ve ??imdilik idare eder.')
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~S??cakl??????n y??kseltilmesi yard??mc?? oldu...')
						quality = quality + 5
						pause = false
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Bas??nc?? d??????rmek durumu daha da k??t??le??tirdi...')
						pause = false
						quality = quality -4
					end
				end
				--
				--   EVENT 8 - 3
				--
				if progress > 41 and progress < 43 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Yanl????l??kla ??ok fazla aseton d??kt??n, ne yapars??n?')	
						ESX.ShowNotification('~o~A. Hi??bir ??ey yapmam')
						ESX.ShowNotification('~o~S. ????r??nga kullanarak emmeye ??al??????r??m')
						ESX.ShowNotification('~o~D. Dengelemek i??in biraz daha lityum eklerim')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~Meth pek aseton gibi kokmuyor.')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~Biraz i??e yarad?? ama h??l?? ??ok fazla.')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~S??persin! Her iki kimyasal maddeyi de ba??ar??yla dengeledin.')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 3
				--
				if progress > 46 and progress < 49 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Biraz su boyas?? buldun, ne yapars??n?')	
						ESX.ShowNotification('~o~A. Eklerim')
						ESX.ShowNotification('~o~S. F??rlat??r??m. Ne i??ime yarayacak?')
						ESX.ShowNotification('~o~D. ????erim')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~G??zel fikir. ??nsanlar renkleri sever.')
						quality = quality + 4
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~Evet, methin tad??n?? yok edebilir.')
						pause = false
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Biraz tuhafs??n ve ba????n d??n??yor. Tad?? iyi miydi bari?')
						pause = false
					end
				end
				--
				--   EVENT 4
				--
				if progress > 55 and progress < 58 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Filtre t??kal??, ne yapars??n?')	
						ESX.ShowNotification('~o~A. Bas??n??l?? hava kullanarak temizlerim')
						ESX.ShowNotification('~o~S. Filtreyi de??i??tiririm')
						ESX.ShowNotification('~o~D. Di?? f??r??as?? kullanarak temizlerim')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~S??k????t??r??lm???? hava her taraf??na s??v?? meth p??sk??rtt??.')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~De??i??tirmek muhtemelen en iyi se??enekti')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Bu olduk??a iyi ??al????t?? ama yine de biraz kirli')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 5
				--
				if progress > 58 and progress < 60 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Yere bir ??i??e aseton d??kt??n, ne yapars??n?')	
						ESX.ShowNotification('~o~A. Kokudan kurtulmak i??in pencereleri a??ar??m')
						ESX.ShowNotification('~o~S. Bir ??ey olmaz, sonra temizlerim')
						ESX.ShowNotification('~o~D. Hava filtreli bir maske takar??m')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~Kokudan kurtulmak i??in cam?? a??t??n. ')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~??ok fazla aseton solumaktan kafay?? buldun.')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Bu, sorunu ????zmenin kolay bir yolu...')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 1 - 6
				--
				if progress > 63 and progress < 65 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Propan borusu s??zd??r??yor, ne yapars??n??z?')	
						ESX.ShowNotification('~o~A. Bantla tuttururum')
						ESX.ShowNotification('~o~S. S??zd??rs??n nap??y??m! ')
						ESX.ShowNotification('~o~D. Boruyu de??i??tiririm')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~Bant s??z??nt??y?? biraz da olsa durdurdu')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~Propan tank?? patlad??, ortal??????n a??z??na s????t??n...')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('Uyu??turucu yapmay?? b??rakt??n')
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~G??zeeel, boru art??k s??zd??rm??yor.')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 4 - 7
				--
				if progress > 71 and progress < 73 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Filtre t??kal??, ne yapars??n?')	
						ESX.ShowNotification('~o~A. Bas??n??l?? hava kullanarak temizlerim')
						ESX.ShowNotification('~o~S. Filtreyi de??i??tiririm')
						ESX.ShowNotification('~o~D. Di?? f??r??as?? kullanarak temizlerim')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~S??k????t??r??lm???? hava her taraf??na s??v?? meth p??sk??rtt??.')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~De??i??tirmek muhtemelen en iyi se??enekti')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Bu olduk??a iyi ??al????t?? ama yine de biraz kirli')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 8
				--
				if progress > 76 and progress < 78 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Yanl????l??kla ??ok fazla aseton d??kt??n, ne yapars??n?')	
						ESX.ShowNotification('~o~A. Hi??bir ??ey yapmam')
						ESX.ShowNotification('~o~S. ????r??nga kullanarak emmeye ??al??????r??m')
						ESX.ShowNotification('~o~D. Dengelemek i??in biraz daha lityum eklerim')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~Meth pek aseton gibi kokmuyor.')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~Biraz i??e yarad?? ama h??l?? ??ok fazla.')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~S??persin! Her iki kimyasal maddeyi de ba??ar??yla dengeledin.')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 9
				--
				if progress > 82 and progress < 84 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Acilen kakan?? yapman laz??m. Ne yapars??n?')	
						ESX.ShowNotification('~o~A. Tutmaya ??al??????r??m')
						ESX.ShowNotification('~o~S. D????ar?? ????k??p s????ar??m')
						ESX.ShowNotification('~o~D. Karavan??n i??ine s????ar??m')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~???? daha ??nemli. Sonra s????ars??n.')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~Sen d????ardayken cam masadan d????t?? ve her yere d??k??ld??...')
						pause = false
						quality = quality - 2
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Hem karavan bok gibi kokuyor, hem de art??k methin tad?? bok gibi.')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 10
				--
				if progress > 88 and progress < 90 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~Daha fazlas??na sahipmi??sin gibi g??r??nmesi i??in methine biraz cam par??alar?? ekler misin?')	
						ESX.ShowNotification('~o~A. Tabii ki!')
						ESX.ShowNotification('~o~S. Asla')
						ESX.ShowNotification('~o~D. Ya bunun yerine cama meth eklersem?')
						ESX.ShowNotification('~c~Ne yapmak istiyorsan o se??ene??in harfine bas')
					end
					if selection == 1 then
						print("a se??ildi")
						ESX.ShowNotification('~r~??imdi birka?? tane daha meth ??antan var')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("s se??ildi")
						ESX.ShowNotification('~r~??yi bir uyu??turucu ??reticisisin, ??r??n??n kaliteli. Adeta Mr. Walkers??n.')
						pause = false
						quality = quality + 1
					end
					if selection == 3 then
						print("d se??ildi")
						ESX.ShowNotification('~r~Bokunu ????kard??n ama neyse.')
						pause = false
						quality = quality - 1
					end
				end
				
				
				
				
				
				
				
				if IsPedInAnyVehicle(playerPed) then
					TriggerServerEvent('esx_methcar:make', pos.x,pos.y,pos.z)
					if pause == false then
						selection = 0
						quality = quality + 1
						progress = progress +  math.random(1, 2)
						ESX.ShowNotification('~r~Meth pi??iriliyor: ~g~~h~' .. progress .. '%')
					end
				else
					TriggerEvent('esx_methcar:stop')
				end

			else
				TriggerEvent('esx_methcar:stop')
				progress = 100
				ESX.ShowNotification('~r~Meth pi??iriliyor: ~g~~h~' .. progress .. '%')
				ESX.ShowNotification('~g~~h~Pi??irme i??lemi bitti')
				TriggerServerEvent('esx_methcar:finish', quality)
				FreezeEntityPosition(LastCar, false)
			end	
			
		end
		
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			else
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('Uyu??turucu yapmay?? b??rakt??n')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)		
		if pause == true then
			if IsControlJustReleased(0, Keys['A']) then
				selection = 1
				ESX.ShowNotification('~g~1 numaral?? se??enek se??ildi')
			end
			if IsControlJustReleased(0, Keys['S']) then
				selection = 2
				ESX.ShowNotification('~g~2 numaral?? se??enek se??ildi')
			end
			if IsControlJustReleased(0, Keys['D']) then
				selection = 3
				ESX.ShowNotification('~g~3 numaral?? se??enek se??ildi')
			end
		end

	end
end)



