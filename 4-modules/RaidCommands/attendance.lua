------------------------------------------------------------------------------------------------------------------------
-- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'Attendance';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName);
------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = true
local raid = {}
local focusColor = Arch_focusColor

-- ==== Body
local function registerAttendance()
    if isEnabled then
        if UnitInRaid('player') then
            raid = {}
            for ii = 1, GetNumRaidMembers() do
                local person = GetRaidRosterInfo(ii)
                table.insert(raid, person)
            end
            --
            local list = ""
            for ii = 1, #raid do
                -- print(GetNumRaidMembers())
                list = list .. raid[ii]
                if ii ~= #raid then 
                    list = list .. ", "
                end
            end
            --
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. focusColor('Raid: ') .. list)
            A.global.lastRaid = {date("%d-%m-%y"), raid}
        else
            SELECTED_CHAT_FRAME:AddMessage(
                moduleAlert .. 'you are not in raid')
        end
    end
end

-- ==== Slash commands [last arg]
SLASH_RAIDATTENDANCE1 = "/attendance"
SlashCmdList["RAIDATTENDANCE"] = function(msg) registerAttendance() end

-- local b = CreateFrame("Button", "MyButton", UIParent, "UIPanelButtonTemplate")
-- b:SetSize(80 ,22)
-- b:SetText("Button!")
-- b:SetPoint("CENTER")
-- b:SetScript("OnClick", function()
--     SendChatMessage("I'm saying stuff" ,"SAY")
-- end)

-- https://www.wowinterface.com/forums/showthread.php?t=37386
