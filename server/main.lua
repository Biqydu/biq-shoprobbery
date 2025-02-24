if Config.Framework == 'qb' then 
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
    ESX = exports['es_extended']:getSharedObject()
end

lib.locale()

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
  sendWebhook(Config.Weebhook, 7506394, 'biq-shoprobbery', locale('cheaterDetected', GetPlayerName(source)))
  Config.CheaterDetected(source)
end)

RegisterNetEvent('biq-shoprobbery:server:giveRewardFromCashRegister', function()
  local src = source
  local playerPed = GetPlayerPed(src)
  local playerCoords = GetEntityCoords(playerPed)
  local isNearCashRegister = false

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

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then return end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then return end
end)