------------------------------------------------------------------
-- Addon Core
------------------------------------------------------------------
-- Addon Core Frame Creation
TEEBS_CLASSIC_FRAME = createFrame("TeebsClassic", UIParent, 500, 500, "CENTER", 0, 0, TEEBS_CLASSIC_BACKDROP_OBJECT, { r = 0, g = 0, b = 0, a = 1 }, onLoadCoreFrame, eventHandlerCoreFrame)
TEEBS_CLASSIC_FRAME:Hide()    -- Hide the addon frame by default, Comment this out to show the addon frame on reload
