-- ==== Development
SLASH_RELOADUI1 = "/rl"; -- for quicker reload
SLASH_RELOADUI2 = "/reloadui"; -- ?? Bunu nasil taniyor numaralari algiliyor mu ?
SLASH_RELOADUI3 = "/re";
SlashCmdList.RELOADUI = ReloadUI;

SLASH_FRAMESTACK1 = "/fs"; -- for quicker access to frame stack
SlashCmdList.FRAMESTACK = function()
    LoadAddOn('Blizzard_DebugTools');
    FrameStackTooltip_Toggle();
end

for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false);
end

--Lua functions
--WoW API / Variables
local SlashCmdList = SlashCmdList

