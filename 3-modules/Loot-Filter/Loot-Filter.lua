------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2 = 'LootFilter', "Loot Filter";
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
-- local f = CreateFrame("Frame")

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- module:RegisterEvent("PLAYER_REGEN_ENABLED")
    -- :: superset construct
    if A.global.utility == nil then A.global.utility = {} end
    if A.global.utility.lootFilter == nil then A.global.utility.lootFilter = {} end
    -- :: set variable: is enabled
    if A.global.utility.lootFilter.isEnabled == nil then
        A.global.utility.lootFilter.isEnabled = isEnabled
    else
        isEnabled = A.global.utility.lootFilter.isEnabled
    end

end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods
local function filterRoll(self, event, msg)
	if (A.global.utility.lootFilter.isEnabled == true and ((string.find(msg, "selected Greed for")) or (string.find(msg, ": Greed Roll -")))) then --or string.find(msg, "passed") or string.find(msg, "Disenchant")
        return true
    else
        return false
    end
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function main(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filterRoll)
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

