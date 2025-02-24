Config = {}

Config.Debug = true

-- Nice debug function so you dont need to check if Config.Debug is true on every print
function debug(...)
    if Config.Debug then print('^3[DEBUG]^7', ...) end
end

Config.Framework = 'qbox'            -- qb , qbox, esx
Config.Notification = 'ox'         -- ox , qb
Config.Inventory = 'ox'            -- ox , qb, esx
Config.ProgressType = 'ox-circle'      -- ox-normal , ox-circle , qb
Config.OxCirclePosition = 0 -- only matters if Config.ProgressType = 'ox-circle'

Config.Weebhook = 'https://discord.com/api/webhooks/1330966212976316456/ZcOBOec2hvSJY-2B2pMP0iAppVSPhxIYiYWmTUhoexf-g2_tRkQ37roeT6va6ylFulMO'

Config.CooldownCashRegister = 15 -- in minutes
Config.CooldownSafe = 30 -- in minutes

Config.MinigameSafe = function() -- set to false to disable minigame
    local success = lib.skillCheck({'medium', 'medium', 'medium'}, {'w', 'a', 's', 'd'})
    return success
end

Config.MinigameCashRegister = function() -- set to false to disable minigame
    local success = lib.skillCheck({'easy', 'medium', 'easy'}, {'w', 'a', 's', 'd'})
    return success
end


Config.Safes = {
    vec3(28.25, -1338.87, 29.19), -- GROVE STREET
    vec3(-43.37, -1748.38, 29.22)  -- BALLAS
}

Config.CashRegister = {
    vec3(24.4, -1344.87, 29.5),  -- GROVE STREET
    vec3(-46.67, -1757.93, 29.42), -- BALLAS 
}

Config.Target = {
    cashRegister = {
        distance = 3, -- do not set above 6
        label = 'Rob Cash Register',
        icon = 'fas fa-cash-register',
    },
    safe = {
        distance = 2, -- do not set above 6
        label = 'Crack Safe',
        icon = 'fas fa-lock',
        size = vec3(2, 2, 2)
    }
}

Config.Progressbars = {
    cashRegister = {
        label = 'Robbing Cash Register...',
        time = 10000,
        anim = {'random@shop_robbery', 'robbery_action_f', 1} -- dict, clip, flag (optional)
    },
    safe = {
        label = 'Robbing Safe...',
        time = 10000,
        anim = {'random@shop_robbery', 'robbery_action_f', 1} -- dict, clip, flag (optional)
    }
}

Config.RequiredItems = {  
    cashRegister = { 
        item = false, --  set to false to disable
        weapon = 'weapon_crowbar'  -- set to false to disable
    },
    safe = { 
        item = {
            'lockpick',  -- set to false to disable
        },
        weapon = false  -- set to false to disable
    }
}


Config.Reward = {
    cashRegister = {
        item = 'black_money',
        min = 500,
        max = 800
    },
    safe = {
        item = 'black_money',
        min = 2000,
        max = 3500
    },
}


Config.CheaterDetected = function(source) 
    -- give your logic here, e.g. export from banning
    DropPlayer(source, 'You have been detected cheating')
end