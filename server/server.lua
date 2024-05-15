local VORPcore = exports.vorp_core:GetCore()

local ShootingActive = false
-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-bottleshooting/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end
--------------------------------------------------------------------------------------------------

RegisterServerEvent('mms-bottleshooting:server:StartShooting',function(Difficulty)
    local src = source
    if not ShootingActive then
        ShootingActive = true
        TriggerClientEvent('mms-bottleshooting:client:StartBottleShooting',src,Difficulty)
    else
        VORPcore.NotifyTip(src, _U('SomeoneAlreadyShooting'),  5000)
    end
end)

RegisterServerEvent('mms-bottleshooting:server:StopShooting',function()
    local src = source
    if ShootingActive then
        ShootingActive = false
    end
end)

RegisterServerEvent('mms-bottleshooting:server:AddHighscore',function(Difficulty)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    local firstname = Character.firstname
    local lastname = Character.lastname
    local result = MySQL.query.await("SELECT * FROM mms_bottleshooting WHERE charidentifier=@charidentifier", { ["charidentifier"] = charidentifier})
        if #result > 0 then 
            if Difficulty == 1 then
                local oldamount = result[1].easyfinish
                local newamount = oldamount + 1
                MySQL.update('UPDATE `mms_bottleshooting` SET easyfinish = ? WHERE charidentifier = ?',{newamount, charidentifier})
            elseif Difficulty == 2 then
                local oldamount = result[1].middlefinish
                local newamount = oldamount + 1
                MySQL.update('UPDATE `mms_bottleshooting` SET middlefinish = ? WHERE charidentifier = ?',{newamount, charidentifier})
            elseif Difficulty == 3 then
                local oldamount = result[1].hardfinish
                local newamount = oldamount + 1
                MySQL.update('UPDATE `mms_bottleshooting` SET hardfinish = ? WHERE charidentifier = ?',{newamount, charidentifier})
            end
        else
            if Difficulty == 1 then
                MySQL.insert('INSERT INTO `mms_bottleshooting` (identifier,charidentifier, firstname,lastname,easyfinish,middlefinish,hardfinish) VALUES (?,?,?,?,?,?,?)',
                {identifier,charidentifier,firstname,lastname,1,0,0}, function()end)
            elseif Difficulty == 2 then
                MySQL.insert('INSERT INTO `mms_bottleshooting` (identifier,charidentifier, firstname,lastname,easyfinish,middlefinish,hardfinish) VALUES (?,?,?,?,?,?,?)',
                {identifier,charidentifier,firstname,lastname,0,1,0}, function()end)
            elseif Difficulty == 3 then
                MySQL.insert('INSERT INTO `mms_bottleshooting` (identifier,charidentifier, firstname,lastname,easyfinish,middlefinish,hardfinish) VALUES (?,?,?,?,?,?,?)',
                {identifier,charidentifier,firstname,lastname,0,0,1}, function()end)
            end
        end
end)

RegisterServerEvent('mms-bottleshooting:server:AddReward',function(Difficulty)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    if Difficulty == 1 and Config.EasyRewardsOn then
        Character.addCurrency(0, Config.EasyReward)
        VORPcore.NotifyTip(src, _U('YouGot') .. Config.EasyReward,  5000)
    elseif Difficulty == 2 and Config.MiddleRewardsOn then
        Character.addCurrency(0, Config.MiddleReward)
        VORPcore.NotifyTip(src, _U('YouGot') .. Config.MiddleReward,  5000)
    elseif Difficulty == 3 and Config.HardRewardsOn then
        Character.addCurrency(0, Config.HardReward)
        VORPcore.NotifyTip(src, _U('YouGot') .. Config.HardReward,  5000)
    end
end)


RegisterServerEvent('mms-bottleshooting:server:gethighscore',function()
    local src = source
    --local Character = VORPcore.getUser(src).getUsedCharacter
    --local identifier = Character.identifier
    --local charidentifier = Character.charIdentifier
            exports.oxmysql:execute('SELECT * FROM mms_bottleshooting', {}, function(highscores)
                if highscores and #highscores > 0 then
                    local eintraege = {}

                    for _, best in ipairs(highscores) do
                        table.insert(eintraege, best)
                        
                    end
                    TriggerClientEvent('mms-bottleshooting:client:recivehighscore', src, eintraege)
                else
                    VORPcore.NotifyTip(src, _U('NoHighscoreYet'),  5000)
            end
        end)
end)


--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()