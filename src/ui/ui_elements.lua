------------------------------------------------------------------
-- Addon UI Element Creation
------------------------------------------------------------------
-- UI Create Object - Frame
function createFrame(name, parentFrame, width, height, anchor, anchorOffsetX, anchorOffsetY, backdropObject, backdropColour, onLoadFunc, eventHandlerFunc)
    -- Create the frame
    local newFrame = CreateFrame("Frame", name, parentFrame)
    -- Initialise the frames positioning and sizing
    newFrame:SetFrameStrata("BACKGROUND")
    newFrame:SetWidth(width)
    newFrame:SetHeight(height)
    -- Positioning
    newFrame:SetPoint(anchor, parentFrame, anchor, anchorOffsetX, anchorOffsetY)
    -- Setup the frames backdrop
    if backdropObject ~= nil then
        newFrame:SetBackdrop(backdropObject)
        -- Set the background colour
        if backdropColour ~= nil then
            newFrame:SetBackdropColor(backdropColour.r, backdropColour.b, backdropColour.g, backdropColour.a)
        else  
            newFrame:SetBackdropColor(0, 0, 0, 1)
        end
    end
    -- Call the onLoad function, you can't register the onLoad function via SetScript outside of XML
    if onLoadFunc ~= nil then
        onLoadFunc(newFrame, eventHandlerFunc)  -- (Yay function references)
    end
    -- Return the new frame object
    return newFrame
end

-- UI Create Object - Button
function createButton(name, parentFrame, text, width, height, anchor, anchorOffsetX, anchorOffsetY, onClickFunction)
    -- Button Setup
    local newButton = CreateFrame("Button", name, parentFrame)
    -- Sizing
    newButton:SetWidth(width)
    newButton:SetHeight(height)
    -- Positioning
    newButton:SetPoint(anchor, parentFrame, anchor, anchorOffsetX, anchorOffsetY)
    -- Text & Font
    newButton:SetText(text)
    newButton:SetNormalFontObject("GameFontNormal")
    -- Button Event Setup
    newButton:SetScript("OnClick", onClickFunction)
    -- Texture setup Normal Texture
    newButton.ntex = newButton:CreateTexture()
    newButton.ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
    newButton.ntex:SetTexCoord(0, 0.625, 0, 0.6875)
    newButton.ntex:SetAllPoints()	
    newButton:SetNormalTexture(newButton.ntex)
    -- Texture setup Highlighted Texture
    newButton.htex = newButton:CreateTexture()
    newButton.htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
    newButton.htex:SetTexCoord(0, 0.625, 0, 0.6875)
    newButton.htex:SetAllPoints()
    newButton:SetHighlightTexture(newButton.htex)
    -- Texture setup Clicked Texture
    newButton.ptex = newButton:CreateTexture()
    newButton.ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
    newButton.ptex:SetTexCoord(0, 0.625, 0, 0.6875)
    newButton.ptex:SetAllPoints()
    newButton:SetPushedTexture(newButton.ptex)
    -- Return the newly created button
    return newButton
end

-- UI Create Object - Text Object
function createTextObject(name, parentFrame, text, colourR, colourG, colourB, colourA, anchor, anchorOffsetX, anchorOffsetY, fontObject)
    -- Create the text object, we use the parent frame to create it
    local newTextObject = parentFrame:CreateFontString(name, "OVERLAY", fontObject)
    -- Positioning
    newTextObject:SetPoint(anchor, parentFrame, anchor, anchorOffsetX, anchorOffsetY)
    -- Setup the Text and text colour
    newTextObject:SetText(text)
    newTextObject:SetTextColor(colourR, colourG, colourB, colourA)
    -- Return the newly created text object
    return newTextObject
end

function createDropDown(name)
    local newDropDownMenu = CreateFrame("Frame", name, nil, "UIDropDownMenuTemplate")
    return newDropDownMenu
end


------------------------------------------------------------------
-- Addon Menu Layouts
------------------------------------------------------------------
function generateMenuData_Main()
    -- Submenu for the profession functions
    local professionsSubmenus = {
        { text = "All", notCheckable = 1, func = clickFunctionMenuItem, arg1 = contentFrameChangeAllProfessions},
        { text = "Primary", notCheckable = 1, func = clickFunctionMenuItem, arg1 = contentFrameChangePrimaryProfessions},
        { text = "Secondary", notCheckable = 1, func = clickFunctionMenuItem, arg1 = contentFrameChangeSecondaryProfessions},
    }
    -- The main menu of the different addon functions
    local mainMenuLayout = {
        { text = "Character Specific", isTitle = 1, notCheckable = 1, },
        { text = "Equipped Gear", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFrameChangeEquipment) },
        { text = "Equipped Bags", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFrameChangeBags) },
        { text = "Talents", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFrameChangeTalents, false, false, false, true) },
        { text = "Professions", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFrameChangeProfessions) },
        { text = "Reputations", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFrameChangeReputations) },
        { text = "All Characters", isTitle = 1, notCheckable = 1, },
        { text = "Experience", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFrameChangeAllExperience, menuList = generateMenuData_CharacterList(nil, true, true) },
        { text = "Locations", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFrameChangeAllLocations, menuList = generateMenuData_CharacterList(nil, true, false, false, false, false, true) },
        { text = "Play Time", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFrameChangeAllPlayTime, menuList = generateMenuData_CharacterList(nil, true, false, false, false, true) },
        { text = "Gold", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFrameChangeAllGold, menuList = generateMenuData_CharacterList(nil, true, false, true) },
        { text = "Professions", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFrameChangeAllProfessions, menuList = professionsSubmenus },
        { text = "Close", func = function() CloseDropDownMenus() end, notCheckable = 1, }
    }
    return mainMenuLayout
end

function generateMenuData_CharacterList(uiFunction, isDisabled, showExperience, showGold, showSpec, showPlaytime, showZone)
    local characterListMenu = {}
    -- Create a list of the characters for the dropdown
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        local menuItemText = upperCaseFirst(recolourNameByClass(characterName)) .. " (" .. characterData.level .. ")"
        -- Toggle the experience text TODO - Add rested %
        if showExperience then
            menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - " .. characterData.experienceCurrentPercentage .. "%")
            menuItemText = menuItemText .. recolourOutputText(characterData.experienceRestedPercentage >= 150 and TEEBS_TEXT_COLOUR_ALERT or TEEBS_TEXT_COLOUR_WHITE, " - " .. characterData.experienceRestedPercentage .. "%")
        end
        -- Toggle the gold text
        if showGold then
            menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - " .. formatCurrencyData(characterData.currency.copper))
        end
        -- Toggle the spec text
        if showSpec then
            menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - " .. characterData.talents.specialisation.distribution)
        end
        -- Toggle the playtime text
        if showPlaytime then
            menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - " .. formatPlayTimeData(characterData["time-played"].total))
        end
        -- Toggle the Zone text
        if showZone then
            if characterData.subzone ~= "" then
                menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - " .. characterData.subzone .. ", " .. characterData.zone)
            else
                menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - " .. characterData.zone)
            end
        end
        -- Generate the menu item details
        local characterMenuItem = {
            disabled = isDisabled,
            text = menuItemText,
            func = clickFunctionMenuItem,
            arg1 = uiFunction, 
            arg2 = characterName,
            notCheckable = 1,
        }
        -- Insert the menu item into the character list menu
        table.insert(characterListMenu, characterMenuItem)
    end
    -- Insert total gold
    if showGold then
        local totalCurrency = 0
        -- For every character cached for the current realm, total up their total gold
        for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
            totalCurrency = totalCurrency + characterData["currency"].copper
        end
        -- Insert the menu item into the character list menu
        table.insert(characterListMenu, { disabled = true, notCheckable = 1, text = recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, "Total - " .. formatCurrencyData(totalCurrency)) })
    end
    -- Insert total playtime
    if showPlaytime then
        local totalPlayTimeInSeconds = 0
        -- For every character cached for the current realm, total up their total playtime
        for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
            totalPlayTimeInSeconds = totalPlayTimeInSeconds + characterData["time-played"].total
        end
        -- Insert the menu item into the character list menu
        table.insert(characterListMenu, { disabled = true, notCheckable = 1, text = recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, "Total - " .. formatPlayTimeData(totalPlayTimeInSeconds)) })
    end
    return characterListMenu
end


------------------------------------------------------------------
-- Addon Layouts
------------------------------------------------------------------
function contentFrameChangeHome()
    print("Layout Activated - Home")
    TEEBS_CLASSIC_FRAME[TEEBS_CLASSIC_CONTENT_FRAMES.home.frameID]:Show()
end

function contentFrameChangeEquipment(character)
    print("Layout Activated - Equipment -", character)
    local equipmentData = interfaceGetAllItemSlots(character)
end

function contentFrameChangeBags(character)
    print("Layout Activated - Bags -", character)
    local bagData = interfaceGetAllBagSlots(character)
end

function contentFrameChangeTalents(character)
    print("Layout Activated - Talents -", character)
    local talentsData = interfaceGetTalents(character)
end

function contentFrameChangeProfessions(character)
    print("Layout Activated - Professions -", character)
    local professionData = interfaceGetProfessions(character)
end

function contentFrameChangeReputations(character)
    print("Layout Activated - Reputations -", character)
    local reputationData = interfaceGetAllReputations(character)
end

function contentFrameChangeAllExperience()
    print("Layout Activated - All Experience")
    local experienceData = interfaceGetAllExperience()
end

function contentFrameChangeAllLocations()
    print("Layout Activated - All Locations")
    local locationData = interfaceGetAllZones()
end

function contentFrameChangeAllPlayTime()
    print("Layout Activated - All Playtimes")
    local playtimeData = interfaceGetAllPlayTime()
end

function contentFrameChangeAllGold()
    print("Layout Activated - All Gold")
    local goldData = interfaceGetAllGold()
end

function contentFrameChangeAllProfessions()
    print("Layout Activated - All Professions")
    local professionsData = interfaceGetAllProfessions()
end

function contentFrameChangePrimaryProfessions()
    print("Layout Activated - All Primary Professions")
    local professionsData = interfaceGetAllPrimaryProfessions()
end

function contentFrameChangeSecondaryProfessions()
    print("Layout Activated - All Secondary Professions")
    local professionsData = interfaceGetAllSecondaryProfessions()
end
