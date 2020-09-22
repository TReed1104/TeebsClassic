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
-- Dropdown Menu Configurations
------------------------------------------------------------------
function generateMenuData_Main()
    -- Submenu for the profession functions
    local professionsSubmenus = {
        { text = "All", notCheckable = 1, func = clickFunctionMenuItem, arg1 = contentFramePopulateAllProfessions},
        { text = "Primary", notCheckable = 1, func = clickFunctionMenuItem, arg1 = contentFramePopulatePrimaryProfessions},
        { text = "Secondary", notCheckable = 1, func = clickFunctionMenuItem, arg1 = contentFramePopulateSecondaryProfessions},
    }
    -- The main menu of the different addon functions
    local mainMenuLayout = {
        { text = "Character Specific", isTitle = 1, notCheckable = 1, },
        { text = "Equipped Gear", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFramePopulateEquipment) },
        { text = "Equipped Bags", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFramePopulateBags) },
        { text = "Talents", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFramePopulateTalents, false, false, false, true) },
        { text = "Professions", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFramePopulateProfessions) },
        { text = "Reputations", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = generateMenuData_CharacterList(contentFramePopulateReputations) },
        { text = "All Characters", isTitle = 1, notCheckable = 1, },
        { text = "Experience", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFramePopulateAllExperience, menuList = generateMenuData_CharacterList(nil, true, true) },
        { text = "Locations", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFramePopulateAllLocations, menuList = generateMenuData_CharacterList(nil, true, false, false, false, false, true) },
        { text = "Play Time", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFramePopulateAllPlayTime, menuList = generateMenuData_CharacterList(nil, true, false, false, false, true) },
        { text = "Gold", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFramePopulateAllGold, menuList = generateMenuData_CharacterList(nil, true, false, true) },
        { text = "Professions", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, func = clickFunctionMenuItem, arg1 = contentFramePopulateAllProfessions, menuList = professionsSubmenus },
        { text = "Close", func = function() CloseDropDownMenus() end, notCheckable = 1, }
    }
    return mainMenuLayout
end

function generateMenuData_CharacterList(uiFunction, isDisabled, showExperience, showGold, showSpec, showPlaytime, showZone, showMail)
    local characterListMenu = {}
    -- Create a list of the characters for the dropdown
    for characterName, characterData in pairs(TeebsClassicDB.realms[CURRENT_REALM].characters) do
        local menuItemText = upperCaseFirst(recolourNameByClass(characterName)) .. " (" .. characterData.level .. ")"
        -- Toggle the experience text TODO - Add rested %
        if showExperience then
            if characterData.level < 60 then
                menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - " .. characterData.experienceCurrentPercentage .. "%")
                menuItemText = menuItemText .. recolourOutputText(characterData.experienceRestedPercentage >= 150 and TEEBS_TEXT_COLOUR_ALERT or TEEBS_TEXT_COLOUR_WHITE, " - " .. characterData.experienceRestedPercentage .. "%")
            else
                menuItemText = menuItemText .. recolourOutputText(TEEBS_TEXT_COLOUR_WHITE, " - Maxed")
            end
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
-- Content Frame Functions
------------------------------------------------------------------
function showAllContentFrames()
    -- Hide all the content frames created via the register
    for contentFrameIndex, contentFrameDetails in pairs(TEEBS_CLASSIC_CONTENT_FRAMES) do
        TEEBS_CLASSIC_FRAME[contentFrameDetails.frameID]:Show()
    end
end

function hideAllContentFrames()
    -- Hide all the content frames created via the register
    for contentFrameIndex, contentFrameDetails in pairs(TEEBS_CLASSIC_CONTENT_FRAMES) do
        TEEBS_CLASSIC_FRAME[contentFrameDetails.frameID]:Hide()
    end
end

function toggleContentFrame(showFrame)
    -- Hide all the content frames created via the register
    for contentFrameIndex, contentFrameDetails in pairs(TEEBS_CLASSIC_CONTENT_FRAMES) do
        TEEBS_CLASSIC_FRAME[contentFrameDetails.frameID]:Hide()
    end
    TEEBS_CLASSIC_FRAME[showFrame.frameID]:Show()
end


------------------------------------------------------------------
-- Content Frame Data Population functions
------------------------------------------------------------------
function contentFramePopulateEquipment(character)
    -- Get the character data
    local equipmentData = interfaceGetAllItemSlots(character)
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateEquipment()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.equipment)
end

function contentFramePopulateBags(character)
    -- Get the character data
    local bagData = interfaceGetAllBagSlots(character)
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateBags()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.bags)
end

function contentFramePopulateTalents(character)
    -- Get the character data
    local talentsData = interfaceGetTalents(character)
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateTalents()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.talents)
end

function contentFramePopulateProfessions(character)
    -- Get the character data
    local professionData = interfaceGetProfessions(character)
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateProfessions()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.professions)
end

function contentFramePopulateReputations(character)
    -- Get the character data
    local reputationData = interfaceGetAllReputations(character)
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateReputations()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.reputations)
end

function contentFramePopulateAllExperience()
    -- Get the character data
    local experienceData = interfaceGetAllExperience()
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateAllExperience()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.experience)
end

function contentFramePopulateAllLocations()
    -- Get the character data
    local locationData = interfaceGetAllZones()
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateAllLocations()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.locations)
end

function contentFramePopulateAllPlayTime()
    -- Get the character data
    local playtimeData = interfaceGetAllPlayTime()
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateAllPlayTime()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.playtime)
end

function contentFramePopulateAllGold()
    -- Get the character data
    local goldData = interfaceGetAllGold()
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateAllGold()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.gold)
end

function contentFramePopulateAllProfessions()
    -- Get the character data
    local professionsData = interfaceGetAllProfessions()
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateAllProfessions()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.professionsAll)
end

function contentFramePopulatePrimaryProfessions()
    -- Get the character data
    local professionsData = interfaceGetAllPrimaryProfessions()
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulatePrimaryProfessions()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.professionsPrimary)
end

function contentFramePopulateSecondaryProfessions()
    -- Get the character data
    local professionsData = interfaceGetAllSecondaryProfessions()
    -- TODO: Link the data to the UI frame
    print(recolourOutputText(TEEBS_TEXT_COLOUR_ALERT, "To Be Implemented - contentFramePopulateSecondaryProfessions()"))
    -- Toggle the content frame to be visible
    toggleContentFrame(TEEBS_CLASSIC_CONTENT_FRAMES.professionsSecondary)
end
