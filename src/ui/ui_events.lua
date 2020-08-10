------------------------------------------------------------------
-- Addon UI Events
------------------------------------------------------------------
function onLoad(frame, eventHandlerFunc)
    -- Register Event Listeners
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("PLAYER_LOGIN")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_LEVEL_UP")
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
end

function exitButton()
    TEEBS_CLASSIC_FRAME:Hide()
    CloseDropDownMenus()
end

function openMainMenu(self)
    EasyMenu(generateMenuData_Main(), TEEBS_CLASSIC_FRAME.mainMenu, self:GetName(), 0, 0, nil)
end

function clickFunctionMenuItem(self, arg1, arg2)
    print(self, arg1, arg2)
    CloseDropDownMenus()
end


------------------------------------------------------------------
-- Addon Layout Changes
------------------------------------------------------------------
function activateLayout_Home()
end

function activateLayout_Equipment(character)
    local equipmentData = interfaceGetAllItemSlots(character)
end

function activateLayout_Bags(character)
    local bagData = interfaceGetAllBagSlots(character)
end

function activateLayout_Professions(character)
    local professionData = interfaceGetProfessions(character)
end

function activateLayout_Reputations(character)
    local reputationData = interfaceGetAllReputations(character)
end

function activateLayout_AllExperience()
    local experienceData = interfaceGetAllExperience()
end

function activateLayout_AllPlayTime()
    local playtimeData = interfaceGetAllPlayTime()
end

function activateLayout_AllGold()
    local goldData = interfaceGetAllGold()
end

function activateLayout_AllTalents()
    local talentsData = interfaceGetAllTalents()
end

function activateLayout_AllProfessions()
    local professionsData = interfaceGetAllProfessions()
end

function activateLayout_PrimaryProfessions()
    local professionsData = interfaceGetAllPrimaryProfessions()
end

function activateLayout_SecondaryProfessions()
    local professionsData = interfaceGetAllSecondaryProfessions()
end
