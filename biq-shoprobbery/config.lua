Config = {}

Config.Debug = false

Config.Language = 'en'             -- en, pl (add your own in locales)
Config.Framework = 'qbox'          -- qb , qbox, esx
Config.Notification = 'ox'         -- ox , qb
Config.Inventory = 'ox'            -- ox , qb, esx
Config.ProgressType = 'ox-normal'  -- ox-normal , ox-circle, qb
Config.OxCirclePosition = 'bottom' -- only matters if Config.ProgressType = 'ox-circle'

Config.Webhook = ''
-- ^ webhook for logging

Config.CooldownCashRegister = 15 -- in minutes
Config.CooldownSafe = 30         -- in minutes

Config.CashRegisters = {
    vec3(24.4, -1344.87, 29.5),     -- GROVE STREET
    vec3(-46.67, -1757.93, 29.42),  -- BALLAS
    vec3(373.14, 328.74, 103.57),   -- VINEWOOD
    vec3(1958.89, 3742.16, 32.34),  -- SANDY SHORES
    vec3(549.47, 2668.96, 42.16),   -- HARMONY
    vec3(1707.97, 4920.32, 42.06),  -- GRAPESEED
    vec3(1728.82, 6417.32, 35.04),  -- PALETO BAY
    vec3(2672.73, 3286.48, 55.04),  -- RIGHT HIGHWAY
    vec3(-3244.78, 1000.22, 12.83), -- CHUMASH
    vec3(-3041.31, 583.71, 7.91),   -- BANHAM CANYON
    vec3(1164.71, -322.64, 69.21),  -- MIRROR PARK
    vec3(-706.11, -913.53, 19.22),  -- CHINA TOWN
}


Config.Safes = {
    vec3(28.25, -1338.87, 29.19),   -- GROVE STREET
    vec3(-43.37, -1748.38, 29.22),  -- BALLAS
    vec3(378.14, 333.35, 103.27),   -- VINEWOOD
    vec3(1959.34, 3748.91, 32.14),  -- SANDY SHORES
    vec3(546.41, 2662.84, 42.06),   -- HARMONY
    vec3(1698.17, 4922.88, 42.06),  -- GRAPESEED
    vec3(1734.68, 6420.86, 35.04),  -- PALETO BAY
    vec3(2675.87, 3280.53, 55.24),  --  RIGHT HIGHWAY
    vec3(-3250.07, 1004.55, 12.43), -- CHUMASH
    vec3(-3047.85, 585.62, 7.91),   -- BANHAM CANYON
    vec3(1159.56, -314.06, 69.21),  -- MIRROR PARK
    vec3(-709.68, -904.03, 19.22),  -- CHINA TOWN
}

Config.MinigameCashRegister = function() -- set to false to disable minigame
    local success = lib.skillCheck({ 'easy', 'medium', 'easy' }, { 'w', 'a', 's', 'd' })
    return success
end

Config.MinigameSafe = function() -- set to false to disable minigame
    local success = lib.skillCheck({ 'medium', 'medium', 'medium' }, { 'w', 'a', 's', 'd' })
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

Config.ActionAfterCashRegisterRobbery = function(source)
    -- give your logic here, e.g. export from inventory
end

Config.ActionAfterSafeRobbery = function(source)
    -- give your logic here, e.g. export from inventory
end


Config.PoliceJobs = {
    'police',
    'sheriff'
}
Config.RequiredPoliceCount = 1 -- set to 0 or false to disable police check

Config.Target = {
    cashRegister = {
        distance = 2, -- do not set above 6
        label = 'Rob Cash Register',
        icon = 'fas fa-cash-register',
        size = vec3(1, 1, 1)
    },
    safe = {
        distance = 2, -- do not set above 6
        label = 'Crack Safe',
        icon = 'fas fa-lock',
        size = vec3(1, 1, 1)
    }
}

Config.Progressbars = {
    cashRegister = {
        label = 'Robbing Cash Register...',
        time = 15000,                                                                    -- in ms
        anim = { 'anim@scripted@player@mission@tun_table_grab@gold@heeled@', 'grab', 1 } -- dict, clip, flag (optional)
    },
    safe = {
        label = 'Robbing Safe...',
        time = 60000,                                           -- in ms
        anim = { 'random@shop_robbery', 'robbery_action_f', 1 } -- dict, clip, flag (optional)
    }
}

Config.RequiredItems = {
    cashRegister = {
        item = false,             --  set to false to disable
        weapon = 'weapon_crowbar' -- set to false to disable
    },
    safe = {
        item = { -- set to false to disable
            'lockpick',
        },
        weapon = false -- set to false to disable
    }
}

Config.Rewards = {
    cashRegister = {
        item = 'black_money',
        amount = math.random(500, 800)
    },
    safe = {
        item = 'black_money',
        amount = math.random(2000, 3500)
    },
}
