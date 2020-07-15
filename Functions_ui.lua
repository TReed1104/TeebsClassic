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
        currentLevel = TeebsClassicDB.realms[CURRENT_REALM].characters[character].level
        currentPercent = TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceCurrentPercentage
        currentRestedPercent = TeebsClassicDB.realms[CURRENT_REALM].characters[character].experienceRestedPercentage
    }
    return levelData
end

function interfaceGetLevel(character)
    return nil
end

function interfaceGetPlayTime(character)
    return nil
end

function interfaceGetSpec(character)
    return nil
end

function interfaceGetTalents(character)
    return nil
end

function interfaceGetGold(character)
    return nil
end

function interfaceGetProfessions(character)
    return nil
end

function interfaceGetPrimaryProfessions(character)
    return nil
end

function interfaceGetSecondaryProfessions(character)
    return nil
end

function interfaceGetReputation(character)
    return nil
end

function interfaceGetAllExperience()
    return nil
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
