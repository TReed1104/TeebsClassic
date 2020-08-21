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
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].zone == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].zone = {}
    end
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].subzone == nil then
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].subzone = {}
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

-- Caching of the current characters location
function setCharacterDataZone()
    -- Set the character zone in the DB
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].zone = GetZoneText()
end

-- Caching of the current characters location
function setCharacterDataSubzone()
    -- Set the character zone in the DB
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].subzone = GetSubZoneText()
end

-- Caching of the characters time played
function setCharacterDataPlayTime(total, current)
    -- If the time-played table exists for the character
    if TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"] ~= nil then
        -- Set the time-played values
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"]["total"] = total
        TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME]["time-played"]["current"] = current
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
    -- Fill out the currency table
    TeebsClassicDB.realms[CURRENT_REALM].characters[CURRENT_CHARACTER_NAME].currency["copper"] = GetMoney()
    -- Uses a data table for future proofing other currencies i think about tracking
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
