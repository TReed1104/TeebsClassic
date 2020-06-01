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
    end
end)

local function slashHandler(msg, editbox)
    if msg == "all" then
        printHiddenStats()
    elseif msg == "melee" then
        printMeleeStats()
    elseif msg == "def" then
        printDefensiveStats()
    elseif msg == "spell" then
        printMagicStats()
    elseif msg == "" then
        print("Please enter your selection: all, melee, def or spell")
    else
        print("Oops! Not recognised mode")
    end
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
        TeebsClassicDB.realms[realm].characters[playerName].gear["ammo"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["head"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["neck"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["shoulder"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["shirt"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["chest"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["belt"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["legs"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["feet"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["wrist"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["gloves"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["ring_1"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["ring_2"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["trinket_1"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["trinket_2"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["back"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["main_hand"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["off_hand"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["ranged"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].gear["tabard"] = 0

        -- Setup the bag slot keys
        TeebsClassicDB.realms[realm].characters[playerName].bags["bag_0"] = 0       -- Right most bag
        TeebsClassicDB.realms[realm].characters[playerName].bags["bag_1"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].bags["bag_2"] = 0
        TeebsClassicDB.realms[realm].characters[playerName].bags["bag_3"] = 0       -- Left most bag
    end
end

-- Slash Commands
SLASH_TEEBSCLASSIC1 = "/teebs"
SlashCmdList["TEEBSCLASSIC"] = slashHandler

function printHiddenStats()
    print("-------------------------------")
    print("Melee Stats")
    print("-------------------------------")
    print("Melee Hit Chance " .. round(GetHitModifier(), 2) .. "%")
    print("Melee Crit Chance " .. round(GetCritChance(), 2) .. "%")
    print("-------------------------------")
    print("Defensive Stats")
    print("-------------------------------")
    print("Dodge Chance " .. round(GetDodgeChance(), 2) .. "%")
    print("Parry Chance " .. round(GetParryChance(), 2) .. "%")
    print("Block Chance " .. round(GetBlockChance(), 2) .. "%")
    print("-------------------------------")
    print("Spell Stats")
    print("-------------------------------")
    print("Spell Hit Chance " .. round(GetSpellHitModifier(), 2) .. "%")
    print("Spell Crit Chance (Physical) " .. round(GetSpellCritChance(1), 2) .. "%")
    local averageSpellCrit = round((GetSpellCritChance(2) + GetSpellCritChance(3) + GetSpellCritChance(4) + GetSpellCritChance(5) + GetSpellCritChance(6) + GetSpellCritChance(7)) / 6, 2)
    print("Spell Crit Chance (Average) " .. averageSpellCrit .. "%")
end

function printMeleeStats()
    print("-------------------------------")
    print("Melee Stats")
    print("-------------------------------")
    print("Melee Hit Chance " .. round(GetHitModifier(), 2) .. "%")
    print("Melee Crit Chance " .. round(GetCritChance(), 2) .. "%")
end

function printDefensiveStats()
    print("-------------------------------")
    print("Defensive Stats")
    print("-------------------------------")
    print("Dodge Chance " .. round(GetDodgeChance(), 2) .. "%")
    print("Parry Chance " .. round(GetParryChance(), 2) .. "%")
    print("Block Chance " .. round(GetBlockChance(), 2) .. "%")
end

function printMagicStats()
    print("-------------------------------")
    print("Spell Stats")
    print("-------------------------------")
    print("Spell Hit Chance " .. round(GetSpellHitModifier(), 2) .. "%")
    print("Spell Crit Chance (Physical) " .. round(GetSpellCritChance(1), 2) .. "%")
    local averageSpellCrit = round((GetSpellCritChance(2) + GetSpellCritChance(3) + GetSpellCritChance(4) + GetSpellCritChance(5) + GetSpellCritChance(6) + GetSpellCritChance(7)) / 6, 2)
    print("Spell Crit Chance (Average) " .. averageSpellCrit .. "%")
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end