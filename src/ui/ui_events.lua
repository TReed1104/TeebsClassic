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
end

function TeebsClassic_OpenMainMenu(self)
    EasyMenu(GenerateMainMenu(), TeebsClassicFrame.mainMenu, self:GetName(), 0, 0, nil)
end
