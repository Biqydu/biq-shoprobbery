if Config.Framework == 'qb' then 
  QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
  ESX = exports['es_extended']:getSharedObject()
end

local lastRobberyTimeCashReg = -Config.CooldownCashRegister * 60 * 1000
local lastRobberyTimeSafe = -Config.CooldownSafe * 60 * 1000

RegisterCommand('ttest', function()
  local currentTime = GetGameTimer()
  local lastRobberyTime = lastRobberyTimeCashReg
  
  local cooldownTime = Config.CooldownCashRegister * 60 * 1000
  
  -- Debugowanie obliczeń
  print("Cooldown time (in ms): " .. cooldownTime)
  print("Current time: " .. currentTime)
  print("Last robbery time: " .. lastRobberyTime)
  print("Time difference: " .. (currentTime - lastRobberyTime))
  print("Cooldown check: " .. tostring((currentTime - lastRobberyTime >= cooldownTime)))
  
end, false)

local function RobCashRegister()
    local currentTime = GetGameTimer()
  
    if Config.RequiredItems.cashRegister.weapon and Config.RequiredItems.cashRegister.weapon ~= "" then
      local selectedWeapon = GetSelectedPedWeapon(cache.ped)
      local requiredWeaponHash = joaat(Config.RequiredItems.cashRegister.weapon) 
  
      if selectedWeapon ~= requiredWeaponHash then
          Notify('', 'You do not have the required weapon in your hand!', 'error')
          return
      end
    end
  
    -- Sprawdzanie wymaganych przedmiotów
    if not HasRequiredItems('cashRegister') then
      Notify('', 'You do not have the required item to rob this cash register!', 'error')
      return
    end
  
    -- Sprawdzanie cooldownu
    if currentTime - lastRobberyTimeCashReg < Config.CooldownCashRegister * 60 * 1000 then
        Notify('', 'This cash register was recently robbed, you must wait to be robbed again', 'error')
        return
    end
  
    if Config.MinigameCashRegister and not Config.MinigameCashRegister() then return end
    if not Progress(Config.Progressbars.cashRegister.time, Config.Progressbars.cashRegister.label, Config.Progressbars.cashRegister.anim) then return end
  
    local playerCoords = GetEntityCoords(cache.ped)
    local isNearCashRegister = false
  
    for _, cashRegister in ipairs(Config.CashRegister) do
        if #(playerCoords - cashRegister) < 6 then
            isNearCashRegister = true
            lastRobberyTimeCashReg = currentTime
            TriggerServerEvent('biq-shoprobbery:server:giveRewardFromCashRegister') 
            break
        end
    end
  
    if not isNearCashRegister then
        TriggerServerEvent('biq-shoprobbery:server:cheaterDetected')
    end
  end
  

local function RobSafe()
  local currentTime = GetGameTimer()

  if not HasRequiredItems('safe') then
    Notify('', 'You do not have the required item to rob the safe!', 'error')
    return
  end

  if currentTime - lastRobberyTimeSafe < Config.CooldownSafe * 60 * 1000 then
      Notify('', 'This safe was recently robbed, you must wait to be robbed again', 'error')
      return
  end

  if Config.MinigameSafe and not Config.MinigameSafe() then return end
  if not Progress(Config.Progressbars.safe.time, Config.Progressbars.safe.label, Config.Progressbars.safe.anim) then return end

  local playerCoords = GetEntityCoords(cache.ped)
  local isNearSafe = false

  for _, safe in ipairs(Config.Safes) do
      if #(playerCoords - safe) < 6 then
          isNearSafe = true
          lastRobberyTimeSafe = currentTime  -- Aktualizujemy czas rabunku
          TriggerServerEvent('biq-shoprobbery:server:giveRewardFromSafe', Config.Reward.safe.min, Config.Reward.safe.max)
          break
      end
  end

  -- Jeśli gracz nie jest blisko sejfu
  if not isNearSafe then
      TriggerServerEvent('biq-shoprobbery:server:cheaterDetected')
  end
end


local function CreateRobTargets()
  for _, cashRegister in ipairs(Config.CashRegister) do
      exports.ox_target:addBoxZone({
          coords = cashRegister,
          size = Config.Target.cashRegister.size,
          options = {
              {
                  distance = Config.Target.cashRegister.distance,
                  name = 'biq-shoprobbery:robCashRegister:' .. _,
                  icon = Config.Target.cashRegister.icon,
                  label = Config.Target.cashRegister.label,
                  onSelect = function()
                      debug('biq-shoprobbery:robCashRegister:' .. _)
                      RobCashRegister()
                  end,
              }
          }
      })
  end

  for _, coords in ipairs(Config.Safes) do
      exports.ox_target:addBoxZone({
          coords = coords,
          size = Config.Target.safe.size,
          options = {
              {
                  distance = Config.Target.safe.distance,
                  name = 'biq-shoprobbery:crackSafe:' .. _,
                  icon = Config.Target.safe.icon,
                  label = Config.Target.safe.label,
                  onSelect = function()
                      debug('biq-shoprobbery:crackSafe:' .. _)
                      RobSafe()
                  end,
              }
          }
      })
  end
end

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then return end
  CreateRobTargets()
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then return end
end)