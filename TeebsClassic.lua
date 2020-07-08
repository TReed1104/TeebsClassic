------------------------------------------------------------------
-- Globals Variables
------------------------------------------------------------------
CURRENT_REALM = ""
CURRENT_CHARACTER_NAME = ""
TEEBS_TEXT_COLOUR_DEFAULT = "ffffff00"
TEEBS_TEXT_COLOUR_ALERT = "ffff0000"
TEEBS_TEXT_COLOUR_CAPPED = "ff00ff00"
TEEBS_TEXT_COLOUR_TALENTS = "ffffa500"

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
frame:RegisterEvent("TRADE_SKILL_UPDATE")
frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
frame:RegisterEvent("UPDATE_FACTION")
frame:RegisterEvent("TIME_PLAYED_MSG")

-- Handle Events Triggering
frame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, ...)
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
        setCharacterDataItemSlots()
        setCharacterDataCurrency()
        setCharacterDataCharacterExperience()
        setCharacterDataLevel()
        setCharacterDataSpecialisation()
        setCharacterDataProfessions()
        setCharacterDataReputation()
        RequestTimePlayed();    -- Send the request to the server to query the character play time, the return data happens in the TIME_PLAYED_MSG event
    end

    -- Player Level Up Trigger
    if event == "PLAYER_LEVEL_UP" then
        setCharacterDataCharacterExperience()
        setCharacterDataLevel()
        RequestTimePlayed();    -- Send the request to the server to query the character play time, the return data happens in the TIME_PLAYED_MSG event
    end

    -- Player Skill Update Trigger
    if event == "TRADE_SKILL_UPDATE" then
        setCharacterDataProfessions()
    end

    -- Player Current Change Trigger
    if event == "PLAYER_MONEY" then
        setCharacterDataCurrency()
    end

    -- Player Gear Change Trigger
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        setCharacterDataItemSlots()
    end

    -- Player XP value update - Quest/NPC Kill
    if event == "PLAYER_XP_UPDATE" then
        setCharacterDataCharacterExperience()
        setCharacterDataLevel()
    end

    -- Player Talent Changes
    if event == "CHARACTER_POINTS_CHANGED" then
        setCharacterDataSpecialisation()
    end

    -- Faction reputation change event
    if event == "UPDATE_FACTION" then
        setCharacterDataReputation()
    end

    -- Play Time callback catch
    if event == "TIME_PLAYED_MSG" then
        setCharacterDataPlayTime(arg1, arg2)
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
function recolourOutputText(colour, text)
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

-- Generate Reputation standing text colour
function getFactionStandingTextColour(standing)
    -- Change faction standing text colour depending on standing
    local standingColour = "ffff00"
    -- Using the faction standing, set the colour to the WoW colours used
    if standing == "Hated" then
        standingColour = "cc0000"
    elseif standing == "Hostile" then
        standingColour = "ff0000"
    elseif standing == "Unfriendly" then
        standingColour = "f26000"
    elseif standing == "Neutral" then
        standingColour = "e4e400"
    elseif standing == "Friendly" then
        standingColour = "33ff33"
    elseif standing == "Honoured" then
        standingColour = "5fe65d"
    elseif standing == "Revered" then
        standingColour = "53e9bc"
    elseif standing == "Exalted" then
        standingColour = "2ee6e6"
    end
    return "ff" .. standingColour
end

-- Calculate the rep standing in numerical values - E.g. 4123/6000 or 12135/21000 etc.
function getFactionStandingValues(reputationData)
    -- repValueBottom acts as the offset for our values, neutral -> exalted is 42000 rep, so an offset of 21000 puts us in the revered-to-exalted range and our repValueEarned value is the amount through that band
    return (reputationData.repValueEarned - reputationData.repValueBottom) .. "/" .. (reputationData.repValueTop - reputationData.repValueBottom)
end

-- Play time data is returned by the server in seconds, this converts it to a X days Y Hours Z Seconds format
function formatPlayTimeData(totalPlayTimeInSeconds)
    local seconds = (totalPlayTimeInSeconds % 60)
    local minutes = (totalPlayTimeInSeconds % 3600) / 60
    local hours = (totalPlayTimeInSeconds % 86400) / 3600
    local days = totalPlayTimeInSeconds / 86400
    -- Pack the calculate values into a return string
    return string.format("%i days, %i hours, %i minutes, %i seconds", days, hours, minutes, seconds)
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

    -- check we have a usable command and that we have a command option
    if messageSplit == nil or messageSplit[1] == nil then
        print("Invalid Command - ", msg)
        return
    end

    -- If supplied, force the Character name to lower case behind the scenes
    if messageSplit[2] then
        messageSplit[2] = messageSplit[2]:lower()
    end

    -- Command parameter checks, sanity check we've got what we need for the command functions
    if messageSplit[1] == "get-exp" or messageSplit[1] == "get-level" or messageSplit[1] == "get-spec" or messageSplit[1] == "get-talents" or messageSplit[1] == "get-gold" or messageSplit[1] == "get-professions" or messageSplit[1] == "get-primary-professions" or messageSplit[1] == "get-secondary-professions" or messageSplit[1] == "get-reps-all" or messageSplit[1] == "get-slot-all" or messageSplit[1] == "get-bags-all" then
        -- Check we have the character name
        if messageSplit[2] == nil then
            print("You must supply a character name for this command")
            return
        end
    elseif messageSplit[1] == "get-slot" or messageSplit[1] == "get-bag" or messageSplit[1] == "get-rep" then
        -- Check we have the character name and slot/bag index
        if messageSplit[2] == nil or messageSplit[3] == nil then
            print("You must supply a character name and item/bag slot index or faction name for this command")
            return
        end
    end

    -- Work out which addon function to use
    if messageSplit[1] == "get-slot" then
        cmdGetCharacterItemSlot(messageSplit[2], messageSplit[3])
    elseif messageSplit[1] == "get-bag" then
        cmdGetCharacterBag(messageSplit[2], messageSplit[3])
    elseif messageSplit[1] == "get-exp" then
        cmdGetCharacterExperience(messageSplit[2])
    elseif messageSplit[1] == "get-level" then
        cmdGetCharacterLevel(messageSplit[2])
    elseif messageSplit[1] == "get-spec" then
        cmdGetCharacterSpec(messageSplit[2])
    elseif messageSplit[1] == "get-talents" then
        cmdGetCharacterTalents(messageSplit[2])
    elseif messageSplit[1] == "get-gold" then
        cmdGetCharacterGold(messageSplit[2])
    elseif messageSplit[1] == "get-professions" then
        cmdGetCharacterProfessions(messageSplit[2])
    elseif messageSplit[1] == "get-primary-professions" then
        cmdGetCharacterPrimaryProfessions(messageSplit[2])
    elseif messageSplit[1] == "get-secondary-professions" then
        cmdGetCharacterSecondaryProfessions(messageSplit[2])
    elseif messageSplit[1] == "get-rep" then
        cmdGetCharacterReputation(messageSplit[2], messageSplit[3]:lower())
    elseif messageSplit[1] == "get-playtime" then
        cmdGetCharacterPlayTime(messageSplit[2])
    elseif messageSplit[1] == "get-slot-all" then
        cmdGetAllCharactersItemSlots(messageSplit[2])
    elseif messageSplit[1] == "get-bags-all" then
        cmdGetAllCharactersBags(messageSplit[2])
    elseif messageSplit[1] == "get-exp-all" then
        cmdGetAllCharactersExperience()
    elseif messageSplit[1] == "get-level-all" then
        cmdGetAllCharactersLevels()
    elseif messageSplit[1] == "get-spec-all" then
        cmdGetAllCharacterSpecs()
    elseif messageSplit[1] == "get-gold-all" then
        cmdGetAllCharactersGold()
    elseif messageSplit[1] == "get-professions-all" then
        cmdGetAllCharacterProfessions()
    elseif messageSplit[1] == "get-primary-professions-all" then
        cmdGetAllCharacterPrimaryProfessions()
    elseif messageSplit[1] == "get-secondary-professions-all" then
        cmdGetAllCharacterSecondaryProfessions()
    elseif messageSplit[1] == "get-reps-all" then
        cmdGetAllCharacterReputations(messageSplit[2])
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
        setCharacterDataLevel()
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"] == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"] = { total = 0, current = 0}
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents = {}
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
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions = {}
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].reputations == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].reputations = {}
    end
end

-- Caching of the current characters level
function setCharacterDataLevel()
    -- Set the character level in the DB
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].level = UnitLevel("player")
end

-- Caching of the characters time played
function setCharacterDataPlayTime(total, current)
    -- If the time-played table exists for the character
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"] ~= nil then
        -- Set the time-played values
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"]["total"] = formatPlayTimeData(total)
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"]["current"] = formatPlayTimeData(current)
    end
end

-- Caching of the current characters talents
function setCharacterDataSpecialisation()
    -- The characters overall talent point distribution
    local overallTalentDistribution = ""
    -- Reset the spec table
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents.specialisation = {}
    -- For all the talent tree tabs
    for tabIndex = 1, GetNumTalentTabs() do
        -- Get the talent tree info
        local talentTreeName, _, talentTreeSpent = GetTalentTabInfo(tabIndex)
        -- Lower case the talentTreeName
        talentTreeName = talentTreeName:lower()
        -- Create a table for the spec
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents[talentTreeName] = {}
        -- Record the number of talents in that tree
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents.specialisation[talentTreeName] = talentTreeSpent
        -- Format the overall spec data
        overallTalentDistribution = (tabIndex == GetNumTalentTabs()) and (overallTalentDistribution .. talentTreeSpent) or (overallTalentDistribution .. talentTreeSpent .. "/")
        -- Iterate through each talent in the talent tree
        for talentIndex = 1, GetNumTalents(tabIndex) do
            -- Get the talent data
            local talentName, _, talentTier, talentColumn, talentRank, talentMaxRank = GetTalentInfo(tabIndex, talentIndex)
            -- Check theres a table made for this tier of the talent tree E.g. Fury -> Tier 1
            if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents[talentTreeName][tostring(talentTier)] == nil then
                TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents[talentTreeName][tostring(talentTier)] = {}
            end
            -- Check theres a table made for this column of the talent tree E.g. Fury -> Tier 1 -> Column 2
            if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents[talentTreeName][tostring(talentTier)][tostring(talentColumn)] == nil then
                TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents[talentTreeName][tostring(talentTier)][tostring(talentColumn)] = {}
            end
            -- Record the data for this talent -> name, current rank and max rank
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents[talentTreeName][tostring(talentTier)][tostring(talentColumn)] = { name = talentName, currentRank = talentRank, maxRank = talentMaxRank }
        end
    end
    -- Set the talent distribution overview e.g. 12/39/0
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].talents.specialisation.distribution = overallTalentDistribution
end

-- Caching of the current characters experience (current + rested %s)
function setCharacterDataCharacterExperience()
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
        -- On login the WoW API sometimes returns a value greater than the 150%, this just caps to the capped 150% it actually uses
        if restedPercentage > 150 then
            restedPercentage = 150
        end
    end

    -- Set the data fields for the character
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].experienceCurrentPercentage = expPercentage
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].experienceRestedPercentage = restedPercentage
end

-- Caching of the current characters equipped items
function setCharacterDataItemSlots(slot)
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
function setCharacterDataCurrency()
    -- Get the characters money value, returns in copper
    local copper = GetMoney()

    -- Map to our current table
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency["gold"] = math.floor(copper / 100 / 100)
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency["silver"] = math.floor((copper / 100) % 100)
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency["copper"] = copper % 100
end

-- Caching the professions of the current character
function setCharacterDataProfessions()
    -- Reset the primary profession table, this is incase the player changes a profession between data caching
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.primary = {}

    -- Check if the secondary professions table exists, create it if not
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.secondary == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.secondary = {}
    end

    -- Primary Professions
    for skillIndex = 1, GetNumSkillLines() do
        local skillName, _, _, skillRank, _, _, skillMaxRank, isAbandonable, _, _, _, _, _ = GetSkillLineInfo(skillIndex)
        if isAbandonable then
            if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.primary[skillName] == nil then
                TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.primary[skillName] = {}
            end
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.primary[skillName].current = skillRank
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.primary[skillName].max = skillMaxRank
        end
    end

    -- Secondary Professions
    for skillIndex = 1, GetNumSkillLines() do
        local skillName, _, _, skillRank, _, _, skillMaxRank, isAbandonable, _, _, _, _, _ = GetSkillLineInfo(skillIndex)
        if skillName == "Cooking" or skillName == "First Aid" or skillName == "Fishing" then
            if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.secondary[skillName] == nil then
                TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.secondary[skillName] = {}
            end
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.secondary[skillName].current = skillRank
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].professions.secondary[skillName].max = skillMaxRank
        end
    end
end

-- Caching of the current characters stats - Currently unused
function setCharacterDataStats()
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

-- Cache the characters faction reputation data
function setCharacterDataReputation()
    -- GetNumFactions() returns the number of factions visible on the reputation panel, it will not count those in collapsed headers etc.
    -- Therefore we have to check if the current faction is a header and if it is, expand the header and get a new faction count value
    -- Base premise taken from the wow gamepedia page about GetFactionInfo

    -- Set our bases for the iteration
    local factionCount = GetNumFactions()
    local factionIndex = 1
    
    -- Keep iterating until we hit the expanding faction counter
    while factionIndex <= factionCount do
        -- Use GetFactionInfo() to retrieve the information on the faction at index x in the reputation tab
        local factionName, _, factionStandingID, repValueBottom, repValueTop, repValueEarned, _, _, isHeader, isHeaderCollapsed = GetFactionInfo(factionIndex)

        -- Check if we are current dealing with a header panel in the rep panel
        if isHeader then
            -- If the faction is actually a header and its been collapsed, expand it and increment the faction counter
            if isHeaderCollapsed then
                ExpandFactionHeader(factionIndex)   -- Expand the faction header to get the real number of factions
                factionCount = GetNumFactions()     -- Get our new Faction count
            end
        else
            -- TODO: Calculate our actual rep standing, e.g. Honored 4123/12000
            -- Format the faction names to not use spaces for the table key -> "argent-dawn" not "argent dawn"
            formattedFactionName = factionName:lower():gsub(" ", "-")
            -- Record the data on the faction
            TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].reputations[formattedFactionName] = { factionName = factionName, factionStanding = _G["FACTION_STANDING_LABEL" .. factionStandingID], factionStandingID = factionStandingID, repValueBottom = repValueBottom, repValueTop = repValueTop, repValueEarned = repValueEarned }
        end
        -- Increment the factionIndex manually
        factionIndex = factionIndex + 1     -- I miss '++' operators, damn it Lua
    end
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
    -- Check a slot number was supplied
    if slotNumber == nil then
        print("No Equipment Slot Supplied")
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
        return
    end
    -- Load the item data
    local item = Item:CreateFromItemID(TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear[slotNumber])
    -- Use the Item Mixin callback to await for the item to be cached
    item:ContinueOnItemLoad(function()
        -- Now the item has been cached, format the output string to use the class colour and print the item link
        local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
        print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in gear slot " .. slotNumber))
    end)
end

-- Command function for retrieving a characters equipped bags from the cache
function cmdGetCharacterBag(character, slotNumber)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check a slot number was supplied
    if slotNumber == nil then
        print("No Bag Slot Supplied")
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
        print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in bag slot " .. slotNumber))
    end)
end

-- Command function for retrieving a characters current and rested experience %s from the cache
function cmdGetCharacterExperience(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the character experience data has been cached
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
    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is " .. currentPercent .. "% into level " .. currentLevel .. " and has ") .. recolourOutputText(currentRestedPercent >= 150 and TEEBS_TEXT_COLOUR_ALERT or TEEBS_TEXT_COLOUR_DEFAULT, currentRestedPercent .. "%") .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " rested experience remaining"))
end

-- Command function for retrieving a characters level from the cache
function cmdGetCharacterLevel(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the character level has been cached
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].level == nil then
        print("Level data not cached")
        return
    end
    -- Get the Character details
    local currentLevel = TeebsClassicDB.realms[CURRENT_REALM].characters[character].level
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Output the results in-game
    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently level " .. currentLevel))
end

-- Command function for retrieving a characters play time
function cmdGetCharacterPlayTime(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the character level has been cached
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character]["time-played"] == nil then
        print("Playtime data not cached")
        return
    end
    -- Local copy the play-time table for faster access
    local currentPlaytime = TeebsClassicDB.realms[CURRENT_REALM].characters[character]["time-played"]
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Output the results in-game
    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Total time played: " .. currentPlaytime.total))
    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Time played this level: " .. currentPlaytime.current))
end

-- Command function for retrieving a characters talent spec
function cmdGetCharacterSpec(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the characters talents have been cached
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents == nil then
        print("Talent data not cached")
        return
    end
    -- Check if the characters specialisation have been cached
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents.specialisation == nil then
        print("Specialisation data not cached")
        return
    end
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Output the results in-game
    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently specced " .. TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents.specialisation.distribution))
end

-- Command function for retrieving a characters talent distribution
function cmdGetCharacterTalents(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the characters talents have been cached
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents == nil then
        print("Talent data not cached")
        return
    end
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Iterate through each talent tree in the talents table
    for talentTreeName, talentTreeTable in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents) do
        -- Ignore the specialisation variable from the talents table
        if talentTreeName ~= "specialisation" then
            -- Check any points are in that talent tree
            if TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents.specialisation[talentTreeName] > 0 then
                print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Talent Tree - ").. recolourOutputText(TEEBS_TEXT_COLOUR_TALENTS, upperCaseFirst(talentTreeName)))
                for talentTier = 1, 7 do
                    for talentColumn = 1, 4 do
                        if talentTreeTable[tostring(talentTier)][tostring(talentColumn)] ~= nil then
                            talent = talentTreeTable[tostring(talentTier)][tostring(talentColumn)]
                            if talent.currentRank > 0 then
                                print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has talent ") .. recolourOutputText(TEEBS_TEXT_COLOUR_TALENTS, talent.name) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " at Rank " .. talent.currentRank .. "/" .. talent.maxRank))
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Command function for retrieving a characters currencies from the cache
function cmdGetCharacterGold(character)
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
    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. formatCurrencyData(currencyData)))
end

-- Command function for retrieving a characters profession skill levels
function cmdGetCharacterProfessions(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end

    -- Check if the currency data has been recorded
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions == nil then
        print("Professions data not cached")
        return
    end

    -- Take a local copy of the profession data for quicker access
    local characterProfessionsTable = TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions

    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())

    -- Example Profession data table
    -- ["primary"] = {
    --     ["Alchemy"] = {
    --         ["max"] = 75,
    --         ["current"] = 1,
    --     }
    -- },
    -- ["secondary"] = {
    --     ["First Aid"] = {
    --         ["max"] = 225,
    --         ["current"] = 181,
    --     }
    -- },

    -- Iterate through each profession type (primary, secondary, etc) stored in the data table
    for professionType, professionTypeTables in pairs(characterProfessionsTable) do
        -- Iterator through each profession in each profession type - This is what actually catches the profession data
        for profession, professionData in pairs(professionTypeTables) do
            -- Output the results in-gam (colour the level output green if its maxed)
            print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
        end
    end
end

-- Get only a characters primary professions
function cmdGetCharacterPrimaryProfessions(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the currency data has been recorded
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions == nil then
        print("Professions data not cached")
        return
    end
    -- Take a local copy of the profession data for quicker access
    local characterPrimaryProfessions = TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions["primary"]
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Iterator through each profession in the primary profession table
    for profession, professionData in pairs(characterPrimaryProfessions) do
        -- Output the results in-gam (colour the level output green if its maxed)
        print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
    end
end

-- Get only a characters secondary professions
function cmdGetCharacterSecondaryProfessions(character)
        -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the currency data has been recorded
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions == nil then
        print("Professions data not cached")
        return
    end
    -- Take a local copy of the profession data for quicker access
    local characterSecondaryProfessions = TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions["secondary"]
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Iterator through each profession in the primary profession table
    for profession, professionData in pairs(characterSecondaryProfessions) do
        -- Output the results in-gam (colour the level output green if its maxed)
        print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
    end
end

-- Get the data on a characters standing with a selected reputation
function cmdGetCharacterReputation(character, faction)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the reputation data has been recorded
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].reputations == nil then
        print("Reputation data not cached")
        return
    end
    -- Check the desired faction exists in the characters reputation data
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].reputations[faction] == nil then
        print("Reputation data on the desired faction not found")
        return
    end
    -- Retrieve the factions data table
    local faction = TeebsClassicDB.realms[CURRENT_REALM].characters[character].reputations[faction]
    -- Get the class colour
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
    -- Generate the function's in-game response
    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " - ") .. recolourOutputText(TEEBS_TEXT_COLOUR_CAPPED, faction.factionName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently ") .. recolourOutputText(getFactionStandingTextColour(faction.factionStanding), faction.factionStanding .. " - " .. getFactionStandingValues(faction)))
end

-- Get the data on all the factions the character has cached
function cmdGetAllCharacterReputations(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- Check if the reputation data has been recorded
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].reputations == nil then
        print("Reputation data not cached")
        return
    end
    -- Iterate through each faction stored in the reputation data table
    for reputation, reputationData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters[character].reputations) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
        -- Generate the function's in-game response
        print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " - ") .. recolourOutputText(TEEBS_TEXT_COLOUR_CAPPED, reputationData.factionName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently ") .. recolourOutputText(getFactionStandingTextColour(reputationData.factionStanding), reputationData.factionStanding .. " - " .. getFactionStandingValues(reputationData)))
    end
end

-- Command function for retrieval all equipment slots for a character
function cmdGetAllCharactersItemSlots(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    -- For each equipment slot in the gear table, grab the item (if its not empty and the id is not 0) and print it like we do with get-slot
    for slotNumber, itemID in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear) do
        -- Check if the slot is recognised
        if TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear[slotNumber] then
            -- Check we have anything equipped in the desired slot
            if TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear[slotNumber] > 0 then
                -- Load the item data
                local item = Item:CreateFromItemID(itemID)
                -- Use the Item Mixin callback to await for the item to be cached
                item:ContinueOnItemLoad(function()
                    -- Now the item has been cached, format the output string to use the class colour and print the item link
                    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
                    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in gear slot " .. slotNumber))
                end)
            end
        end
    end
end

-- Command function for retrieving all the bags cached equipped by a characters
function cmdGetAllCharactersBags(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end

    -- For each equipment bag in the bags table, grab the item (if its not empty and the id is not 0) and print it like we do with get-slot
    for slotNumber, itemID in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags) do
        -- Check if the bag slot is recognised
        if TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags[slotNumber] then
            -- Check we have anything currently in the desired bag slot
            if TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags[slotNumber] > 0 then
                -- Load the item data
                local item = Item:CreateFromItemID(itemID)
                -- Use the Item Mixin callback to await for the item to be cached
                item:ContinueOnItemLoad(function()
                    -- Now the item has been cached, format the output string to use the class colour and print the item link
                    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[character].class:upper())
                    print(recolourOutputText(classColourHex, upperCaseFirst(character)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in bag slot " .. slotNumber))
                end)
            end
        end
    end
end

-- Command function for retrieving the current and rested experience %s for all tracked characters on the realm
function cmdGetAllCharactersExperience()
    -- For every character cached for the current realm, print their current and rested exp %s
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(characterData.class:upper())
        -- Check if the character is level 60
        if characterData.level == 60 then
            -- Print the character is level 60, theres no point in printing the exp stats as they're always 0!
            print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is level " .. characterData.level))
        else
            -- Output the results in-game, current level, current exp and rested exp
            print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is " .. characterData.experienceCurrentPercentage .. "% into level " .. characterData.level .. " and has ") .. recolourOutputText(characterData.experienceRestedPercentage >= 150 and TEEBS_TEXT_COLOUR_ALERT or TEEBS_TEXT_COLOUR_DEFAULT, characterData.experienceRestedPercentage .. "%") .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " rested experience remaining"))
        end
    end
end

-- Command function for retrieving the level of every cached character
function cmdGetAllCharactersLevels()
    -- For every character cached for the current realm, print their current level
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(characterData.class:upper())
        -- Output the character levels
        print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is level " .. characterData.level))
    end
end

-- Command function for retrieving the talent spec of all cached characters on the current server
function cmdGetAllCharacterSpecs()
    -- For every character cached for the current realm, print their character spec
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(characterData.class:upper())
        -- Output the character levels
        print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently specced " .. characterData.talents.specialisation))
    end
end

-- Command function for retrieving the gold of every character on the realm
function cmdGetAllCharactersGold()
    -- For every character cached for the current realm, print their current gold, silver and copper
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(characterData.class:upper())
        -- Output the results in-game
        print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. formatCurrencyData(characterData.currency)))
    end
end

-- Command function for retrieving the profession data of every character on the realm
function cmdGetAllCharacterProfessions()
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(characterData.class:upper())
        -- Iterate through each profession type (primary, secondary, etc) stored in the data table
        for professionType, professionTypeTables in pairs(characterData.professions) do
            -- Iterator through each profession in each profession type - This is what actually catches the profession data
            for profession, professionData in pairs(professionTypeTables) do
                -- Output the results in-gam (colour the level output green if its maxed)
                print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
            end
        end
    end
end

-- Command function for retrieving the primary profession data of every character on the realm
function cmdGetAllCharacterPrimaryProfessions()
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(characterData.class:upper())
        -- Iterator through each profession in each profession type - This is what actually catches the profession data
        for profession, professionData in pairs(characterData.professions["primary"]) do
            -- Output the results in-gam (colour the level output green if its maxed)
            print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
        end
    end
end

-- Command function for retrieving the secondary profession data of every character on the realm
function cmdGetAllCharacterSecondaryProfessions()
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Get the class colour
        local _, _, _, classColourHex = GetClassColor(characterData.class:upper())
        -- Iterator through each profession in each profession type - This is what actually catches the profession data
        for profession, professionData in pairs(characterData.professions["secondary"]) do
            -- Output the results in-gam (colour the level output green if its maxed)
            print(recolourOutputText(classColourHex, upperCaseFirst(characterName)) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
        end
    end
end
