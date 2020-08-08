------------------------------------------------------------------
-- Addon UI Element Creation
------------------------------------------------------------------
-- UI Create Object - Frame
function TeebsClassic_CreateFrame(name, parentFrame, width, height, anchor, anchorOffsetX, anchorOffsetY, backdropObject, onLoadFunc, eventHandlerFunc)
    -- Create the frame
    local newFrame = CreateFrame("Frame", name, parentFrame)
    -- Initialise the frames positioning and sizing
    newFrame:SetFrameStrata("BACKGROUND")
    newFrame:SetWidth(width)
    newFrame:SetHeight(height)
    -- Positioning
    newFrame:SetPoint(anchor, parentFrame, anchor, anchorOffsetX, anchorOffsetY)
    -- Setup the frames backdrop
    newFrame:SetBackdrop(backdropObject)
    -- Call the onLoad function, you can't register the onLoad function via SetScript outside of XML
    onLoadFunc(newFrame, eventHandlerFunc)  -- (Yay function references)
    -- Return the new frame object
    return newFrame
end

-- UI Create Object - Button
function TeebsClassic_CreateButton(name, parentFrame, text, width, height, anchor, anchorOffsetX, anchorOffsetY, onClickFunction)
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
function TeebsClassic_CreateTextObject(name, parentFrame, text, colourR, colourG, colourB, colourA, anchor, anchorOffsetX, anchorOffsetY, fontObject)
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

function TeebsClassic_CreateDropDown(name)
    local newDropDownMenu = CreateFrame("Frame", name, nil, "UIDropDownMenuTemplate")
    return newDropDownMenu
end


------------------------------------------------------------------
-- Addon UI Layouts
------------------------------------------------------------------
function GenerateCoreUIElements(addonMainFrame)
    addonMainFrame.titleText = TeebsClassic_CreateTextObject("TitleText", addonMainFrame, "TeebsClassic", 1, 1, 1, 1, "TOP", 0, -10, "GameFontNormal")      -- Title Text
    addonMainFrame.exitButton = TeebsClassic_CreateButton("CloseButton", addonMainFrame, "x", 30, 30, "TOPRIGHT", -6, -2, TeebsClassic_ExitButton)          -- Create the Exit button
    addonMainFrame.menuButton = TeebsClassic_CreateButton("MenuButton", addonMainFrame, "Menu", 50, 30, "TOPLEFT", 6, -2, TeebsClassic_OpenMainMenu)        -- Menu Button
    addonMainFrame.mainMenu = TeebsClassic_CreateDropDown("MenuDropDown")
end


------------------------------------------------------------------
-- Addon Menu Layouts
------------------------------------------------------------------
function GenerateMenuData_Main()
    local mainMenuLayout = {
        { text = "Character Specific", isTitle = 1, notCheckable = 1, },
        { text = "Experience", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = GenerateMenuData_CharacterList(nil, true, true) },
        { text = "Gold", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = GenerateMenuData_CharacterList(nil, true, false, true) },
        { text = "Talents", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = GenerateMenuData_CharacterList(interfaceGetTalents, true, false, false, true) },
        { text = "Equipped Gear", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = GenerateMenuData_CharacterList(interfaceGetAllItemSlots) },
        { text = "Equipped Bags", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = GenerateMenuData_CharacterList(interfaceGetAllBagSlots) },
        { text = "Professions", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = GenerateMenuData_CharacterList(interfaceGetProfessions) },
        { text = "Reputations", notCheckable = 1, hasArrow = true, keepShownOnClick = 0, menuList = GenerateMenuData_CharacterList(interfaceGetAllReputations) },
        { text = "All Characters", isTitle = 1, notCheckable = 1, },
        { text = "Experience", func = function() print(text) end, notCheckable = 1, },
        { text = "Levels", func = function() print(text) end, notCheckable = 1, },
        { text = "PlayTime", func = function() print(text) end, notCheckable = 1, },
        { text = "Talents", notCheckable = 1, hasArrow = true, keepShownOnClick = 0,
            menuList = {
                { text = "Spec", func = function() print(text) end, notCheckable = 1, },
                { text = "Talent Breakdown", func = function() print(text) end, notCheckable = 1, },
            }
        },
        { text = "Currencies", func = function() print(text) end, notCheckable = 1, },
        { text = "Professions", notCheckable = 1, hasArrow = true, keepShownOnClick = 0,
            menuList = {
                { text = "All", func = function() print(text) end, notCheckable = 1, },
                { text = "Primary", func = function() print(text) end, notCheckable = 1, },
                { text = "Secondary", func = function() print(text) end, notCheckable = 1, },
            }
        },
        { text = "Close", func = function() CloseDropDownMenus() end, notCheckable = 1, }
    }
    return mainMenuLayout
end

function GenerateMenuData_CharacterList(uiFunction, isDisabled, showExperience, showGold, showSpec)
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

        -- Generate the menu item details
        local characterMenuItem = {
            disabled = isDisabled,
            text = menuItemText,
            func = TeebsClassic_ClickFunctionMenuItem,
            arg1 = uiFunction, 
            arg2 = characterName,
            notCheckable = 1,
        }
        -- Insert the menu item into the character list menu
        table.insert(characterListMenu, characterMenuItem)
    end
    return characterListMenu
end