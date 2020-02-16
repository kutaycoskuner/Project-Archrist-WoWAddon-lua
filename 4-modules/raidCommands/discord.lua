------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, M, N = unpack(select(2, ...));
local moduleName = 'discord';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = true
local string1 = "Join https://discord.gg/XCGTYtp "
local string2 = ">> Change your discord nickname same as wow "
local string3 = ">> Join [The Prancing Pony] Channel "

-- ==== Body
local function announceDiscord()
    if isEnabled then
        SendChatMessage(string1 .. string2 .. string3,"RAID_WARNING") -- RAID_WARNING, SAY
    end
end

-- ==== Slash commands [last arg]
SLASH_DISCORD1 = "/discord"
SlashCmdList["DISCORD"] = function(msg) announceDiscord() end

-- local b = CreateFrame("Button", "MyButton", UIParent, "UIPanelButtonTemplate")
-- b:SetSize(80 ,22)
-- b:SetText("Button!")
-- b:SetPoint("CENTER")
-- b:SetScript("OnClick", function()
--     SendChatMessage("I'm saying stuff" ,"SAY")
-- end)

-- https://www.wowinterface.com/forums/showthread.php?t=37386