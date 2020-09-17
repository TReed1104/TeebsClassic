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

-- Colour a character name by its class colour used in the WoW API
function recolourNameByClass(characterName)
    local _, _, _, classColourHex = GetClassColor(TeebsClassicDB.realms[CURRENT_REALM].characters[characterName].class:upper())
    return recolourOutputText(classColourHex, upperCaseFirst(characterName))
end

-- Capitalise first letter of string
function upperCaseFirst(inputString)
    return inputString:sub(1,1):upper()..inputString:sub(2)
end

-- Print currency data formatter
function formatCurrencyData(rawCopper)
    -- Format the copper into its G, S, C values
    local gold = math.floor(rawCopper / 100 / 100)
    local silver = math.floor((rawCopper / 100) % 100)
    local copper = rawCopper % 100
    -- Return the formatted data string
    return string.format("%ig %is %ic", gold, silver, copper)
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

-- Get the character data table for the specified character
function getCharacterData(server, characterName)
    local characterData = nil
    -- Check the server exists
    if TeebsClassicDB.realms[server] ~= nil then
        -- Check the character exists
        if TeebsClassicDB.realms[server].characters[characterName] ~= nil then
            -- If the server and character name are valid, set the data to return
            characterData = TeebsClassicDB.realms[server].characters[characterName]
        end
    end
    return characterData
end

-- Get the chracter data of all characters on a specified server
function getServerCharacterData(server)
    -- Our character name list
    local characterList = {}
    -- Check the server exists
    if TeebsClassicDB.realms[server] == nil then
        return characterList
    end
    -- Copy the character data table
    characterList = TeebsClassicDB.realms[server].characters
    -- Return the copy table
    return characterList
end

function getServerFactionCharacterData(server, faction)
    -- Our data table for copying the character data
    local characterList = {}
    return characterList
end

-- Get a list of the servers with cached data
function getListServerNames()
    -- Server name list
    local serverList = {}
    -- Iterate through each server and list their names
    for serverName, serverTable in pairs(TeebsClassicDB.realms) do
        serverList[serverName] = upperCaseFirst(serverName:gsub("-", " "))
    end
    return serverList
end

-- Get a list of the characters we've cached on a specified server
function getListCharacterNames(server)
    -- Our character name list
    local characterList = {}
    -- Check the server exists
    if TeebsClassicDB.realms[server] == nil then
        return characterList
    end
    -- Iterate through each character on the specified server and list their names
    for characterName, characterData in pairs(TeebsClassicDB.realms[server].characters) do
        characterList[characterName] = upperCaseFirst(characterName)
    end
    return characterList
end

-- Get the name of every character we've cached
function getListAllCharacterNames()
    local serverList = {}
    -- For each server
    for serverName, serverTable in pairs(TeebsClassicDB.realms) do
        -- Get the character list for the current server iterator
        serverList[serverName] = getListCharacterNames(serverName)
    end
    return serverList
end

-- Get all characters of the specified faction
function getServerFactionCharacterNames(server, faction)
    -- Our data table for copying the names into
    local characterList = {}
    -- Check the server exists
    if TeebsClassicDB.realms[server] == nil then
        print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "getServerFactionCharacterNames() - Invalid Server"))
        return characterList
    end
    -- Check a valid faction was supplied
    if faction ~= "Alliance" and faction ~= "Horde" then
        print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "getServerFactionCharacterNames() - Invalid Faction"))
        return characterList
    end
    -- Get the character list for the current server iterator
    for characterName, characterData in pairs(TeebsClassicDB.realms[server].characters) do
        -- Check the character is of the specified faction
        if characterData.faction == faction then
            characterList[characterName] = upperCaseFirst(characterName)
        end
    end
    -- Return the data table
    return characterList
end

