------------------------------------------------------------------
-- Addon Core Creation, Event Registration And Handling
------------------------------------------------------------------
-- Frame Creation
local TeebsClassicFrame = CreateFrame("Frame", "TeebsClassic", UIParent)
TeebsClassicFrame:SetFrameStrata("BACKGROUND")
TeebsClassicFrame:SetWidth(500)
TeebsClassicFrame:SetHeight(500)
TeebsClassicFrame:SetPoint("CENTER", 0, 0)

-- Backdrop and border setup
local backdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    edgeSize = 12,
    tile = true,
    tileSize = 12,
    insets = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
TeebsClassicFrame:SetBackdrop(backdrop)

-- Title Text
local titleTextString = TeebsClassicFrame:CreateFontString(TeebsClassicFrame, "OVERLAY", "GameFontNormal")
titleTextString:SetTextColor(255, 255, 255)
titleTextString:SetText("TeebsClassic")
titleTextString:SetPoint("Top", 0, -10)

-- Exit Button Setup
TeebsClassicFrame.button = CreateFrame("Button", "Close_Button", TeebsClassicFrame)
TeebsClassicFrame.button:SetWidth(25)
TeebsClassicFrame.button:SetHeight(25)
TeebsClassicFrame.button:SetPoint("TOPRIGHT", TeebsClassicFrame, "TOPRIGHT", -6, -2)
TeebsClassicFrame.button:SetText("x")
TeebsClassicFrame.button:SetNormalFontObject("GameFontNormal")
TeebsClassicFrame.button:SetScript("OnClick", TeebsClassic_ExitButton)
-- Exit Button Texture - Normal
TeebsClassicFrame.button.ntex = TeebsClassicFrame.button:CreateTexture()
TeebsClassicFrame.button.ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
TeebsClassicFrame.button.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
TeebsClassicFrame.button.ntex:SetAllPoints()	
TeebsClassicFrame.button:SetNormalTexture(TeebsClassicFrame.button.ntex)
-- Exit Button Texture - Highlighted
TeebsClassicFrame.button.htex = TeebsClassicFrame.button:CreateTexture()
TeebsClassicFrame.button.htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
TeebsClassicFrame.button.htex:SetTexCoord(0, 0.625, 0, 0.6875)
TeebsClassicFrame.button.htex:SetAllPoints()
TeebsClassicFrame.button:SetHighlightTexture(TeebsClassicFrame.button.htex)
-- Exit Button Texture - Pushed
TeebsClassicFrame.button.ptex = TeebsClassicFrame.button:CreateTexture()
TeebsClassicFrame.button.ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
TeebsClassicFrame.button.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
TeebsClassicFrame.button.ptex:SetAllPoints()
TeebsClassicFrame.button:SetPushedTexture(TeebsClassicFrame.button.ptex)

-- Debugging show to automatically show the frame on reload
--TeebsClassicFrame:Show()

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
