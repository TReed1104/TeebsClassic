-- Frames
local frame = CreateFrame("Frame")

-- Register Event Listeners
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("PLAYER_XP_UPDATE")

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
    if event == "PLAYER_ENTERING_WORLD" then
        -- Player Enter World Trigger
        getCharacterItemsID()
        getCharacterMoney()
        getCharacterExperience()
        getCharacterLevel()
    end
    if event == "PLAYER_LEVEL_UP" then
        -- Player Level Up Trigger
        getCharacterExperience()
        getCharacterLevel()
    end
    if event == "PLAYER_MONEY" then
        -- Player Current Change Trigger
        getCharacterMoney()
    end
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        -- Player Gear Change Trigger
        getCharacterItemsID()
    end
    if event == "PLAYER_XP_UPDATE" then
        -- Player XP value update - Quest/NPC Kill
        getCharacterExperience()
        getCharacterLevel()
    end
end)

-- Custom Split string
function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

-- Slash Commands
SLASH_TEEBSCLASSIC1 = "/teebs"
SLASH_TEEBSCLASSIC2 = "/tbs"
SLASH_TEEBSCLASSIC3 = "/th"
SlashCmdList["TEEBSCLASSIC"] = function(msg)
    -- Get the base details about the logged in session
    local realm = GetRealmName()

    -- Message syntax
        -- [1] - Command
        -- [2] - Character
        -- [3] - Slot/value
    local messageSplit = splitString(msg)

    if messageSplit[1] == "get-slot" then
        -- Get character item slot
        if TeebsClassicDB.realms[realm].characters[messageSplit[2]] == nil then
            print("Unknown Charater", messageSplit[2])
        else
            -- Check if the slot is recognised
            if TeebsClassicDB.realms[realm].characters[messageSplit[2]].gear[messageSplit[3]] == nil then
                print("Unknwon Slot", messageSplit[3])
            else
                -- Check we have anything equipped
                if TeebsClassicDB.realms[realm].characters[messageSplit[2]].gear[messageSplit[3]] == 0 then
                    print("Item Slot Empty")
                else
                    -- Load the item data
                    local item = Item:CreateFromItemID(TeebsClassicDB.realms[realm].characters[messageSplit[2]].gear[messageSplit[3]])
                    -- When loaded, print the link
                    item:ContinueOnItemLoad(function()
                        local classColourR, classColourG, classColourB, classColourHex = GetClassColor(TeebsClassicDB.realms[realm].characters[messageSplit[2]].class:upper())
                        print(string.format("%s%s", "|c" .. classColourHex, messageSplit[2]), string.format("%s%s", "|cffffffff", "has"), item:GetItemLink(), "equipped in slot", messageSplit[3])
                    end)
                end
            end
        end
    else
        print("Unknown Command", messageSplit[1])
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
    end

    -- Create each of the variables and tables to store on the character
    if TeebsClassicDB.realms[realm].characters[playerName].faction == nil then
        TeebsClassicDB.realms[realm].characters[playerName].faction = UnitFactionGroup("player")
    end
    if TeebsClassicDB.realms[realm].characters[playerName].class == nil then
        TeebsClassicDB.realms[realm].characters[playerName].class = UnitClass("player")
    end
    if TeebsClassicDB.realms[realm].characters[playerName].level == nil then
        getCharacterLevel()
    end
    if TeebsClassicDB.realms[realm].characters[playerName].currency == nil then
        TeebsClassicDB.realms[realm].characters[playerName].currency = {}
    end
    if TeebsClassicDB.realms[realm].characters[playerName].gear == nil then
        TeebsClassicDB.realms[realm].characters[playerName].gear = {}
    end
    if TeebsClassicDB.realms[realm].characters[playerName].bags == nil then
        TeebsClassicDB.realms[realm].characters[playerName].bags = {}
    end
end

function getCharacterLevel()
    -- Get the base details about the logged in session
    local realm = GetRealmName()
    local playerName = UnitName("player")

    TeebsClassicDB.realms[realm].characters[playerName].level = UnitLevel("player")
end

function getCharacterExperience()
    -- Get the base details about the logged in session
    local realm = GetRealmName()
    local playerName = UnitName("player")

    -- Check the player level, if 60 
    if UnitLevel("player") == 60 then
        -- As the character is level 60, set the data fields to 0 as no more rested or exp can be gained
        TeebsClassicDB.realms[realm].characters[playerName].experienceCurrentPercentage = 0
        TeebsClassicDB.realms[realm].characters[playerName].experienceRestedPercentage = 0
        return  -- Return as we've got our data
    end

    -- Current Exp Calculations
    local currentExp = UnitXP("player")
    local maxExp = UnitXPMax("player")
    local expPercentage = math.floor((currentExp / maxExp) * 100)

    -- Rested Exp Calculations
    local restedExp = GetXPExhaustion()
    local restedPercentage = 0;
    -- If the API call doesn't return nil, calculate the percentage
    if restedExp then
        restedPercentage = math.floor((restedExp / maxExp) * 100)
    end

    -- Set the data fields for the character
    TeebsClassicDB.realms[realm].characters[playerName].experienceCurrentPercentage = expPercentage
    TeebsClassicDB.realms[realm].characters[playerName].experienceRestedPercentage = restedPercentage
end

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
