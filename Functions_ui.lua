------------------------------------------------------------------
-- Addon UI Functions - Return data for binding to UI panels
------------------------------------------------------------------
function interfaceGetAllItemSlots(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    local characterEquippedGear = {}
    for slotNumber, itemID in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear) do
        -- Check we have anything equipped in the desired slot
        if TeebsClassicDB.realms[CURRENT_REALM].characters[character].gear[slotNumber] > 0 then
            -- Load the item data
            local item = Item:CreateFromItemID(itemID)
            item:ContinueOnItemLoad(function()
                characterEquippedGear[slotNumber] = { item = item:GetItemLink() }
            end)
        end
    end
    return characterEquippedGear
end

function interfaceGetAllBagSlots(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return
    end
    local characterEquippedBags = {}
    for slotNumber, itemID in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags) do
        -- Check we have anything currently in the desired bag slot
        if TeebsClassicDB.realms[CURRENT_REALM].characters[character].bags[slotNumber] > 0 then
            -- Load the item data
            local item = Item:CreateFromItemID(itemID)
            item:ContinueOnItemLoad(function()
                characterEquippedBags[slotNumber] = { bag = item:GetItemLink() }
            end)
        end
    end
    return characterEquippedBags
end

function interfaceGetExperience(character)
    -- Check the character exists
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character] == nil then
        print("Unknown Charater", character)
        return nil
    end
    -- Check if the character experience data has been cached
    if TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceCurrentPercentage == nil or TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceRestedPercentage == nil then
        print("Experience data not cached")
        return nil
    end
    -- Create our return data table
    local levelData = {
        currentLevel = TeebsClassicDB.realms[CURRENT_REALM].characters[character].level,
        currentPercent = TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceCurrentPercentage,
        currentRestedPercent = TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceRestedPercentage
    }
    return levelData
end

function interfaceGetLevel(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local characterLevel = TeebsClassicDB.realms[CURRENT_REALM].characters[character].level
    return characterLevel
end

function interfaceGetPlayTime(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local characterTimePlayed = TeebsClassicDB.realms[CURRENT_REALM].characters[character]["time-played"]
    return characterTimePlayed
end

function interfaceGetSpec(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local talentPointDistribution = TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents.specialisation.distribution
    return talentPointDistribution
end

function interfaceGetTalents(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local characterTalents = TeebsClassicDB.realms[CURRENT_REALM].characters[character].talents
    return characterTalents
end

function interfaceGetGold(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local currencyData = TeebsClassicDB.realms[CURRENT_REALM].characters[character].currency
    return currencyData
end

function interfaceGetProfessions(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local characterProfessionsTable = TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions
    return characterProfessionsTable
end

function interfaceGetPrimaryProfessions(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local characterPrimaryProfessions = TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions["primary"]
    return characterPrimaryProfessions
end

function interfaceGetSecondaryProfessions(character)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local characterSecondaryProfessions = TeebsClassicDB.realms[CURRENT_REALM].characters[character].professions["secondary"]
    return characterSecondaryProfessions
end

function interfaceGetReputation(character, faction)
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
    -- Copy the character data to return, Lua passes data tables by reference
    local chosenFactionData = TeebsClassicDB.realms[CURRENT_REALM].characters[character].reputations[faction]
    return chosenFactionData
end

function interfaceGetAllReputations(character)
    -- Create our data table for copying the character experience data into
    local allCharacterReputationData = {}
    -- For every character cached for the current realm, collect their reputation data
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharacterReputationData[characterName] = {
            reputations = characterData.reputations
        }
    end
    -- Return our collated character reputation data
    return allCharacterReputationData
end

function interfaceGetAllExperience()
    -- Create our data table for copying the character experience data into
    local allCharacterExperienceData = {}
    -- For every character cached for the current realm, collect their experience data
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharacterExperienceData[characterName] = {
            currentLevel = characterData.level,
            currentPercent = characterData.experienceCurrentPercentage,
            currentRestedPercent = characterData.experienceRestedPercentage
        }
    end
    -- Return our collated character experience data
    return allCharacterExperienceData
end

function interfaceGetAllLevels()
    -- Create our data table for copying the character levels into
    local allCharacterLevelData = {}
    -- For every character cached for the current realm, collect their level values
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharacterLevelData[characterName] = {
            currentLevel = characterData.level
        }
    end
    -- Return our collated character levels
    return allCharacterLevelData
end

function interfaceGetAllPlayTime()
    -- Create our data table for copying the character play-time into
    local allCharactersPlayTime = {}
    -- For every character cached for the current realm, collect their play-time data
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharactersPlayTime[characterName] = {
            total = characterData["time-played"].total,
            current = characterData["time-played"].current
        }
    end
    -- Return our collated character play-times
    return allCharactersPlayTime
end

function interfaceGetAllSpecs()
    -- Create our data table for copying the character specs into
    local allCharactersSpecs = {}
    -- For every character cached for the current realm, collect their specs
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharactersSpecs[characterName] = {
            spec = characterData.talents.specialisation
        }
    end
    -- Return our collated character specs
    return allCharactersSpecs
end

function interfaceGetAllTalents()
    -- Create our data table for copying the character talent tree data
    local allCharactersTalents = {}
    -- For every character cached for the current realm, collect their talent trees
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharactersTalents[characterName] = {
            spec = characterData.talents
        }
    end
    -- Return our collated character talent trees
    return allCharactersTalents
end

function interfaceGetAllGold()
    -- Create our data table for copying the character currency data into
    local allCharactersCurrency = {}
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharactersCurrency[characterName] = {
            copper = characterData.currency.copper
        }
    end
    -- Return our collated character copper
    return allCharactersCurrency
end

function interfaceGetAllProfessions()
    -- Create our data table for copying the character professions data into
    local allCharactersProfessions = {}
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharactersProfessions[characterName] = {
            professions = characterData.professions
        }
    end
    -- Return our collated character professions
    return allCharactersProfessions
end

function interfaceGetAllPrimaryProfessions()
    -- Create our data table for copying the character primary professions data into
    local allCharactersPrimaryProfessions = {}
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharactersPrimaryProfessions[characterName] = {
            professions = characterData.professions["primary"]
        }
    end
    -- Return our collated character professions
    return allCharactersPrimaryProfessions
end

function interfaceGetAllSecondaryProfessions()
    -- Create our data table for copying the character primary professions data into
    local allCharactersSecondaryProfessions = {}
    -- For every character cached for the current realm
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharactersSecondaryProfessions[characterName] = {
            professions = characterData.professions["secondary"]
        }
    end
    -- Return our collated character professions
    return allCharactersSecondaryProfessions
end
