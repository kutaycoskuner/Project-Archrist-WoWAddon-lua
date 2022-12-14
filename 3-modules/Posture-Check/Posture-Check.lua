------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'PostureCheck', "Posture Check";
local moduleAlert = M .. moduleName2 .. ": |r";
local module = A:GetModule(moduleName1, true);
if module == nil then
    return
end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------
-- todo ----------------------------------------------------------------------------------------------------------------
--[[
    - variables - isenabled, time, announce type, custom text
    - [x] 07.12.2022 discrete customizability in times 15,30,45,60
    - [x] 07.12.2022 custom text
    3. custom message type print / whisper / party etc.    
        - print, none, raid frame, party, raid
]]

-- ==== use case ------------------------------------------------------------------------------------------------------------
--[[

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = false
local timeInMin = 30
local announceType = 'self'
local text = "Check your posture!"

local f = CreateFrame("Frame")

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- module:RegisterEvent("PLAYER_REGEN_ENABLED")
    -- :: superset construct
    if A.global.utility == nil then A.global.utility = {} end
    if A.global.utility.posture == nil then A.global.utility.posture = {} end
    -- :: set variable: is enabled
    if A.global.utility.posture.isEnabled == nil then
        A.global.utility.posture.isEnabled = isEnabled
    else
        isEnabled = A.global.utility.posture.isEnabled
    end
    -- :: set variable: time in minute
    if A.global.utility.posture.timeInMin == nil then
        A.global.utility.posture.timeInMin = timeInMin
    else
        timeInMin = A.global.utility.posture.timeInMin 
    end
    -- :: set variable: announce type
    if A.global.utility.posture.announceType == nil then
        A.global.utility.posture.announceType = announceType
    else
        announceType = A.global.utility.posture.announceType
    end
    -- :: set variable: text
    if A.global.utility.posture.text == nil then
        A.global.utility.posture.text = text
    else
        text = A.global.utility.posture.text
    end
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
    timeInMin = timeInMin - elapsed
    if timeInMin <= 0 then
        -- :: defensive
        if A.global.utility.posture.isEnabled ~= isEnabled then
            isEnabled = A.global.utility.posture.isEnabled 
        end
        if A.global.utility.posture.text ~= text then
            text = A.global.utility.posture.text 
        end
        if A.global.utility.posture.announceType ~= announceType then
            announceType = A.global.utility.posture.announceType 
        end
        if isEnabled then
            if announceType == 1 then -- announce type 1 = self print
                print(moduleAlert .. text)
            -- elseif announceType == "party" then
                -- SendChatMessage(raidAlerts.lootrules.onetrophy, "RAID_WARNING")
            -- elseif announceType == "raid" then
            end
            -- RaidNotice_AddMessage(RaidBossEmoteFrame, "Check your posture!", ChatTypeInfo["RAID_BOSS_EMOTE"])
            -- PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_2)
        end
        timeInMin = (A.global.utility.posture.timeInMin * 60 * 15)
    end
end)
-- function module:PLAYER_REGEN_ENABLED()
--     -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
--     isInCombat = false
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)  

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

