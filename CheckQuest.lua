--=====================================================================
-- CheckQuest
-- Checks whether a quest has been completed on the current character.
-- Commands: /checkquest <questID> or /cq <questID>
--=====================================================================

local ADDON_NAME = "CheckQuest"
local ADDON_PREFIX = "CheckQuest"
local MAX_QUESTS_PER_COMMAND = 50

local pendingQuests = {}

--=====================================================================
-- Compatibility helpers
--=====================================================================

local function GetAddonMetadata(addonName, field)
    if C_AddOns and C_AddOns.GetAddOnMetadata then
        return C_AddOns.GetAddOnMetadata(addonName, field)
    end

    if GetAddOnMetadata then
        return GetAddOnMetadata(addonName, field)
    end
end

local function LoadAddon(addonName)
    if C_AddOns and C_AddOns.LoadAddOn then
        return C_AddOns.LoadAddOn(addonName)
    end

    if LoadAddOn then
        return LoadAddOn(addonName)
    end

    return false, "LoadAddOn unavailable"
end

local ADDON_VERSION = GetAddonMetadata(ADDON_NAME, "Version") or "Unknown"

--=====================================================================
-- Output
--=====================================================================

local function PrintQuestResult(questID, completed, questName)
    local result

    if completed then
        result = "|cFF00FF00Completed|r"
    else
        result = "|cFFFF0000Incomplete|r"
    end

    if questName and questName ~= "" then
        print(string.format(
            "%s: %s (%d) - %s",
            ADDON_PREFIX,
            questName,
            questID,
            result
        ))
    else
        print(string.format(
            "%s: Quest %d - %s",
            ADDON_PREFIX,
            questID,
            result
        ))
    end
end

local function PrintHelp()
    print("|cFFFFD100CheckQuest|r commands:")
    print("  |cFFFFFFFF/cq <questID>|r - Check a quest.")
    print("  |cFFFFFFFF/cq <questID> <questID> ...|r - Check multiple quests.")
    print("  |cFFFFFFFF/cq help|r - Show this help.")
    print("  |cFFFFFFFF/cq version|r - Show addon version.")
end

--=====================================================================
-- Quest checking
--=====================================================================

local function ShowQuestResult(questID)
    local completed = C_QuestLog.IsQuestFlaggedCompleted(questID)
    local questName = C_QuestLog.GetTitleForQuestID(questID)

    if questName and questName ~= "" then
        PrintQuestResult(questID, completed, questName)
        return
    end

    -- Quest data is not always cached locally.
    -- Request it from the server and print the result when loaded.
    pendingQuests[questID] = completed

    if C_QuestLog.RequestLoadQuestByID then
        C_QuestLog.RequestLoadQuestByID(questID)
    else
        PrintQuestResult(questID, completed)
        pendingQuests[questID] = nil
    end
end

--=====================================================================
-- Events
--=====================================================================

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("QUEST_DATA_LOAD_RESULT")

eventFrame:SetScript("OnEvent", function(_, event, questID, success)
    if event ~= "QUEST_DATA_LOAD_RESULT" then
        return
    end

    local completed = pendingQuests[questID]

    if completed == nil then
        return
    end

    pendingQuests[questID] = nil

    local questName

    if success then
        questName = C_QuestLog.GetTitleForQuestID(questID)
    end

    PrintQuestResult(questID, completed, questName)
end)

--=====================================================================
-- Slash commands
--=====================================================================

local function CheckQuestCommand(msg)
    msg = msg or ""

    local trimmed = msg:match("^%s*(.-)%s*$") or ""

    if trimmed == "" then
        PrintHelp()
        return
    end

    local command = trimmed:lower()

    if command == "help" then
        PrintHelp()
        return
    end

    if command == "version" then
        print(string.format(
            "%s: Version %s",
            ADDON_PREFIX,
            ADDON_VERSION
        ))
        return
    end

    local questIDs = {}
    local seen = {}

    for idText in trimmed:gmatch("%d+") do
        local questID = tonumber(idText)

        if questID and questID > 0 and not seen[questID] then
            seen[questID] = true
            questIDs[#questIDs + 1] = questID

            if #questIDs >= MAX_QUESTS_PER_COMMAND then
                break
            end
        end
    end

    if #questIDs == 0 then
        print("CheckQuest: Please enter a Quest ID. Example: /cq 12345")
        return
    end

    local totalIDsFound = 0
    local totalSeen = {}

    for idText in trimmed:gmatch("%d+") do
        local questID = tonumber(idText)

        if questID and questID > 0 and not totalSeen[questID] then
            totalSeen[questID] = true
            totalIDsFound = totalIDsFound + 1
        end
    end

    if totalIDsFound > MAX_QUESTS_PER_COMMAND then
        print(string.format(
            "CheckQuest: Maximum %d unique quest IDs per command. Only the first %d will be checked.",
            MAX_QUESTS_PER_COMMAND,
            MAX_QUESTS_PER_COMMAND
        ))
    end

    for _, questID in ipairs(questIDs) do
        ShowQuestResult(questID)
    end
end

SLASH_CHECKQUEST1 = "/checkquest"
SLASH_CHECKQUEST2 = "/cq"
SlashCmdList["CHECKQUEST"] = CheckQuestCommand

--=====================================================================
-- Convenience commands
--=====================================================================

SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI

SLASH_FRAMESTK1 = "/fs"
SlashCmdList["FRAMESTK"] = function()
    local loaded, reason = LoadAddon("Blizzard_DebugTools")

    if not loaded then
        print(string.format(
            "CheckQuest: Could not load Blizzard_DebugTools%s.",
            reason and " (" .. tostring(reason) .. ")" or ""
        ))
        return
    end

    if FrameStackTooltip_Toggle then
        FrameStackTooltip_Toggle()
    else
        print("CheckQuest: Frame stack tool is unavailable on this client.")
    end
end

--=====================================================================