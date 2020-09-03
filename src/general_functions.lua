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
function getCharacterData(characterName)
end
