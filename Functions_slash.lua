------------------------------------------------------------------
-- Slash Command Registration and Functions
------------------------------------------------------------------
-- Slash Commands
SLASH_TEEBSCLASSIC1 = "/teebs"
SLASH_TEEBSCLASSIC2 = "/tbs"
SLASH_TEEBSCLASSIC3 = "/th"

-- Slash Command Handler Function
SlashCmdList["TEEBSCLASSIC"] = function(msg)
    -- Message syntax
        -- [1] - Command
        -- [2] - Character
        -- [3] - Slot/value - Might not always been required, depending on the function
    local messageSplit = splitString(msg)

    -- check we have a usable command and that we have a command option
    if messageSplit == nil or messageSplit[1] == nil then
        print("Invalid Command - ", msg)
        return
    end

    -- If supplied, force the Character name to lower case behind the scenes
    if messageSplit[2] then
        messageSplit[2] = messageSplit[2]:lower()
    end

    -- Command parameter checks, sanity check we've got what we need for the command functions
    if messageSplit[1] == "get-exp" or messageSplit[1] == "get-level" or messageSplit[1] == "get-spec" or messageSplit[1] == "get-talents" or messageSplit[1] == "get-gold" or messageSplit[1] == "get-professions" or messageSplit[1] == "get-primary-professions" or messageSplit[1] == "get-secondary-professions" or messageSplit[1] == "get-reps-all" or messageSplit[1] == "get-slot-all" or messageSplit[1] == "get-bags-all" then
        -- Check we have the character name
        if messageSplit[2] == nil then
            print("You must supply a character name for this command")
            return
        end
    elseif messageSplit[1] == "get-slot" or messageSplit[1] == "get-bag" or messageSplit[1] == "get-rep" then
        -- Check we have the character name and slot/bag index
        if messageSplit[2] == nil or messageSplit[3] == nil then
            print("You must supply a character name and item/bag slot index or faction name for this command")
            return
        end
    end

    -- Work out which addon function to use
    if messageSplit[1] == "get-slot" then
        cmdGetCharacterItemSlot(messageSplit[2], messageSplit[3])
    elseif messageSplit[1] == "get-bag" then
        cmdGetCharacterBag(messageSplit[2], messageSplit[3])
    elseif messageSplit[1] == "get-exp" then
        cmdGetCharacterExperience(messageSplit[2])
    elseif messageSplit[1] == "get-level" then
        cmdGetCharacterLevel(messageSplit[2])
    elseif messageSplit[1] == "get-spec" then
        cmdGetCharacterSpec(messageSplit[2])
    elseif messageSplit[1] == "get-talents" then
        cmdGetCharacterTalents(messageSplit[2])
    elseif messageSplit[1] == "get-gold" then
        cmdGetCharacterGold(messageSplit[2])
    elseif messageSplit[1] == "get-professions" then
        cmdGetCharacterProfessions(messageSplit[2])
    elseif messageSplit[1] == "get-primary-professions" then
        cmdGetCharacterPrimaryProfessions(messageSplit[2])
    elseif messageSplit[1] == "get-secondary-professions" then
        cmdGetCharacterSecondaryProfessions(messageSplit[2])
    elseif messageSplit[1] == "get-rep" then
        cmdGetCharacterReputation(messageSplit[2], messageSplit[3]:lower())
    elseif messageSplit[1] == "get-playtime" then
        cmdGetCharacterPlayTime(messageSplit[2])
    elseif messageSplit[1] == "get-slot-all" then
        cmdGetAllCharactersItemSlots(messageSplit[2])
    elseif messageSplit[1] == "get-bags-all" then
        cmdGetAllCharactersBags(messageSplit[2])
    elseif messageSplit[1] == "get-exp-all" then
        cmdGetAllCharactersExperience()
    elseif messageSplit[1] == "get-level-all" then
        cmdGetAllCharactersLevels()
    elseif messageSplit[1] == "get-spec-all" then
        cmdGetAllCharacterSpecs()
    elseif messageSplit[1] == "get-gold-all" then
        cmdGetAllCharactersGold()
    elseif messageSplit[1] == "get-professions-all" then
        cmdGetAllCharacterProfessions()
    elseif messageSplit[1] == "get-primary-professions-all" then
        cmdGetAllCharacterPrimaryProfessions()
    elseif messageSplit[1] == "get-secondary-professions-all" then
        cmdGetAllCharacterSecondaryProfessions()
    elseif messageSplit[1] == "get-reps-all" then
        cmdGetAllCharacterReputations(messageSplit[2])
    elseif messageSplit[1] == "get-playtime-all" then
        cmdGetAllCharacterPlayTime()
    elseif messageSplit[1] == "get-total-playtime" then
        cmdGetTotalPlayTime()
    elseif messageSplit[1] == "get-total-gold" then
        cmdGetTotalGold()
    elseif messageSplit[1] == "show" then
        TeebsClassic_MainFrame:Show()
    elseif messageSplit[1] == "hide" then
        TeebsClassic_MainFrame:Hide()
    else
        print("Unknown Command", messageSplit[1])
    end
end
