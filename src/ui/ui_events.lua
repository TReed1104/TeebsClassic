------------------------------------------------------------------
-- Addon UI Events
------------------------------------------------------------------
function TeebsClassic_OnLoad(frame, eventHandlerFunc)
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

function TeebsClassic_ExitButton()
    TeebsClassicFrame:Hide()
    CloseDropDownMenus()
end

function TeebsClassic_OpenMainMenu(self)
    EasyMenu(GenerateMenuData_Main(), TeebsClassicFrame.mainMenu, self:GetName(), 0, 0, nil)
end

function TeebsClassic_ClickFunctionMenuItem(self, arg1, arg2)
    print(self, arg1, arg2)
    CloseDropDownMenus()
end


------------------------------------------------------------------
-- Addon Layout Changes
------------------------------------------------------------------
function ActivateLayout_Home()
end

function ActivateLayout_Equipment(character)
    local equipmentData = interfaceGetAllItemSlots(character)
end

function ActivateLayout_Bags(character)
    local bagData = interfaceGetAllBagSlots(character)
end

function ActivateLayout_Professions(character)
    local professionData = interfaceGetProfessions(character)
end

function ActivateLayout_Reputations(character)
    local reputationData = interfaceGetAllReputations(character)
end

function ActivateLayout_AllExperience()
    local experienceData = interfaceGetAllExperience()
end

function ActivateLayout_AllPlayTime()
    local playtimeData = interfaceGetAllPlayTime()
end

function ActivateLayout_AllGold()
    local goldData = interfaceGetAllGold()
end

function ActivateLayout_AllTalents()
    local talentsData = interfaceGetAllTalents()
end

function ActivateLayout_AllProfessions()
    local professionsData = interfaceGetAllProfessions()
end

function ActivateLayout_PrimaryProfessions()
    local professionsData = interfaceGetAllPrimaryProfessions()
end

function ActivateLayout_SecondaryProfessions()
    local professionsData = interfaceGetAllSecondaryProfessions()
end
