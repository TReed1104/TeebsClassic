-- Frames
local frame = CreateFrame("Frame")

-- Register Event Listeners
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- Handle Events Triggering
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        -- Addon Loaded Trigger
        initialiseDB()
    end
    if event == "PLAYER_LOGIN" then
        -- Player Login Event Trigger
        print("Welcome to Teebs Classic, use /teebs")
        getCharacterItemsID();
        getCharacterMoney();
        -- getCharacterStats();
    end
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        -- Player Gear Change Trigger
        getCharacterItemsID();
        -- getCharacterStats();
    end
    if event == "PLAYER_MONEY" then
        -- Player Current Change Trigger
        getCharacterMoney();
    end
end)

local function slashHandler(msg, editbox)

end

-- Check is a table contains a key
function checkTableKey(table, key)
    return table[key] ~= nil
end

-- Create/load the addon database
function initialiseDB()
    -- Seed the schema of the database table
    if TeebsClassicDB == nil then
        -- Initialise the database
        TeebsClassicDB = {}

        -- Initialise the databases tables
        TeebsClassicDB.realms = {}
    end

    -- Get the base details about the logged in session
    local realm = GetRealmName()
    local playerName = UnitName("player");

    -- Check if there is a database entry for the current realm
    if TeebsClassicDB.realms[realm] == nil then
        TeebsClassicDB.realms[realm] = {}
        TeebsClassicDB.realms[realm].characters = {}
    end

    -- Check if there is a table entry for the current character in the realm table
    if TeebsClassicDB.realms[realm].characters[playerName] == nil then
        -- Create a table for the character
        TeebsClassicDB.realms[realm].characters[playerName] = {}
    end

    -- Create each of the variables and tables to store on the character
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "currency") then
        TeebsClassicDB.realms[realm].characters[playerName].currency = {}
    end
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "stats") then
        TeebsClassicDB.realms[realm].characters[playerName].stats = {}
    end
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "gear") then
        TeebsClassicDB.realms[realm].characters[playerName].gear = {}
    end
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "reputation") then
        TeebsClassicDB.realms[realm].characters[playerName].reputation = {}
    end
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "professions") then
        TeebsClassicDB.realms[realm].characters[playerName].professions = {}
    end
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "gear") then
        TeebsClassicDB.realms[realm].characters[playerName].gear = {}
    end
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "bags") then
        TeebsClassicDB.realms[realm].characters[playerName].bags = {}
    end
    if not checkTableKey(TeebsClassicDB.realms[realm].characters[playerName], "test") then
        TeebsClassicDB.realms[realm].characters[playerName].test = {}
    end
end

-- Slash Commands
SLASH_TEEBSCLASSIC1 = "/teebs"
SlashCmdList["TEEBSCLASSIC"] = slashHandler

function getCharacterItemsID(slot)
    -- Get the base details about the logged in session
    local realm = GetRealmName()
    local playerName = UnitName("player");

    -- Set each character slot
    for i = 0, 19 do
        local itemID, unknown = GetInventoryItemID("player", i)
        if itemID == nil then
            TeebsClassicDB.realms[realm].characters[playerName].gear[tostring(i)] = 0
        else
            TeebsClassicDB.realms[realm].characters[playerName].gear[tostring(i)] = itemID
        end
    end

    -- Set each bag slot
    for i = 0, 3 do
        local itemID, unknown = GetInventoryItemID("player", (i + 20))
        if itemID == nil then
            TeebsClassicDB.realms[realm].characters[playerName].bags[tostring(i)] = 0
        else
            TeebsClassicDB.realms[realm].characters[playerName].bags[tostring(i)] = itemID
        end
    end
end

function getCharacterMoney()
    -- Get the base details about the logged in session
    local realm = GetRealmName()
    local playerName = UnitName("player");

    -- Get the characters money value, returns in copper
    local copper = GetMoney()

    -- Map to our current table
    TeebsClassicDB.realms[realm].characters[playerName].currency["gold"] = math.floor(copper / 100 / 100)
    TeebsClassicDB.realms[realm].characters[playerName].currency["silver"] = math.floor((copper / 100) % 100)
    TeebsClassicDB.realms[realm].characters[playerName].currency["copper"] = copper % 100
end

function getCharacterStats()
    -- Get the base details about the logged in session
    local realm = GetRealmName()
    local playerName = UnitName("player");

    -- Get the character stats
    local _, stamina = UnitStat("player", 3)
    local _, strength = UnitStat("player", 1)
    local _, agility = UnitStat("player", 2)
    local _, intellect = UnitStat("player", 4)
    local _, spirit = UnitStat("player", 5)

    -- Set the character stats in the stats table
    TeebsClassicDB.realms[realm].characters[playerName].stats["stamina"] = stamina
    TeebsClassicDB.realms[realm].characters[playerName].stats["agility"] = agility
    TeebsClassicDB.realms[realm].characters[playerName].stats["strength"] = strength
    TeebsClassicDB.realms[realm].characters[playerName].stats["intellect"] = intellect
    TeebsClassicDB.realms[realm].characters[playerName].stats["spirit"] = spirit
end
