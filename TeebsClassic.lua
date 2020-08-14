------------------------------------------------------------------
-- Addon Core Creation, Event Registration And Handling
------------------------------------------------------------------
-- Addon Initialisation and UI setup
TEEBS_CLASSIC_FRAME = createFrame("TeebsClassic", UIParent, 500, 500, "CENTER", 0, 0, { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 12, tile = true, tileSize = 12, insets = { left = 0, right = 0, top = 0, bottom = 0, }, }, onLoadCoreFrame, eventHandler)
generateCoreUIElements(TEEBS_CLASSIC_FRAME)
TEEBS_CLASSIC_FRAME:Hide()    -- Hide the addon frame by default, Comment this out to show the addon frame on reload
