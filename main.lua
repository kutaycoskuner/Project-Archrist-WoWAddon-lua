-- ==== Development
SLASH_RELOADUI1 = "/rl"; -- for quicker reload
SlashCmdList.RELOADUI = ReloadUI;

SLASH_FRAMESTK1 = "/fs"; -- for quicker access to frame stack
SlashCmdList.FRAMESTK = function()
    LoadAddOn('Blizzard_DebugTools');
    FrameStackTooltip_Toggle();
end

for i = 1, NUM_CHAT_WINDOWS do 
    _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode (false);
end
-- ==== Start

-- local UIConfig = CreateFrame("Frame", "Orth_ConfigFrame", UIParent, "BasicFrameTemplateWithInset"); 

-- --[[
--     CreateFrame Arguments:
--         1- The type of frame - 'frame'
--         2- The global frame name 
--         3- The parent frame (not a string)
--         4- A comma separated list (string list) of xml templates to inherit from
-- ]]

-- UIConfig.SetSize(300, 360);
-- UIConfig.SetPoint("CENTER", UIParent, "CENTER"); -- point, relativeFrame, relativePoint, xOffset, yOffset

-- --[[
--     "TOPLEFT"
--     "TOP"
--     "TOPRIGHT"
--     "LEFT"
--     "CENTER"
--     "RIGHT"
--     "BOTTOMLEFT"
--     "BOTTOM"
--     "BOTTOMRIGHT"
-- ]]