------------------------------------------------------------------
-- Globals Variables
------------------------------------------------------------------
CURRENT_REALM = ""
CURRENT_CHARACTER_NAME = ""

------------------------------------------------------------------
-- Addon Core Creation, Event Registration And Handling
------------------------------------------------------------------
-- Frame Creation
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
    -- Addon Loaded Trigger
    if event == "ADDON_LOADED" then
        CURRENT_REALM = GetRealmName():lower()
        CURRENT_CHARACTER_NAME = UnitName("player"):lower()
        initialiseDB()
    end

    -- Player Login Event Trigger
    if event == "PLAYER_LOGIN" then
        print("Welcome to Teebs Classic, use /teebs")
    end

    -- Player Enter World Trigger
    if event == "PLAYER_ENTERING_WORLD" then
        updateCharacterItemSlots()
        updateCharacterMoney()
        updateCharacterExperience()
        updateCharacterLevel()
    end

    -- Player Level Up Trigger
    if event == "PLAYER_LEVEL_UP" then
        updateCharacterExperience()
        updateCharacterLevel()
    end

    -- Player Current Change Trigger
    if event == "PLAYER_MONEY" then
        updateCharacterMoney()
    end

    -- Player Gear Change Trigger
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        updateCharacterItemSlots()
    end

    -- Player XP value update - Quest/NPC Kill
    if event == "PLAYER_XP_UPDATE" then
        updateCharacterExperience()
        updateCharacterLevel()
    end

end)


------------------------------------------------------------------
-- General Helper Functions
------------------------------------------------------------------
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

-- custom colour text wrapper
function colourText(colour, text)
    return string.format("%s%s", "|c" .. colour, text)
end

-- Capitalise first letter of string
function upperCaseFirst(inputString)
    return inputString:sub(1,1):upper()..inputString:sub(2)
end

-- Print currency data formatter
function formatCurrencyData(currencyData)
    return string.format("%ig %is %ic", currencyData["gold"], currencyData["silver"], currencyData["copper"])
end


------------------------------------------------------------------
-- Slash Command Registration and Functions
------------------------------------------------------------------
-- Slash Commands
SLASH_TEEBSCLASSIC1 = "/teebs"
SLASH_TEEBSCLASSIC2 = "/tbs"
SLASH_TEEBSCLASSIC3 = "/th"

-- Slash Command Handler Function
SlashCmdList["TEEBSCLASSIC"] = function(msg)
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

    -- Force the Character name to lower case behind the scenes
    messageSplit[2] = messageSplit[2]:lower()

    -- Work out which addon function to use
    if messageSplit[1] == "get-slot" then
        cmdGetCharacterItemSlot(messageSplit[2], messageSplit[3])
    elseif messageSplit[1] == "get-bags" then
        cmdGetCharacterBags(messageSplit[2], messageSplit[3])
    elseif messageSplit[1] == "get-exp" then
        cmdupdateCharacterExperience(messageSplit[2])
    elseif messageSplit[1] == "get-level" then
        cmdupdateCharacterLevel(messageSplit[2])
    elseif messageSplit[1] == "get-gold" then
        cmdGetCharacterGold(messageSplit[2])
    else
        print("Unknown Command", messageSplit[1])
    end
end


------------------------------------------------------------------
-- Data Caching Functions
------------------------------------------------------------------
-- Create the addon database and layout its data tables
function initialiseDB()
    -- Seed the schema of the database table
    if TeebsClassicDB == nil then
        -- Initialise the database
        TeebsClassicDB = {}

        -- Initialise the databases tables
        TeebsClassicDB.realms = {}
    end

    -- Check if there is a database entry for the current realm
    if TeebsClassicDB.realms[CURRENT_REALM] == nil then
        TeebsClassicDB.realms[CURRENT_REALM] = {}
        TeebsClassicDB.realms[CURRENT_REALM].characters = {}
    end

    -- Check if there is a table entry for the current character in the realm table
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME] == nil then
        -- Create a table for the character
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME] = {}
    end

    -- Create each of the variables and tables to store on the character
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].faction == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].faction = UnitFactionGroup("player")
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].class == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].class = UnitClass("player")
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].level == nil then
        updateCharacterLevel()
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency = {}
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].gear == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].gear = {}
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].bags == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].bags = {}
    end
end

-- Caching of the current characters level
function updateCharacterLevel()
    -- Set the character level in the DB
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].level = UnitLevel("player")
end

-- Caching of the current characters experience (current + rested %s)
function updateCharacterExperience()
    -- Check the player level, if 60 
    if UnitLevel("player") == 60 then
        -- As the character is level 60, set the data fields to 0 as no more rested or exp can be gained
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].experienceCurrentPercentage = 0
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].experienceRestedPercentage = 0
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
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].experienceCurrentPercentage = expPercentage
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].experienceRestedPercentage = restedPercentage
end

-- Caching of the current characters equipped items
function updateCharacterItemSlots(slot)
    -- Set each character slot
    for i = 0, 19 do
        local itemID, unknown = GetInventoryItemID("player", i)
        if itemID == nil then
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].gear[tostring(i)] = 0
        else
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].gear[tostring(i)] = itemID
        end
    end

    -- Set each bag slot
    for i = 1, 4 do
        local itemID, unknown = GetInventoryItemID("player", (i + 19))
        if itemID == nil then
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].bags[tostring(i)] = 0
        else
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].bags[tostring(i)] = itemID
        end
    end
end

-- Caching of the current characters currencies
function updateCharacterMoney()
    -- Get the characters money value, returns in copper
    local copper = GetMoney()

    -- Map to our current table
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency["gold"] = math.floor(copper / 100 / 100)
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency["silver"] = math.floor((copper / 100) % 100)
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency["copper"] = copper % 100
end

-- Caching of the current characters stats - Currently unused
function updateCharacterStats()
    -- Get the character stats
    local _, stamina = UnitStat("player", 3)
    local _, strength = UnitStat("player", 1)
    local _, agility = UnitStat("player", 2)
    local _, intellect = UnitStat("player", 4)
    local _, spirit = UnitStat("player", 5)

    -- Set the character stats in the stats table
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].stats["stamina"] = stamina
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].stats["agility"] = agility
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].stats["strength"] = strength
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].stats["intellect"] = intellect
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].stats["spirit"] = spirit
end


------------------------------------------------------------------
-- Addon Command Functions
------------------------------------------------------------------
-- Command function for retrieving a characters equipped items from the cache
function cmdGetCharacterItemSlot(character, slotNumber)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the slot is recognised
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear[slotNumber] == nil then
        print("Unknwon Slot", slotNumber)
        return
    end
    -- Check we have anything equipped in the desired slot
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear[slotNumber] == 0 then
        print("Item Slot Empty")
    end
    -- Load the item data
    local item = Item:CreateFromItemID(TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear[slotNumber])
    -- Use the Item Mixin callback to await for the item to be cached
    item:ContinueOnItemLoad(function()
        -- Now the item has been cached, format the output string to use the class colour and print the item link
        local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
        print(colourText(classColourHex, upperCaseFirst(character)) .. colourText("ffffff00", " has ") ..  item:GetItemLink() .. colourText("ffffff00", " equipped in gear slot " .. slotNumber))
    end)
end

-- Command function for retrieving a characters equipped bags from the cache
function cmdGetCharacterBags(character, slotNumber)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the slot is recognised
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags[slotNumber] == nil then
        print("Unknwon Bag Slot", slotNumber)
        return
    end
    -- Check we have anything equipped in the desired slot
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags[slotNumber] == 0 then
        print("Bag Slot Empty")
    end
    -- Load the item data
    local item = Item:CreateFromItemID(TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags[slotNumber])
    -- Use the Item Mixin callback to await for the item to be cached
    item:ContinueOnItemLoad(function()
        -- Now the item has been cached, format the output string to use the class colour and print the item link
        local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
        print(colourText(classColourHex, upperCaseFirst(character)) .. colourText("ffffff00", " has ") ..  item:GetItemLink() .. colourText("ffffff00", " equipped in bag slot " .. slotNumber))
    end)
end

-- Command function for retrieving a characters current and rested experience %s from the cache
function cmdupdateCharacterExperience(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the slot is recognised
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceCurrentPercentage == nil or TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceRestedPercentage == nil then
        print("Experience data not cached")
        return
    end
    -- Get the Character details
    local currentLevel = TeebsClassicDB.realms[CURRENT_REALM].characters[character].level
    local currentPercent = TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceCurrentPercentage
    local currentRestedPercent = TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceRestedPercentage
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Output the results in-game
    print(colourText(classColourHex, upperCaseFirst(character)) .. colourText("ffffff00", " is " .. currentPercent .. "% into level " .. currentLevel .. " and has ") .. colourText(currentRestedPercent == 150 and "ffff0000" or "ffffff00", currentRestedPercent .. "%") .. colourText("ffffff00", " rested experience remaining"))
end

-- Command function for retrieving a characters level from the cache
function cmdupdateCharacterLevel(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the slot is recognised
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].level == nil then
        print("Level data not cached")
        return
    end
    -- Get the Character details
    local currentLevel = TeebsClassicDB.realms[CURRENT_REALM].characters[character].level
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Output the results in-game
    print(colourText(classColourHex, upperCaseFirst(character)) .. colourText("ffffff00", " is currently level " .. currentLevel))
end

-- Command function for retrieving a characters currencies from the cache
function cmdGetCharacterGold(character)
    print(string.format("%s%s", "|cffff0000", "To Be Implemented - getCharacterGold()"))

    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the currency data has been recorded
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].currency == nil then
        print("Currency data not cached")
        return
    end
    -- Take a local copy of the currency
    local currencyData = TeebsClassicDB.realms[CURRENT_REALM].characters[character].currency
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Output the results in-game
    print(colourText(classColourHex, upperCaseFirst(character)) .. colourText("ffffff00", " has " .. formatCurrencyData(currencyData)))
end
