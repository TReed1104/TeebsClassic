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
        initialiseDB()
    end
    if event == "PLAYER_LOGIN" then
        -- Player Login Event Trigger
        print("Welcome to Teebs Classic, use /teebs")
    end
end)

local function slashHandler(msg, editbox)
    if msg == "all" then
        printHiddenStats()
    elseif msg == "melee" then
        printMeleeStats()
    elseif msg == "def" then
        printDefensiveStats()
    elseif msg == "spell" then
        printMagicStats()
    elseif msg == "" then
        print("Please enter your selection: all, melee, def or spell")
    else
        print("Oops! Not recognised mode")
    end
end

-- Create/load the addon database
function initialiseDB()
end

-- Slash Commands
SLASH_TEEBSCLASSIC1 = "/teebs"
SlashCmdList["TEEBSCLASSIC"] = slashHandler

function printHiddenStats()
    print("-------------------------------")
    print("Melee Stats")
    print("-------------------------------")
    print("Melee Hit Chance " .. round(GetHitModifier(), 2) .. "%")
    print("Melee Crit Chance " .. round(GetCritChance(), 2) .. "%")
    print("-------------------------------")
    print("Defensive Stats")
    print("-------------------------------")
    print("Dodge Chance " .. round(GetDodgeChance(), 2) .. "%")
    print("Parry Chance " .. round(GetParryChance(), 2) .. "%")
    print("Block Chance " .. round(GetBlockChance(), 2) .. "%")
    print("-------------------------------")
    print("Spell Stats")
    print("-------------------------------")
    print("Spell Hit Chance " .. round(GetSpellHitModifier(), 2) .. "%")
    print("Spell Crit Chance (Physical) " .. round(GetSpellCritChance(1), 2) .. "%")
    local averageSpellCrit = round((GetSpellCritChance(2) + GetSpellCritChance(3) + GetSpellCritChance(4) + GetSpellCritChance(5) + GetSpellCritChance(6) + GetSpellCritChance(7)) / 6, 2)
    print("Spell Crit Chance (Average) " .. averageSpellCrit .. "%")
end

function printMeleeStats()
    print("-------------------------------")
    print("Melee Stats")
    print("-------------------------------")
    print("Melee Hit Chance " .. round(GetHitModifier(), 2) .. "%")
    print("Melee Crit Chance " .. round(GetCritChance(), 2) .. "%")
end

function printDefensiveStats()
    print("-------------------------------")
    print("Defensive Stats")
    print("-------------------------------")
    print("Dodge Chance " .. round(GetDodgeChance(), 2) .. "%")
    print("Parry Chance " .. round(GetParryChance(), 2) .. "%")
    print("Block Chance " .. round(GetBlockChance(), 2) .. "%")
end

function printMagicStats()
    print("-------------------------------")
    print("Spell Stats")
    print("-------------------------------")
    print("Spell Hit Chance " .. round(GetSpellHitModifier(), 2) .. "%")
    print("Spell Crit Chance (Physical) " .. round(GetSpellCritChance(1), 2) .. "%")
    local averageSpellCrit = round((GetSpellCritChance(2) + GetSpellCritChance(3) + GetSpellCritChance(4) + GetSpellCritChance(5) + GetSpellCritChance(6) + GetSpellCritChance(7)) / 6, 2)
    print("Spell Crit Chance (Average) " .. averageSpellCrit .. "%")
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end