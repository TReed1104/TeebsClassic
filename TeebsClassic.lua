-- Frames
local frame = CreateFrame("Frame")

-- Register Event Listeners
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

-- Handle Events Triggering
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        -- Addon Loaded Trigger
        print("Welcome to Teebs Classic, use /teebs")
    elseif event == "PLAYER_LOGIN" then
        -- Player Login Event Trigger
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- World Enter Event Trigger
    elseif event == "PLAYER_LEVEL_UP" then
        -- Level Up Event Trigger
    elseif event == "PLAYER_MONEY" then
        -- Money Changes Event Trigger
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        -- Equipment Changes Event Trigger
    end
end)
