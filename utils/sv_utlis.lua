if Config.Framework == 'qb' then 
  QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then 
  ESX = exports['es_extended']:getSharedObject()
end

function debug(msg)
    if Config.Debug then print('^3[DEBUG]^7', msg) end
end

---@param src number # player source
---@param title string # noti title can be empty string for qb
---@param desc string # noti desc
---@param type string # success or error
---@param duration number # Length of noti
function Notify(src, title, desc, type, duration)
  if Config.Notification == 'ox' then
    TriggerClientEvent('ox_lib:notify', src, {
      title = title,
      description = desc,
      type = type or 'info',
      duration = duration or 3000,
    })
  elseif Config.Notification == 'qb' then
    TriggerClientEvent('QBCore:Notify', src, title .. ' ' .. desc, type, duration)
  end
end


function AddItem(src, item, amount)
    local src = source
  if Config.Inventory == 'ox' then
      if exports.ox_inventory:CanCarryItem(src, item, amount or 1) then
          exports.ox_inventory:AddItem(src, item, amount or 1)
      else
          Notify(src, 5000, 'Inventory: ', 'You cant carry that!', 'error')
      end
  elseif Config.Inventory == 'qb' then
      if exports['qb-inventory']:CanAddItem(src, item, amount or 1) then
          exports['qb-inventory']:AddItem(src, item, amount or 1)
      else
          Notify(src, 5000, 'Inventory: ', 'You cant carry that!', 'error')
      end
  elseif Config.Inventory == 'esx' then
      local xPlayer = ESX.GetPlayerFromId(src)
      if not xPlayer then return end
      if xPlayer.canCarryItem and xPlayer.canCarryItem(item, amount or 1) then
          xPlayer.addInventoryItem(item, amount or 1)
      else
          Notify(src, 5000, 'Inventory: ', 'You cant carry that!', 'error')
      end
  end
end

function HasItem(src, item, amount)
    amount = amount or 1 

    if Config.Inventory == 'ox' then
        return exports.ox_inventory:GetItem(src, item, nil, true) >= amount

    elseif Config.Inventory == 'qb' then
        local itemData = exports['qb-inventory']:GetItem(src, item)
        return itemData and itemData.amount >= amount

    elseif Config.Inventory == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end
        local inventoryItem = xPlayer.getInventoryItem(item)
        return inventoryItem and inventoryItem.count >= amount
    end

    return false
end

function Contains(table, value)
    for _, v in pairs(table) do
        if v == value then return true end
    end
    return false
end

function GetPlayerIdentifier(source)
    if Config.Framework == 'qb'  then
        return QBCore.Functions.GetPlayer(source).PlayerData.citizenid
    elseif Config.Framework == 'qbox' then
        return exports.qbx_core:GetPlayer(source).PlayerData.citizenid
    elseif Config.Framework == 'esx' then
        return ESX.GetPlayerFromId(source).getIdentifier()
    else
        debug('Config.Framework is not set correctly')
        return
    end
end

lib.callback.register('biq-shoprobbery:server:checkPoliceCount', function()
    local policeCount = 0
  
    if Config.Framework == 'esx' then
        local players = ESX.GetExtendedPlayers()
        for _, player in pairs(players) do
            if player.getJob() and Contains(Config.PoliceJobs, player.getJob().name) then
                policeCount = policeCount + 1
            end
        end
      elseif Config.Framework == 'qbox' or Config.Framework == 'qb' then
        local player = exports.qbx_core:GetQBPlayers()
        for _, player in pairs(player) do
            if player.PlayerData.job and Contains(Config.PoliceJobs, player.PlayerData.job.name) then
                policeCount = policeCount + 1
            end
        end
      end
    return policeCount
  end)
  