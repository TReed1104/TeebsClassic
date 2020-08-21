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
        -- Now the item has been cached, print the item link
        print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in gear slot " .. slotNumber))
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
        print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in bag slot " .. slotNumber))
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
    -- Output the results in-game
    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is " .. currentPercent .. "% into level " .. currentLevel .. " and has ") .. recolourOutputText(currentRestedPercent >= 150 and TEEBS_TEXT_COLOUR_ALERT or TEEBS_TEXT_COLOUR_DEFAULT, currentRestedPercent .. "%") .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " rested experience remaining"))
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
    -- Output the results in-game
    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently level " .. currentLevel))
end

-- Command function for retrieving a characters zones from the cache
function cmdGetCharacterZone(character)
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
    -- Output the results in-game
    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Total time played: " .. formatPlayTimeData(currentPlaytime.total)))
    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Time played this level: " .. formatPlayTimeData(currentPlaytime.current)))
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
    -- Local copy the point distribution for returning
    local talentPointDistribution = TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents.specialisation.distribution
    -- Output the results in-game
    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently specced " .. talentPointDistribution))
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
    -- Iterate through each talent tree in the talents table
    for talentTreeName, talentTreeTable in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents) do
        -- Ignore the specialisation variable from the talents table
        if talentTreeName ~= "specialisation" then
            -- Check any points are in that talent tree
            if TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents.specialisation[talentTreeName] > 0 then
                print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Talent Tree - ").. recolourOutputText(TEEBS_TEXT_COLOUR_TALENTS, upperCaseFirst(talentTreeName)))
                for talentTier = 1, 7 do
                    for talentColumn = 1, 4 do
                        if talentTreeTable[tostring(talentTier)][tostring(talentColumn)] ~= nil then
                            talent = talentTreeTable[tostring(talentTier)][tostring(talentColumn)]
                            if talent.currentRank > 0 then
                                print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has talent ") .. recolourOutputText(TEEBS_TEXT_COLOUR_TALENTS, talent.name) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " at Rank " .. talent.currentRank .. "/" .. talent.maxRank))
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
    -- Output the results in-game
    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. formatCurrencyData(currencyData.copper)))
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
    -- Take a local copy of the profession data for quicker access
    local characterProfessionsTable = TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions
    -- Iterate through each profession type (primary, secondary, etc) stored in the data table
    for professionType, professionTypeTables in pairs(characterProfessionsTable) do
        -- Iterator through each profession in each profession type - This is what actually catches the profession data
        for profession, professionData in pairs(professionTypeTables) do
            -- Output the results in-gam (colour the level output green if its maxed)
            print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
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
    -- Iterator through each profession in the primary profession table
    for profession, professionData in pairs(characterPrimaryProfessions) do
        -- Output the results in-gam (colour the level output green if its maxed)
        print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
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
    -- Iterator through each profession in the primary profession table
    for profession, professionData in pairs(characterSecondaryProfessions) do
        -- Output the results in-gam (colour the level output green if its maxed)
        print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
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
    -- Generate the function's in-game response
    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " - ") .. recolourOutputText(TEEBS_TEXT_COLOUR_CAPPED, faction.factionName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently ") .. recolourOutputText(getFactionStandingTextColour(faction.factionStanding), faction.factionStanding .. " - " .. getFactionStandingValues(faction)))
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
        -- Generate the function's in-game response
        print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " - ") .. recolourOutputText(TEEBS_TEXT_COLOUR_CAPPED, reputationData.factionName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently ") .. recolourOutputText(getFactionStandingTextColour(reputationData.factionStanding), reputationData.factionStanding .. " - " .. getFactionStandingValues(reputationData)))
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
                    -- Now the item has been cached, format the output string and print the item link
                    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in gear slot " .. slotNumber))
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
                    -- Now the item has been cached, format the output string and print the item link
                    print(recolourNameByClass(character) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has ") ..  item:GetItemLink() .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " equipped in bag slot " .. slotNumber))
                end)
            end
        end
    end
end

-- Command function for retrieving the current and rested experience %s for all tracked characters on the realm
function cmdGetAllCharactersExperience()
    -- For every character cached for the current realm, print their current and rested exp %s
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Check if the character is level 60
        if characterData.level == 60 then
            -- Print the character is level 60, theres no point in printing the exp stats as they're always 0!
            print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is level " .. characterData.level))
        else
            -- Output the results in-game, current level, current exp and rested exp
            print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is " .. characterData.experienceCurrentPercentage .. "% into level " .. characterData.level .. " and has ") .. recolourOutputText(characterData.experienceRestedPercentage >= 150 and TEEBS_TEXT_COLOUR_ALERT or TEEBS_TEXT_COLOUR_DEFAULT, characterData.experienceRestedPercentage .. "%") .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " rested experience remaining"))
        end
    end
end

-- Command function for retrieving the level of every cached character
function cmdGetAllCharactersLevels()
    -- For every character cached for the current realm, print their current level
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Output the character levels
        print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is level " .. characterData.level))
    end
end

-- Command function for retrieving all characters play time
function cmdGetAllCharacterPlayTime()
    -- For every character cached for the current realm, print their playtime values last cached
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Output the results in-game
        print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Total time played: " .. formatPlayTimeData(characterData["time-played"].total)))
        print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " Time played this level: " .. formatPlayTimeData(characterData["time-played"].current)))
    end
end

-- Command function for retrieving the talent spec of all cached characters on the current server
function cmdGetAllCharacterSpecs()
    -- For every character cached for the current realm, print their character spec
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Output the character levels
        print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " is currently specced " .. characterData.talents.specialisation.distribution))
    end
end

-- Command function for retrieving the gold of every character on the realm
function cmdGetAllCharactersGold()
    -- For every character cached for the current realm, print their current gold, silver and copper
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Output the results in-game
        print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. formatCurrencyData(characterData.currency.copper)))
    end
end

-- Command function for retrieving the profession data of every character on the realm
function cmdGetAllCharacterProfessions()
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Iterate through each profession type (primary, secondary, etc) stored in the data table
        for professionType, professionTypeTables in pairs(characterData.professions) do
            -- Iterator through each profession in each profession type - This is what actually catches the profession data
            for profession, professionData in pairs(professionTypeTables) do
                -- Output the results in-gam (colour the level output green if its maxed)
                print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
            end
        end
    end
end

-- Command function for retrieving the primary profession data of every character on the realm
function cmdGetAllCharacterPrimaryProfessions()
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Iterator through each profession in each profession type - This is what actually catches the profession data
        for profession, professionData in pairs(characterData.professions["primary"]) do
            -- Output the results in-gam (colour the level output green if its maxed)
            print(recolourNameByClass(characterName).. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
        end
    end
end

-- Command function for retrieving the secondary profession data of every character on the realm
function cmdGetAllCharacterSecondaryProfessions()
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        -- Iterator through each profession in each profession type - This is what actually catches the profession data
        for profession, professionData in pairs(characterData.professions["secondary"]) do
            -- Output the results in-gam (colour the level output green if its maxed)
            print(recolourNameByClass(characterName) .. recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, " has " .. profession .. " - ") .. recolourOutputText(professionData.current == 300 and TEEBS_TEXT_COLOUR_CAPPED or TEEBS_TEXT_COLOUR_DEFAULT, professionData.current .. " / " .. professionData.max))
        end
    end
end

-- Get the total playtime across all cached characters on the realm
function cmdGetTotalPlayTime()
    local totalPlayTimeInSeconds = 0
    -- For every character cached for the current realm, total up their total playtime
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        totalPlayTimeInSeconds = totalPlayTimeInSeconds + characterData["time-played"].total
    end
    -- Print the result
    print(recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, "Total Time Played across this server is " .. formatPlayTimeData(totalPlayTimeInSeconds)))
end

-- Get the total gold across all cached characters on the realm
function cmdGetTotalGold()
    local totalCurrency = 0
    -- For every character cached for the current realm, total up their total gold
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        totalCurrency = totalCurrency + characterData["currency"].copper
    end
    -- Print the result
    print(recolourOutputText(TEEBS_TEXT_COLOUR_DEFAULT, "Total Currency across this server is " .. formatCurrencyData(totalCurrency)))
end
