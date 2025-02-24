Config = {}

Config.Debug = true

Config.Language = 'pl' -- en, pl (add your own in locales)
Config.Framework = 'qbox'  -- qb , qbox, esx
Config.Notification = 'ox' -- ox , qb
Config.Inventory = 'ox'  -- ox , qb, esx
Config.ProgressType = 'ox-normal' -- ox-normal , ox-circle, qb
Config.OxCirclePosition = 'bottom' -- only matters if Config.ProgressType = 'ox-circle'

Config.Webhook = 'https://discord.com/api/webhooks/1247283578094620712/EDx9DmmYnXqXMkGgKBXrORH0m9NHcaZCbgRnhIebdjXzKebrA4QJ0fHTN7s0Jj_MAsGM'
-- ^ webhook for logging

Config.CooldownCashRegister = 15 -- in minutes
Config.CooldownSafe = 30 -- in minutes

Config.Safes = {
    vec3(28.25, -1338.87, 29.19), -- GROVE STREET
    vec3(-43.37, -1748.38, 29.22)  -- BALLAS
}

Config.CashRegister = {
    vec3(24.4, -1344.87, 29.5),  -- GROVE STREET
    vec3(-46.67, -1757.93, 29.42), -- BALLAS 
}

Config.MinigameSafe = function() -- set to false to disable minigame
    local success = lib.skillCheck({'medium', 'medium', 'medium'}, {'w', 'a', 's', 'd'})
    return success
end

Config.MinigameCashRegister = function() -- set to false to disable minigame
    local success = lib.skillCheck({'easy', 'medium', 'easy'}, {'w', 'a', 's', 'd'})
    return success
end

Config.CheaterDetected = function(source) 
    -- give your logic here, e.g. export from banning
    -- DropPlayer(source, 'You have been detected cheating')
end

Config.SpamEventDetected = function(source)
    -- give your logic here, e.g. export from banning
    -- DropPlayer(source, 'You have been detected spamming')
end

Config.PoliceAlert = function(source)
     -- give your logic here, e.g. export from police alert
end

Config.PoliceJobs = {
    'police',
    'sheriff'
}
Config.RequiredPoliceCount = 0 -- set to 0 or false to disable police check

Config.Target = {
    cashRegister = {
        distance = 2, -- do not set above 6
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
        time = 15000, -- in ms
        anim = {'anim@scripted@player@mission@tun_table_grab@gold@heeled@', 'grab', 1} -- dict, clip, flag (optional)
    },
    safe = {
        label = 'Robbing Safe...',
        time = 60000, -- in ms
        anim = {'random@shop_robbery', 'robbery_action_f', 1} -- dict, clip, flag (optional)
    }
}

Config.RequiredItems = {  
    cashRegister = { 
        item = false, --  set to false to disable
        weapon = 'weapon_crowbar'  -- set to false to disable
    },
    safe = { 
        item = {  -- set to false to disable
            'lockpick',  
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