local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local FeatherMenu =  exports['feather-menu'].initiate()

---- Globals
local Difficulty = 0
local CreatedBlips11 = {}
local CreatedNpcs11 = {}
--local CreatedBottles = {}
local Hits = 0
local Timer = 0
local HighscoreOpened = false
local Easytargets = #Config.EasyShooting
local Middletargets = #Config.MiddleShooting
local Hardtargets = #Config.HardShooting

---------------------------------------------------------------------------------

Citizen.CreateThread(function()
    local StartBsPrompt = BccUtils.Prompts:SetupPromptGroup()
    local startssprompt = StartBsPrompt:RegisterPrompt(_U('PromptName'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'})
    if Config.StartBsBlips then
        for h,v in pairs(Config.StartBsBlip) do
        local bsblip = BccUtils.Blips:SetBlip(_U('StartBsBlip'), 'blip_shop_gunsmith', 2.0, v.Coords.x,v.Coords.y,v.Coords.z)
        CreatedBlips11[#CreatedBlips11 + 1] = bsblip
        end
    end
    if Config.CreateBsNPC then
        for h,v in pairs(Config.StartBsBlip) do
        local bsped = BccUtils.Ped:Create('A_M_O_SDUpperClass_01', v.Coords.x,v.Coords.y,v.Coords.z -1, 0, 'world', false)
        CreatedNpcs11[#CreatedNpcs11 + 1] = bsped
        bsped:Freeze()
        bsped:SetHeading(v.NpcHeading)
        bsped:Invincible()
        end
    end
    while true do
        Wait(1)
        for h,v in pairs(Config.StartBsBlip) do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - v.Coords)
        if dist < 2 then
            StartBsPrompt:ShowGroup(_U('PromptName'))

            if startssprompt:HasCompleted() then
                TriggerEvent('mms-bottleshooting:client:openboard') break
            end
        end
    end
    end
end)

RegisterNetEvent('mms-bottleshooting:client:openboard')
AddEventHandler('mms-bottleshooting:client:openboard',function()
    BottleshootingBoard:Open({
        startupPage = BottleshootingBoardPage1,
    })
end)

RegisterNetEvent('mms-bottleshooting:client:gethighscore',function()
    TriggerServerEvent('mms-bottleshooting:server:gethighscore')
end)

---------------------------------------------------------------------------------------------------------
--------------------------------------- SEITE 1 Hauptmenü------------------------------------------------
---------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function ()
    BottleshootingBoard = FeatherMenu:RegisterMenu('feather:character:bottleshooting', {
        top = '30%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '700px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {
            ['border'] = '5px solid orange',
            -- ['background-image'] = 'none',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '550px',
                ['min-height'] = '250px'
            }
        },
        draggable = true,
    --canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
})
    BottleshootingBoardPage1 = BottleshootingBoard:RegisterPage('seite1')
    BottleshootingBoardPage1:RegisterElement('header', {
        value = _U('BoardHeader'),
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    BottleshootingBoardPage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    EmpfohleneWaffe = BottleshootingBoardPage1:RegisterElement('textdisplay', {
        value = _U('UsefullGun'),
        style = {
            ['color'] = 'orange'
        }
    })
    BottleshootingBoardPage1:RegisterElement('button', {
        label = _U('StartEasy') .. Easytargets .. _U('Targets'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Difficulty = 1
        TriggerEvent('mms-bottleshooting:client:StartShooting',Difficulty)
        BottleshootingBoard:Close({ 
        })
    end)
    BottleshootingBoardPage1:RegisterElement('button', {
        label = _U('StartMiddle') .. Middletargets .. _U('Targets'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Difficulty = 2
        TriggerEvent('mms-bottleshooting:client:StartShooting',Difficulty)
        BottleshootingBoard:Close({ 
        })
    end)
    BottleshootingBoardPage1:RegisterElement('button', {
        label = _U('StartHard') .. Hardtargets .. _U('Targets'),
        style = {
            ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        Difficulty = 3
        TriggerEvent('mms-bottleshooting:client:StartShooting',Difficulty)
        BottleshootingBoard:Close({ 
        })
    end)
    BottleshootingBoardPage1:RegisterElement('button', {
        label =  _U('ScoreBoard'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        TriggerEvent('mms-bottleshooting:client:gethighscore')
    end)
    BottleshootingBoardPage1:RegisterElement('button', {
        label =  _U('CloseBoard'),
        style = {
        ['background-color'] = '#FF8C00',
        ['color'] = 'orange',
        ['border-radius'] = '6px'
        },
    }, function()
        BottleshootingBoard:Close({ 
        })
    end)
    BottleshootingBoardPage1:RegisterElement('subheader', {
        value = _U('BoardHeader'),
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
    BottleshootingBoardPage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
end)

RegisterNetEvent('mms-bottleshooting:client:recivehighscore',function(eintraege)
    if not HighscoreOpened then
        BottleshootingBoardPage2 = BottleshootingBoard:RegisterPage('seite2')
        BottleshootingBoardPage2:RegisterElement('header', {
            value = _U('HighscoresHeader'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        BottleshootingBoardPage2:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for _, best in ipairs(eintraege) do
            local buttonLabel = best.firstname ..' '.. best.lastname .. _U('Easy') .. best.easyfinish .. _U('Middle') .. best.middlefinish .. _U('Hard') .. best.hardfinish
            BottleshootingBoardPage2:RegisterElement('button', {
                label = buttonLabel,
                style = {
                    ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
                }
            }, function()
                
            end)
        end
        BottleshootingBoardPage2:RegisterElement('button', {
            label = _U('BackMenu'),
            style = {
                ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BottleshootingBoardPage1:RouteTo()
        end)
        BottleshootingBoardPage2:RegisterElement('button', {
            label =  _U('CloseBoard'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BottleshootingBoard:Close({ 
            })
        end)
        BottleshootingBoardPage2:RegisterElement('subheader', {
            value = _U('BoardHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BottleshootingBoardPage2:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BottleshootingBoardPage2:RouteTo()
        HighscoreOpened = true
    elseif HighscoreOpened then
        BottleshootingBoardPage2:UnRegister()
        BottleshootingBoardPage2 = BottleshootingBoard:RegisterPage('seite2')
        BottleshootingBoardPage2:RegisterElement('header', {
            value = _U('HighscoresHeader'),
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        BottleshootingBoardPage2:RegisterElement('line', {
            slot = 'header',
            style = {
            ['color'] = 'orange',
            }
        })
        for _, best in ipairs(eintraege) do
            local buttonLabel = best.firstname ..' '.. best.lastname .. _U('Easy') .. best.easyfinish .. _U('Middle') .. best.middlefinish .. _U('Hard') .. best.hardfinish
            BottleshootingBoardPage2:RegisterElement('button', {
                label = buttonLabel,
                style = {
                ['background-color'] = '#FF8C00',
                ['color'] = 'orange',
                ['border-radius'] = '6px'
                }
            }, function()
                
            end)
        end
        BottleshootingBoardPage2:RegisterElement('button', {
            label = _U('BackMenu'),
            style = {
                ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BottleshootingBoardPage1:RouteTo()
        end)
        BottleshootingBoardPage2:RegisterElement('button', {
            label =  _U('CloseBoard'),
            style = {
            ['background-color'] = '#FF8C00',
            ['color'] = 'orange',
            ['border-radius'] = '6px'
            },
        }, function()
            BottleshootingBoard:Close({ 
            })
        end)
        BottleshootingBoardPage2:RegisterElement('subheader', {
            value = _U('BoardHeader'),
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BottleshootingBoardPage2:RegisterElement('line', {
            slot = 'footer',
            style = {
            ['color'] = 'orange',
            }
        })
        BottleshootingBoardPage2:RouteTo()
    end

end)

RegisterNetEvent('mms-bottleshooting:client:StartShooting')  --- Checks if a Player Already Using shooting Range
AddEventHandler('mms-bottleshooting:client:StartShooting',function(Difficulty)
    TriggerServerEvent('mms-bottleshooting:server:StartShooting',Difficulty)
end)

RegisterNetEvent('mms-bottleshooting:client:StartBottleShooting')
AddEventHandler('mms-bottleshooting:client:StartBottleShooting',function(Difficulty)
    VORPcore.NotifyTip(_U('GoInPosition'), 5000)
    Citizen.Wait(9000)
    VORPcore.NotifyTip(_U('Go'), 5000)
    Citizen.Wait(1000)
    if Difficulty == 1 then
        local Bottlemodel = GetHashKey(Config.Easyprop)
            while not HasModelLoaded(Bottlemodel) do
                Wait(10)
                RequestModel(Bottlemodel)
            end
            for i, v in ipairs(Config.EasyShooting) do
                CreatedBottle = CreateObject(Bottlemodel, v.BottleCoords.x,v.BottleCoords.y,v.BottleCoords.z -1, true, false, false)
                SetEntityAsMissionEntity(CreatedBottle, true)
                PlaceObjectOnGroundProperly(CreatedBottle, true)
                FreezeEntityPosition(CreatedBottle, true)
                Citizen.InvokeNative(0x7DFB49BCDB73089A,CreatedBottle,true)

                --CreatedBottles[#CreatedBottles + 1] = CreatedBottle
                while Timer < Config.Easytime do
                    local BottleBroken = Citizen.InvokeNative(0x8ABFB70C49CC43E2,CreatedBottle)
                    if BottleBroken then
                        VORPcore.NotifyTip(_U('Hit'), 3000)
                        Hits = Hits + 1
                        goto continue
                    end
                    Citizen.Wait(250)
                    Timer = Timer +0.25
                end
            VORPcore.NotifyTip(_U('Miss'), 3000)
            ::continue::
            Timer = 0
            DeleteObject(CreatedBottle)
            end
            if Hits == Easytargets then
                VORPcore.NotifyTip(_U('AllTargets'), 3000)
                TriggerServerEvent('mms-bottleshooting:server:AddHighscore',Difficulty)
                TriggerServerEvent('mms-bottleshooting:server:AddReward',Difficulty)
            elseif Hits < Easytargets then
                VORPcore.NotifyTip(_U('YouHited') .. Hits .. _U('From') .. Easytargets .. _U('TargetsHit') , 3000)
            end
            Hits = 0
            TriggerServerEvent('mms-bottleshooting:server:StopShooting')
        elseif Difficulty == 2 then
            local Bottlemodel = GetHashKey(Config.Middleprop)
                while not HasModelLoaded(Bottlemodel) do
                    Wait(10)
                    RequestModel(Bottlemodel)
                end
                for i, v in ipairs(Config.MiddleShooting) do
                    CreatedBottle = CreateObject(Bottlemodel, v.BottleCoords.x,v.BottleCoords.y,v.BottleCoords.z -1, true, false, false)
                    SetEntityAsMissionEntity(CreatedBottle, true)
                    PlaceObjectOnGroundProperly(CreatedBottle, true)
                    FreezeEntityPosition(CreatedBottle, true)
                    Citizen.InvokeNative(0x7DFB49BCDB73089A,CreatedBottle,true)
                    --CreatedBottles[#CreatedBottles + 1] = CreatedBottle
                    while Timer < Config.Middletime do
                        local BottleBroken = Citizen.InvokeNative(0x8ABFB70C49CC43E2,CreatedBottle)
                        if BottleBroken then
                            VORPcore.NotifyTip(_U('Hit'), 3000)
                            Hits = Hits + 1
                            goto continue
                        end
                        Citizen.Wait(250)
                        Timer = Timer +0.25
                    end
                VORPcore.NotifyTip(_U('Miss'), 3000)
                ::continue::
                Timer = 0
                DeleteObject(CreatedBottle)
                end
                if Hits == Middletargets then
                    VORPcore.NotifyTip(_U('AllTargets'), 3000)
                    TriggerServerEvent('mms-bottleshooting:server:AddHighscore',Difficulty)
                    TriggerServerEvent('mms-bottleshooting:server:AddReward',Difficulty)
                elseif Hits < Middletargets then
                    VORPcore.NotifyTip(_U('YouHited') .. Hits .. _U('From') .. Middletargets .. _U('TargetsHit') , 3000)
                end
                Hits = 0
                TriggerServerEvent('mms-bottleshooting:server:StopShooting')
            elseif Difficulty == 3 then
                local Bottlemodel = GetHashKey(Config.Hardprop)
                    while not HasModelLoaded(Bottlemodel) do
                        Wait(10)
                        RequestModel(Bottlemodel)
                    end
                    for i, v in ipairs(Config.HardShooting) do
                        CreatedBottle = CreateObject(Bottlemodel, v.BottleCoords.x,v.BottleCoords.y,v.BottleCoords.z -1, true, false, false)
                        SetEntityAsMissionEntity(CreatedBottle, true)
                        PlaceObjectOnGroundProperly(CreatedBottle, true)
                        FreezeEntityPosition(CreatedBottle, true)
                        Citizen.InvokeNative(0x7DFB49BCDB73089A,CreatedBottle,true)
                        --CreatedBottles[#CreatedBottles + 1] = CreatedBottle
                        while Timer < Config.Hardtime do
                            local BottleBroken = Citizen.InvokeNative(0x8ABFB70C49CC43E2,CreatedBottle)
                            if BottleBroken then
                                VORPcore.NotifyTip(_U('Hit'), 3000)
                                Hits = Hits + 1
                                goto continue
                            end
                            Citizen.Wait(250)
                            Timer = Timer +0.25
                        end
                    VORPcore.NotifyTip(_U('Miss'), 3000)
                    ::continue::
                    Timer = 0
                    DeleteObject(CreatedBottle)  
                end
                if Hits == Hardtargets then
                    VORPcore.NotifyTip(_U('AllTargets'), 3000)
                    TriggerServerEvent('mms-bottleshooting:server:AddHighscore',Difficulty)
                    TriggerServerEvent('mms-bottleshooting:server:AddReward',Difficulty)
                elseif Hits < Hardtargets then
                    VORPcore.NotifyTip(_U('YouHited') .. Hits .. _U('From') .. Hardtargets .. _U('TargetsHit') , 3000)
                end
                Hits = 0
                TriggerServerEvent('mms-bottleshooting:server:StopShooting')
    end
   
end)


------------------------- Clean Up on Resource Restart -----------------------------

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
    for _, npcs in ipairs(CreatedNpcs11) do
        npcs:Remove()
	end
    for _, blips in ipairs(CreatedBlips11) do
        blips:Remove()
	end
    end
end)