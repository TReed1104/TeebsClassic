------------------------------------------------------------------
-- Addon Core Creation, Event Registration And Handling
------------------------------------------------------------------
-- Addon Initialisation and UI setup
TEEBS_CLASSIC_FRAME = createFrame("TeebsClassic", UIParent, 500, 500, "CENTER", 0, 0, TEEBS_CLASSIC_BACKDROP_OBJECT, onLoadCoreFrame, eventHandlerCoreFrame)
generateCoreUIElements(TEEBS_CLASSIC_FRAME)
TEEBS_CLASSIC_FRAME:Hide()    -- Hide the addon frame by default, Comment this out to show the addon frame on reload
