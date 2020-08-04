------------------------------------------------------------------
-- Addon Core Creation, Event Registration And Handling
------------------------------------------------------------------
-- Addon Initialisation and UI setup
local TeebsClassicFrame = TeebsClassic_CreateFrame("TeebsClassic", UIParent, 500, 500, "CENTER", 0, 0, { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 12, tile = true, tileSize = 12, insets = { left = 0, right = 0, top = 0, bottom = 0, }, }, TeebsClassic_OnLoad, TeebsClassic_EventHandler)
ActivateLayout_Core(TeebsClassicFrame)
Layout_MainMenu(TeebsClassicFrame)
TeebsClassicFrame:Hide()    -- Hide the addon frame by default, Comment this out to show the addon frame on reload

-- Register the Main Addon frame with the Global variable array provided by the Wow API
_G["TeebsClassicFrame"] = TeebsClassicFrame
