
--=====================================================================
local function MyAddonCommands(msg, editbox)
  myQuestID = string.match(msg,"%d+");
  myResult = "Incomplete";
  
  if (myQuestID == nil) or (myQuestID == '') then
    print("Please enter a Quest ID.")
  elseif myQuestID ~= '' then
    if (IsQuestFlaggedCompleted(myQuestID)) then
          --myQuestName = GetQuestInfo(myQuestID)
          myResult = "Completed";
    end
    print("QuestID: "..myQuestID.." : "..myResult);
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



