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
function splitString(stringToSplit, seperatorToken)
    -- Check if no custom seperator has been supplied, if not default to a blank space (' ')
    if seperatorToken == nil then
        seperatorToken = "%s"
    end

    -- Split the string
    local seperatedString = {}
    for stringChunk in string.gmatch(stringToSplit, "([^"..seperatorToken.."]+)") do
        -- Chunk found, insert into response
        table.insert(seperatedString, stringChunk)
    end
    return seperatedString
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
        -- [3] - Slot/value - Might not always been required, depending on the function
    local messageSplit = splitString(msg)

    -- Check we have our three inputs
    if messageSplit[1] == nil or messageSplit[2] == nil then
        print("Unknown Command - Please Check Your Syntax -", msg)
        return
    end

    -- Work out which addon function to use
    if messageSplit[1] == "get-slot" then
        cmdGetCharacterItemSlot(realm, messageSplit[2], messageSplit[3])
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

function cmdGetCharacterItemSlot(realm, character, slotNumber)
    -- Check the character exists
    if TeebsClassicDB.realms[realm].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the slot is recognised
    if TeebsClassicDB.realms[realm].characters[character].gear[slotNumber] == nil then
        print("Unknwon Slot", slotNumber)
        return
    end
    -- Check we have anything equipped in the desired slot
    if TeebsClassicDB.realms[realm].characters[character].gear[slotNumber] == 0 then
        print("Item Slot Empty")
    end
    -- Load the item data
    local item = Item:CreateFromItemID(TeebsClassicDB.realms[realm].characters[character].gear[slotNumber])
    -- Use the Item Mixin callback to await for the item to be cached
    item:ContinueOnItemLoad(function()
        -- Now the item has been cached, format the output string to use the class colour and print the item link
        local classColourR, classColourG, classColourB, classColourHex = GetClassColor(TeebsClassicDB.realms[realm].characters[character].class:upper())
        print(string.format("%s%s", "|c" .. classColourHex, character), string.format("%s%s", "|cffffffff", "has"), item:GetItemLink(), "equipped in slot", slotNumber)
    end)
end

function cmdGetCharacterBags(realm, character, slotNumber)
    print(string.format("%s%s", "|cffff0000", "To Be Implemented - getCharacterBags()"))
end

function cmdGetCharacterExperience(realm, character)
    print(string.format("%s%s", "|cffff0000", "To Be Implemented - getCharacterExperience()"))
end

