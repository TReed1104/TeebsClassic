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
    end
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        -- Player Gear Change Trigger
        getCharacterItemsID();
    end
    if event == "PLAYER_MONEY" then
        -- Player Current Change Trigger
        getCharacterMoney();
    end
end)

local function slashHandler(msg, editbox)

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

        -- Create each of the variables and tables to store on the character
        TeebsClassicDB.realms[realm].characters[playerName].currency = {}
        TeebsClassicDB.realms[realm].characters[playerName].stats = {}
        TeebsClassicDB.realms[realm].characters[playerName].gear = {}
        TeebsClassicDB.realms[realm].characters[playerName].reputation = {}
        TeebsClassicDB.realms[realm].characters[playerName].professions = {}
        TeebsClassicDB.realms[realm].characters[playerName].gear = {}
        TeebsClassicDB.realms[realm].characters[playerName].bags = {}

        -- Setup the currency keys
        TeebsClassicDB.realms[realm].characters[playerName].currency["gold"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].currency["silver"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].currency["copper"] = 0

        -- Setup the stats keys
        TeebsClassicDB.realms[realm].characters[playerName].stats["stamina"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].stats["agility"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].stats["strength"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].stats["intellect"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].stats["spirit"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].stats["armor"] = 0

        -- Setup the professions keys
        TeebsClassicDB.realms[realm].characters[playerName].professions["main_one"] = {}
        TeebsClassicDB.realms[realm].characters[playerName].professions["main_two"] = {}
        TeebsClassicDB.realms[realm].characters[playerName].professions["first_aid"] = {}
        TeebsClassicDB.realms[realm].characters[playerName].professions["fishing"] = {}
        TeebsClassicDB.realms[realm].characters[playerName].professions["cooking"] = {}

        -- Setup the gear slot Keys
        TeebsClassicDB.realms[realm].characters[playerName].gear["0"] = 0         -- Ammo
        TeebsClassicDB.realms[realm].characters[playerName].gear["1"] = 0         -- Head
        TeebsClassicDB.realms[realm].characters[playerName].gear["2"] = 0         -- Neck
        TeebsClassicDB.realms[realm].characters[playerName].gear["3"] = 0         -- Shoulder
        TeebsClassicDB.realms[realm].characters[playerName].gear["4"] = 0         -- Shirt
        TeebsClassicDB.realms[realm].characters[playerName].gear["5"] = 0         -- Chest
        TeebsClassicDB.realms[realm].characters[playerName].gear["6"] = 0         -- Belt
        TeebsClassicDB.realms[realm].characters[playerName].gear["7"] = 0         -- Legs
        TeebsClassicDB.realms[realm].characters[playerName].gear["8"] = 0         -- Feet
        TeebsClassicDB.realms[realm].characters[playerName].gear["9"] = 0         -- Wrist
        TeebsClassicDB.realms[realm].characters[playerName].gear["10"] = 0        -- Gloves
        TeebsClassicDB.realms[realm].characters[playerName].gear["11"] = 0        -- Ring 1
        TeebsClassicDB.realms[realm].characters[playerName].gear["12"] = 0        -- Ring 2
        TeebsClassicDB.realms[realm].characters[playerName].gear["13"] = 0        -- Trinket 1
        TeebsClassicDB.realms[realm].characters[playerName].gear["14"] = 0        -- Trinket 2
        TeebsClassicDB.realms[realm].characters[playerName].gear["15"] = 0        -- Back
        TeebsClassicDB.realms[realm].characters[playerName].gear["16"] = 0        -- Main Hand
        TeebsClassicDB.realms[realm].characters[playerName].gear["17"] = 0        -- Off Hand
        TeebsClassicDB.realms[realm].characters[playerName].gear["18"] = 0        -- Ranged
        TeebsClassicDB.realms[realm].characters[playerName].gear["19"] = 0        -- Tabard

        -- Setup the bag slot keys
        TeebsClassicDB.realms[realm].characters[playerName].bags["0"] = 0       -- Right most bag
        TeebsClassicDB.realms[realm].characters[playerName].bags["1"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].bags["2"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].bags["3"] = 0       -- Left most bag
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

end
