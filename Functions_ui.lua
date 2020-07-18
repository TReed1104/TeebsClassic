------------------------------------------------------------------
-- Addon UI Functions - Return data for binding to UI panels
------------------------------------------------------------------
function interfaceGetAllItemSlots()
    return nil
end

function interfaceGetAllBagSlots()
    return nil
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
    return nil
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

function interfaceGetReputation(character)
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

function interfaceGetAllExperience()
    -- Create our data table for copying the character experience data into
    local allCharacterLevelData = {}
    -- For every character cached for the current realm, collect their experience data
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        allCharacterLevelData[characterName] = {
            currentLevel = characterData.level,
            currentPercent = characterData.experienceCurrentPercentage,
            currentRestedPercent = characterData.experienceRestedPercentage
        }
    end
    -- Return our collated character experience data
    return allCharacterLevelData
end

function interfaceGetAllLevels()
    return nil
end

function interfaceGetAllPlayTime()
    return nil
end

function interfaceGetAllSpecs()
    return nil
end

function interfaceGetAllTalents()
    return nil
end

function interfaceGetAllGold()
    return nil
end

function interfaceGetAllProfessions()
    return nil
end

function interfaceGetAllPrimaryProfessions()
    return nil
end

function interfaceGetAllSecondaryProfessions()
    return nil
end

function interfaceGetAllReputation()
    return nil
end
