------------------------------------------------------------------------------------------------------------------------
--------- Import: System, Locales, PrivateDB, ProfileDB, GlobalDB, PeopleDB, AlertColors AddonName
------------------------------------------------------------------------------------------------------------------------
local A, L, V, P, G, C, R, M, N = unpack(select(2, ...));
local m_name, m_name2 = nil, nil;
local group = nil;
local module = A:GetModule(m_name, true);
local moduleAlert = M .. m_name2 .. ": |r";
local mprint = function(msg)
    print(moduleAlert .. msg)
end
local aprint = Arch_print
if module == nil then return end

------------------------------------------------------------------------------------------------------------------------
--------- Notes
------------------------------------------------------------------------------------------------------------------------

-- use case ------------------------------------------------------------------------------------------------------------
--[[
    ]]

-- blackboard ------------------------------------------------------------------------------------------------------------
--[[
]]

-- todo ----------------------------------------------------------------------------------------------------------------
--[[
]]

------------------------------------------------------------------------------------------------------------------------
-- ==== Variables
local isEnabled = true
-- :: global Functions
local fCol = Arch_focusColor
local cCol = Arch_commandColor
local mCol = Arch_moduleColor
local tCol = Arch_trivialColor
local classCol = Arch_classColor
local realmName = GetRealmName()

------------------------------------------------------------------------------------------------------------------------
-- ==== Start
function module:Initialize()
    self.Initialized = true
    -- :: construct
    if A.global[group] == nil then
        A.global[group] = {}
    end
    if A.global[group][m_name] == nil then
        A.global[group][m_name] = {}
    end
    if A.global[group][m_name].isEnabled == nil then
        A.global[group][m_name].isEnabled = isEnabled
    end
    isEnabled = A.global[group][m_name].isEnabled
end

------------------------------------------------------------------------------------------------------------------------
-- ==== Local Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Global Methods

------------------------------------------------------------------------------------------------------------------------
-- ==== Main
local function toggleModule(isSilent)
    if isEnabled then
        -- :: register
        module:RegisterEvent("CHAT_MSG_SYSTEM")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is enabled")
        end
    else
        -- :: deregister
        -- module:UnregisterEvent("CHAT_MSG_SYSTEM")
        if not isSilent or isSilent == nil then
            aprint(fCol(m_name2) .. " is disabled")
        end
    end
    if not isSilent then
        isEnabled = not isEnabled
        -- A.global.assist.groupOrganizer.isEnabled = isEnabled
    end
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
    toggleModule(true)
end
A:RegisterModule(module:GetName(), InitializeCallback)
