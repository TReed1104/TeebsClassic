------------------------------------------------------------------
-- Addon UI Events
------------------------------------------------------------------
-- Addons core onLoad function - has to be manually called because we aren't using XML
function onLoadCoreFrame(frame, eventHandlerFunc)
    -- Register Event Listeners
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("PLAYER_LOGIN")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_LEVEL_UP")
    frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    frame:RegisterEvent("PLAYER_MONEY")
    frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    frame:RegisterEvent("PLAYER_XP_UPDATE")
    frame:RegisterEvent("TRADE_SKILL_UPDATE")
    frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
    frame:RegisterEvent("UPDATE_FACTION")
    frame:RegisterEvent("TIME_PLAYED_MSG")

    -- Handle Events Triggering
    frame:SetScript("OnEvent", eventHandlerFunc)

    -- Setup the frame for being movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- Generate the core UI elements
    frame.titleRegion = createFrame("TitleRegion", frame, 150, 30, "TOP", 0, -5, TEEBS_CLASSIC_BACKDROP_OBJECT, TEEBS_OBJECT_COLOUR_RED)
    frame.titleRegion.titleText = createTextObject("TitleText", frame.titleRegion, "TeebsClassic", 1, 1, 1, 1, "CENTER", 0, 0, "GameFontNormal")      -- Title Text
    frame.exitButton = createButton("CloseButton", frame, "x", 30, 30, "TOPRIGHT", -10, -5, exitButton)          -- Create the Exit button
    frame.menuButton = createButton("MenuButton", frame, "Menu", 50, 30, "TOPLEFT", 10, -5, openMainMenu)        -- Menu Button
    frame.mainMenu = createDropDown("MenuDropDown")
    activateLayout_Home(frame)
end

-- The master event handler
function eventHandlerCoreFrame(self, event, arg1, arg2, arg3, ...)
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
        setCharacterDataZone()
        setCharacterDataSubzone()
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

    -- Location change trigger
    if event == "ZONE_CHANGED_NEW_AREA" then
        setCharacterDataZone()
        setCharacterDataSubzone()
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
end

-- Click event for the exit button
function exitButton()
    TEEBS_CLASSIC_FRAME:Hide()
    CloseDropDownMenus()
end

-- Click event for the main menu button
function openMainMenu(self)
    EasyMenu(generateMenuData_Main(), TEEBS_CLASSIC_FRAME.mainMenu, self:GetName(), 0, 0, nil)
end

-- Click event for each of the main menu's items
function clickFunctionMenuItem(self, uiLayoutFunction, character)
    uiLayoutFunction(character)     -- Call the passing ui-layout function, this will generate the layout of the addon page
    CloseDropDownMenus()            -- Close all dropdown menus because we've changed layout
end
