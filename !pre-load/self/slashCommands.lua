-- ==== Development

-- :: reload
SLASH_RELOADUI1 = "/rl"; -- for quicker reload
SLASH_RELOADUI2 = "/reloadui";
SLASH_RELOADUI3 = "/re";
SlashCmdList.RELOADUI = ReloadUI;

-- :: frameStacks
SLASH_FRAMESTACK1 = "/fs"; -- for quicker access to frame stack
SlashCmdList.FRAMESTACK = function()
    LoadAddOn('Blizzard_DebugTools');
    FrameStackTooltip_Toggle();
end

for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false);
end

-- :: in lootMsgFilter
-- SLASH_lootFilter1 = "/lootfilter"
-- SLASH_rollFilter1 = "/rollfilter"
-- :: in raidWarnings
-- SLASH_RaidWarning1 = "/war"
-- SLASH_SelectLeadChannel1 = "/comms"

-- :: Slash Command List Local [LastArg]
local SlashCmdList = SlashCmdList

