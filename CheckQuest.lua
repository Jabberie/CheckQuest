
--=====================================================================
local MyScanningTooltip = CreateFrame("GameTooltip", "MyScanningTooltip", UIParent, "GameTooltipTemplate")

local QuestTitleFromID = setmetatable({}, { __index = function(t, id)
  MyScanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
  MyScanningTooltip:SetHyperlink("quest:"..id)
  local title = MyScanningTooltipTextLeft1:GetText()
  MyScanningTooltip:Hide()
  if title and title ~= RETRIEVING_DATA then
    t[id] = title
    return title
  end
end })



local function MyAddonCommands(msg, editbox)
  myQuestID = string.match(msg,"%d+");
  myResult = "is |cffff0000Incomplete|r on this character.";
  
  if (myQuestID == nil) or (myQuestID == '') then
    print("Please enter a Quest ID.")
  elseif myQuestID ~= '' then
    if (IsQuestFlaggedCompleted(myQuestID)) then
          --myQuestName = QuestTitleFromID(myQuestID)
          myQuestName = QuestTitleFromID[myQuestI]D;
          if myQuestName == nil then
            myQuestName = QuestTitleFromID[myQuestI]D;
          end
          myResult = "has been |cFF00FF00Completed|r on this character.";
    end
    print("CheckQuest: The quest "..myQuestName.."("..myQuestID..") "..myResult);
    --print("CheckQuest: The quest ("..myQuestID..") "..myResult);
  else
    print("You broke it, somehow!");
  end
end




SLASH_CHECKQUEST1, SLASH_CHECKQUEST2 = '/checkquest', '/cq'
SlashCmdList["CHECKQUEST"] = MyAddonCommands 
--=====================================================================

--=====================================================================
SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI;
--=====================================================================



