------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName = 'PlayerDB';
local moduleAlert = M .. moduleName .. ": |r";
local module = A:GetModule(moduleName, true);
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - create command [x]
    - understand command arguments
]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[
    posture check reminder with intervals
]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local length = 3600
local t = length
local f = CreateFrame("Frame")

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- module:RegisterEvent("PLAYER_REGEN_ENABLED")
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function main(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
f:SetScript("OnUpdate", function(self, elapsed)
    t = t - elapsed
    if t <= 0 then
        print("Check your posture!")
        RaidNotice_AddMessage(RaidBossEmoteFrame, "Check your posture!", ChatTypeInfo["RAID_BOSS_EMOTE"])
        -- PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_2)
        t = length
    end
end)

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
-- SLASH_reputation1 = "/rep"
-- SlashCmdList["reputation"] = function(msg)
--     handlePlayerStat(msg, 'reputation')
-- end

SLASH_POSTURECHECK1 = '/posture'

function SlashCmdList.POSTURECHECK(msg, editbox)
    print("PostureCheck timer set to " .. msg .. " minute(s).");
    length = msg * 60
    t = length
end

------------------------------------------------------------------------------------------------------------------------
-- ==== GUI
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getPlayerData)
-- GameTooltip:HookScript("OnTooltipSetUnit", Archrist_PlayerDB_getNote)

------------------------------------------------------------------------------------------------------------------------
-- ==== Callback & Register [last arg]
local function InitializeCallback()
    module:Initialize()
end
A:RegisterModule(module:GetName(), InitializeCallback)
