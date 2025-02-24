if Config.Framework == 'qb' then 
  QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
  ESX = exports['es_extended']:getSharedObject()
end

local lastRobberyTimeCashReg = -Config.CooldownCashRegister * 60 * 1000
local lastRobberyTimeSafe = -Config.CooldownSafe * 60 * 1000

lib.locale(Config.Language or 'en')


local function RobCashRegister()
    local currentTime = GetGameTimer()

    if tonumber(Config.RequiredPoliceCount) and Config.RequiredPoliceCount > 0 then
        local policeCount = lib.callback.await('biq-shoprobbery:server:checkPoliceCount', false)
        if policeCount < Config.RequiredPoliceCount then
            Notify('', locale('not_enough_police', Config.RequiredPoliceCount), 'error')
            return
        end
    end
    
  
    if not HasRequiredItems('cashRegister') then
      Notify('', locale('not_have_required_item'), 'error')
      return
    end
  
    if currentTime - lastRobberyTimeCashReg < Config.CooldownCashRegister * 60 * 1000 then
        Notify('', locale('recently_robbed'), 'error')
        return
    end
  
    if Config.MinigameCashRegister and not Config.MinigameCashRegister() then return end
    if not Progress(Config.Progressbars.cashRegister.time, Config.Progressbars.cashRegister.label, Config.Progressbars.cashRegister.anim) then return end

    lastRobberyTimeCashReg = GetGameTimer()

    TriggerServerEvent('biq-shoprobbery:server:giveRewardFromCashRegister')
  end
  

local function RobSafe()
  local currentTime = GetGameTimer()

if Config.RequiredPoliceCount and Config.RequiredPoliceCount > 0 then
    local policeCount = lib.callback.await('biq-shoprobbery:server:checkPoliceCount', false)
    if policeCount < Config.RequiredPoliceCount then
        Notify('', locale('not_enough_police', Config.RequiredPoliceCount), 'error')
        return
    end
end

  if not HasRequiredItems('safe') then
    Notify('', locale('not_have_required_item'), 'error')
    return
  end

  if currentTime - lastRobberyTimeSafe < Config.CooldownSafe * 60 * 1000 then
      Notify('', locale('recently_robbed'), 'error')
      return
  end

  if Config.MinigameSafe and not Config.MinigameSafe() then return end
  if not Progress(Config.Progressbars.safe.time, Config.Progressbars.safe.label, Config.Progressbars.safe.anim) then return end

  lastRobberyTimeSafe = GetGameTimer()

  TriggerServerEvent('biq-shoprobbery:server:giveRewardFromSafe')
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
                  canInteract = function()
                    if Config.RequiredItems.cashRegister.weapon and Config.RequiredItems.cashRegister.weapon ~= "" then
                        local selectedWeapon = GetSelectedPedWeapon(cache.ped)
                        local requiredWeaponHash = joaat(Config.RequiredItems.cashRegister.weapon) 
                        
                        return selectedWeapon == requiredWeaponHash
                    end
                    
                    return true
                end                
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
                  canInteract = function()
                    if Config.RequiredItems.safe.weapon and Config.RequiredItems.safe.weapon ~= "" then
                        local selectedWeapon = GetSelectedPedWeapon(cache.ped)
                        local requiredWeaponHash = joaat(Config.RequiredItems.safe.weapon) 
                        
                        return selectedWeapon == requiredWeaponHash
                    end
                    
                    return true
                end    
              }
          }
      })
  end
end

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then return end
  CreateRobTargets()
end)

