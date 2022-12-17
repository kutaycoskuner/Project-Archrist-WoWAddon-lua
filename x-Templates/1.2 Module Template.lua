------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local moduleName1, moduleName2  = 'PostureCheck', "Posture Check";
local moduleAlert = M .. moduleName2 .. ": |r";
local module = A:GetModule(moduleName1, true);
local aprint = Arch_print
local mprint = function(msg) print(moduleAlert..msg) end
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

]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables


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

local function handleCommand(msg)
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Event Handlers
-- function module:PLAYER_REGEN_ENABLED()
--     -- SELECTED_CHAT_FRAME:AddMessage('You are out of combat.')
--     isInCombat = false
-- end

------------------------------------------------------------------------------------------------------------------------
-- ==== CLI (Slash Commands)
-- SLASH_reputation1 = "/rep"
-- SlashCmdList["reputation"] = function(msg)
--     handleCommand(msg)
-- end


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