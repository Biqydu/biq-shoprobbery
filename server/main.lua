if Config.Framework == 'qb' then 
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

lib.locale(Config.Language or 'en')

local lastRobberyTimeCashReg = 0
local lastRobberyTimeSafe = 0

lib.callback.register('biq-shoprobbery:server:checkCooldown', function(source, type)
    local currentTime = os.time() 

    if type == "cashRegister" then
        if currentTime - lastRobberyTimeCashReg < Config.CooldownCashRegister * 60 then
            return false
        end
    elseif type == "safe" then
        if currentTime - lastRobberyTimeSafe < Config.CooldownSafe * 60 then
            return false
        end
    end
    return true
end)

RegisterNetEvent('biq-shoprobbery:server:updateCooldown')
AddEventHandler('biq-shoprobbery:server:updateCooldown', function(type)
    local currentTime = os.time()

    if type == "cashRegister" then
        lastRobberyTimeCashReg = currentTime
    elseif type == "safe" then
        lastRobberyTimeSafe = currentTime
    end

    TriggerClientEvent('biq-shoprobbery:client:cancelProgress', -1)
end)


local function sendWebhook(webhook, color, name, message)
  local currentDate = os.date("%Y-%m-%d")
  local currentTime = os.date("%H:%M:%S")
  local embed = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = currentTime.." "..currentDate,
            },
        }
    }
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('biq-shoprobbery:server:cheaterDetected', function(source)
  sendWebhook(Config.Webhook, 7506394, 'biq-shoprobbery', locale('cheaterDetected', GetPlayerIdentifier(source)))
  Config.CheaterDetected(source)
end)

RegisterNetEvent('biq-shoprobbery:server:spamEvent', function(source)
  sendWebhook(Config.Webhook, 7506394, 'biq-shoprobbery', locale('spam_event_detected', GetPlayerIdentifier(source)))
  Config.SpamEventDetected(source)
end)

local robberyCooldowns = {}

RegisterNetEvent('biq-shoprobbery:server:giveRewardFromCashRegister', function()
  local src = source
  local playerPed = GetPlayerPed(src)
  local playerCoords = GetEntityCoords(playerPed)
  local isNearCashRegister = false

  if robberyCooldowns[src] and (os.time() - robberyCooldowns[src]) < 10 then
    TriggerEvent('biq-shoprobbery:server:spamEvent', src)
    return
    end
    robberyCooldowns[src] = os.time()

  for _, cashRegister in ipairs(Config.CashRegister) do
      local distance = #(playerCoords - cashRegister)

      if distance < 6 then
          isNearCashRegister = true
          AddItem(src, Config.Reward.cashRegister.item, math.random(Config.Reward.cashRegister.min, Config.Reward.cashRegister.max))
          break
      end
  end

  if not isNearCashRegister then
      TriggerEvent('biq-shoprobbery:server:cheaterDetected', src)
  end
end)


RegisterNetEvent('biq-shoprobbery:server:giveRewardFromSafe', function()
    local src = source
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local isNearSafe = false

    if robberyCooldowns[src] and (os.time() - robberyCooldowns[src]) < 10 then
        TriggerEvent('biq-shoprobbery:server:spamEvent', src)
        return
    end
    robberyCooldowns[src] = os.time()

    for _, safe in ipairs(Config.Safes) do
        local distance = #(playerCoords - safe)
        if distance < 6 then
            isNearSafe = true
            AddItem(src, Config.Reward.safe.item, math.random(Config.Reward.safe.min, Config.Reward.safe.max))
            break
        end
    end

    if not isNearSafe then
        TriggerEvent('biq-shoprobbery:server:cheaterDetected', src)
    end
end)