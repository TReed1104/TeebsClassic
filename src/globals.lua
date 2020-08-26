------------------------------------------------------------------
-- Globals Variables
------------------------------------------------------------------
_G["CURRENT_REALM"] = ""
_G["CURRENT_CHARACTER_NAME"] = ""
_G["TEEBS_TEXT_COLOUR_DEFAULT"] = "ffffff00"
_G["TEEBS_TEXT_COLOUR_WHITE"] = "ffffffff"
_G["TEEBS_TEXT_COLOUR_ALERT"] = "ffff0000"
_G["TEEBS_TEXT_COLOUR_CAPPED"] = "ff00ff00"
_G["TEEBS_TEXT_COLOUR_TALENTS"] = "ffffa500"
_G["TEEBS_CLASSIC_FRAME"] = nil
_G["TEEBS_CLASSIC_BACKDROP_OBJECT"] = {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}
_G["TEEBS_OBJECT_COLOUR_BLACK"] = {
	r = 0,
	g = 0,
	b = 0,
	a = 1
}
_G["TEEBS_OBJECT_COLOUR_WHITE"] = {
	r = 1,
	g = 1,
	b = 1,
	a = 1
}
_G["TEEBS_OBJECT_COLOUR_GREY"] = {
	r = 0.3,
	g = 0.3,
	b = 0.3,
	a = 1
}
_G["TEEBS_OBJECT_COLOUR_RED"] = {
	r = 1,
	g = 0,
	b = 0,
	a = 1
}
_G["TEEBS_OBJECT_COLOUR_GREEN"] = {
	r = 0,
	g = 1,
	b = 0,
	a = 1
}
_G["TEEBS_OBJECT_COLOUR_BLUE"] = {
	r = 0,
	g = 0,
	b = 1,
	a = 1
}
_G["TEEBS_CLASSIC_CONTENT_FRAMES"] = {
	home = { frameID = "contentFrameHome", titleID = "frameTitle", titleText = "Home" },
	equipment = { frameID = "contentFrameEquipment", titleID = "frameTitleEquipment", titleText = "Gear" },
	bags = { frameID = "contentFrameBags", titleID = "frameTitleBags", titleText = "Bags" },
	talents = { frameID = "contentFrameTalents", titleID = "frameTitleTalents", titleText = "Talents" },
	professions = { frameID = "contentFrameCharacterProfessions", titleID = "frameTitleCharacterProfessions", titleText = "Character Professions" },
	reputations = { frameID = "contentFrameCharacterReputations", titleID = "frameTitleCharacterReputations", titleText = "Character Reputations" },
	experience = { frameID = "contentFrameExperience", titleID = "frameTitleExperience", titleText = "Experience" },
	locations = { frameID = "contentFrameLocations", titleID = "frameTitleLocations", titleText = "Location" },
	playtime = { frameID = "contentFramePlaytime", titleID = "frameTitlePlaytime", titleText = "Play Time" },
	gold = { frameID = "contentFrameGold", titleID = "frameTitleGold", titleText = "Gold" },
	professionsAll = { frameID = "contentFrameAllProfessions", titleID = "frameTitleAllProfessions", titleText = "All Professions" },
	professionsPrimary = { frameID = "contentFrameAllPrimaryProfessions", titleID = "frameTitleAllPrimaryProfessions", titleText = "All Primary Professions" },
	professionsSecondary = { frameID = "contentFrameAllSecondaryProfessions", titleID = "frameTitleAllSecondaryProfessions", titleText = "All Secondary Professions" },
}
