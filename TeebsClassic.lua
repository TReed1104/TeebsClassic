
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

local function slashHandler(msg, editbox)
    if msg == "stats" then
        printHiddenStats()
    end
end

-- Slash Commands
SLASH_TEEBSCLASSIC1 = "/teebs"
SlashCmdList["TEEBSCLASSIC"] = slashHandler

function printHiddenStats()
    print("Crit Chance " .. round(GetCritChance(), 2) .. "%")
    print("Melee Hit Chance " .. round(GetHitModifier(), 2) .. "%")
    print("Spell Hit Chance " .. round(GetSpellHitModifier(), 2) .. "%")
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end