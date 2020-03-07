-- ==== Metadata
local A, L, V, P, G = unpack(select(2, ...)) -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local module = A:GetModule('raidWarnings');

-- ==== Variables
local boss = 'none';
local comms = '/p ' .. UnitName('player') .. " ";
--
local rwDefault1 = '{skull} Focus on [%t] {skull}';
local rwDefault2 = '{square} Innervate me {square}';
local rwDefault3 = '{circle} Heroism Now! {circle}';
local rwDefault4 = '{triangle} Combat Res [%t] {triangle}';
--
local raidWarning1 = rwDefault1;
local raidWarning2 = rwDefault2;
local raidWarning3 = rwDefault3;
local raidWarning4 = rwDefault4;

-- :: buttons
local warn1 = CreateFrame("CheckButton", "WarnButton1", UIParent,
                          "SecureActionButtonTemplate")
warn1:SetAttribute("type", "macro")
local warn2 = CreateFrame("CheckButton", "WarnButton2", UIParent,
                          "SecureActionButtonTemplate")
warn2:SetAttribute("type", "macro")
local warn3 = CreateFrame("CheckButton", "WarnButton3", UIParent,
                          "SecureActionButtonTemplate")
warn3:SetAttribute("type", "macro")
local warn4 = CreateFrame("CheckButton", "WarnButton4", UIParent,
                          "SecureActionButtonTemplate")
warn4:SetAttribute("type", "macro")

-- ==== Start
-- function module:Initialize()
--     self.initialized = true
--     setRaidWarnings();
--     print('init')
--     -- :: Register some events
-- end

-- :: sets raid warning
function setRaidWarnings()
    WarnButton1:SetAttribute("macrotext", comms .. raidWarning1)
    WarnButton2:SetAttribute("macrotext", comms .. raidWarning2)
    WarnButton3:SetAttribute("macrotext", comms .. raidWarning3)
    WarnButton4:SetAttribute("macrotext", comms .. raidWarning4)
end

-- :: selecting boss via slash command
local function selectBoss(boss)
    if boss then
        local firsti, lasti, command, value =
            string.find(boss, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(boss, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(boss, "(%w+)");
        end
        -- :: komut varsa
        if (command ~= nil) then command = string.lower(command); end
        --
        if (command == "skadi") then
            raidWarning1 = '{triangle} Watchout for Breath {triangle}'
            raidWarning2 = '{triangle} LEFT {triangle}'
            raidWarning3 = '{triangle} RIGHT {triangle}'
            raidWarning4 = '{triangle} Use Harpoons {triangle}'
            -- elseif (command == "something") then
            -- raidWarning1 = '{triangle} Watchout for Breath {triangle}'
            -- raidWarning2 = '{triangle} LEFT {triangle}'
            -- raidWarning3 = '{triangle} RIGHT {triangle}'
            -- raidWarning4 = '{triangle} Use Harpoons {triangle}'
        elseif (command == "emalon") then
            raidWarning1 = '{triangle} Run away from the boss {triangle}'
            raidWarning2 = '{skull} Focus on Big Add {skull}'
            raidWarning3 = '{skull} Back to boss {skull}'
            raidWarning4 = '{triangle} Use Harpoons {triangle}'
        else
            boss = 'default'
            raidWarning1 = rwDefault1;
            raidWarning2 = rwDefault2;
            raidWarning3 = rwDefault3;
            raidWarning4 = rwDefault4;
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff128ec4[Archrium] Raidwarnings:|r " ..
                                          tostring(boss))
        UIErrorsFrame:AddMessage("|cff128ec4Raidwarnings|r " .. tostring(boss))
    end
    setRaidWarnings();
end

local function selectChannel(channel)
    if channel then
        local firsti, lasti, command, value =
            string.find(channel, "(%w+) \"(.*)\"");
        if (command == nil) then
            firsti, lasti, command, value = string.find(channel, "(%w+) (%w+)");
        end
        if (command == nil) then
            firsti, lasti, command = string.find(channel, "(%w+)");
        end
        -- :: komut varsa
        if (command ~= nil) then command = string.lower(command); end
        --
        if (command == "w" or command == "test") then
            comms = "/w " .. UnitName('player') .. " "
        elseif (command == "s" or command == "say") then
            comms = "/s "
        elseif (command == "p" or command == "party") then
            comms = "/p "
        elseif (command == "ra" or command == "raid") then
            comms = "/ra "
        elseif (command == "rw" or command == "raidwarning") then
            comms = "/rw "
        elseif (command == "bg" or command == "battlegrouund") then
            comms = "/bg "
        else
            comms = '/rw '
        end
        DEFAULT_CHAT_FRAME:AddMessage(
            "|cff128ec4[Archrium] WarningChannel:|r " .. tostring(comms))
        UIErrorsFrame:AddMessage("|cff128ec4WarningChannel|r " ..
                                     tostring(comms))
    end
    setRaidWarnings();
end

-- -- ==== End
setRaidWarnings();
-- local function InitializeCallback() module:Initialize() end
-- A:RegisterModule(module:GetName(), InitializeCallback)

-- ==== Slash Handlers
SLASH_RaidWarning1 = "/war"
SlashCmdList["RaidWarning"] = function(boss) selectBoss(boss) end
SLASH_SelectLeadChannel1 = "/comms"
SlashCmdList["SelectLeadChannel"] = function(channel) selectChannel(channel) end

-- ==== Example Usage [last arg]
--[[
/click WarnButton1;  
/click WarnButton2; 
/click WarnButton3; 
/click WarnButton4; 
--]]