------------------------------------------------------------------
-- Addon Core Creation, Event Registration And Handling
------------------------------------------------------------------
-- Frame Creation
local TeebsClassicFrame = CreateFrame("Frame", "TeebsClassic", UIParent)
_G["TeebsClassicFrame"] = TeebsClassicFrame

-- Register Event Listeners
TeebsClassicFrame:RegisterEvent("ADDON_LOADED")
TeebsClassicFrame:RegisterEvent("PLAYER_LOGIN")
TeebsClassicFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TeebsClassicFrame:RegisterEvent("PLAYER_LEVEL_UP")
TeebsClassicFrame:RegisterEvent("PLAYER_MONEY")
TeebsClassicFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
TeebsClassicFrame:RegisterEvent("PLAYER_XP_UPDATE")
TeebsClassicFrame:RegisterEvent("TRADE_SKILL_UPDATE")
TeebsClassicFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
TeebsClassicFrame:RegisterEvent("UPDATE_FACTION")
TeebsClassicFrame:RegisterEvent("TIME_PLAYED_MSG")

-- Handle Events Triggering
TeebsClassicFrame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, ...)
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
