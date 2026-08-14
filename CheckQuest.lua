--=====================================================================
-- CheckQuest
-- Quickly checks whether quests have been completed on this character.
-- Commands: /checkquest <questID ...> or /cq <questID ...>
--=====================================================================

local ADDON_NAME = "CheckQuest"
local ADDON_VERSION = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version") or "Unknown"
local MAX_QUESTS_PER_COMMAND = 50
local pendingQuests = {}

local COLOR_PREFIX = "|cff33ff99"
local COLOR_GREEN = "|cff00ff00"
local COLOR_RED = "|cffff4040"
local COLOR_YELLOW = "|cffffff00"
local COLOR_RESET = "|r"

local function Print(message)
    print(string.format("%s%s:%s %s", COLOR_PREFIX, ADDON_NAME, COLOR_RESET, message))
end

local function GetQuestDisplay(questID, questName)
    if questName and questName ~= "" then
        return string.format("%s (%d)", questName, questID)
    end

    return string.format("Quest %d", questID)
end

local function PrintQuestResult(questID, completed, questName)
    local questDisplay = GetQuestDisplay(questID, questName)

    if completed then
        Print(string.format("%s — %sCompleted%s", questDisplay, COLOR_GREEN, COLOR_RESET))
    else
        Print(string.format("%s — %sIncomplete%s", questDisplay, COLOR_RED, COLOR_RESET))
    end
end

local function ShowQuestResult(questID)
    local completed = C_QuestLog.IsQuestFlaggedCompleted(questID)
    local questName = C_QuestLog.GetTitleForQuestID(questID)

    if questName and questName ~= "" then
        PrintQuestResult(questID, completed, questName)
        return
    end

    -- Quest data is not always cached locally. Remember the completion state,
    -- request the quest data, and finish when QUEST_DATA_LOAD_RESULT fires.
    pendingQuests[questID] = completed
    C_QuestLog.RequestLoadQuestByID(questID)
end

local function ShowHelp()
    Print(string.format("Check quest completion with %s/cq <questID>%s.", COLOR_YELLOW, COLOR_RESET))
    Print(string.format("Check up to %d quests at once: /cq 12345 23456 34567", MAX_QUESTS_PER_COMMAND))
    Print("Quest IDs can also be pasted from text or a Wowhead URL.")
    Print("Commands: /cq help, /cq version")
end

local function ExtractQuestIDs(message)
    local questIDs = {}
    local seen = {}
    local capped = false

    for value in message:gmatch("%d+") do
        local questID = tonumber(value)

        if questID and questID > 0 and not seen[questID] then
            if #questIDs >= MAX_QUESTS_PER_COMMAND then
                capped = true
                break
            end

            seen[questID] = true
            questIDs[#questIDs + 1] = questID
        end
    end

    return questIDs, capped
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("QUEST_DATA_LOAD_RESULT")
eventFrame:SetScript("OnEvent", function(_, _, questID, success)
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

local function HandleCommand(message)
    message = strtrim(message or "")

    if message == "" or message:lower() == "help" then
        ShowHelp()
        return
    end

    if message:lower() == "version" then
        Print("Version " .. ADDON_VERSION)
        return
    end

    local questIDs, capped = ExtractQuestIDs(message)
    if #questIDs == 0 then
        Print(string.format("No quest ID found. Try %s/cq 12345%s or %s/cq help%s.",
            COLOR_YELLOW, COLOR_RESET, COLOR_YELLOW, COLOR_RESET))
        return
    end

    if capped then
        Print(string.format("Only the first %d unique quest IDs will be checked.", MAX_QUESTS_PER_COMMAND))
    end

    for _, questID in ipairs(questIDs) do
        ShowQuestResult(questID)
    end
end

SLASH_CHECKQUEST1 = "/checkquest"
SLASH_CHECKQUEST2 = "/cq"
SlashCmdList["CHECKQUEST"] = HandleCommand

--=====================================================================
-- Convenience commands
--=====================================================================

SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI

SLASH_FRAMESTK1 = "/fs"
SlashCmdList["FRAMESTK"] = function()
    local loaded, reason = C_AddOns.LoadAddOn("Blizzard_DebugTools")
    if not loaded then
        Print(string.format("Could not load Blizzard_DebugTools%s.", reason and " (" .. reason .. ")" or ""))
        return
    end

    if FrameStackTooltip_Toggle then
        FrameStackTooltip_Toggle()
    else
        Print("Frame stack tool is unavailable on this client.")
    end
end
