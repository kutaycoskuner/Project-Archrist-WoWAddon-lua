------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Discord';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local raidAlerts = Arch_raidAlerts
local isEnabled = true
local string1 = "If you like to be informed about further runs please join https://discord.gg/wQTEexv "
local string2 = "If you like to be informed about further runs or join guild https://discord.gg/PGAZuj7 "
local string3 = ">> Join [The Prancing Pony] Channel "
string2, string3 = '',''

-- ==== Body
local function announceDiscord()
    if isEnabled then
        -- SELECTED_CHAT_FRAME:AddMessage(string1)
        SendChatMessage(raidAlerts.community.discord,"RAID_WARNING") -- RAID_WARNING, SAY
    end
end

local function announceGuild()
    if isEnabled then
        -- SELECTED_CHAT_FRAME:AddMessage(string1)
        SendChatMessage(raidAlerts.community.guild,"RAID_WARNING") -- RAID_WARNING, SAY
    end
end

-- ==== Slash commands [last arg]
SLASH_DISCORD1 = "/discord"
SlashCmdList["DISCORD"] = function(msg) announceDiscord() end
SLASH_ARCHGUILD1 = "/guild"
SlashCmdList["ARCHGUILD"] = function(msg) announceGuild() end


-- local b = CreateFrame("Button", "MyButton", UIParent, "UIPanelButtonTemplate")
-- b:SetSize(80 ,22)
-- b:SetText("Button!")
-- b:SetPoint("CENTER")
-- b:SetScript("OnClick", function()
--     SendChatMessage("I'm saying stuff" ,"SAY")
-- end)

-- https://www.wowinterface.com/forums/showthread.php?t=37386